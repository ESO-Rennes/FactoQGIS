##FactoQGIS=group
##Espace_de_travail=Folder C:/Users/demoraes_f/Desktop/temp/Exo_QGIS
##Couche_en_entree=Vector parispc_com_N_variables
##Identifiant_des_unites_spatiales=Field Couche_en_entree
##Variables_quantitatives_actives=Field numeric multiple Couche_en_entree P20ANS07;PNDIP07;TXCHOMA07;INTAO07;PART07;PCAD07;PINT07;PEMP07;POUV07;PRET07;PMONO07;PREFETR07;RFUCQ207
##Variables_quantitatives_illustratives=optional Field numeric multiple Couche_en_entree
##Variables_qualitatives_illustratives=optional Field string multiple Couche_en_entree
##Centrer_reduire_les_donnees=selection TRUE;FALSE
##Nombre_d_axes_a_garder_pour_l_ACP=Number 5
##Nombre_d_axes_a_garder_pour_la_CAH=Number 2
##Nombre_de_classes_a_garder_pour_la_CAH=Number 5
##Type_de_distance_pour_la_CAH=selection euclidean;manhattan
##Methode_d_agregation_pour_definir_les_classes=selection ward;average;single;complete
##Table_des_valeurs_propres=output table
##Tables_des_coordonnees_des_variables=output table
##Couche_avec_les_classes=output vector 
options("scipen"=100)  #permet de convertir les chiffres initialement sous forme de Facteur en chiffres décimaux standard

# 1 - Chargement des packages necessaires
# Pour executer l'ACP
library(FactoMineR)
# Pour produire des graphiques esthetiques issus de l'ACP
library(factoextra)
# Pour exporter les resultats vers Excel
library(openxlsx)
# Pour generer un fichier html contenant les resultats
library(R2HTML)
# Pour creer une matrice restituant la qualite de representation des variables (cos2 des variables sur toutes les dimensions)
library(corrplot)
# Pour creer un fichier de style au format qml (format xml)
library(XML)


# 2 - Recuperation et formatage des valeurs saisies dans la boite de dialogue par l'utilisateur
# Pour recuperer dans une chaine de caracteres le chemin de l'espace de travail saisi par l'utilisateur
Working_Directory <- as.character(Espace_de_travail)

# Pour indiquer a R l'espace de travail saisi par l'utilisateur
setwd(Working_Directory)

# Pour recuperer dans une chaine de caracteres ListVarActiv les variables actives quantitatives selectionnees par l'utilisateur
ListVarActiv<-as.character(Variables_quantitatives_actives)

# Pour recuperer dans une chaine de caracteres ListComplet toutes les variables choisies par l'utilisateur qu'elles soient actives, illustratives, quantitatives ou qualitatives
if ((is.null(Variables_quantitatives_illustratives)==TRUE)&(is.null(Variables_qualitatives_illustratives)==TRUE)) {ListComplet<-ListVarActiv} else if ((is.null(Variables_qualitatives_illustratives)==TRUE)&(is.null(Variables_quantitatives_illustratives)==FALSE)) {ListComplet<-c(ListVarActiv,as.character(Variables_quantitatives_illustratives))} else if (((is.null(Variables_qualitatives_illustratives)==FALSE))&(is.null(Variables_quantitatives_illustratives)==TRUE)) {ListComplet<-c(ListVarActiv,as.character(Variables_qualitatives_illustratives))} else {ListComplet<-c(ListVarActiv,as.character(Variables_quantitatives_illustratives),as.character(Variables_qualitatives_illustratives))}

# Pour recuperer dans une chaine de caracteres ListQTsup la liste des variables quantitatives supplémentaires si l'utilisateur en a selectionne
if (is.null(Variables_quantitatives_illustratives)==FALSE) {ListQTsup<-as.character(Variables_quantitatives_illustratives)} 

# Pour recuperer dans une chaine de caracteres ListQLsup la liste des variables qualitatives supplémentaires si l'utilisateur en a selectionne
if (is.null(Variables_qualitatives_illustratives)==FALSE) {ListQLsup<-as.character(Variables_qualitatives_illustratives)} 

# Pour enregister le nombre de facteurs a garder pour l'ACP saisi par l'utilisateur
nf<-as.numeric(Nombre_d_axes_a_garder_pour_l_ACP)

# Pour enregister le nombre de classes a garder pour la CAH saisi par l'utilisateur 
Nb_clust<-as.numeric(Nombre_de_classes_a_garder_pour_la_CAH)

# Pour enregister le nombre de facteurs a garder pour la CAH saisi par l'utilisateur
HAC_nf<-as.numeric(Nombre_d_axes_a_garder_pour_la_CAH)

# Pour creer un parametre booleen correspondant aux choix de l'utilisateur de centrer et de reduire ou non les donnees
Scales<-c("TRUE","FALSE")
Scale<-Scales[Centrer_reduire_les_donnees+1]
if (Scale == 'TRUE'){scale <- 1} else {scale <- 0}

# Pour creer un parametre correspondant au type de distance a retenir afin de construire le dendrogramme
distances<-c("euclidean","manhattan")
distance<-distances[Type_de_distance_pour_la_CAH+1]

# Pour creer un parametre correspondant a la methode d'agregation a retenir afin de constituer les classes
methodes<-c("ward","average","single","complete")
methode<-methodes[Methode_d_agregation_pour_definir_les_classes+1]

# Importation du jeu de donnee
dataset<-as.data.frame(Couche_en_entree) # a ce stade on ne travaille que sur les valeurs attributaires donc on convertit Couche_en_entree en simple dataframe

# Pour rajouter la colonne Identifiant_des_unites_spatiales au jeu de donnee
dataset<-cbind(dataset, Couche_en_entree[[Identifiant_des_unites_spatiales]])

# Pour renommer la colonne Identifiant_des_unites_spatiales en ID
names(dataset)[names(dataset) == "Couche_en_entree[[Identifiant_des_unites_spatiales]]"] <- "ID"

# Pour specifier l'attribut ID comme rowname
row.names(dataset)<-dataset$ID

# Creation d'un sous-ensemble (dataframe) a partir du tableau initial sur la base des variables quantitatives actives selectionnees par l'utilisateur
datasetListVarActiv <- dataset[names(dataset)[names(dataset) %in% ListVarActiv]]

# Creation d'un dataframe complet rassemblant toutes les variables selectionnees par l'utilisateur qu'elles soient actives, illustratives, quantitatives ou qualitatives
datasetComplet <- dataset[names(dataset)[names(dataset) %in% ListComplet]]

# Creation dans l'espace de travail d'un fichier html dans lequel on va enregistrer les graphiques et tableaux
directory<-getwd()
HTMLoutput=file.path(directory,"PCA_Results.html")

# Lancement de l'ACP
res.pca <-PCA(datasetComplet, quanti.sup=if (is.null(Variables_quantitatives_illustratives)==FALSE) {which(colnames(datasetComplet) %in% ListQTsup)} else {NULL}, quali.sup=if (is.null(Variables_qualitatives_illustratives)==FALSE) {which(colnames(datasetComplet) %in% ListQLsup)} else {NULL}, ind.sup=NULL, scale.unit=scale, graph=TRUE, ncp=nf)

# Creation d'un objet avec les differents resultats issus de l'ACP relatifs aux variables
var <- get_pca_var(res.pca)

# Creation d'un tableau avec les valeurs propres et export xlsx
eig.val <- get_eigenvalue(res.pca)
eig.val<-round(eig.val,2) # permet d'arrondir les valeurs
write.xlsx(eig.val, "EigenValue.xlsx", asTable=FALSE, col.names = TRUE, row.names = TRUE, append = FALSE, showNA = FALSE)

# Affichage de la table des valeurs propres dans QGIS
Table_des_valeurs_propres=eig.val

# Creation d'un fichier png et enregistrement du graphe des gains d'inertie dedans
GrapheGainInertie="GrapheGainInertie.png"
png("GrapheGainInertie.png",  bg = "transparent", width = 1200, height = 1000, units = "px", pointsize = 12)
fviz_eig(res.pca, addlabels = TRUE, ylim = c(0, 50), font.main = 20, font.submain = 18,  font.x = 14, font.y = 14)
dev.off()

# Creation d'un tableau avec les coordonnees des variables sur les axes et export xlsx
VarCoord<-as.data.frame(var$coord)
VarCoord<-round(VarCoord,2)   # round permet d'arrondir les valeurs
VarCoord<-VarCoord[order(VarCoord$Dim.1, decreasing = TRUE), ] # Tri du tableau sur le premier axe
write.xlsx(VarCoord, "VarCoord.xlsx", asTable=FALSE, col.names = TRUE, row.names = TRUE, append = FALSE, showNA = FALSE)

# Affichage du tableau avec les coordonnees des variables sur les axes dans QGIS
Tables_des_coordonnees_des_variables=VarCoord

# Creation d'un fichier png et enregistrement du graphe des variables dedans
GrapheVariables="GrapheVariables.png"
png("GrapheVariables.png", bg = "transparent", width = 500, height = 500, units = "px", pointsize = 24)
fviz_pca_var(res.pca, col.var="contrib", gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"), repel = TRUE)
dev.off()

# Creation d'un fichier png et enregistrement dedans d'une matrice graphique coloree restituant la qualite de representation des variables (cos2 des variables sur toutes les dimensions)
MatriceQualiteRepresentation="MatriceQualiteRepresentation.png"
png("MatriceQualiteRepresentation.png", bg = "transparent", width = 1000, height = 1500, units = "px", pointsize = 24)
corrplot(var$cos2, is.corr=FALSE)
dev.off()

# Creation d'un fichier png et enregistrement dedans d'une matrice graphique coloree restituant les corrélations entre variables
MatriceCorrelation="MatriceCorrelation.png"
png("MatriceCorrelation.png", bg = "transparent", width = 1000, height = 1200, units = "px", pointsize = 24)
col<- colorRampPalette(c("darkblue", "blue", "lightblue", "white", "orange", "red", "darkred"))(20)  # pour définir une palette de couleurs
corrplot(cor(datasetListVarActiv), method="circle", diag=FALSE, col= col, type="upper",order="hclust")
dev.off()

# Creation d'un fichier png et enregistrement du graphe des individus dedans
GrapheIndividus="GrapheIndividus.png"
png("GrapheIndividus.png", bg = "transparent", width = 800, height = 800, units = "px", pointsize = 24)
fviz_pca_ind(res.pca, col.ind="contrib", gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"), repel = TRUE)
dev.off()

# Creation d'un fichier png et enregistrement dedans du graphe des individus differencies suivant la/les variables(s) qualitative(s) supplementaire(s) + ellipses 
# Ce graphique est créé uniquement si au moins une variable qualitative supplémentaire a été sélectionnée
if (is.null(Variables_qualitatives_illustratives)==FALSE) 
{GrapheIndQualiSup="GrapheIndQualiSup.png"
png("GrapheIndQualiSup.png", bg = "transparent", width = 800, height = 800, units = "px", pointsize = 24) 
fviz_pca_ind(res.pca, repel = TRUE, label="var", habillage= which(colnames(datasetComplet) %in% ListQLsup), addEllipses = TRUE)
} else {0}
dev.off()
1000+1000

# Creation d'un fichier png et enregistrement dedans du graphe combinant les variables et les individus
GrapheVarInd="GrapheVarInd.png"
png("GrapheVarInd.png", bg = "transparent", width = 800, height = 800, units = "px", pointsize = 24)
fviz_pca_biplot(res.pca, repel = TRUE, label="var")
dev.off()

# Relancer l'ACP en ne gardant que les n premiers facteurs
res.pca2 <-PCA(datasetComplet, quanti.sup=if (is.null(Variables_quantitatives_illustratives)==FALSE) {which(colnames(datasetComplet)%in%ListQTsup)} else {NULL}, quali.sup=if (is.null(Variables_qualitatives_illustratives)==FALSE) {which(colnames(datasetComplet)%in%ListQLsup)} else {NULL}, ind.sup=NULL, scale.unit=scale, graph=TRUE, ncp=HAC_nf)

# Calcul d'une CAH sur les n premiers facteurs choisis par l'utilisateur
res.HCPC<-HCPC(res.pca2, nb.clust=Nb_clust, consol=FALSE, graph=FALSE, metric=distance, method=methode)

# Creation d'un fichier png et enregistrement de l'arbre hierarchique dedans
Dendrogram="Dendrogram.png"
png("Dendrogram.png", bg = "transparent", width = 800, height = 800, units = "px", pointsize = 24)
fviz_dend(res.HCPC,
cex = 0.7,                     # Label size
palette = "jco",               # Color palette see ?ggpubr::ggpar
rect = TRUE, rect_fill = TRUE, # Add rectangle around groups
rect_border = "jco",           # Rectangle color
labels_track_height = 0.8      # Place for labels
)
dev.off()

# Creation d'un fichier png et enregistrement de l'arbre hierarchique 3D dedans
Dendrogram3D="Dendrogram3D.png"
png("Dendrogram3D.png", bg = "transparent", width = 800, height = 800, units = "px", pointsize = 24)
plot.HCPC(res.HCPC, choice='3D.map', ind.names=FALSE, centers.plot=FALSE, angle=60, axes=c(1, 2))
dev.off()

# Conversion de l'objet res.HCPC data.clust en dataframe
res.HCPC.dataclust <- as.data.frame(res.HCPC[["data.clust"]])

# Creation d'une colonne contenant le code des unites spatiales a partir de l'argument row.names
# Utile uniquement au final pour controler le resultat dans la couche en sortie (verification de l'appariement)
res.HCPC.dataclust$ID <- row.names(res.HCPC.dataclust)

# Pour récupérer l'ordre de la variable "clust" dans le dataframe res.HCPC.dataclust
VarClust <-which(colnames(res.HCPC.dataclust) == "clust")

# Pour récupérer l'ordre de la variable "ID" dans le dataframe res.HCPC.dataclust
VarID <-which(colnames(res.HCPC.dataclust) == "ID")

# Choix des variables dans la couche en sortie pour eviter qu'elles ne soient dupliquees. 
# Ce qui nous interesse dans le dataframe res.HCPC.dataclust c'est le champ "clust", donc on enleve toutes les variables actives qui sont deja contenues dans Couche_en_entree
res.HCPC.dataclust<-res.HCPC.dataclust[names(res.HCPC.dataclust)[c(VarClust,VarID)]]

# Reformatage et assemblage des jeux de donnees pour pouvoir les afficher dans QGIS
# 1 - Récupération dans un dataframe des attributs de Couche_en_entree
dataset_layer <- as.data.frame(Couche_en_entree) 
# 2 - Conversion de l'objet Couche_en_entree qui est au format "sf" en objet "spdf - SpatialPolygonsDataFrame" (indispensable pour la suite)
dataset_spdf <- as_Spatial(Couche_en_entree) 
# 3 - Creation d'un objet au format spdf contenant les categories de la variable "clust"
spdf_clust <- SpatialPolygonsDataFrame(dataset_spdf, res.HCPC.dataclust, match.ID = F) # specification de l'argument match.ID = F pour que l'appariement se fasse automatiquement
# 4 - Jointure des deux SpatialPolygonsDataFrames pour avoir tous les champs de Couche_en_entree + la colonne clust
spdf_Complet <-cbind(dataset_spdf, spdf_clust)
# 5 - Conversion de l'objet complet qui est au format "SpatialPolygonsDataFrame" en objet "sf" (pour l'afficher en sortie dans QGIS)
sf_Complet <- as(spdf_Complet, "sf")
# 6 - Affichage de la couche contenant les classes dans QGIS
Couche_avec_les_classes=sf_Complet

# Creation d'un fichier de style QML
# 1 - Transformation de la colonne clust en valeur numerique ensuite tri ordre croissant puis extraction des elements differents d'un vecteur
Numer_clust=strtoi(res.HCPC.dataclust$clust)
Crois_clust=sort(Numer_clust)
Extra_clust=unique(Crois_clust)

# 2 - Creation et configuration du xml (transparence =alpha) (attr=valeurs des classes)
alpha = 1
base = newXMLNode("qgis")
addAttributes(base,version="3.4.9-Madeira",minimumScale="0",maximumScale="1e+08",hasScaleBasedVisibilityFlag="0")
trans <- newXMLNode("transparencyLevelInt", 255)
rend <- newXMLNode("renderer-v2", attrs = c(attr="clust",symbollevels="0",type="categorizedSymbol"))

# 3 - Creation des differentes categories
categories <- newXMLNode("categories")
category <- lapply(seq_along(Extra_clust),function(x){newXMLNode("category", attrs = c(symbol = Extra_clust[x], label = Extra_clust[x], value = Extra_clust[x]))})
addChildren(categories,category)

# 4 - Creation du style : couleur, transparence
symbols <- newXMLNode("symbols")
symbol <- lapply(seq_along(Extra_clust),function(x){dum.sym <- newXMLNode("symbol", attrs = c(outputUnit="MM",alpha=alpha,type="fill",name=as.character(x)))
liste2=list("#000000", "#ff0000", "#00cd00", "#0000ff", "#65fffe", "#ff00ff", "#a9a9a9", "#b8860b", "#006400", "#ee82ee")
layer <- newXMLNode("layer", attrs =c(pass="0",class="SimpleFill",locked="0"))
prop <- newXMLNode("prop", attrs =c(k="color",v=liste2[x] ))
addChildren(layer, prop)
addChildren(dum.sym, layer)
}) 
addChildren(symbols, symbol)

# 5 - Rendu en ajoutant les categories et le style cree precedement
addChildren(rend, list(categories, symbols))
addChildren(base, list(trans, rend))

# 6 - Enregistrement du fichier qml
sortieqml=paste(Espace_de_travail,"/style.qml",sep="")
writeLines(saveXML(base), sortieqml)


# Parametrage du contenu du fichier html (titres, graphiques, tableaux)
# Ajout d'un titre pour le tableau des valeurs propres a inserer dans le fichier html PCA_Results (reinitialisation du fichier html a chaque fois que le script est execute avec l'option append = FALSE)
HTML("<br>Tableau des valeurs propres ===>", file= "PCA_Results.html", append=FALSE)
# Insertion du tableau des valeurs propres dans le fichier html PCA_Results
HTML(eig.val, file= "PCA_Results.html", append=TRUE)

# Ajout d'un titre pour le graphe des gains d'inertie a inserer dans le fichier html PCA_Results
HTML("<br>Graphe des gains d'inertie ===>", file= "PCA_Results.html", append=TRUE)
# Insertion du graphe des gains d'inertie dans le fichier html PCA_Results
HTMLInsertGraph(GrapheGainInertie,file=HTMLoutput, append = TRUE)

# Ajout d'un titre pour le graphe des variables a inserer dans le fichier html PCA_Results
HTML("<br>Graphe des variables (1er plan factoriel) ===>", file= "PCA_Results.html", append=TRUE)
# Insertion du graphe des variables dans le fichier html PCA_Results
HTMLInsertGraph(GrapheVariables,file=HTMLoutput, append = TRUE)

# Ajout d'un titre pour la matrice restituant la representation a inserer dans le fichier html PCA_Results
HTML("<br>Qualité de représentation des variables (Cos2) ===>", file= "PCA_Results.html", append=TRUE)
# Insertion de la matrice de la qualite de representation dans le fichier html PCA_Results
HTMLInsertGraph(MatriceQualiteRepresentation,file=HTMLoutput, append = TRUE)

# Ajout d'un titre pour la matrice graphique des corrélations entre les variables a inserer dans le fichier html PCA_Results
HTML("<br>Matrice graphique des corrélations entre les variables ===>", file= "PCA_Results.html", append=TRUE)
# Insertion de la matrice de la qualite de representation dans le fichier html PCA_Results
HTMLInsertGraph(MatriceCorrelation,file=HTMLoutput, append = TRUE)

# Ajout d'un titre pour le graphe des individus a inserer dans le fichier html PCA_Results
HTML("<br>Graphe des individus suivant leur contribution <br>aux axes (1er plan factoriel) ===>", file= "PCA_Results.html", append=TRUE)
# Insertion du graphe des individus dans le fichier html PCA_Results
HTMLInsertGraph(GrapheIndividus,file=HTMLoutput, append = TRUE)

# Ajout d'un titre pour le graphe des individus suivant la/les variable(s) qualitative(s) supplémentaire(s) a inserer dans le fichier html PCA_Results
# Insertion du graphe des individus dans le fichier html PCA_Results (uniquement si au moins une variable qualitative supplémentaire a été sélectionnées)
if (is.null(Variables_qualitatives_illustratives)==FALSE)
{
HTML("<br>Graphe des individus suivant la/les variable(s) <br>qualitative(s) supplémentaire(s) ===>", file= "PCA_Results.html", append=TRUE)
HTMLInsertGraph(GrapheIndQualiSup,file=HTMLoutput, append = TRUE)} else {0}

# Ajout d'un titre pour le graphe combiné des variables et des individus a inserer dans le fichier html PCA_Results
HTML("<br>Graphe combiné des variables et des individus ===>", file= "PCA_Results.html", append=TRUE)
# Insertion du graphe combiné des variables et des individus dans le fichier html PCA_Results
HTMLInsertGraph(GrapheVarInd,file=HTMLoutput, append = TRUE)

# Ajout d'un titre pour l'arbre hierarchique a inserer dans le fichier html PCA_Results
HTML("<br>Arbre hiérarchique<br>(permet de choisir le nombre de classes à garder) ===>", file= "PCA_Results.html", append=TRUE)
# Insertion de l'arbre hierarchique dans le fichier html PCA_Results
HTMLInsertGraph(Dendrogram,file=HTMLoutput, append = TRUE)

# Ajout d'un titre pour l'arbre hierarchique 3D sur le 1er plan factoriel a inserer dans le fichier html PCA_Results
HTML("<br>Arbre hiérarchique sur le 1er plan factoriel ===>", file= "PCA_Results.html", append=TRUE)
# Insertion de l'arbre hierarchique sur le 1er plan factoriel dans le fichier html PCA_Results
HTMLInsertGraph(Dendrogram3D,file=HTMLoutput, append = TRUE)

# Ajout d'un titre pour les graphiques et tableaux de description des classes par les variables a inserer dans le fichier html PCA_Results (reinitialisation du fichier html a chaque fois que le script est execute avec l'option append = FALSE)
HTML("<br>Graphiques et tableaux de description <br>des classes par les variables ===>", file= "PCA_Results.html", append=TRUE)

# Recuperation dans des dataframes de la description de chacune des N classes par les variables
for (i in 1:Nb_clust){

  # Nommage des dataframes
  name<- paste("classe",i, sep="")  # La fonction paste permet de concatener differents elements
 
  # Recuperation dans des dataframes de la description de chacune des N classes par les variables
  b<-assign(name,as.data.frame(res.HCPC$desc.var$quanti[[i]])) # La fonction assign permet d'assigner un nom à une valeur/un element
  b<-signif(b,3)

  # Nommage des fichiers png
  name_png<- paste("Graphe_classe",i,".png",sep="")
 
  # Creation des fichiers png qui contiendront les histogramme horizontaux decrivant les classes par les variables
  png(name_png, bg = "transparent", width = 800, height = 800, units = "px", pointsize = 24)
  fichier<-get(name)
  barplot((fichier$v.test), names = row.names(fichier), col = "black", border = "white", horiz = TRUE, las = 1, xlim = c(-10, 10), cex.names=0.55, main = paste("Classe", i, sep=" "))
  dev.off()
  
  # Insertion des graphiques png dans le fichier html PCA_Results
  HTMLInsertGraph(name_png,file=HTMLoutput, append = TRUE)
  # Insertion des tableaux de description des classes par les variables dans le fichier html PCA_Results
  HTML(b, file= "PCA_Results.html", append=TRUE)
 }

# Affichage du fichier html PCA_Results dans un navigateur
browseURL("PCA_Results.html")
