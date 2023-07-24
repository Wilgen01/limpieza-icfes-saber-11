## instalar librerias
require(magrittr)
require(readr)
require(tidyverse)
require(dplyr)
library(Amelia)
library(janitor)

## establecer directorios
dir_data <- "D:/seminario/scripts/limpieza-icfes-saber-11/data_final/data_final.csv"

## importar data
data <- read_csv(dir_data)

## graficos de gauss SB11
area <- data$pn_naturales
md_SB11 <- mean(area)
sd_SB11 <- sd(area)

x <- seq(min(area), max(area), length.out = nrow(data))

pdf_SB11 <- dnorm(x, mean = md_SB11, sd = sd_SB11)

plot(x, pdf_SB11, type = "l", lwd = 2, col = "blue", xlab = "Probabilidad", ylab = "Densidad de probabilidad",
     main = "Distribución normal puntaje naturales SB11")

## graficos de gauss SP
area <- data$pn_com_escrita_sp
md_SP <- mean(area)
sd_SP <- sd(area)

x <- seq(min(area), max(area), length.out = nrow(data))

pdf_SP <- dnorm(x, mean = md_SP, sd = sd_SP)

plot(x, pdf_SP, type = "l", lwd = 2, col = "red", xlab = "Probabilidad", ylab = "Densidad de probabilidad",
     main = "Distribución normal puntaje comunucación escrita SP")

lines(x, pdf_SP, lwd = 2, col = "red")
legend("topright", legend = c("Saber 11", "Saber Pro"), col = c("blue", "red"), lwd = 2, cex = 0.8)




