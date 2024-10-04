# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# --------  TP 2 - Lecture et manipulation de données I  ---------
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# mis-à-jour: 14/02/24 11:43

# fonctions vues: install.packages, library,setwd, getwd, nrow, ncol, names, str, $, read_delim, write_delim, arrange, slice, filter, select, rename, arrange, mutate, group_by, summarise, slice_max, slice_min, slice_sample, distinct, n_distinct, relocate

# package: tidyverse, dplyr, readxl

# source: https://juba.github.io/tidyverse/

# raccourcis:
# le pipe %>%  CTRL + SHIFT + m
# sauver CTRL + s
# annuler la dernière écriture CTRL + z
# rétablir la dernière écriture CTRL + SHIFT + z
# commenter/ décommenter plusieurs lignes CTRL + SHIFT + c

# 1. Installer des packages -----

# R étant un logiciel libre, il bénéficie d'un développement communautaire riche et dynamique. L'installation de base de R permet de faire énormément de choses, mais le langage dispose en plus d'un système d'extensions permettant d'ajouter facilement de nouvelles fonctionnalités. La plupart des extensions sont développées et maintenues par la communauté des utilisateurs et utilisatrices de R, et diffusées via un réseau de serveurs nommé [CRAN](https://cran.r-project.org/) (*Comprehensive R Archive Network*).

# Pour installer une extension, si on dispose d'une connexion Internet, on peut utiliser le bouton *Install* de l'onglet *Packages* de RStudio.

# Il suffit alors d'indiquer le nom de l'extension dans le champ *Package* et de cliquer sur *Install*.

# On peut aussi installer des extensions en utilisant la fonction `install.packages()` directement dans la console. Par exemple, pour installer le *package* `questionr` on peut exécuter la commande:

install.packages("questionr")

# Installer une extension via l'une des deux méthodes précédentes va télécharger l'ensemble des fichiers nécessaires depuis l'une des machines du CRAN, puis installer tout ça sur le disque dur de votre ordinateur. Vous n'avez besoin de le faire qu'une fois, comme vous le faites pour installer un programme sur votre Mac ou PC.

# Une fois l'extension installée, il faut la "charger" avant de pouvoir utiliser les fonctions qu'elle propose. Ceci se fait avec la fonction `library`. Par exemple, pour pouvoir utiliser les fonctions de `questionr`, vous devrez exécuter la commande suivante:

library(questionr)

# Ainsi, on regroupe en général en début de script toute une série d'appels à `library` qui permettent de charger tous les packages utilisés dans le script. Quelque chose comme:

library(readxl)
library(ggplot2)
library(questionr)

# Si vous essayez d'exécuter une fonction d'une extension et que vous obtenez le message d'erreur `impossible de trouver la fonction`, c'est certainement parce que vous n'avez pas exécuté la commande `library` correspondante.

# 2 Le tidyverse -----
#
# Le terme tidyverse est une contraction de tidy (qu’on pourrait traduire par “bien rangé”) et de universe. Il s’agit en fait d’une collection d’extensions conçues pour travailler ensemble et basées sur une philosophie commune.
#
# Elles abordent un très grand nombre d’opérations courantes dans R (la liste n’est pas exhaustive) :
#
# visualisation
# manipulation des tableaux de données
# import/export de données
# manipulation de variables
# extraction de données du Web
# programmation
#
# Un des objectifs de ces extensions est de fournir des fonctions avec une syntaxe cohérente, qui fonctionnent bien ensemble, et qui retournent des résultats prévisibles. Elles sont en grande partie issues du travail d’Hadley Wickham, qui travaille désormais pour RStudio.
#
# tidyverse est également le nom d’une extension qu’on peut installer de manière classique, soit via le bouton Install de l’onglet Packages de RStudio, soit en utilisant la commande :
#
install.packages("tidyverse")
#
# Cette commande va en fait installer plusieurs extensions qui constituent le “coeur” du tidyverse, à savoir :
#
# ggplot2 (visualisation)
# dplyr (manipulation des données)
# tidyr (remise en forme des données)
# purrr (programmation)
# readr (importation de données)
# tibble (tableaux de données)
# forcats (variables qualitatives)
# stringr (chaînes de caractères)
# lubridate (manipulation de dates)

library(tidyverse)

# Le tidyverse est en partie fondé sur le concept de tidy data. Il s’agit d’un modèle d’organisation des données qui vise à faciliter le travail souvent long et fastidieux de nettoyage et de préparation préalable à la mise en oeuvre de méthodes d’analyse. Les principes d’un jeu de données tidy sont les suivants :
#
# - chaque variable est une colonne
# - chaque observation est une ligne
# - chaque type d’observation est dans une table différente

# Une autre particularité du tidyverse est que ces extensions travaillent avec des tableaux de données au format tibble, qui est une évolution plus moderne du classique data frame du R de base. Ce format est fourni et géré par l’extension du même nom (tibble), qui fait partie du coeur du tidyverse. La plupart des fonctions des extensions du tidyverse acceptent des data frames en entrée, mais retournent un objet de classe tibble.
#
# Contrairement aux data frames, les tibbles :
#
# - n’ont pas de noms de lignes (rownames)
# - autorisent des noms de colonnes invalides pour les data frames (espaces, caractères spéciaux, nombres…)1
# - s’affichent plus intelligemment que les data frames : seules les premières lignes sont affichées, ainsi que quelques informations supplémentaires utiles (dimensions, types des colonnes…)
# - ne font pas de partial matching sur les noms de colonnes
# - affichent un avertissement si on essaie d’accéder à une colonne qui n’existe pas
#
# Pour autant, les tibbles restent compatibles avec les data frames. On peut ainsi facilement convertir un data frame en tibble avec as_tibble


# 3. Lire des données  -----

## 3.1. Définir le répertoire de travail  -----

# Il faut définir où se trouve le répertoire de travail, il sera le point de départ pour la lecture et l'écriture de données. Si on a créé un projet, le répertoire de travail est celui qui contient le fichier projet (.proj). Si on n'a pas réaliser de projet alors il faut définir son répertoire de travail avec stwd (set working directory):

setwd("LE/CHEMIN/VERS/MON/REPERTOIRE")
setwd("/home/user/ownCloud/ULB/GEO/GEOG F 404")
setwd("/home/hperille/")


# il est possible de vérifier quel est notre répertoire de travail avec

getwd()

## 3.2. Lire des données  -----

#L’extension readr, qui fait partie du tidyverse, permet l’importation de fichiers texte, notamment au format CSV (Comma separated values), format standard pour l’échange de données tabulaires entre logiciels.

# Si votre fichier CSV suit un format CSV standard (c’est le cas s’il a été exporté depuis LibreOffice par exemple), avec des champs séparés par des virgules (,), vous pouvez utiliser la fonction read_csv en lui passant en argument le nom du fichier :
#d <- read_csv("fichier.csv")

#Si votre fichier vient d’Excel, avec des valeurs séparées par des points virgule (;), utilisez la fonction read_csv2 :
#d <- read_csv2("fichier.csv")

# Il est donc plus sûr d'utiliser read_delim où il est possible de spécifier le délimiteur via delim =

d <- read_delim("data/expulsions_2018_secteursstat.csv", delim= ";")

# L’extension readxl, qui fait également partie du tidyverse, permet d’importer des données directement depuis un fichier au format xls ou xlsx.

# Elle ne fait pas partie du “coeur” du tidyverse, il faut donc la charger explicitement avec :

library(readxl)

#On peut alors utiliser la fonction read_excel en lui spécifiant le nom du fichier :

d <- read_excel("fichier.xls")

## 3.3. Structure du tableau  -----

#Un tableau étant un objet comme un autre, on peut lui appliquer des fonctions. Par exemple, nrow et ncol retournent le nombre de lignes et de colonnes du tableau.

nrow(d)
ncol(d)

#La fonction names retourne les noms des colonnes du tableau, c’est-à-dire la liste de nos variables.

names(d)

#Enfin, la fonction str renvoie un descriptif plus détaillé de la structure du tableau. Elle liste les différentes variables, indique leur type et affiche les premières valeurs.
str(d)

## 3.3.  Accéder aux variables d’un tableau  -----

#Une opération très importante est l’accès aux variables du tableau (à ses colonnes) pour pouvoir les manipuler, effectuer des calculs, etc. On utilise pour cela l’opérateur $, qui permet d’accéder aux colonnes du tableau. Ainsi, si l’on tape :

d$exp_total

#On peut alors faire des opérations sur cette colonne comme sur n'importe quel vecteur:
sum(d$exp_total)

#R va afficher l’ensemble des valeurs de la variable expulsion totale dans la console, ce qui est à nouveau fort peu utile. Mais cela nous permet de constater que d$sexe est un vecteur de nombre tels qu’on en a déjà rencontré précédemment.

#La fonction table$colonne renvoie donc la colonne nommée colonne du tableau table, c’est-à-dire un vecteur, en général de nombres ou de chaînes de caractères.


## 3.4. Créer une nouvelle variable  -----

# On créer une variable comme on créé un objet avec le signe d'assignation <-

d$expul_jour <- d$exp_total / 365
d$expul_jour

# On peut vérifier qu'on a le même résultat
sum(d$expul_jour)
sum(d$exp_total)/365

## 3.5. Exporter des données  -----

# Il est possible d'exporter avec write_csv qui utilisera la virgule (,) comme sépareteur ou avec write_csv2 qui utilisera le point-virgule (;) mais de nouveau il est plus prudent d'utiliser write_delim et de bien spécifier le séparateur avec delim =

write_delim(d, "data/fichier_test.csv", delim= ";")

# Une autre manière de sauvegarder des données est de les enregistrer au format RData. Ce format propre à R est compact, rapide, et permet d’enregistrer plusieurs objets R, quel que soit leur type, dans un même fichier.

# Pour enregistrer des objets, il suffit d’utiliser la fonction save et de lui fournir la liste des objets à sauvegarder et le nom du fichier :

# save(d, rp2018, tab, file = "fichier.RData")

# Pour charger des objets préalablement enregistrés, utiliser load :

# load("fichier.RData")

# Les objets d, rp2018 et tab devraient alors apparaître dans votre environnement.

# Attention, quand on utilise load, les objets chargés sont importés directement dans l’environnement en cours avec leur nom d’origine. Si d’autres objets du même nom existent déjà, ils sont écrasés sans avertissement.

# Une alternative est d’utiliser les fonctions saveRDS et readRDS, qui permettent d’enregistrer un unique objet, et de le charger dans notre session avec le nom que l’on souhaite.

# saveRDS(rp2018, "fichier.rds")
# df <- readRDS("fichier.rds")


## 3.6. Des données dans des packages  -----

# Des données d'exemples peuvent être transmises au travers de packages.
#
# Dans ce qui suit on va utiliser le jeu de données nycflights13, contenu dans l’extension du même nom (qu’il faut donc avoir installé). Celui-ci correspond aux données de tous les vols au départ d’un des trois aéroports de New-York en 2013. Il a la particularité d’être réparti en trois tables :
#
# - flights contient des informations sur les vols : date, départ, destination, horaires, retard…
# - airports contient des informations sur les aéroports
# - airlines contient des données sur les compagnies aériennes
#
# On va charger les trois tables du jeu de données :

install.packages("nycflights13")
library(nycflights13)

## Chargement des trois tables
data(flights)
data(airports)
data(airlines)

# 4. Les verbes de dplyr  -----

# On charge le package dplyr:
library(dplyr)

## 4.1. slice  -----

# Le verbe slice sélectionne des lignes du tableau selon leur position. On lui passe un chiffre ou un vecteur de chiffres.

# Si on souhaite sélectionner la 345e ligne du tableau airports :
slice(airports, 345)

# Ceci équivaut en rbase à faire une indexation où on indique [ligne,colonne]
airports[345,]

#Si on veut sélectionner les 5 premières lignes :
slice(airports, 1:5)
airports[1:5,]


# slice propose plusieurs variantes utiles, dont slice_head et slice_tail, qui permettent de sélectionner les premières ou les dernières lignes du tableau (on peut spécifier le nombre de lignes souhaitées avec n)

slice_tail(airports, n = 3)
slice_head(airports, n = 5)


#Autres variantes utiles, slice_min et slice_max permettent de sélectionner les lignes avec les valeurs les plus grandes ou les plus petite d’une variable donnée. Ainsi, la commande suivante sélectionne le vol ayant le retard au départ le plus faible.

slice_min(flights, dep_delay)
slice_max(airports, alt, n = 5)


## 4.2. filter  -----

# filter sélectionne des lignes d’une table selon une condition. On lui passe en paramètre un test, et seules les lignes pour lesquelles ce test renvoie TRUE (vrai) sont conservées.

# On peut utiliser les opérateurs suivants:
# < 	plus petit
# <= 	plus petit ou égal
# > 	plus grand
# >= 	plus grand ou égal
# == 	exactement égal
# != 	différent

# Par exemple, si on veut sélectionner les vols du mois de janvier, on peut filtrer sur la variable month de la manière suivante :

filter(flights, month == 1)

# Si on veut uniquement les vols avec un retard au départ (variable dep_delay) compris entre 10 et 15 minutes :

filter(flights, dep_delay >= 10 & dep_delay <= 15)
filter(flights, dep_delay >= 10, dep_delay <= 15) # la ',' équivaut à un '&'


# On peut également utiliser l'opérateur %in% suivi d'un vecteur. Il conservera toutes les lignes dont la valeur de la colonne indiquée se trouve dans le vecteur:

filter(airports, faa %in% c("1OH", "2G9"))

# la fonction 'not in' n'existe pas par défaut dans R, il faut préalablement
`%notin%` <- Negate(`%in%`)
filter(airports, dst %notin% c("A", "U"))


# On peut également placer des fonctions dans les tests, qui nous permettent par exemple de sélectionner les vols ayant une distance supérieure à la distance médiane :

filter(flights, distance > median(distance))


## 4.3.  select  -----

# select permet de sélectionner des colonnes d’un tableau de données. Ainsi, si on veut extraire les colonnes lat et lon du tableau airports :

select(airports, lat, lon)

# Si on fait précéder le nom d’un -, la colonne est éliminée plutôt que sélectionnée :

select(airports, -lat, -lon)


# select comprend toute une série de fonctions facilitant la sélection de colonnes multiples. Par exemple, starts_with, ends_width, contains ou matches permettent d’exprimer des conditions sur les noms de variables.

select(flights, starts_with("dep_"))


# La syntaxe colonne1:colonne2 permet de sélectionner toutes les colonnes situées entre colonne1 et colonne2 incluses.

select(flights, year:day)


## 4.4. rename  -----

# On l’utilise en lui passant des paramètres de la forme NOUVEAU_NOM = ANCIEN_NOM . Ainsi, si on veut renommer les colonnes lon et lat de airports en longitude et latitude :

rename(airports, longitude = lon, latitude = lat)

# Pour stocker le résultat
airports <- rename(airports, longitude = lon, latitude = lat)

## 4.5. arrange  -----

# arrange réordonne les lignes d’un tableau selon une ou plusieurs colonnes.

# Ainsi, si on veut trier le tableau flights selon le retard au départ croissant :

arrange(flights, dep_delay)

# Si on veut trier selon une colonne par ordre décroissant, on lui applique la fonction desc() :

arrange(flights, desc(dep_delay))


## 4.6. mutate  -----

# mutate permet de créer de nouvelles colonnes dans le tableau de données, en général à partir de variables existantes.

# Par exemple, la table flights contient la durée du vol en minutes.. Si on veut créer une nouvelle variable duree_h avec cette durée en heures, on peut faire :


flights <- mutate(flights, 
                  duree_h = air_time / 60)
select(flights, air_time, duree_h)

# Ceci est équivalent à ceci en R base:
flights$duree_h <-flights$air_time / 60
select(flights, air_time, duree_h)


# 5. Le pipe %>%  pour enchaîner les opérations  -----

# Quand on manipule un tableau de données, il est très fréquent d’enchaîner plusieurs opérations. On va par exemple extraire une sous-population avec filter, sélectionner des colonnes avec select puis trier selon une variable avec arrange, etc.

# Quand on veut enchaîner des opérations, on peut le faire de différentes manières. La première est d’effectuer toutes les opérations en une fois en les “emboîtant” :

arrange(select(filter(flights, dest == "LAX"), dep_delay, arr_delay), dep_delay)

# Cette notation a plusieurs inconvénients :

# - elle est peu lisible
# - les opérations apparaissent dans l’ordre inverse de leur réalisation. Ici on effectue d’abord le filter, puis le select, puis le arrange, alors qu’à la lecture du code c’est le arrange qui apparaît en premier.
# - Il est difficile de voir quel paramètre se rapporte à quelle fonction

# Une autre manière de faire est d’effectuer les opérations les unes après les autres, en stockant les résultats intermédiaires dans un objet temporaire :

tmp <- filter(flights, dest == "LAX")
tmp <- select(tmp, dep_delay, arr_delay)
arrange(tmp, dep_delay)

# C’est nettement plus lisible, l’ordre des opérations est le bon, et les paramètres sont bien rattachés à leur fonction. Par contre, ça reste un peu “verbeux”, et on crée un objet temporaire tmp dont on n’a pas réellement besoin.

# Pour simplifier et améliorer encore la lisibilité du code, on va utiliser un nouvel opérateur, baptisé pipe3. Le pipe se note %>%, et son fonctionnement est le suivant : si j’exécute expr %>% f, alors le résultat de l’expression expr, à gauche du pipe, sera passé comme premier argument à la fonction f, à droite du pipe, ce qui revient à exécuter f(expr).

# Ainsi les deux expressions suivantes sont rigoureusement équivalentes :

filter(flights, dest == "LAX")
flights %>% filter(dest == "LAX")

# Ce qui est particulièrement intéressant, c’est qu’on va pouvoir enchaîner les pipes. Plutôt que d’écrire :

select(filter(flights, dest == "LAX"), dep_delay, arr_delay)


# On va pouvoir faire :

flights %>% 
  filter(dest == "LAX") %>% 
  select(dep_delay, arr_delay)

# À chaque fois, le résultat de ce qui se trouve à gauche du pipe est passé comme premier argument à ce qui se trouve à droite : on part de l’objet flights, qu’on passe comme premier argument à la fonction filter, puis on passe le résultat de ce filter comme premier argument du select.

# Le résultat final est le même avec les deux syntaxes, mais avec le pipe l’ordre des opérations correspond à l’ordre naturel de leur exécution, et on n’a pas eu besoin de créer d’objet intermédiaire.

# Si la liste des fonctions enchaînées est longue, on peut les répartir sur plusieurs lignes à condition que l’opérateur %>% soit en fin de ligne :

flights %>%
  filter(dest == "LAX") %>%
  select(dep_delay, arr_delay) %>%
  arrange(dep_delay)

# Le raccourci pour le pipe %>% est CTRL + MAJ + m
# Depuis la version 4.1, R propose un pipe “natif”, qui fonctionne partout, même si on n’utilise pas les extensions du tidyverse. Celui-ci est noté |>. Dans la suite du TP on privilégiera le pipe du tidyverse %>%, pour des raisons de compatibilité avec des versions de R moins récentes.


# 6. Opérations groupées  -----
## 6.1. group_by  -----

# Un élément très important de dplyr est la fonction group_by. Elle permet de définir des groupes de lignes à partir des valeurs d’une ou plusieurs colonnes. Par exemple, on peut grouper les vols selon leur mois :

flights %>% group_by(month)

# Par défaut ceci ne fait rien de visible, à part l’apparition d’une mention Groups dans l’affichage du résultat. Mais à partir du moment où des groupes ont été définis, les verbes comme slice, mutate ou summarise vont en tenir compte lors de leurs opérations.

# Par exemple, si on applique slice à un tableau préalablement groupé, il va sélectionner les lignes aux positions indiquées pour chaque groupe. Ainsi la commande suivante affiche le premier vol de chaque mois, selon leur ordre d’apparition dans le tableau :

flights %>% group_by(month) %>% slice(1)

# Idem pour mutate : les opérations appliquées lors du calcul des valeurs des nouvelles colonnes sont appliquées groupe de lignes par groupe de lignes. Dans l’exemple suivant, on ajoute une nouvelle colonne qui contient le retard moyen pour chaque compagnie aérienne. Cette valeur est donc différente d’une compagnie à une autre, mais identique pour tous les vols d’une même compagnie :

flights %>%
  group_by(carrier) %>%
  mutate(mean_delay_carrier = mean(dep_delay, na.rm = TRUE)) %>%
  select(dep_delay, mean_delay_carrier)


## 6.2. summarise  -----

# summarise permet d’agréger les lignes du tableau en effectuant une opération “résumée” sur une ou plusieurs colonnes. Il est peut être utile pour réaliser des "tableaux croisés dynamiques". Par exemple, si on souhaite connaître les retards moyens au départ et à l’arrivée pour l’ensemble des vols du tableau flights :

flights %>%
  summarise(
    retard_dep = mean(dep_delay, na.rm = TRUE),
    retard_arr = mean(arr_delay, na.rm = TRUE)
  )

# Cette fonction est en général utilisée avec group_by, puisqu’elle permet du coup d’agréger et résumer les lignes du tableau groupe par groupe. Si on souhaite calculer le délai maximum, le délai minimum et le délai moyen au départ pour chaque mois, on pourra faire :

flights %>%
  group_by(month) %>%
  summarise(
    max_delay = max(dep_delay, na.rm = TRUE),
    min_delay = min(dep_delay, na.rm = TRUE),
    mean_delay = mean(dep_delay, na.rm = TRUE)
  )

  # summarise dispose d’un opérateur spécial, n(), qui retourne le nombre de lignes du groupe. Ainsi si on veut le nombre de vols par destination, on peut utiliser :.

flights %>%
  group_by(dest) %>%
  summarise(nb = n())

# On peut grouper selon plusieurs variables à la fois, il suffit de les indiquer dans la clause du group_by. Le pipeline suivant calcule le retard moyen au départ pour chaque mois et pour chaque destination, et trie le résultat par retard décroissant :

test<-flights %>%
  group_by(month, dest) %>%
  summarise(retard_moyen = mean(dep_delay, na.rm = TRUE)) %>%
  arrange(desc(retard_moyen))


# Il est possible de faire des table de fréquence par modalité également grâce à la fonction native (issue de rbase et pas de dplyr) `table`. Même si celle-ci permet moins de possibilité que le passage par group_by elle permet rapidement d'avoir un résultat:

table(flights$month)
table(flights$origin)
table(flights$dest)


## 6.3. Dégroupage  -----

# On peut à tout moment “dégrouper” un tableau à l’aide de ungroup.

flights %>%
  group_by(month, dest) %>%
  summarise(retard_moyen = mean(dep_delay, na.rm = TRUE)) %>%
  ungroup() %>%
  slice_max(retard_moyen, n = 3)


# 7. Autres fonctions utiles  -----
## 7.1. slice_sample  -----

# Ce verbe permet de sélectionner aléatoirement un nombre de lignes (avec l’argument n) ou une fraction des lignes (avec l’argument prop) d’un tableau.

# Ainsi si on veut choisir 5 lignes au hasard dans le tableau airports :

airports %>% slice_sample(n = 5)

## 7.2. distinct et n_distinct   -----

# distinct filtre les lignes du tableau pour ne conserver que les lignes distinctes, en supprimant toutes les lignes en double.

flights %>%
  select(day, month) %>%
  distinct()

# On peut lui spécifier une liste de variables : dans ce cas, pour toutes les observations ayant des valeurs identiques pour les variables en question, distinct ne conservera que la première d’entre elles.

flights %>%
  distinct(month, day)

# L’option .keep_all permet, dans l’opération précédente, de conserver l’ensemble des colonnes du tableau :

flights %>%
  distinct(month, day, .keep_all = TRUE)

  # La fonction n_distinct, elle, renvoie le nombre de valeurs distinctes d’un vecteur. On peut notamment l’utiliser dans un summarise.

# Dans l’exemple qui suit on calcule, pour les trois aéroports de départ de la table flights le nombre de valeurs distinctes de l’aéroport d’arrivée :

flights %>%
  group_by(origin) %>%
  summarise(n_dest = n_distinct(dest))

## 7.3. relocate   -----

# relocate peut être utilisé pour réordonner les colonnes d’une table. Par défaut, si on lui passe un ou plusieurs noms de colonnes, relocate les place en début de tableau.

airports %>% relocate(longitude, latitude)

# Les arguments supplémentaires .before et .after permettent de préciser à quel endroit déplacer la ou les colonnes indiquées.

airports %>% relocate(starts_with('tz'), .after = name)




