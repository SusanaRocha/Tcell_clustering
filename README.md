# Tcell_clustering

This document contains MATLAB code for:
*	Localizing single molecules in dSTORM-TIRF experiment in bulk
*	Partitioning localizations into Voronoi areas and calculating certain cluster properties
<h2>MATLAB_CODE_Localizations_bulk</h2>
<h3>Input</h3>
<ul><li>.HIS files from single-molecule dSTORM-TIRF experiment. For one cell, two movies of each 5000 frames are imaged. The two movies have to have the same core name, followed by _mov1 or _mov2 for the analysis to work. Example: </li>
- 20240801_C3 control_02_mov1.HIS <br>
- 20240801_C3 control_02_mov2.HIS (core name = 20240801_C3 control_02) - data can be supplied upon request <br>
<li>	Localizer function (Dedecker et al. doi:10.1117/1.JBO.17.12. For download and installation, see: https://bitbucket.org/pdedecker/localizer/src/master/ )</li></ul>
<h3>Important code aspects</h3>
<ul><li>	Bulk analysis for .HIS files </li>
<li>	First individual .HIS files are analyzed: <br>
- Localizations are retrieved by using the Localizer function that fits a 2D Gaussian with PSF standard deviation factor 1.8 and intensity selection sigma factor 25. <br>
- Localizations are saved in the variable pts: a table with 12 columns (see explanation Localizer function) where each row represents 1 localization.<br>
- Localizations are plotted with a scale bar of 5 µm. LUT scale of these images can be adjusted in the script.<br></li>
<li>	Then, two movies with the same core name (coming from the same cell), are combined into one dataset by combining the pts variables of both movies. </li></ul>
<h3>Output</h3>
<ul><li>	For each .HIS file: Matlab data file called _LocRes.mat containing the pts variable of that .HIS file. <br>Example: 20240801_C3 control_02_mov1_LocRes and 20240801_C3 control_02_mov2_LocRes</li>
<li>	For each .HIS file: PNG file with the plotted reconstructed image with scalebar 5 µm. <br>Example: 20240801_C3 control_02_mov1 and 20240801_C3 control_02_mov2</li>
<li>	For each .HIS file with the same core name: combined Matlab data file called _Res_all_movies containing the pts variable of those .HIS files. <br>Example: 20240801_C3 control_02_Res_all_movies</li>
<li>	For each .HIS file with the same core name: combined PNG file with filename ending in “all” with the plotted reconstructed image with scalebar 5 µm. <br>Example: 20240801_C3 control_02all</li></ul>

<h2>MATLAB_CODE_Voronoi_analysis</h2>
<h3>Input</h3>
<ul><li>	_Res_all_movies.HIS file </li></ul>
<h3>Important code aspects</h3>
<ul><li>	Automated analysis with manual user input: <br>
-	Select the _Res_all_movies.HIS file to be analyzed. E.g. 20240801_C3 control_02_Res_all_movies <br>
-	The code generates a new figure with all plotted localizations.<br>
-	On the figure with all plotted localizations, select the region of interest (that contains the cell) that will be analyzed. To do this, select the “zoom in” button and draw the region of interest. This region of interest can be further modified: zoom in further, zoom out, pan for dragging to another area. When the region of interest is correctly selected, press any key to continue the analysis.<br>
-	The code runs the Voronoi analysis on the selected region (https://nl.mathworks.com/help/matlab/ref/voronoin.html). Voronoi areas with a molecular density 3 times higher than the average density are selected and adjacent selected Voronoi areas are clustered. Clusters with more than 10 localizations are further analyzed.<br>
-	The code visually represent the Voronoi result: non-selected Voronoi regions in blue, selected Voronoi regions in red.<br>
-	The code calculates:<br>
<ul><li>	for each selected Voronoi region: the area</li>
<li>	for each selected Voronoi region: the number of localizations inside</li>
<li>	for the region of interest: the area</li>
<li>	for the region of interest: the number of localizations inside</li></ul></ul>
<h3>Output</h3>
<ul><li>	For the analyzed file, a _Res_all_movies_Voronoi.HIS file containing Voronoi analysis variables and results. Example: 20240801_C3 control_02_Res_all_movies_Voronoi. The “ar_vor_group” variable includes per Voronoi region the area (column 1), x,y coordinates of the center of the Voronoi (columns 2 and 3), number of localizations (column 4), fraction of localizations in the Voronoi region versus in the total region of interest (column 5).</li></ul>
