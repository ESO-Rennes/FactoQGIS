# FactoQGIS
<strong>FactoQGIS</strong>: a GUI tool based on an R script to perform Geometric Data Analysis in QGIS
</br> <strong>Main Author</strong>: Florent Demoraes, UMR ESO CNRS 6590, Université Rennes 2, France
</br> https://perso.univ-rennes2.fr/florent.demoraes
</br> <strong>Contributors</strong>: SIGAT Master Degree students (Université Rennes 2, 2018-2019 and 2019-2020) 
</br> https://www.sites.univ-rennes2.fr/mastersigat/


<p><a target="_blank" rel="noopener noreferrer" href="https://github.com/Florent-Demoraes/FactoQGIS/blob/master/FactoQGIS_Diagram.png"><img src="https://github.com/Florent-Demoraes/FactoQGIS/raw/master/FactoQGIS_Diagram.png" style="max-width:200%;"></a></p>

<p class="MsoNormal"><b style="mso-bidi-font-weight:normal"><span style="color:red">!!NEW!! FactoQGIS has been upgraded on June 2021 <o:p></o:p></span></b></p>
</br> FactoQGIS now works with:
</br> Processing R Provider --> version 2.x and newer 
</br> QGIS --> version 3.16 and newer
</br> R --> version 3.5.3 and newer
</br> 
</br> The output html file now includes new features
</br>  --> A table with all the input parameters, a table with the number of spatial units in each cluster
</br>  --> The x-axis of the bar plots which describe the clusters now adjust automatically
</br>  --> A factor map showing the individuals differentiated according to the additional qualitative variable(s). This factor map only appears if at least one additional qualitative variable has been selected
</br>  --> A map of the typology rendered with the same color palette as the one used on the 3D dendrogram
</br> 
</br> Reminder
</br> --> FactoQGIS only works with polygons layers which contain data (counts, %, ratios, categories, etc.) in the table of attributes
</br> --> Allowed input layer formats: shapefile, geopackage, geojson (etc.)
</br> --> When using FactoQGIS for the first time, the required R packages are automatically installed and loaded
</br> --> Known issues: NA or unknown values are not allowed in the table of attributes


</br> A full description of the first release of the algorithm is available here : https://hal.archives-ouvertes.fr/hal-02181611

</br> ENGLISH------------------------------- 

This algorithm implements in QGIS a typological analysis based on quantitative data aggregated in spatial units. First, it performs a PCA (Principal Component Analysis) on N variables and second, a HAC (Hierarchical Ascending Classification also called Hierarchical Agglomerative Clustering) on the first factors. This algorithm is mainly based on the FactoMineR package developed by François Husson et al. (Agrocampus Ouest, Rennes, France). The output tables and plots are exported respectively to Excel and to png format and then are inserted into an html file that automatically pops up in a web browser at the end of the process. The Eigenvalue table and the variable coordinate table are also added to the table of contents in QGIS. Finally, the algorithm creates a new layer which contains an attribute field indicating the cluster each spatial unit belongs to, so as to make it easy to map the typology. For this purpose, a style file in QML format is generated and can be used as default rendering (the colors of the clusters are the same as those on the 3D hierarchical tree). FactoQGIS is accessible from a graphical user interface directly in the QGIS environment. It will be of particular interest to any user who wishes to simply build and map a multidimensional typology without knowing the R language. 

To use FactoQGIS, just download the <a href="https://github.com/ESO-Rennes/FactoQGIS/raw/master/NEW_FactoQGIS_English_Version_2021.zip" target="_new" rel="noopener">NEW_FactoQGIS_English_Version.zip</a> file, unzip and save it to C:\Users\...\AppData\Roaming\QGIS\QGIS3\profiles\default\processing\rscripts folder.


</br> FRANCAIS------------------------------- 

Cet algorithme met en œuvre dans QGIS une analyse typologique à partir de données quantitatives agrégées dans un découpage spatial. Il permet dans un premier temps d’exécuter une ACP (Analyse en Composante Principale) sur N variables et dans un deuxième temps d’appliquer une CAH (Classification Ascendante Hiérarchique) sur les premiers facteurs. Cet algorithme repose principalement sur le package FactoMineR développé par François Husson et al. (Agrocampus Ouest, Rennes, France). Les résultats produits (tableaux et graphiques) sont exportés respectivement au format Excel et au format png puis insérés dans un fichier html qui s’ouvre automatiquement dans un navigateur web à la fin du calcul. Le tableau des valeurs propres et le tableau des coordonnées des variables sur les axes sont également ajoutés à la liste des couches dans QGIS. Enfin, l’algorithme crée une nouvelle couche comportant une colonne indiquant l’appartenance des unités spatiales aux classes issues de la typologie, classes qui peuvent ensuite être directement cartographiées. A cet effet, un fichier de style au format QML est créé et peut être utilisé comme rendu par défaut (les couleurs des classes sont les mêmes que celles sur l'arbre hiérarchique 3D). FactoQGIS est accessible depuis une interface graphique directement dans l'environnement QGIS. Il sera ainsi particulièrement utile pour les utilisateurs qui souhaitent simplement construire et cartographier une typologie multidimensionnelle sans connaître le langage R. 

Pour utiliser FactoQGIS, télécharger le fichier <a href="https://github.com/ESO-Rennes/FactoQGIS/raw/master/NOUVEAU_FactoQGIS_Version_Francaise_2021.zip" target="_new" rel="noopener">NOUVEAU_FactoQGIS_Version_Francaise.zip</a>. Décompressez-le et sauvegardez-le dans le dossier C:\Users\...\AppData\Roaming\QGIS\QGIS3\profiles\default\processing\rscripts.

Un poster de présentation élaboré par un groupe d'étudiants du Master 2 SIGAT (2019-2020) est disponible <a href="https://github.com/ESO-Rennes/FactoQGIS/blob/master/POSTER_FactoQGIS_FR.pdf" target="_new" rel="noopener"><strong>ICI</strong></a>. Un tutoriel vidéo réalisé par un deuxième groupe d'étudiants du Master 2 SIGAT (2019-2020) est également accessible <a href="https://bit.ly/3pg4SBO" target="_new"><strong>ICI</strong></a>. Le jeu de données d'exemple utilisé dans le tutoriel est téléchargeable <a href="https://github.com/ESO-Rennes/FactoQGIS/raw/master/JeuxDonneesExemple.zip" target="_new" rel="noopener"><strong>ICI</strong></a>.


</br> REFERENCES---------------

1.	BENZECRI, J.P., (1973) L'Analyse des données, Dunod, 619 p. ISBN 2-04-007225-X
2.	CORNILLON P.A., GUYADER A., HUSSON F., JEGOU N., JOSSE J., KLUTCHNIKOFF N., LE PENNEC E., MATZNER-LØBER E., ROUVIERE L. & THIEURMEL B. (2018). R pour la statistique et la science des données. Presses Universitaires de Rennes, 1 ed. 415 p., ISBN : 978-2-7535-7573-8
3.	GRASER, A.; OLAYA, V. (2015) Processing: A Python Framework for the Seamless Integration of Geoprocessing Tools in QGIS. Vol. 4, ISPRS Int. J. Geo-Information, 2219-2245. Available online: https://doi.org/10.3390/ijgi4042219 (accessed on May 13, 2019)
4.	GREENACRE M. J.; BLASIUS J. (2006), Multiple Correspondence Analysis and Related Methods. CRC press. ISBN 978-1-58488-628-0.
5.	HUSSON F., LÊ S., PAGÈS J., (2009), Analyse de données avec R, Presses Universitaires de Rennes, 224 p. ISBN 978-2753509382
6.	LE ROUX B., ROUANET H. (2005), Geometric Data Analysis - From Correspondence Analysis to Structured Data Analysis, Springer Netherlands, 475 p. ISBN 978-1-4020-2236-4
7.	LEBART L., PIRON M., MORINEAU A., (2006), Statistique exploratoire multidimensionnelle : visualisation et inférence en fouille de données, Dunod, 464 p.


</br> ONLINE RESOURCES---------------

0.  Processing R Provider Plugin for QGIS 3.x. https://github.com/north-road/qgis-processing-r
1.	Documentation of the FactoMineR package used in FactoQGIS. https://www.rdocumentation.org/packages/FactoMineR/versions/1.41
2.	Documentation of the factoextra package used in FactoQGIS. https://www.rdocumentation.org/packages/factoextra/versions/1.0.5
3.	Documentation of the openxlsx package used in FactoQGIS. https://www.rdocumentation.org/packages/openxlsx/versions/4.1.0
4.	Documentation of the R2HTML package used in FactoQGIS. https://www.rdocumentation.org/packages/R2HTML/versions/2.3.2
5.	Documentation of the corrplot package used in FactoQGIS. https://www.rdocumentation.org/packages/corrplot/versions/0.84


