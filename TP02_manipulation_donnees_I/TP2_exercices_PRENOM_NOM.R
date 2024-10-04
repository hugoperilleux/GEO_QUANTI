# ---------------------------------------------
#              TP 2 -  Exercices
# ---------------------------------------------

## Exercices  -----

# NOM
# PRENOM

# **Exercice 1 ** -----
# charger les library nécessaire et lire fichier population de statbel : OPEN DATA_SECTOREN_2019.xlsx source: https://statbel.fgov.be/fr/open-data/population-par-secteur-statistique-7


# **Exercice 1.1 ** -----
# Combien il a de ligne et de colonne dans ce tableau


# **Exercice 1.2 ** -----
# Lister les variables avec le différents types de données

# **Exercice 1.3 ** -----
# quelle est le nombre d'habitant-es en Belgique en 2019

# **Exercice 1.4 ** -----
# Renommer le champ superficie avec un nom sans caractères spéciaux

# **Exercice 1.6 ** -----
# Réaliser un filtre pour supprimer les secteurs où la population = 0 et la surface = 0


# **Exercice 1.7 ** -----
# Créer la variable de densité population par ha de deux façons différentes en R base et en dplyr (avec mutate)


# **Exercice 1.8 ** -----
# Afficher les 5 secteurs statistiques les plus denses


# **Exercice 1.8 ** -----
# Supprimer les colonnes en néérlandais

# **Exercice 1.9 ** -----
# compter le nombre d'habitants par commune en gardant le nom en français et le code NIS


# **Exercice 1.10 ** -----
# classe les communes par le nombre d'habitant-es (d'abord les communes avec le plus d'habitant-es)


# **Exercice 1.11 ** -----
# calculer la densité de population par commune


# **Exercice 1.12 ** -----
# calculer le nombre de secteurs statistiques par commune de deux façon différentes : avec un group_by et avec un table()


# **Exercice 2.1 ** -----
# Importer les données "airbnb_property_bxl.csv" et lister les variables


# **Exercice 2.1 ** -----
# compter le nombre de bien par "commune" (Neighborhood) calculer le revenu moyen  (`Annual Revenue LTM (USD)`) classer du plus grand au plus petit


# **Exercice 2.2 ** -----
# lister dans quelle devise monétaire les prix sont demander et le nombre de bien pour chaque devise


# **Exercice 2.3 ** -----
# claculer le revenu moyen par "commune" (Neighborhood)


# **Exercice 2.4 ** -----
# compter la proportion de bien au-delà la latitude 50.87


# **Exercice 2.5 ** -----
# indiquer la capacité totale en nombre de lits (`Max Guests`) par "commune" (Neighborhood)


# Il existe des NA, or les hébergements peuvent accueillir au moins une personne. Remplacer donc les NA par des 1 de la façon suivante:
# d$`Max Guests`[is.na(d$`Max Guests`)] <- 1


