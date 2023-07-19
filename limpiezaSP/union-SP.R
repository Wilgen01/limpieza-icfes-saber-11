## instalar librerias
require(magrittr)
require(readr)
require(tidyverse)
require(dplyr)
library(Amelia)
library(janitor)

## preparando directorios
data2017 <- "C:/wilgen/data_limpia_SP/SP_2017.TXT"
data2018 <- "C:/wilgen/data_limpia_SP/SP_2018.TXT"
data2019 <- "C:/wilgen/data_limpia_SP/SP_2019.TXT"




## importar data
df17 <- read_delim(data2017, 
                   delim = ",", escape_double = FALSE, 
                   trim_ws = TRUE)

df18 <- read_delim(data2018, 
                   delim = ",", escape_double = FALSE, 
                   trim_ws = TRUE)

df19 <- read_delim(data2019, 
                   delim = ",", escape_double = FALSE, 
                   trim_ws = TRUE)

## limpiar indice y validar que tengan las mismas columnas
df17$...1 <- NULL
df18$...1 <- NULL
df19$...1 <- NULL

dataUnida <- merge(periodo1, periodo2, all = T)
merge()