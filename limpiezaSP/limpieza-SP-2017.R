## instalar librerias
require(magrittr)
require(readr)
require(tidyverse)
require(dplyr)
library(Amelia)
library(janitor)

## preparando directorios
dirData <- "C:/wilgen/saber pro/SP_2017.TXT"
outputDir <- "C:/wilgen/data_limpia_SP/SP_2017.csv"
outputDirTXT <- "C:/wilgen/data_limpia_SP/SP_2017.TXT"

## importar data
df <- read_delim(dirData, 
                       delim = "¬", escape_double = FALSE, 
                       trim_ws = TRUE)

## copiar los datos a una nueva variable
data <- df
df <- NULL

# eliminar las columnas inecesarias del periodo 1
names(data)
mantener_columnas <- c(3,4,7,9,11,13,62,63,64,71,82,86,90,94,98,102)
data_limpia <- data[mantener_columnas]
names(data_limpia)
write.csv(data_limpia, "C:/wilgen/data_limpia/SB11_20221.TXT")


## de ser necesario convertir nulos a 0
data_limpia <- mutate_all(data_limpia, ~replace(., is.na(.), 0))
missmap(data_limpia)

## separar la fecha de nacimiento
data_limpia$nacimiento <- substr(data_limpia$ESTU_FECHANACIMIENTO, 7, 10)
data_limpia$ESTU_FECHANACIMIENTO <- NULL
data_limpia$nacimiento %>% class()


## normalizar nombres para poder unir
data_limpia %<>%  clean_names()

## obtener estadisticas 
md<-mean(data_limpia$mod_competen_ciudada_punt)
sd<-sd(data_limpia$mod_competen_ciudada_punt)
data_limpia$pn_sociales<-round(pnorm(data_limpia$mod_competen_ciudada_punt, md, sd)*100)

md<-mean(data_limpia$mod_ingles_punt)
sd<-sd(data_limpia$mod_ingles_punt)
data_limpia$pn_ingles<-round(pnorm(data_limpia$mod_ingles_punt, md, sd)*100) 

md<-mean(data_limpia$mod_comuni_escrita_punt)
sd<-sd(data_limpia$mod_comuni_escrita_punt)
data_limpia$pn_com_escrita<-round(pnorm(data_limpia$mod_comuni_escrita_punt, md, sd)*100) 

md<-mean(data_limpia$mod_razona_cuantitat_punt)
sd<-sd(data_limpia$mod_razona_cuantitat_punt)
data_limpia$pn_matematicas<-round(pnorm(data_limpia$mod_razona_cuantitat_punt, md, sd)*100) 

md<-mean(data_limpia$mod_lectura_critica_punt)
sd<-sd(data_limpia$mod_lectura_critica_punt)
data_limpia$pn_lectura<-round(pnorm(data_limpia$mod_lectura_critica_punt, md, sd)*100) 

md<-mean(data_limpia$punt_global)
sd<-sd(data_limpia$punt_global)
data_limpia$pn_global<-round(pnorm(data_limpia$punt_global, md, sd)*100)

## convertir txt a factor
data_limpia %<>% mutate_if(is.character, as.factor) 
str(data_limpia)

## guardar a CSV 
write.csv(data_limpia, outputDir)
write.csv(data_limpia, outputDirTXT)










