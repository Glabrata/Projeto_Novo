
install.packages("rio")
install.packages("sf")


library(sf)
library(dplyr)
library(ggplot2)
library(tidyr)
library(stringr)
library(rio)


Sinesp1 <- readRDS("/Documents and Settings/gabri/Desktop/Projeto_Novo/data/dados_sinesp.rds")

Sinesp <- Sinesp1 %>%
  separate(col = "mes_ano",
           into = c("mes", "ano"),
           sep = "/")



Sinesp %>%
  filter(mes == "01" | mes == "02" | mes == "03") %>%
  group_by(regiao, ano) %>%
  filter(!str_detect(ano, "NA")) %>%
  summarise(soma_vitimas = sum(vitimas , na.rm = TRUE)) %>%
  ggplot() +
  geom_bar(aes(x = soma_vitimas , y = regiao, fill = soma_vitimas),
           stat="identity"
           ) +
  facet_wrap(~ano, ncol = 3) +
  scale_y_discrete(
    limits = c("NORDESTE", "SUDESTE", "SUL", "NORTE", "CENTRO-OESTE")
  ) +
  geom_label(aes(x = soma_vitimas , y = regiao, label = soma_vitimas), size = 2.5) +
  scale_fill_gradient(low="yellow", high="darkred") +
  theme_minimal() +
  labs(
    x = "Somatório de vítimas",
    y = "Região",
    color = "Vítimas",
    title = "Gráfico de colunas",
    subtitle = "Região vs Somatório de vítimas"
  ) +
  coord_cartesian(xlim = c(500, 6500))


##




Sinesp %>%
  filter(mes == "01" | mes == "02" | mes == "03") %>%
  group_by(ano) %>%
  filter(!str_detect(ano, "NA")) %>%
  summarise(soma_vitimas = sum(vitimas , na.rm = TRUE)) %>%
  ggplot() +
  geom_col(aes(x = ano,
               y = soma_vitimas,
               fill = soma_vitimas)) +
  geom_label(aes(x = ano,
                 y = soma_vitimas,
                 label = soma_vitimas),
             size = 2.5) +
  scale_fill_gradient(low="yellow", high="darkred") +
  theme_minimal() +
  labs(
    x = "Ano",
    y = "Somatório de vítimas",
    title = "Somatório de vítimas por ano"
  ) +
  coord_cartesian(ylim = c(10000, 14000))










# Outras tabelas

SisnespRS_2018 <- Sinesp %>%
  filter(sigla_uf == "RS") %>%
  filter(ano == 2018) %>%
  group_by(municipio) %>%
  summarise(Total_vitimas = sum(vitimas))

SisnespRS_2019 <- Sinesp %>%
  filter(sigla_uf == "RS") %>%
  filter(ano == 2019)%>%
  group_by(municipio) %>%
  summarise(Total_vitimas = sum(vitimas))

SisnespRS_2020 <- Sinesp %>%
  filter(sigla_uf == "RS") %>%
  filter(ano == 2020)%>%
  group_by(municipio) %>%
  summarise(Total_vitimas = sum(vitimas))



# Mapas

tab_estados <- geobr::read_state()


# Estados brasileiros



tab_estados %>%
  ggplot() +
  geom_sf() +
  geom_sf_text(aes(label = abbrev_state), size = 2)

# Simplificando os polígonos

# dTolerance > 0
# Quanto maior, mais simples serão os
# polígonos
tab_estados %>%
  sf::st_simplify(dTolerance = 0.1) %>%
  ggplot() +
  geom_sf() +
  geom_sf_text(aes(label = abbrev_state), size = 2)

# Usando labels
tab_estados %>%
  sf::st_simplify(dTolerance = 0.1) %>%
  ggplot() +
  geom_sf() +
  geom_sf_label(aes(label = abbrev_state), size = 2)




# Sinesp 2018 por estado

Sinesp2018 <- Sinesp %>%
  select(!municipio) %>%
  select(!regiao) %>%
  filter(mes == "01" | mes == "02" | mes == "03") %>%
  filter(ano == "2018") %>%
  group_by(sigla_uf) %>%
  na.omit() %>%
  summarise(soma_vitimas = sum(vitimas))


# Sinesp 2019 por estado

Sinesp2019 <- Sinesp %>%
  select(!municipio) %>%
  select(!regiao) %>%
  filter(mes == "01" | mes == "02" | mes == "03") %>%
  filter(ano == "2019") %>%
  group_by(sigla_uf) %>%
  na.omit() %>%
  summarise(soma_vitimas = sum(vitimas))

# Sinesp 2020 por estado

Sinesp2020 <- Sinesp %>%
  select(!municipio) %>%
  select(!regiao) %>%
  filter(mes == "01" | mes == "02" | mes == "03") %>%
  filter(ano == "2020")%>%
  group_by(sigla_uf) %>%
  na.omit() %>%
  summarise(soma_vitimas = sum(vitimas))

# Info

tab_estados <- sf::st_simplify(tab_estados, dTolerance = 0.1)

tab_estados_2018 <- Sinesp2018 %>%
  right_join(tab_estados, by = c("sigla_uf" = "abbrev_state"))

tab_estados_2019 <- Sinesp2019 %>%
  right_join(tab_estados, by = c("sigla_uf" = "abbrev_state"))

tab_estados_2020 <- Sinesp2020 %>%
  right_join(tab_estados, by = c("sigla_uf" = "abbrev_state"))

library(ggrepel)


# Trazendo mais informações

tab_estados_2018 %>%
  ggplot() +
  geom_sf(aes(geometry = geom, fill = soma_vitimas)) +
  geom_sf_label(aes(geometry = geom, label = sigla_uf), size = 2)+
  scale_fill_gradient(low = "yellow", high = "darkred") +
  labs(
    title = "Mapa de calor",
    subtitle = "2018"
  )

tab_estados_2019 %>%
  ggplot() +
  geom_sf(aes(geometry = geom, fill = soma_vitimas)) +
  geom_sf_label(aes(geometry = geom, label = sigla_uf), size = 2)+
  scale_fill_gradient(low = "yellow", high = "darkred") +
  labs(
    title = "Mapa de calor",
    subtitle = "2019"
  )

tab_estados_2020 %>%
  ggplot() +
  geom_sf(aes(geometry = geom, fill = soma_vitimas)) +
  geom_sf_label(aes(geometry = geom, label = sigla_uf), size = 2)+
  scale_fill_gradient(low = "yellow", high = "darkred") +
  labs(
    title = "Mapa de calor",
    subtitle = "2020"
  )


