# ---------------------------------------------
#              TP 5 -  Exercices
# ---------------------------------------------

## Exercices  -----

# NOM
# PRENOM


# **Exercice 1.1 ** -----
# A partir des données Airbnb réaliser un graphique en boxplot sur le nombre de jours réservés (`Count Reservation Days LTM`)


# **Exercice 1.2 ** -----
# Réaliser le même graphique mais en ne prenant que les 3 communes suivantes
# filter(Neighborhood %in% c("Watermael-Boitsfort","Bruxelles-Ville", "Ixelles" ))
# et en faisant varier la largeur des boxplot selon le nombre d'individus


# **Exercice 2. ** -----
# réaliser un histogramme à partir du fichier indice_synthetique.csv  des valeur de l'indice synthétique de difficulté  (voir graphique attendu exercice_1_indice_synth_histogramme.png)



# **Exercice 3. ** -----
# A partir des données des expulsions, de population et de l'indice synthétique de difficulté par quartier, réaliser un graphique en nuage de points (scatter plot) de la relation entre le nombre d'expulsion pour 1000 habitants et l'indice synthétique de difficulté.

# Importer les données de la façon suivante:
# library(readxl)
# expulsions <- read_delim("data/expulsions_2018_secteursstat.csv", delim= ";")
# pop <- read_excel("data/OPEN DATA_SECTOREN_2019.xlsx")
# data<-expulsions %>%
#   inner_join(indice_synth, by= c("ID_SS_bis"= "Secteur statistique")) %>%
#   inner_join(pop,  by= c("ID_SS_bis"= "CD_SECTOR")) %>%
#   filter(POPULATION>200) %>%
#   mutate(expul_pop=1000*exp_total/ POPULATION )


# **Exercice 4. ** -----
# Reproduire le graphique graph_loyers.png à l'aide du fichier evolution_loyers.csv
# Pour positionner la légende, vous pouvez utiliser: theme(legend.position = c(.35, .88)) et utiliser theme_minimal()



