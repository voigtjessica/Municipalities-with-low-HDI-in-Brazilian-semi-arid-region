# Cruzando IDHM com lat e long

library(openxlsx)
library(ggmap)
library(janitor)
library(dplyr)
library(data.table)

register_google(key ="")

setwd("C:/Users/coliv/Documents/GIF/atlasbrasil")

munic_atlas <- openxlsx::read.xlsx("atlas2013_dadosbrutos_pt.xlsx",sheet = "MUN 91-00-10" )

ne <- c(21:29)


ba_baixo_idhm <- munic_atlas %>%
  clean_names() %>%
  filter(ano == 2010,
         uf == 29,
         idhm < 0.599) %>%
  mutate(endereco = paste0(municipio, ", BA, BRASIL"),
         lon = NA,
         lat = NA) %>%
  select(uf, codmun6, codmun7, municipio, idhm, endereco, lon, lat)

ba_baixo_idhm_end <- ba_baixo_idhm$endereco

x <- geocode(ba_baixo_idhm_end[2])
ba_baixo_idhm[2,7] <- x[1,1] 
ba_baixo_idhm[1,8] <- x[1,2] 

for(i in 1:253){

  x <- geocode(ba_baixo_idhm_end[i])
  ba_baixo_idhm[i,7] <- x[1,1] 
  ba_baixo_idhm[i,8] <- x[1,2] 
  
}

ba_baixo_idhm_sertao <- ba_baixo_idhm %>%
  mutate(norm_lat = lat * -1,
         norm_lon = lon * -1) %>%
  filter( norm_lon > 39,
          norm_lon < 43,
          norm_lat > 9 ,
          norm_lat < 11)

fwrite(ba_baixo_idhm_sertao, file="ba_baixo_idhm_sertao.csv")
