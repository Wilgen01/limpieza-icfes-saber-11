## instalar librerias
require(magrittr)
require(readr)
require(tidyverse)
require(dplyr)
library(Amelia)
library(janitor)

## establecer directorios
dir_data_11 <- "D:/seminario/scripts/limpieza-icfes-saber-11/data_sb11_unida/SB11_unida.csv"
dir_data_sp <- "D:/seminario/scripts/limpieza-icfes-saber-11/data_limpia_SP/SP_unida.csv"
dir_data_keys <- "D:/seminario/scripts/limpieza-icfes-saber-11/data_limpia_SP/Llave_Saber11_SaberPro.txt"

## importar data
SB11 <- read_csv(dir_data_11)
SP <- read_csv(dir_data_sp)
keys <- read_csv(dir_data_keys)


## limpiar indice y validar que tengan las mismas columnas
names(SB11)
SB11$...1 <- NULL

names(SP)
SP$...1 <- NULL

## renombrar variable en saber 11 y saber pro
names(SB11)[2]="consecutivo11"
names(SB11)

names(SP)[2]="consecutivosp"
names(SP)

## renombrar variable en las cruces
names(keys)[1]="consecutivo11"
names(keys)

names(union_llave)[13]="consecutivosp"
names(union_llave)

## ajustar sp a sb11
SP$mod_competen_ciudada_punt <- NULL
SP$mod_lectura_critica_punt <- NULL
SP$mod_ingles_punt <- NULL
SP$mod_comuni_escrita_punt <- NULL
SP$mod_razona_cuantitat_punt <- NULL
SP$punt_global <- NULL


## renombrar variables prob normal de sp
SP %>% names()
names(SP)[11] = "pn_sociales_sp"
names(SP)[12] = "pn_ingles_sp"
names(SP)[13] = "pn_com_escrita_sp"
names(SP)[14] = "pn_matematicas_sp"
names(SP)[15] = "pn_lectura_sp"
names(SP)[16] = "pn_global_sp"


## union 
union_llave<-merge(x=SB11, y=keys, by = "consecutivo11")
data_final<-merge(x=union_llave, y=SP, by = "consecutivosp")

str(union_llave)


## graficando 
plot(data_final$pn_lectura_sp, data_final$pn_global_sp)


## guardar a CSV 
outputDir <- "C:/Users/SEMINARIOS/Documents/data_final.csv"
write.csv(data_final, outputDir)
