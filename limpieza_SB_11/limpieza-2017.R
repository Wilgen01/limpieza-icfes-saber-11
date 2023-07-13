## instalar librerias
require(magrittr)
require(readr)
require(tidyverse)
require(dplyr)

## definir directorios
dirData1 <- "D:/seminario/saber 11/SB11_20171.TXT"
outputDir1 <- "D:/seminario/data_limpia/SB11_20171.TXT"
dirData2 <- "D:/seminario/saber 11/SB11_20172.TXT"
outputDir2 <- "D:/seminario/data_limpia/SB11_20172.TXT"

## importar data
periodo1 <- read_delim(dirData1, 
                       delim = "¬", escape_double = FALSE, 
                       trim_ws = TRUE)
periodo2 <- read_delim(dirData2, 
                       delim = "¬", escape_double = FALSE, 
                       trim_ws = TRUE)

## copiar los datos a una nueva variable
data_periodo1 <- periodo1
periodo1 <- NULL
data_periodo2 <- periodo2
periodo2 <- NULL

# eliminar las columnas inecesarias del periodo 1
names(data_periodo1)
mantener_columnas_p1 <- c(3,4,6,8,11,13,61,64,67,70,73,76)
data_limpiap1 <- data_periodo1[mantener_columnas_p1]
names(data_limpiap1)
write.csv(data_limpiap1, outputDir1)

## limpiar espacio de trabajo
data_limpiap1 <- NULL
data_periodo1 <- NULL


# eliminar las columnas inecesarias del periodo 2

names(data_periodo2)
mantener_columnas_p2 <- c(3,4,6,8,11,13,61,64,67,70,73,76)
data_limpiap2 <- data_periodo2[mantener_columnas_p2]
names(data_limpiap2)
write.csv(data_limpiap2, outputDir2)
