# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# --------  TP 3 - Lecture et manipulation de données II  --------
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# fonctions vues: bind_rows, bind_cols, rbind, cbind, left_join, right_join, inner_join, anti_join, full_join

# package: tidyverse

# source: https://juba.github.io/tidyverse/

# raccourcis:
# %>%  CTRL + SHIFT + m
# sauver CTRL + s
# annuler la dernière écriture CTRL + z
# rétablir la dernière écriture CTRL + SHIFT + z
# commenter/ décommenter plusieurs lignes CTRL + SHIFT + c



# 8. Les jointures   -----

# Le jeu de données nycflights13 est un exemple de données réparties en plusieurs tables. Ici on en a trois : les informations sur les vols dans flights, celles sur les aéroports dans airports et celles sur les compagnies aériennes dans airlines.

# dplyr propose différentes fonctions permettant de travailler avec des données structurées de cette manière.

# On va charger les trois tables du jeu de données :

install.packages("nycflights13")
library(nycflights13)
library(tidyverse)

## Chargement des trois tables
data(flights)
data(airports)
data(airlines)

## 8.1 Concaténation : bind_rows et bind_cols   -----

# Les fonctions bind_rows et bind_cols permettent d’ajouter des lignes (respectivement des colonnes) à une table à partir d’une ou plusieurs autres tables.

# L’exemple suivant (certes très artificiel) montre l’utilisation de bind_rows. On commence par créer trois tableaux t1, t2 et t3 :
t1 <- airports %>%
      select(faa, name, lat, lon) %>%
      slice(1:2)
t1

t2 <- airports %>%
  select(faa, name, lon, lat) %>%
  slice(5:6)

t2

t3 <- airports %>%
  select(faa, name) %>%
  slice(100:101)
t3

# On concaténe ensuite les trois tables avec bind_rows :

bind_rows(t1, t2, t3)
rbind(t1, t2, t3)


# On remarquera que si des colonnes sont manquantes pour certaines tables, comme les colonnes lat et lon de t3, des NA sont automatiquement insérées.

# bind_cols permet de concaténer des colonnes et fonctionne de manière similaire :

t1 <- flights %>% slice(1:5) %>% select(dep_delay, dep_time)
t2 <- flights %>% slice(1:5) %>% select(origin, dest)
t3 <- flights %>% slice(1:5) %>% select(arr_delay, arr_time)
bind_cols(t1, t2, t3)

# À noter que bind_cols associe les lignes uniquement par position. Les lignes des différents tableaux associés doivent donc correspondre (et leur nombre doit être identique). Pour associer des tables par valeur, on doit utiliser des jointures.

# Notez qu'il existe également les fonctions natives (rbase mais pas dplyr) `rbind` et `cbind` mais ces dernières renvoient des erreurs lorsque le nombre de ligne ou de colonne ne correspondent pas plutôt que de mettre des `NA` et les colonnes sont concaténée uniquement sur base de leur position et non leur nom.

## 8.2. Jointure avec clé implicites   -----

# Très souvent, les données relatives à une analyse sont réparties dans plusieurs tables différentes. Dans notre exemple, on peut voir que la table flights contient le code de la compagnie aérienne du vol dans la variable carrier :

flights %>% select(carrier)

# Et que par ailleurs la table airlines contient une information supplémentaire relative à ces compagnies, à savoir le nom complet.

airlines

# Il est donc naturel de vouloir associer les deux, ici pour ajouter les noms complets des compagnies à la table flights. Pour cela on va effectuer une jointure : les lignes d’une table seront associées à une autre en se basant non pas sur leur position, mais sur les valeurs d’une ou plusieurs colonnes. Ces colonnes sont appelées des clés.

# Pour faire une jointure de ce type, on va utiliser la fonction left_join :

test<-left_join(flights, airlines)

# Pour faciliter la lecture, on va afficher seulement certaines colonnes du résultat :

left_join(flights, airlines) %>%
  select(month, day, carrier, name)

# On voit que la table résultat est bien la fusion des deux tables d’origine selon les valeurs des deux colonnes clés carrier. On est parti de la table flights, et pour chaque ligne de celle-ci on a ajouté les colonnes de airlines pour lesquelles la valeur de carrier est la même. On a donc bien une nouvelle colonne name dans notre table résultat, avec le nom complet de la compagnie aérienne.

# À noter qu’on peut tout à fait utiliser le pipe avec les fonctions de jointure :

flights %>% left_join(airlines)

# Nous sommes ici dans le cas le plus simple concernant les clés de jointure : les deux clés sont uniques et portent le même nom dans les deux tables. Par défaut, si on ne lui spécifie pas explicitement les clés, dplyr fusionne en utilisant l’ensemble des colonnes communes aux deux tables. On peut d’ailleurs voir dans cet exemple qu’un message a été affiché précisant que la jointure s’est bien faite sur la variable carrier.

## 8.3. Jointure avec clé explicites   -----

# La table airports, contient des informations supplémentaires sur les aéroports : nom complet, altitude, position géographique, etc. Chaque aéroport est identifié par un code contenu dans la colonne faa.

# Si on regarde la table flights, on voit que le code d’identification des aéroports apparaît à deux endroits différents : pour l’aéroport de départ dans la colonne origin, et pour celui d’arrivée dans la colonne dest. On a donc deux clés de jointure possibles, et qui portent un nom différent de la clé de airports.

# On va commencer par fusionner les données concernant l’aéroport de départ. Pour simplifier l’affichage des résultats, on va se contenter d’un sous-ensemble des deux tables :

flights_ex <- flights %>% select(month, day, origin, dest)
airports_ex <- airports %>% select(faa, alt, name)

# Si on se contente d’un left_join comme à l’étape précédente, on obtient un message d’erreur car aucune colonne commune ne peut être identifiée comme clé de jointure :

flights_ex %>% left_join(airports_ex)

# On doit donc spécifier explicitement les clés avec l’argument by de left_join. Ici la clé est nommée origin dans la première table, et faa dans la seconde. La syntaxe est donc la suivante :

flights_ex <- flights_ex %>%
  left_join(airports_ex, by = c("origin" = "faa"))

# Supposons qu’on souhaite maintenant fusionner à nouveau les informations de la table airports, mais cette fois pour les aéroports d’arrivée de notre nouvelle table flights_ex. Les deux clés sont donc désormais dest dans la première table, et faa dans la deuxième. La syntaxe est donc la suivante :

flights_ex %>%
  left_join(airports_ex, by = c("dest" = "faa"))

# Cela fonctionne, les informations de l’aéroport d’arrivée ont bien été ajoutées, mais on constate que les colonnes ont été renommées. En effet, ici les deux tables fusionnées contenaient toutes les deux des colonnes name et alt. Comme on ne peut pas avoir deux colonnes avec le même nom dans un tableau, dplyr a renommé les colonnes de la première table en name.x et alt.x, et celles de la deuxième en name.y et alt.y.

# C’est pratique, mais pas forcément très parlant. On pourrait renommer manuellement les colonnes avec rename avant de faire la jointure pour avoir des intitulés plus explicites, mais on peut aussi utiliser l’argument suffix de left_join, qui permet d’indiquer les suffixes à ajouter aux colonnes.

flights_ex %>%
  left_join(
    airports_ex,
    by = c("dest" = "faa"),
    suffix = c("_depart", "_arrivee")
  )

## 8.4. Types de jointures   -----

# Jusqu’à présent nous avons utilisé la fonction left_join, mais il existe plusieurs types de jointures.

# Partons de deux tables d’exemple, personnes et voitures :

personnes <- tibble(
    nom = c("Sylvie", "Sylvie", "Monique", "Gunter", "Rayan", "Rayan"),
    voiture = c("Twingo", "Ferrari", "Scenic", "Lada", "Twingo", "Clio")
  )

voitures <- tibble(
  voiture = c("Twingo", "Ferrari", "Clio", "Lada", "208"),
  vitesse = c("140", "280", "160", "85", "160")
)

### 8.4.1. left_join   -----

# Si on fait un left_join de voitures sur personnes :

personnes %>% left_join(voitures)

# On voit que chaque ligne de personnes est bien présente, et qu’on lui a ajouté une ligne de voitures correspondante si elle existe. Dans le cas du Scenic, il n’y a avait pas de ligne dans voitures, donc vitesse a été mise à NA. Dans le cas de 208, présente dans voitures mais pas dans personnes, la ligne n’apparaît pas.

# Si on fait un left_join cette fois de personnes sur voitures, c’est l’inverse :

voitures %>% left_join(personnes)

# La ligne 208 est là, mais nom est à NA. Par contre Monique est absente. Et on remarquera que la ligne Twingo, présente deux fois dans personnes, a été dupliquée pour être associée aux deux lignes de données de Sylvie et Rayan.

# En résumé, quand on fait un left_join(x, y), toutes les lignes de x sont présentes, et dupliquées si nécessaire quand elles apparaissent plusieurs fois dans y. Les lignes de y non présentes dans x disparaissent. Les lignes de x non présentes dans y se voient attribuer des NA pour les nouvelles colonnes.

# Intuitivement, on pourrait considérer que left_join(x, y) signifie “ramener l’information de la table y sur la table x”.

# En général, left_join sera le type de jointures le plus fréquemment utilisé.

### 8.4.2. right_join   -----

# La jointure right_join est l’exacte symétrique de left_join, c’est-à dire que right_join(x, y) est équivalent à left_join(y, x) :

personnes %>% right_join(voitures)

### 8.4.3. inner_join   -----

# Dans le cas de inner_join(x, y), seules les lignes présentes à la fois dans x et y sont conservées (et si nécessaire dupliquées) dans la table résultat :

personnes %>% inner_join(voitures)

# Ici la ligne 208 est absente, ainsi que la ligne Monique, qui dans le cas d’un left_join avait été conservée et s’était vue attribuer une vitesse à NA.

### 8.4.4. full_join   -----

# Dans le cas de full_join(x, y), toutes les lignes de x et toutes les lignes de y sont conservées (avec des NA ajoutés si nécessaire) même si elles sont absentes de l’autre table :

personnes %>% full_join(voitures)

### 8.4.3. semi_join et anti_join   -----

# semi_join et anti_join sont des jointures filtrantes, c’est-à-dire qu’elles sélectionnent les lignes de x sans ajouter les colonnes de y.

# Ainsi, semi_join ne conservera que les lignes de x pour lesquelles une ligne de y existe également, et supprimera les autres. Dans notre exemple, la ligne Monique est donc supprimée :

personnes %>% semi_join(voitures)

# Un anti_join fait l’inverse, il ne conserve que les lignes de x absentes de y. Dans notre exemple, on ne garde donc que la ligne Monique :

personnes %>% anti_join(voitures)



