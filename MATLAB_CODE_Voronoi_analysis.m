%% select file and load data
[fn, fp] = uigetfile({'*_res_all_movies*.mat';'*.*'}, 'Select a file');
cd(fp)
load(fn);

%% convert pixels to nm
pts(:,4:5)=pts(:,4:5)*80;

%% plot the figure to zoom in the cell
h = figure; plot(pts(:,4), pts(:,5), '.k')
pause

%% select the region of interest to be analysed
xmin=min(get(gca, 'XLim'));xmax=max(get(gca, 'XLim'));
ymin=min(get(gca, 'YLim'));ymax=max(get(gca, 'YLim'));
ROI = [ymin xmin; ymin xmax; ymax xmax; ymax xmin; ymin xmin];
in=inpolygon(pts(:,4), pts(:,5), ROI(:,2), ROI(:,1));
selpts=pts(in, 4:5);
% reset position to start at zero (saving computation later)
selpts(:, 1) = selpts(:, 1) - xmin +1;
selpts(:, 2) = selpts(:, 2) - ymin +1;
box = selpts(boundary(selpts(:,1),selpts(:,2)), :); 
close (h)


%% Voronoi analysis 
[v,c] = voronoin(selpts); 
ind = find(~inpolygon(v(:,1),v(:,2),box(:,1), box(:,2))); %find index of vertices located outside the set of points
c_ind = cellfun(@(x) ismember(ind, x), c, 'UniformOutput', false); %find polygons that have at least one vertice outside the cell 
c(find(cellfun(@max, c_ind)))=[]; %mark polygons to be deleted 
clear c_ind ind
[ar_vor] = arrayfun(@(x) polyarea(v(c{x}, 1), v(c{x}, 2)), 1:length(c)); % calculate&plot area of each voronoi cell 
    
%% calculate mean area for Voronoi
mean_area = polyarea(box(:,1), box(:,2))./length(selpts);
 
%% group voronoi regions that have a higher density
temp_vor = c(ar_vor<(mean_area/3));
sel_vor = temp_vor;
all={};
sel_vor_group={};
ar_vor_group=[];
ar_vor_group_sum=[];

%% plot result
figure
voronoi(selpts(:,1), selpts(:,2)); hold on
tic
while ~isempty(temp_vor) 
index = find(cell2mat(cellfun(@(x) sum(ismember(temp_vor{1},x)), temp_vor, 'UniformOutput', false))>0); %check which other entries share the same vertice - get index values
ind_pt = unique(cat(2, temp_vor{index})); %merge polygon and delete repeated points
    temp_vor(index)=[];
    if length(index) == 1 %no more shapes sharing the vertices
        shp =  alphaShape(v(ind_pt, 1), v(ind_pt, 2));
        if sum(inShape(shp,selpts(:,1),selpts(:,2))) >= 10 %minimum number of localization
            ctr=[mean(shp.Points(:,1)), mean(shp.Points(:,2))]; %center of the area
ar_vor_group = cat(1, ar_vor_group, [area(shp) ctr sum(inShape(shp,selpts(:,1),selpts(:,2)))]);
            sel_vor_group{end+1} = boundaryFacets(shp);
plot(shp,'FaceColor','red','EdgeColor','red','FaceAlpha',0.25)         
            all{end+1} = ind_pt;
        end
    else
        temp_vor = [{ind_pt}; temp_vor];
    end
    disp(num2str(length(temp_vor)))
end
toc

%% save file
ar_vor_group(:,5)=ar_vor_group(:,4)./sum(ar_vor_group(:,4));
save([fn(1:end-4) '_Voronoi.mat'], 'all', 'ar_vor_group', 'pts', 'c', 'v', 'ROI', 'sel_vor', 'sel_vor_group', 'selpts');