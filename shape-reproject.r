#source("shape-reproject.R")
#######################################################################################################
#######################################################################################################
#######################################################################################################
#Shape reproject
#######################################################################################################
#######################################################################################################
#######################################################################################################
#packages
#######################################################################################################
loadandinstall <- function(mypkg) {if (!is.element(mypkg,
                  installed.packages()[,1])){install.packages(mypkg)};
                  library(mypkg, character.only=TRUE)}
pk <- c("maptools","rgdal","raster","tcltk")
for(i in pk){loadandinstall(i)}
#######################################################################################################
#Definition of possible data  types
#######################################################################################################

Filters <- matrix(c("shp", "*.shp","All files", "*"),
                  2, 2, byrow = TRUE)
rownames(Filters) <- c("shp", "All files")
print(noquote(rownames(Filters)))
#######################################################################################################
#Interactive choosing of working directory
#######################################################################################################
setwd(file.path(choose.dir(default = "", caption = "Choose working directory")))
#######################################################################################################
#inactive settings
#######################################################################################################
print(list.files(pattern=".shp$"))
input.file  <- choose.files(filters = Filters[c("shp"),],caption = "Select input shape file ...")
output.file <- tkgetSaveFile(initialfile="", title="Name of output shape file ...")
input.epsg  <- readline(prompt = "Enter espg code of input shape file: ")
output.epsg <- readline(prompt = "Enter espg code of output shape file: ")  
#######################################################################################################
#import shapefile
shape <- shapefile(input.file)
#######################################################################################################
#assignment of projection
proj4string(shape) <- CRS(paste('+init=epsg:',input.epsg,sep=""))
#######################################################################################################
#transformation
#######################################################################################################
shape.trans <- spTransform(shape, CRS(paste('+init=epsg:',output.epsg,sep="")))
#######################################################################################################
#export
#######################################################################################################
shapefile(shape.trans, paste(output.file), overwrite=TRUE)