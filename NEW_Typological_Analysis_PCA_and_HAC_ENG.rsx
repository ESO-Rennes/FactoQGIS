##FactoQGIS=group
##Working_Directory=Folder C:/Users/demoraes_f/Desktop/temp/Exo_QGIS
##Input_Layer=Vector parispc_com_N_variables
##Spatial_Units_ID=Field Input_Layer
##Active_Quantitative_Variables=Field numeric multiple Input_Layer P20ANS07;PNDIP07;TXCHOMA07;INTAO07;PART07;PCAD07;PINT07;PEMP07;POUV07;PRET07;PMONO07;PREFETR07;RFUCQ207
##Additional_Quantitative_Variables=optional Field numeric multiple Input_Layer
##Additional_Qualitative_Variables=optional Field string multiple Input_Layer
##Scale_Data=selection TRUE;FALSE
##Number_of_axes_to_be_kept_for_PCA=Number 5
##Number_of_axes_to_be_kept_for_HAC=Number 2
##Number_of_clusters_to_be_kept_for_HAC=Number 5
##Metric_to_be_used_to_build_the_tree=selection euclidean;manhattan
##Aggregation_method_to_be_used_to_define_clusters=selection ward;average;single;complete
##Eigen_Value_Table=output table
##Variable_Coordinates_Table=output table
##Layer_with_Clusters=output vector 
options("scipen"=100)  # To convert the values from Factor to standard decimal numbers

# 1 - Loading required packages
# To perform the PCA
library(FactoMineR)
# To produce aesthetic graphs deriving from the PCA
library(factoextra)
# To save the results to Excel
library(openxlsx)
# To generate a html file with the results
library(R2HTML)
# To create a matrix to visualize the quality of representation of the variables (cos2 of the variables on every dimension)
library(corrplot)
# To create a style file in qml format (xml format)
library(XML)


# 2 - Recovering and formatting the values entered into the dialog box by the user
# To assign to a character string the path of the working directory entered by the user
Working_Directory <- as.character(Working_Directory)

# To set working directory entered by the user
setwd(Working_Directory)

# To fetch in a character string named ListVarActiv the quantitative active variables selected by the user
ListVarActiv<-as.character(Active_Quantitative_Variables)

# To fetch in a character string named ListComplete all the variables chosen by the user whether they are active, additional, quantitative or qualitative
if ((is.null(Additional_Quantitative_Variables)==TRUE)&(is.null(Additional_Qualitative_Variables)==TRUE)) {ListComplet<-ListVarActiv} else if ((is.null(Additional_Qualitative_Variables)==TRUE)&(is.null(Additional_Quantitative_Variables)==FALSE)) {ListComplet<-c(ListVarActiv,as.character(Additional_Quantitative_Variables))} else if (((is.null(Additional_Qualitative_Variables)==FALSE))&(is.null(Additional_Quantitative_Variables)==TRUE)) {ListComplet<-c(ListVarActiv,as.character(Additional_Qualitative_Variables))} else {ListComplet<-c(ListVarActiv,as.character(Additional_Quantitative_Variables),as.character(Additional_Qualitative_Variables))}

# To fetch in a character string named ListQTsup the list of additional quantitative variables if selected by the user
if (is.null(Additional_Quantitative_Variables)==FALSE) {ListQTsup<-as.character(Additional_Quantitative_Variables)} 

# To fetch in a character string named ListQLsup the list of additional qualitative variables if selected by the user
if (is.null(Additional_Qualitative_Variables)==FALSE) {ListQLsup<-as.character(Additional_Qualitative_Variables)} 

# To save the number of factors entered by user to be kept for the PCA
nf<-as.numeric(Number_of_axes_to_be_kept_for_PCA)

# To save the number of clusters entered by user to be kept for the HAC
Nb_clust<-as.numeric(Number_of_clusters_to_be_kept_for_HAC)

# To save the number of factors entered by user to be kept for the HAC
HAC_nf<-as.numeric(Number_of_axes_to_be_kept_for_HAC)

# To create a boolean parameter which corresponds to the choice set by the user to scale and center or not the data
Scales<-c("TRUE","FALSE")
Scale<-Scales[Scale_Data+1]
if (Scale == 'TRUE'){scale <- 1} else {scale <- 0}

# To create a parameter which corresponds to the distance type set by the user to build the tree
distances<-c("euclidean","manhattan")
distance<-distances[Metric_to_be_used_to_build_the_tree+1]

# To create a parameter which corresponds to the method of aggregation set by the user to define clusters
methodes<-c("ward","average","single","complete")
methode<-methodes[Aggregation_method_to_be_used_to_define_clusters+1]

# To import the dataset
dataset<-as.data.frame(Input_Layer) # At this stage we only work on the attribute values so we convert Input_Layer to a simple dataframe

# To add the field Spatial_Units_ID to the dataset
dataset<-cbind(dataset, Input_Layer[[Spatial_Units_ID]])

# To rename the field Spatial_Units_ID as ID
names(dataset)[names(dataset) == "Input_Layer[[Spatial_Units_ID]]"] <- "ID"

# To set ID attribute as rowname
row.names(dataset)<-dataset$ID

# To create a dataframe subset from the initial table based on the user-selected quantitative active fields
datasetListVarActiv <- dataset[names(dataset)[names(dataset) %in% ListVarActiv]]

# To create a complete dataframe combining all the variables selected by the user, whether they are active, additional, quantitative or qualitative
datasetComplet <- dataset[names(dataset)[names(dataset) %in% ListComplet]]

# To create in the working directory a html file that will contain all the output graphs and tables
directory<-getwd()
HTMLoutput=file.path(directory,"PCA_Results.html")

# To perform the PCA
res.pca <-PCA(datasetComplet, quanti.sup=if (is.null(Additional_Quantitative_Variables)==FALSE) {which(colnames(datasetComplet) %in% ListQTsup)} else {NULL}, quali.sup=if (is.null(Additional_Qualitative_Variables)==FALSE) {which(colnames(datasetComplet) %in% ListQLsup)} else {NULL}, ind.sup=NULL, scale.unit=scale, graph=TRUE, ncp=nf)

# To create an object containing the results from the PCA for variables
var <- get_pca_var(res.pca)

# To create a table with the eigen values and to export it to xlsx
eig.val <- get_eigenvalue(res.pca)
eig.val<-round(eig.val,2)
write.xlsx(eig.val, "EigenValue.xlsx", asTable=FALSE, col.names = TRUE, row.names = TRUE, append = FALSE, showNA = FALSE)

# To display the eigen values table in QGIS
Eigen_Value_Table=eig.val

# To create a png file and to save the scree plot (gain of inertia) in it
GrapheGainInertie="GrapheGainInertie.png"
png("GrapheGainInertie.png",  bg = "transparent", width = 1200, height = 1000, units = "px", pointsize = 12)
fviz_eig(res.pca, addlabels = TRUE, ylim = c(0, 50), font.main = 20, font.submain = 18,  font.x = 14, font.y = 14)
dev.off()

# To create a table with the coordinates of the variables on the axes and to export it to xlsx
VarCoord<-as.data.frame(var$coord)
VarCoord<-round(VarCoord,2)
VarCoord<-VarCoord[order(VarCoord$Dim.1, decreasing = TRUE), ] # To sort the table on the first axis
write.xlsx(VarCoord, "VarCoord.xlsx", asTable=FALSE, col.names = TRUE, row.names = TRUE, append = FALSE, showNA = FALSE)

# To display the coordinates of the variables on the axes in a table in QGIS
Variable_Coordinates_Table=VarCoord

# To create a png file that will contain the PCA plot of the variables
GrapheVariables="GrapheVariables.png"
png("GrapheVariables.png", bg = "transparent", width = 500, height = 500, units = "px", pointsize = 24)
fviz_pca_var(res.pca, col.var="contrib", gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"), repel = TRUE)
dev.off()

# To create a png file that will contain a graphical colored matrix showing the quality of the representation of the variables (cosine of the variables on every dimensions)
MatriceQualiteRepresentation="MatriceQualiteRepresentation.png"
png("MatriceQualiteRepresentation.png", bg = "transparent", width = 1000, height = 1500, units = "px", pointsize = 24)
corrplot(var$cos2, is.corr=FALSE)
dev.off()

# To create a png file that will contain a graphical colored matrix showing the correlations between the variables
MatriceCorrelation="MatriceCorrelation.png"
png("MatriceCorrelation.png", bg = "transparent", width = 1000, height = 1200, units = "px", pointsize = 24)
col<- colorRampPalette(c("darkblue", "blue", "lightblue", "white", "orange", "red", "darkred"))(20)  # to define a colour palette
corrplot(cor(datasetListVarActiv), method="circle", diag=FALSE, col= col, type="upper",order="hclust")
dev.off()

# To create a png file that will contain the PCA plot of the individuals
GrapheIndividus="GrapheIndividus.png"
png("GrapheIndividus.png", bg = "transparent", width = 800, height = 800, units = "px", pointsize = 24)
fviz_pca_ind(res.pca, col.ind="contrib", gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"), repel = TRUE)
dev.off()

# To create a png file that will contain the PCA plot of the individuals differentiated according to the additional qualitative variable(s) + ellipses  
# This graph is only created if at least one additional qualitative variable has been selected
if (is.null(Additional_Qualitative_Variables)==FALSE) 
{GrapheIndQualiSup="GrapheIndQualiSup.png"
png("GrapheIndQualiSup.png", bg = "transparent", width = 800, height = 800, units = "px", pointsize = 24) 
fviz_pca_ind(res.pca, repel = TRUE, label="var", habillage= which(colnames(datasetComplet) %in% ListQLsup), addEllipses = TRUE)
} else {0}
dev.off()
1000+1000

# To create a png file that will contain a PCA plot combining the variables and the individuals
GrapheVarInd="GrapheVarInd.png"
png("GrapheVarInd.png", bg = "transparent", width = 800, height = 800, units = "px", pointsize = 24)
fviz_pca_biplot(res.pca, repel = TRUE, label="var")
dev.off()

# To perfom again the PCA only by keeping the n first factors
res.pca2 <-PCA(datasetComplet, quanti.sup=if (is.null(Additional_Quantitative_Variables)==FALSE) {which(colnames(datasetComplet)%in%ListQTsup)} else {NULL}, quali.sup=if (is.null(Additional_Qualitative_Variables)==FALSE) {which(colnames(datasetComplet)%in%ListQLsup)} else {NULL}, ind.sup=NULL, scale.unit=scale, graph=TRUE, ncp=HAC_nf)

# To perform a HAC on the n first factors chosen by the user
res.HCPC<-HCPC(res.pca2, nb.clust=Nb_clust, consol=FALSE, graph=FALSE, metric=distance, method=methode)

# To create a png file that will contain the Hierarchical cluster tree
Dendrogram="Dendrogram.png"
png("Dendrogram.png", bg = "transparent", width = 800, height = 800, units = "px", pointsize = 24)
# res.HCPC$call$t$nb.clust = Nb_clust #override nombre par defaut de cluster
fviz_dend(res.HCPC,
cex = 0.7,                     # Label size
palette = "jco",               # Color palette see ?ggpubr::ggpar
rect = TRUE, rect_fill = TRUE, # Add rectangle around groups
rect_border = "jco",           # Rectangle color
labels_track_height = 0.8      # Place for labels
)
dev.off()

# To create a png file that will contain the 3D Hierarchical cluster tree
Dendrogram3D="Dendrogram3D.png"
png("Dendrogram3D.png", bg = "transparent", width = 800, height = 800, units = "px", pointsize = 24)
plot.HCPC(res.HCPC, choice='3D.map', ind.names=FALSE, centers.plot=FALSE, angle=60, axes=c(1, 2))
dev.off()

# To convert the object res.HCPC data.clust into a dataframe
res.HCPC.dataclust <- as.data.frame(res.HCPC[["data.clust"]])

# Create a column containing the ID of the spatial units using the row.names argument
# Only useful in the end to control the result in the output layer (to check if the matching between rows is ok)
res.HCPC.dataclust$ID <- row.names(res.HCPC.dataclust)

# To fetch the index of the variable "clust" from the dataframe res.HCPC.dataclust
VarClust <-which(colnames(res.HCPC.dataclust) == "clust")

# To fetch the index of the variable "ID" from the dataframe res.HCPC.dataclust
VarID <-which(colnames(res.HCPC.dataclust) == "ID")

# To choose the variables in the output layer to avoid their duplication. 
# What concern us in the dataframe res.HCPC.dataclust is the "clust" field, so we remove all the active variables which are already contained in Input_Layer
res.HCPC.dataclust<-res.HCPC.dataclust[names(res.HCPC.dataclust)[c(VarClust,VarID)]]

# To reformat and to merge the dataframes so as to be able to display them in Qgis
# 1 - To convert the attributes from Input_Layer to a dataframe
dataset_layer <- as.data.frame(Input_Layer) 
# 2 - To convert the object Input_Layer which is a "sf" format into an "spdf - SpatialPolygonsDataFrame" object (essential for later on)
dataset_spdf <- as_Spatial(Input_Layer) 
# 3 - To create a spdf format object containing the categories of the variable "clust"
spdf_clust <- SpatialPolygonsDataFrame(dataset_spdf, res.HCPC.dataclust, match.ID = F) # match.ID = F for automatic matching
# 4 - To merge both SpatialPolygonsDataFrames to get all the fields from Input_Layer + the field "clust"
spdf_Complet <-cbind(dataset_spdf, spdf_clust)
# 5 - To convert the complete SpatialPolygonsDataFrame object into an "sf" object (in order to display it in QGIS)
sf_Complet <- as(spdf_Complet, "sf")
# 6 - To display the layer containing the clusters in QGIS
Layer_with_Clusters=sf_Complet

# To create a QML style file 
# 1 - Transformation of the clust column into a numerical value, then sorting in ascending order and extraction of the different elements of a vector
Numer_clust=strtoi(res.HCPC.dataclust$clust)
Crois_clust=sort(Numer_clust)
Extra_clust=unique(Crois_clust)

# 2 - Creation and setting of the xml file (transparency=alpha) (attr=class values)
alpha = 1
base = newXMLNode("qgis")
addAttributes(base,version="3.4.9-Madeira",minimumScale="0",maximumScale="1e+08",hasScaleBasedVisibilityFlag="0")
trans <- newXMLNode("transparencyLevelInt", 255)
rend <- newXMLNode("renderer-v2", attrs = c(attr="clust",symbollevels="0",type="categorizedSymbol"))

# 3 - Creation of the different categories
categories <- newXMLNode("categories")
category <- lapply(seq_along(Extra_clust),function(x){newXMLNode("category", attrs = c(symbol = Extra_clust[x], label = Extra_clust[x], value = Extra_clust[x]))})
addChildren(categories,category)

# 4 - Defining style: color, transparency
symbols <- newXMLNode("symbols")
symbol <- lapply(seq_along(Extra_clust),function(x){dum.sym <- newXMLNode("symbol", attrs = c(outputUnit="MM",alpha=alpha,type="fill",name=as.character(x)))
liste2=list("#000000", "#ff0000", "#00cd00", "#0000ff", "#65fffe", "#ff00ff", "#a9a9a9", "#b8860b", "#006400", "#ee82ee")
layer <- newXMLNode("layer", attrs =c(pass="0",class="SimpleFill",locked="0"))
prop <- newXMLNode("prop", attrs =c(k="color",v=liste2[x] ))
addChildren(layer, prop)
addChildren(dum.sym, layer)
}) 
addChildren(symbols, symbol)

# 5 - Defining render with the previous categories and style
addChildren(rend, list(categories, symbols))
addChildren(base, list(trans, rend))

# 6 - Saving qml file
sortieqml=paste(Working_Directory,"/style.qml",sep="")
writeLines(saveXML(base), sortieqml)


# Settings for the content of the html file (titles, graphs, tables)
# To add into the PCA_Results html file a caption for the table of the eigen values (the append = FALSE option allows to reset the html file each time the script is executed)
HTML("<br>Table of the eigen values ===>", file= "PCA_Results.html", append=FALSE)
# To insert into the PCA_Results html file the table of the eigen values
HTML(eig.val, file= "PCA_Results.html", append=TRUE)

# To add into the PCA_Results html file a caption for the scree plot (gain of inertia)
HTML("<br>Scee plot (Gain of inertia) ===>", file= "PCA_Results.html", append=TRUE)
# To insert into the PCA_Results html file the scree plot (gain of inertia)
HTMLInsertGraph(GrapheGainInertie,file=HTMLoutput, append = TRUE)

# To add into the PCA_Results html file a caption for the factor map of variables
HTML("<br>First factor map showing the variables <br>and their contribution to the axes ===>", file= "PCA_Results.html", append=TRUE)
# To insert into the PCA_Results html file the PCA plot showing the variables
HTMLInsertGraph(GrapheVariables,file=HTMLoutput, append = TRUE)

# To add into the PCA_Results html file a caption for the matrix showing the quality of the representation of the variables
HTML("<br>Quality of the representation of the variables (Cos2) ===>", file= "PCA_Results.html", append=TRUE)
# To insert into the PCA_Results html file the graphical matrix showing the quality of the representation of the variables
HTMLInsertGraph(MatriceQualiteRepresentation,file=HTMLoutput, append = TRUE)

# To add into the PCA_Results html file a caption for the graphical colored matrix showing the correlations between the variables
HTML("<br>Correlations between the variables ===>", file= "PCA_Results.html", append=TRUE)
# To insert into the PCA_Results html file the graphical colored matrix showing the correlations between the variables
HTMLInsertGraph(MatriceCorrelation,file=HTMLoutput, append = TRUE)

# To add into the PCA_Results html file a caption for the factor map showing the contribution of the individuals
HTML("<br>PCA plot showing the contribution of the individuals <br>to the axes (1st factor map) ===>", file= "PCA_Results.html", append=TRUE)
# To insert into the PCA_Results html file the PCA plot showing the individuals with their contribution
HTMLInsertGraph(GrapheIndividus,file=HTMLoutput, append = TRUE)

# To add into the PCA_Results html file a caption for the factor map showing the individuals differentiated according to the additional qualitative variable(s)
# To insert into the PCA_Results html file the PCA plot of the individuals (only if at least one additional qualitative variable has been selected)
if (is.null(Additional_Qualitative_Variables)==FALSE)
{
HTML("<br>PCA plot showing the individuals differentiated according <br>to the additional qualitative variable(s) <br>(1st factor map) ===>", file= "PCA_Results.html", append=TRUE)
HTMLInsertGraph(GrapheIndQualiSup,file=HTMLoutput, append = TRUE)} else {0}

# To add into the PCA_Results html file a caption for the PCA Plot combining the variables and the individuals
HTML("<br>PCA Plot combining the variables and the individuals <br>(1st factor map) ===>", file= "PCA_Results.html", append=TRUE)
# To insert into the PCA_Results html file the PCA plot combining the variables and the individuals
HTMLInsertGraph(GrapheVarInd,file=HTMLoutput, append = TRUE)

# To add into the PCA_Results html file a caption for the Hierarchical cluster tree
HTML("<br>Hierarchical cluster tree<br>(allows to select the number of clusters to be kept) ===>", file= "PCA_Results.html", append=TRUE)
# To insert into the PCA_Results html file the Hierarchical cluster tree
HTMLInsertGraph(Dendrogram,file=HTMLoutput, append = TRUE)

# To add into the PCA_Results html file a caption for the 3D Hierarchical cluster tree on the first factor map
HTML("<br>3D Hierarchical cluster tree <br>(1st factor map)===>", file= "PCA_Results.html", append=TRUE)
# To insert into the PCA_Results html file the 3D Hierarchical cluster tree on the first factor map
HTMLInsertGraph(Dendrogram3D,file=HTMLoutput, append = TRUE)

# To add into the PCA_Results html file a caption for the bar plots and tables showing the variables which best describe the clusters (the append = FALSE option allows to reset the html file each time the script is executed)
HTML("<br>Bar plots and tables which describe the clusters <br>based on the variables ===>", file= "PCA_Results.html", append=TRUE)

# To save into dataframes the description of each one of the N clusters by the variables
for (i in 1:Nb_clust){

  # To name the dataframes
  name<- paste("classe",i, sep="")  # La fonction paste permet de concatener differents elements
 
  # To save into dataframes the description of each one of the N clusters by the variables
  b<-assign(name,as.data.frame(res.HCPC$desc.var$quanti[[i]]))
  b<-signif(b,3)

  # To name the png files
  name_png<- paste("Graphe_classe",i,".png",sep="")
 
  # To create png files that will contain the bar plots showing the variables which best describe the clusters
  png(name_png, bg = "transparent", width = 800, height = 800, units = "px", pointsize = 24)
  fichier<-get(name)
  barplot((fichier$v.test), names = row.names(fichier), col = "black", border = "white", horiz = TRUE, las = 1, xlim = c(-10, 10), cex.names=0.55, main = paste("Classe", i, sep=" "))
  dev.off()
  
  # To insert the bar plots into the PCA_Results html file 
  HTMLInsertGraph(name_png,file=HTMLoutput, append = TRUE)
  # To insert into the PCA_Results html file the dataframes giving the description of each one of the N clusters by the variables
  HTML(b, file= "PCA_Results.html", append=TRUE)
 }

# Display the PCA_Results html file in a web browser
browseURL("PCA_Results.html")
