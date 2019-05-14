# FactoQGIS
FactoQGIS: a GUI tool based on an R script to perform Geometric Data Analysis in QGIS
</br> By : Florent Demoraes, UMR ESO CNRS 6590, Université Rennes 2, France
</br> https://perso.univ-rennes2.fr/florent.demoraes

<p><a target="_blank" rel="noopener noreferrer" href="https://github.com/Florent-Demoraes/FactoQGIS/blob/master/FactoQGIS_Diagram.png"><img src="https://github.com/Florent-Demoraes/FactoQGIS/raw/master/FactoQGIS_Diagram.png" style="max-width:50%;"></a></p>


</br> ENGLISH------------------------------- 

This algorithm implements a typological analysis based on quantitative data aggregated in spatial units. First, it performs a PCA (Principal Component Analysis) on N variables and second, a HAC (Hierarchical Ascending Classification also called Hierarchical Agglomerative Clustering) on the first factors. This algorithm is mainly based on the FactoMineR package developed by François Husson et al (Agrocampus Ouest, Rennes, France). It also makes secondary use of factoextra, stringr, openxlsx, R2HTML and corrplot packages. These packages must have been previously installed in R before launching the algorithm in QGIS. The output tables and plots are exported respectively to Excel and to png format and then are inserted into an html file that automatically pops up in a web browser at the end of the process. The Eigenvalue table and the variable coordinate table on the dimensions are also added to the table of contents in QGIS. Finally, the algorithm creates a new layer with the column indicating the cluster each spatial unit belongs to, so as to make it easy to map the typology.


</br> FRANCAIS------------------------------- 

Cet algorithme met en œuvre une analyse typologique à partir de données quantitatives agrégées dans un découpage spatial. Il permet dans un premier temps d’exécuter une ACP (Analyse en Composante Principale) sur N variables et dans un deuxième temps d’appliquer une CAH (Classification Ascendante Hiérarchique) sur les premiers facteurs. Cet algorithme repose principalement sur le package FactoMineR développé par François Husson et al. (Agrocampus Ouest, Rennes, France). Il fait également appel de manière secondaire aux packages factoextra, stringr, openxlsx, R2HTML et corrplot. Ces packages doivent avoir été installés au préalable dans R avant de lancer l’algorithme dans QGIS. Les résultats produits (tableaux et graphiques) sont exportés respectivement au format Excel et au format png puis insérés dans un fichier html qui s’ouvre automatiquement dans un navigateur web à la fin du calcul. Le tableau des valeurs propres et le tableau des coordonnées des variables sur les axes sont également ajoutés à la liste des couches dans QGIS. Enfin, l’algorithme crée une nouvelle couche comportant la colonne indiquant l’appartenance des unités spatiales aux classes issues de la typologie, classes qui peuvent ensuite être directement cartographiées.


</br> REFERENCES---------------

1.	BENZECRI, J.P., (1973) L'Analyse des données, Dunod, 619 p. ISBN 2-04-007225-X
2.	CORNILLON P.A., GUYADER A., HUSSON F., JEGOU N., JOSSE J., KLUTCHNIKOFF N., LE PENNEC E., MATZNER-LØBER E., ROUVIERE L. & THIEURMEL B. (2018). R pour la statistique et la science des données. Presses Universitaires de Rennes, 1 ed. 415 p., ISBN : 978-2-7535-7573-8
3.	GRASER, A.; OLAYA, V. (2015) Processing: A Python Framework for the Seamless Integration of Geoprocessing Tools in QGIS. Vol. 4, ISPRS Int. J. Geo-Information, 2219-2245. Available online: https://doi.org/10.3390/ijgi4042219 (accessed on May 13, 2019)
4.	HUSSON F., LÊ S., PAGÈS J., (2009), Analyse de données avec R, Presses Universitaires de Rennes, 224 p. ISBN 978-2753509382
5.	LE ROUX B., ROUANET H. (2005), Geometric Data Analysis - From Correspondence Analysis to Structured Data Analysis, Springer Netherlands, 475 p. ISBN 978-1-4020-2236-4
6.	LEBART L., PIRON M., MORINEAU A., (2006), Statistique exploratoire multidimensionnelle : visualisation et inférence en fouille de données, Dunod, 464 p.


</br> ONLINE RESOURCES---------------

1.	Blog on how to execute R scripts in QGIS 3.0 and later. Available online: https://github.com/north-road/qgis-processing-r/releases/tag/v0.0.2 (accessed on May 13, 2019)
2.	List of the R scripts that can be executed from the QGIS Toolbox. Available online: https://github.com/qgis/QGIS-Processing/tree/master/rscripts (accessed on May 13, 2019)
3.	Documentation of the FactoMineR package used in FactoQGIS. Available online: https://www.rdocumentation.org/packages/FactoMineR/versions/1.41 (accessed on May 13, 2019)
4.	Documentation of the factoextra package used in FactoQGIS. Available online: https://www.rdocumentation.org/packages/factoextra/versions/1.0.5 (accessed on May 13, 2019)
5.	Documentation of the stringr package used in FactoQGIS. Available online: https://www.rdocumentation.org/packages/stringr/versions/1.3.1 (accessed on May 13, 2019)
6.	Documentation of the openxlsx package used in FactoQGIS. Available online: https://www.rdocumentation.org/packages/openxlsx/versions/4.1.0 (accessed on May 13, 2019)
7.	Documentation of the R2HTML package used in FactoQGIS. Available online: https://www.rdocumentation.org/packages/R2HTML/versions/2.3.2 (accessed on May 13, 2019)
8.	Documentation of the corrplot package used in FactoQGIS. Available online: https://www.rdocumentation.org/packages/corrplot/versions/0.84 (accessed on May 13, 2019)


