## instalar librerias
require(magrittr)
require(readr)
require(tidyverse)
require(dplyr)
library(Amelia)
library(janitor)

## preparando directorios
dirData1 <- "C:/Users/SEMINARIOS/Documents/data_limpia/SB11_20181.TXT"
dirData2 <- "C:/Users/SEMINARIOS/Documents/data_limpia/SB11_20182.TXT"
outputDir <- "C:/Users/SEMINARIOS/Documents/SB11_2018.csv"
outputDirTXT <- "C:/Users/SEMINARIOS/Documents/SB11_2018.TXT"

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
dataUnidad <- merge(periodo1, periodo2, all = T)

## cambiar nombre a las variables para que coincidan con años superiores
names(dataUnidad)
names(dataUnidad)[10] = "punt_sociales_ciudadanas"
names(dataUnidad)[11] = "punt_ingles"
names(dataUnidad)[7] = "punt_lectura_critica"
names(dataUnidad)[10] = "punt_matematicas"
names(dataUnidad)[11] = "punt_c_naturales"

## calcular puntaje global
dataUnidad$punt_global <- round((dataUnidad$punt_c_naturales+dataUnidad$punt_ciencias_sociales+dataUnidad$punt_ingles+dataUnidad$punt_lectura_critica+dataUnidad$punt_matematicas)/5)


## normalizar nombres
dataUnidad %<>%  clean_names()
names(dataUnidad)

## separar la fecha de nacimiento
dataUnidad$nacimeinto <- substr(dataUnidad$estu_fechanacimiento, 7, 10)
dataUnidad$estu_fechanacimiento <- NULL
dataUnidad$nacimeinto %>% class()

## validar datos nulos
missmap(dataUnidad)

## de ser necesario convertir nulos a 0
dataUnidad[is.na(dataUnidad)] <- 0

## obtener estadisticas 
md_global<-mean(dataUnidad$punt_global)
sd_global<-sd(dataUnidad$punt_global)
dataUnidad$pn_global<-round(pnorm(dataUnidad$punt_global, md_global, sd_global)*100) 
max(dataUnidad$pn_global)

md_matematica<-mean(dataUnidad$punt_matematicas)
sd_matematica<-sd(dataUnidad$punt_matematicas)
dataUnidad$pn_matematicas<-round(pnorm(dataUnidad$punt_matematicas, md_matematica, sd_matematica)*100) 

md_lecturaC<-mean(dataUnidad$punt_lectura_critica)
sd_lecturaC<-sd(dataUnidad$punt_lectura_critica)
dataUnidad$pn_lectura<-round(pnorm(dataUnidad$punt_lectura_critica, md_lecturaC, sd_lecturaC)*100) 

md_ingles<-mean(dataUnidad$punt_ingles)
sd_ingles<-sd(dataUnidad$punt_ingles)
dataUnidad$pn_ingles<-round(pnorm(dataUnidad$punt_ingles, md_ingles, sd_ingles)*100) 

md_cNaturales<-mean(dataUnidad$punt_c_naturales)
sd_cNaturales<-sd(dataUnidad$punt_c_naturales)
dataUnidad$pn_naturales<-round(pnorm(dataUnidad$punt_c_naturales, md_cNaturales, sd_cNaturales)*100) 

md_socialesC<-mean(dataUnidad$punt_sociales_ciudadanas)
sd_socialesC<-sd(dataUnidad$punt_sociales_ciudadanas)
dataUnidad$pn_sociales<-round(pnorm(dataUnidad$punt_sociales_ciudadanas, md_socialesC, sd_socialesC)*100) 



## convertir txt a factor
dataUnidad %<>% mutate_if(is.character, as.factor) 
str(dataUnidad)

## guardar a CSV 
write.csv(dataUnidad, outputDir)
write.csv(dataUnidad, outputDirTXT)
