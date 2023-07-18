## instalar librerias
require(magrittr)
require(readr)
require(tidyverse)
require(dplyr)
library(Amelia)
library(janitor)

## preparando directorios
dirData1 <- "D:/seminario/scripts/limpieza-icfes-saber-11/data_limpia/SB11_20151.TXT"
dirData2 <- "D:/seminario/scripts/limpieza-icfes-saber-11/data_limpia/SB11_20152.TXT"
outputDir <- "D:/seminario/scripts/limpieza-icfes-saber-11/data_sb11_unida/SB11_2015.csv"
outputDirTXT <- "D:/seminario/scripts/limpieza-icfes-saber-11/data_sb11_unida/SB11_2015.txt"

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

## unir los dos periodos
dataUnida <- merge(periodo1, periodo2, all = T)

## promedia areas similares
names(dataUnida)
dataUnida$punt_sociales_ciudadanas <- round((dataUnida$PUNT_SOCIALES_CIUDADANAS+dataUnida$PUNT_COMP_CIUDADANA)/2)
dataUnida$PUNT_SOCIALES_CIUDADANAS <- NULL
dataUnida$PUNT_COMP_CIUDADANA <- NULL

dataUnida$punt_matematicas <- round((dataUnida$PUNT_MATEMATICAS+dataUnida$PUNT_RAZONA_CUANTITATIVO)/2)
dataUnida$PUNT_MATEMATICAS <- NULL
dataUnida$PUNT_RAZONA_CUANTITATIVO <- NULL
dataUnida$PUNT_GLOBAL <- NULL

## normalizar nombres para poder unir
dataUnida %<>%  clean_names()

## validar datos nulos
missmap(dataUnida)

## de ser necesario convertir nulos a 0
dataUnida[is.na(dataUnida)] <- 0

## calcular puntaje global
dataUnida$punt_global <- round((dataUnida$punt_c_naturales+dataUnida$punt_sociales_ciudadanas+dataUnida$punt_ingles+dataUnida$punt_lectura_critica+dataUnida$punt_matematicas)/5)


## separar la fecha de nacimiento
dataUnida$Nacimeinto <- substr(dataUnida$estu_fechanacimiento, 7, 10)
dataUnida$estu_fechanacimiento <- NULL
dataUnida$Nacimeinto %>% class()


## obtener estadisticas 
md<-mean(dataUnida$punt_sociales_ciudadanas)
sd<-sd(dataUnida$punt_sociales_ciudadanas)
dataUnida$pn_sociales<-round(pnorm(dataUnida$punt_sociales_ciudadanas, md, sd)*100)

md<-mean(dataUnida$punt_ingles)
sd<-sd(dataUnida$punt_ingles)
dataUnida$pn_ingles<-round(pnorm(dataUnida$punt_ingles, md, sd)*100) 

md<-mean(dataUnida$punt_c_naturales)
sd<-sd(dataUnida$punt_c_naturales)
dataUnida$pn_naturales<-round(pnorm(dataUnida$punt_c_naturales, md, sd)*100) 

md<-mean(dataUnida$punt_matematicas)
sd<-sd(dataUnida$punt_matematicas)
dataUnida$pn_matematicas<-round(pnorm(dataUnida$punt_matematicas, md, sd)*100) 

md<-mean(dataUnida$punt_lectura_critica)
sd<-sd(dataUnida$punt_lectura_critica)
dataUnida$pn_lectura<-round(pnorm(dataUnida$punt_lectura_critica, md, sd)*100) 

md<-mean(dataUnida$punt_global)
sd<-sd(dataUnida$punt_global)
dataUnida$pn_global<-round(pnorm(dataUnida$punt_global, md, sd)*100) 

## convertir txt a factor
dataUnida %<>% mutate_if(is.character, as.factor) 
str(dataUnida)

## guardar a CSV 
write.csv(dataUnida, outputDir)
write.csv(dataUnida, outputDirTXT)
