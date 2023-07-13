## instalar librerias
require(magrittr)
require(readr)
require(tidyverse)
require(dplyr)
library(readr)

## importar data
periodo1 <- read_delim("C:/wilgen/saber 11/SB11_20121.TXT", 
                         delim = "¬", escape_double = FALSE, 
                         trim_ws = TRUE)
periodo2 <- read_delim("C:/wilgen/saber 11/SB11_20122.TXT", 
                         delim = "¬", escape_double = FALSE, 
                         trim_ws = TRUE)

## copiar los datos a una nueva variable
data_periodo1 <- periodo1
data_periodo2 <- periodo2

# eliminar las columnas inecesarias del periodo 1
names(data_periodo1)
mantener_columnas_p1 <- c(3,4,6,8,9,11,95,96,98,99,100,101,102,103,115:120)
data_limpiap1 <- data_periodo1[mantener_columnas_p1]
names(data_limpiap1)
write.csv(data_limpiap1, "C:/wilgen/data_limpia/SB11_20121.TXT")

## limpiar espacio de trabajo
data_limpiap1 <- NULL
data_periodo1 <- NULL
periodo1 <- NULL


# eliminar las columnas inecesarias del periodo 2

names(data_periodo2)
mantener_columnas_p2 <- c(3,4,6,8,9,11,96,97,99,100,101,102,103,104,116:121)
data_limpiap2 <- data_periodo2[mantener_columnas_p2]
names(data_limpiap2)
write.csv(data_limpiap2, "C:/wilgen/data_limpia/SB11_20122.TXT")

