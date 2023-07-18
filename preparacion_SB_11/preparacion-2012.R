## instalar librerias
require(magrittr)
require(readr)
require(tidyverse)
require(dplyr)
library(Amelia)
library(janitor)

## preparando directorios
dirData1 <- "D:/seminario/scripts/limpieza-icfes-saber-11/data_limpia/SB11_20121.TXT"
dirData2 <- "D:/seminario/scripts/limpieza-icfes-saber-11/data_limpia/SB11_20122.TXT"
outputDir <- "D:/seminario/scripts/limpieza-icfes-saber-11/data_sb11_unida/SB11_2012.csv"
outputDirTXT <- "D:/seminario/scripts/limpieza-icfes-saber-11/data_sb11_unida/SB11_2012.txt"

## importar data
periodo1 <- read_delim(dirData1, 
                       delim = ",", escape_double = FALSE, 
                       trim_ws = TRUE)
periodo2 <- read_delim(dirData2, 
                       delim = ",", escape_double = FALSE, 
                       trim_ws = TRUE)


## limpiar indice y validar que tengan las mismas columnas
periodo1$...1 <- NULL
periodo2$...1 <- NULL
names(periodo1)
names(periodo2)

## unir los dos periodos
dataUnida2012 <- merge(periodo1, periodo2, all = T)

## cambiar nombre a las variables para que coincidan con años superiores
names(dataUnida2012)
dataUnida2012[c(7:14, 20)] <- NULL
names(dataUnida2012)[7] = "punt_sociales_ciudadanas"
names(dataUnida2012)[8] = "punt_ingles"
names(dataUnida2012)[9] = "punt_lectura_critica"
names(dataUnida2012)[10] = "punt_matematicas"
names(dataUnida2012)[11] = "punt_c_naturales"

## calcular puntaje global
dataUnida2012$punt_global <- round((dataUnida2012$punt_c_naturales+dataUnida2012$punt_sociales_ciudadanas+dataUnida2012$punt_ingles+dataUnida2012$punt_lectura_critica+dataUnida2012$punt_matematicas)/5)


## normalizar nombres
dataUnida2012 %<>%  clean_names()
names(dataUnida2012)

## separar la fecha de nacimiento
dataUnida2012$Nacimeinto <- substr(dataUnida2012$estu_fechanacimiento, 7, 10)
dataUnida2012$estu_fechanacimiento <- NULL
dataUnida2012$Nacimeinto %>% class()

## validar datos nulos
missmap(dataUnida2012)

## de ser necesario convertir nulos a 0
dataUnida2012[is.na(dataUnida2012)] <- 0

## obtener estadisticas 
md<-mean(dataUnida2012$punt_sociales_ciudadanas)
sd<-sd(dataUnida2012$punt_sociales_ciudadanas)
dataUnida2012$pn_sociales<-round(pnorm(dataUnida2012$punt_sociales_ciudadanas, md, sd)*100)

md<-mean(dataUnida2012$punt_ingles)
sd<-sd(dataUnida2012$punt_ingles)
dataUnida2012$pn_ingles<-round(pnorm(dataUnida2012$punt_ingles, md, sd)*100) 

md<-mean(dataUnida2012$punt_c_naturales)
sd<-sd(dataUnida2012$punt_c_naturales)
dataUnida2012$pn_naturales<-round(pnorm(dataUnida2012$punt_c_naturales, md, sd)*100) 

md<-mean(dataUnida2012$punt_matematicas)
sd<-sd(dataUnida2012$punt_matematicas)
dataUnida2012$pn_matematicas<-round(pnorm(dataUnida2012$punt_matematicas, md, sd)*100) 

md<-mean(dataUnida2012$punt_lectura_critica)
sd<-sd(dataUnida2012$punt_lectura_critica)
dataUnida2012$pn_lectura<-round(pnorm(dataUnida2012$punt_lectura_critica, md, sd)*100) 

md<-mean(dataUnida2012$punt_global)
sd<-sd(dataUnida2012$punt_global)
dataUnida2012$pn_global<-round(pnorm(dataUnida2012$punt_global, md, sd)*100) 


## convertir txt a factor
dataUnida2012 %<>% mutate_if(is.character, as.factor) 
str(dataUnida2012)

## guardar a CSV 
write.csv(dataUnida2012, outputDir)
write.csv(dataUnida2012, outputDirTXT)
