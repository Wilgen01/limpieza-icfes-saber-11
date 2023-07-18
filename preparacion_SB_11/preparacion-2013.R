## instalar librerias
require(magrittr)
require(readr)
require(tidyverse)
require(dplyr)
library(Amelia)
library(janitor)

## preparando directorios
dirData1 <- "D:/seminario/scripts/limpieza-icfes-saber-11/data_limpia/SB11_20131.TXT"
dirData2 <- "D:/seminario/scripts/limpieza-icfes-saber-11/data_limpia/SB11_20132.TXT"
outputDir <- "D:/seminario/scripts/limpieza-icfes-saber-11/data_sb11_unida/SB11_2013.csv"
outputDirTXT <- "D:/seminario/scripts/limpieza-icfes-saber-11/data_sb11_unida/SB11_2013.txt"

## importar data
periodo1 <- read_delim(dirData1, 
                       delim = ",", escape_double = FALSE, 
                       trim_ws = TRUE)
periodo2 <- read_delim(dirData2, 
                       delim = ",", escape_double = FALSE, 
                       trim_ws = TRUE)


## limpiar indice y validar que tengan las mismas columnas
periodo1$...2 <- NULL
periodo2$...2 <- NULL
names(periodo1)
names(periodo2)

## unir los dos periodos
dataUnida <- merge(periodo1, periodo2, all = T)

## cambiar nombre a las variables para que coincidan con años superiores
names(dataUnida)
names(dataUnida)[7] = "punt_sociales_ciudadanas"
names(dataUnida)[8] = "punt_ingles"
names(dataUnida)[9] = "punt_lectura_critica"
names(dataUnida)[10] = "punt_matematicas"
names(dataUnida)[11] = "punt_c_naturales"

## validar datos nulos
missmap(dataUnida)

## de ser necesario convertir nulos a 0
dataUnida[is.na(dataUnida)] <- 0

## calcular puntaje global
dataUnida$punt_global <- round((dataUnida$punt_c_naturales+dataUnida$punt_sociales_ciudadanas+dataUnida$punt_ingles+dataUnida$punt_lectura_critica+dataUnida$punt_matematicas)/5)


## normalizar nombres
dataUnida %<>%  clean_names()
names(dataUnida)

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
