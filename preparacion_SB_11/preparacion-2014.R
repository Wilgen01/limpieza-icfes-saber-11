## instalar librerias
require(magrittr)
require(readr)
require(tidyverse)
require(dplyr)
library(Amelia)
library(janitor)

## preparando directorios
dirData1 <- "C:/wilgen/data_limpia/SB11_20141.TXT"
dirData2 <- "C:/wilgen/data_limpia/SB11_20142.TXT"
outputDir <- "C:/wilgen/data_sb11_unida/SB11_2014.csv"
outputDirTXT <- "C:/wilgen/data_sb11_unida/SB11_2014.TXT"

## importar data
periodo1 <- read_delim(dirData1, 
                       delim = ",", escape_double = FALSE, 
                       trim_ws = TRUE)
periodo2 <- read_delim(dirData2, 
                       delim = ",", escape_double = FALSE, 
                       trim_ws = TRUE)


## limpiar indice y validar que tengan las mismas columnas
names(periodo1)
names(periodo2)
periodo1$...1 <- NULL
periodo2$...1 <- NULL

## promedia areas similares
periodo2$punt_ciencias_sociales <- round(periodo2$PUNT_SOCIALES_CIUDADANAS+periodo1$RECAF_PUNT_LECTURA_CRITICA)
periodo2$punt_ciencias_sociales[is.na(periodo2$punt_ciencias_sociales)] <- 0

## unir los dos periodos
dataUnida <- merge(periodo1, periodo2, all = T)

## cambiar nombre a las variables para que coincidan con años superiores
names(dataUnida)
names(dataUnida)[7] = "punt_ciencias_sociales"
names(dataUnida)[8] = "punt_ingles"
names(dataUnida)[9] = "punt_lectura_critica"
names(dataUnida)[10] = "punt_matematicas"
names(dataUnida)[11] = "punt_c_naturales"

## validar datos nulos
missmap(dataUnida)

## de ser necesario convertir nulos a 0
dataUnida[is.na(dataUnida)] <- 0

## calcular puntaje global
dataUnida$punt_global <- round((dataUnida$punt_c_naturales+dataUnida$punt_ciencias_sociales+dataUnida$punt_ingles+dataUnida$punt_lectura_critica+dataUnida$punt_matematicas)/5)


## normalizar nombres
dataUnida %<>%  clean_names()
names(dataUnida)

## separar la fecha de nacimiento
dataUnida$Nacimeinto <- substr(dataUnida$estu_fechanacimiento, 7, 10)
dataUnida$estu_fechanacimiento <- NULL
dataUnida$Nacimeinto %>% class()


## obtener estadisticas 
md_global<-mean(dataUnida$punt_global)
sd_global<-sd(dataUnida$punt_global)
dataUnida$pn_global<-round(pnorm(dataUnida$punt_global, md_global, sd_global)*100) 
max(dataUnida$pn_global)

## convertir txt a factor
dataUnida %<>% mutate_if(is.character, as.factor) 
str(dataUnida)

## guardar a CSV 
write.csv(dataUnida, outputDir)
write.csv(dataUnida, outputDirTXT)
