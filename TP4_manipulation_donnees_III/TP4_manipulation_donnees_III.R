# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# --------  TP 4 - Lecture et manipulation de données III  -------
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# fonctions vues:typeof, str, as.numeric, as.character, as.factor, class, levels,fct_recode, fct_relevel, fct_reorder, ifelse, case_when, freq, cut, paste, paste0, str_to_lower, str_to_upper, str_to_title, str_split, str_sub, substr, str_detect, str_extract, str_replace_all

# package: tidyverse, forcat, stringr

# source: https://juba.github.io/tidyverse/
  
# raccourcis:
# %>%  CTRL + SHIFT + m
# sauver CTRL + s
# annuler la dernière écriture CTRL + z
# rétablir la dernière écriture CTRL + SHIFT + z
# commenter/ décommenter plusieurs lignes CTRL + SHIFT + c


# 9. Recoder des variables  -----
## 9.1 Rappel sur les variables et les vecteurs  -----

# Dans R, une variable, en général une colonne d’un tableau de données, est un objet de type vecteur. Un vecteur est un ensemble d’éléments, tous du même type.

# On a vu qu’on peut construire un vecteur manuellement de différentes manières :

couleur <- c("Jaune", "Jaune", "Rouge", "Vert")
nombres <- 1:10

# Mais le plus souvent on manipule des vecteurs faisant partie d’une table importée dans R. Dans ce qui suit on va utiliser le jeu de données d’exemple hdv2003 de l’extension questionr.

library(questionr)
data(hdv2003)

# Quand on veut accéder à un vecteur d’un tableau de données, on peut utiliser l’opérateur $ :

hdv2003$qualif

# On peut facilement créer de nouvelles variables (ou colonnes) dans un tableau de données en utilisant le $ dans une assignation :

hdv2003$minutes.tv <- hdv2003$heures.tv * 60

# Les vecteurs peuvent être de classes différentes, selon le type de données qu’ils contiennent.

# On a ainsi des vecteurs de type integer ou double, qui contiennent respectivement des nombres entiers ou décimaux :

typeof(hdv2003$age)
str(hdv2003$age)

typeof(hdv2003$heures.tv)
str(hdv2003$heures.tv)

# Des vecteurs de type character, qui contiennent des chaînes de caractères :

vec <- c("Jaune", "Jaune", "Rouge", "Vert")
typeof(vec)

# Et des vecteurs de type logical, qui ne peuvent contenir que les valeurs vraie (TRUE) ou fausse (FALSE).

vec <- c(TRUE, FALSE, FALSE, TRUE)
typeof(vec)

# On peut convertir un vecteur d’un type en un autre en utilisant les fonctions as.numeric, as.character ou as.logical. Les valeurs qui n’ont pas pu être converties sont automatiquement transformées en NA.

x <- c("1", "2.35", "8.2e+03", "foo")
as.numeric(x)

y <- 2:6
as.character(y)

# On peut sélectionner certains éléments d’un vecteur à l’aide de l’opérateur []. La manière la plus simple est d’indiquer la position des éléments qu’on veut sélectionner :

vec <- c("Jaune", "Jaune", "Rouge", "Vert")
vec[c(1, 3)]


# La sélection peut aussi être utilisée pour modifier certains éléments d’un vecteur, par exemple :

vec <- c("Jaune", "Jaune", "Rouge", "Vert")
vec[2] <- "Violet"
vec

# Pour rappel, on appelle variable qualitative une variable pouvant prendre un nombre limité de modalités (de valeurs possibles).


## 9.2 Facteurs et forcats  -----

# Dans R, les variables qualitatives peuvent être de deux types : ou bien des vecteurs de type character (des chaînes de caractères), ou bien des factor (facteurs). Si vous utilisez les fonctions des extensions du tidyverse comme readr, readxl ou haven pour importer vos données, vos variables qualitatives seront importées sous forme de character. Mais dans d’autres cas elles se retrouveront parfois sous forme de factor. C’est le cas de notre jeu de données d’exemple hdv2003.

typeof(hdv2003$qualif)
class(hdv2003$qualif)


# Les facteurs sont un type de variable ne pouvant prendre qu’un nombre défini de modalités nommés levels.

levels(hdv2003$qualif)

# Ceci complique les opérations de recodage car du coup l’opération suivante, qui tente de modifier une modalité de la variable, aboutit à un avertissement, et l’opération n’est pas effectuée.

hdv2003$qualif[hdv2003$qualif == "Ouvrier specialise"] <- "Ouvrier"

# forcats est une extension facilitant la manipulation des variables qualitatives, qu’elles soient sous forme de vecteurs character ou de facteurs. Elle fait partie du tidyverse, et est donc automatiquement chargée par :

library(tidyverse)


## 9.3 Modifier les modalités d’une variable qualitative  -----

# Une opération courante consiste à modifier les valeurs d’une variable qualitative, que ce soit pour avoir des intitulés plus courts ou plus clairs ou pour regrouper des modalités entre elles.

# Il existe plusieurs possibilités pour effectuer ce type de recodage, mais ici on va utiliser la fonction fct_recode de l’extension forcats. Celle-ci prend en argument une liste de recodages sous la forme "Nouvelle valeur" = "Ancienne valeur".

# Un exemple :

f <- c("Pomme", "Poire", "Pomme", "Cerise")
f <- fct_recode(
  f,
  "Fraise" = "Pomme",
  "Ananas" = "Poire"
)
f

# Autre exemple sur une “vraie” variable :

freq(hdv2003$qualif)

hdv2003$qualif5 <- fct_recode(
  hdv2003$qualif,
  "Ouvrier" = "Ouvrier specialise",
  "Ouvrier" = "Ouvrier qualifie",
  "Interm" = "Technicien",
  "Interm" = "Profession intermediaire"
)

freq(hdv2003$qualif5)

# Ceci peut s'écrire de façon également de cette façon en utilisant le %>%, mutate et sans le $ pour appeler la variable a recoder.

hdv2003 <- hdv2003 %>% mutate(qualif6= fct_recode(
  qualif,
  "Ouvrier" = "Ouvrier specialise",
  "Ouvrier" = "Ouvrier qualifie",
  "Interm" = "Technicien",
  "Interm" = "Profession intermediaire"
))

freq(hdv2003$qualif6)

# Attention, les anciennes valeurs saisies doivent être exactement égales aux valeurs des modalités de la variable recodée : toute différence d’accent ou d’espace fera que ce recodage ne sera pas pris en compte. Dans ce cas, forcats affiche un avertissement nous indiquant qu’une valeur saisie n’a pas été trouvée dans les modalités de la variable.

hdv2003$qualif_test <- fct_recode(
  hdv2003$qualif,
  "Ouvrier" = "Ouvrier spécialisé", # avec des accents
  "Ouvrier" = "Ouvrier qualifié"
)


# Si on souhaite recoder une modalité de la variable en NA, il faut (contre intuitivement) lui assigner la valeur NULL.

hdv2003$qualif_rec <- fct_recode(
  hdv2003$qualif,
  NULL = "Autre"
)

freq(hdv2003$qualif_rec)


## 9.4. Ordonner les modalités d’une variable qualitative  -----

# L’avantage des facteurs (par rapport aux vecteurs de type character) est que leurs modalités peuvent être ordonnées, ce qui peut faciliter la lecture de tableaux ou graphiques.

# On peut ordonner les modalités d’un facteur manuellement, par exemple avec la fonction fct_relevel() de l’extension forcats.

hdv2003$qualif_rec <- fct_relevel(
  hdv2003$qualif,
  "Cadre", "Profession intermediaire", "Technicien",
  "Employe", "Ouvrier qualifie", "Ouvrier specialise",
  "Autre"
)

freq(hdv2003$qualif_rec)


# Une autre possibilité est d’ordonner les modalités d’un facteur selon les valeurs d’une autre variable. Par exemple, si on représente le boxplot de la répartition de l’âge selon le statut d’occupation :

library(ggplot2)
ggplot(hdv2003) +
  geom_boxplot(aes(x = occup, y = age))


# Le graphique pourrait être plus lisible si les modalités étaient triées par âge median croissant. On peut dans ce cas utiliser la fonction fct_reorder. Celle-ci prend 3 arguments : le facteur à réordonner, la variable dont les valeurs doivent être utilisées pour ce réordonnancement, et enfin une fonction à appliquer à cette deuxième variable.

hdv2003$occup_age <- fct_reorder(hdv2003$occup, hdv2003$age, median)

ggplot(hdv2003) +
  geom_boxplot(aes(x = occup_age, y = age))


# Ceci peut se faire aussi directement dans ggplot:
ggplot(hdv2003) +
  geom_boxplot(aes(x =  fct_reorder(occup, age, median), y = age))


# En r de base il est possible également de changer l'ordre de façon manuel de cette façon. La fonction levels permet d'afficher l'ordre des facteurs

levels(hdv2003$occup)

# Dès lors on peut écraser les levels

levels(hdv2003$occup)<-c( "Retraite", "Retire des affaires" , "Au foyer", "Autre inactif", "Exerce une profession", "Chomeur", "Etudiant, eleve")

# ou de façon plus longue:

hdv2003$occup<-factor( hdv2003$occup, levels= c("Chomeur", "Etudiant, eleve" , "Retraite", "Retire des affaires" , "Au foyer", "Autre inactif", "Exerce une profession"))

ggplot(hdv2003) +
  geom_boxplot(aes(x = occup, y = age))



## 9.5 Combiner plusieurs variables  -----

# Parfois, on veut créer une nouvelle variable en partant des valeurs d’une ou plusieurs autres variables. Dans ce cas on peut utiliser les fonctions ifelse pour les cas les plus simples, ou case_when pour les cas plus complexes. Cette dernière fonction est incluse dans l’extension dplyr, qu’il faut donc avoir chargé précédemment.

### 9.5.1 ifelse  -----

# ifelse prend trois arguments : un test, une valeur à renvoyer si le test est vrai, et une valeur à renvoyer si le test est faux.

# Voici un exemple simple :

v <- c(12, 14, 8, 16)
ifelse(v > 10, "Supérieur à 10", "Inférieur à 10")


# La fonction permet d’utiliser des tests combinant plusieurs variables. Par exemple, imaginons qu’on souhaite créer une nouvelle variable indiquant les hommes de plus de 60 ans :

hdv2003$statut <- ifelse(
  hdv2003$sexe == "Homme" & hdv2003$age > 60,
  "Homme de plus de 60 ans",
  "Autre"
)

freq(hdv2003$statut)

### 9.5.2 case_when  -----

# case_when est une généralisation du ifelse qui permet d’indiquer plusieurs tests et leurs valeurs associées.

# Imaginons qu’on souhaite créer une nouvelle variable permettant d’identifier les hommes de plus de 60 ans, les femmes de plus de 60 ans, et les autres. On peut utiliser la syntaxe suivante :

hdv2003$statut <- case_when(
  hdv2003$age > 60 & hdv2003$sexe == "Homme" ~ "Homme de plus de 60 ans",
  hdv2003$age > 60 & hdv2003$sexe == "Femme" ~ "Femme de plus de 60 ans",
  TRUE ~ "Autre"
)

freq(hdv2003$statut)

# Avec des ifelse cela aurait pu s'écrire de cette façon:
hdv2003$statut <- ifelse(
  hdv2003$age > 60 & hdv2003$sexe == "Homme" , "Homme de plus de 60 ans",
  ifelse(hdv2003$age > 60 & hdv2003$sexe == "Femme" , "Femme de plus de 60 ans", "Autre"))


# case_when prend en arguments une série d’instructions sous la forme condition ~ valeur. Il les exécute une par une, et dès qu’une condition est vraie, il renvoie la valeur associée.

# La dernière clause TRUE ~ "Autre" permet d’assigner une valeur à toutes les lignes pour lesquelles aucune des conditions précédentes n’est vraie.

# Attention : comme les conditions sont testées l’une après l’autre et que la valeur renvoyée est celle correspondant à la première condition vraie, l’ordre de ces conditions est très important. Il faut absolument aller du plus spécifique au plus général.

# Pour illustrer cet avertissement, on pourra noter que le recodage suivant ne fonctionne pas :

hdv2003$statut <- case_when(
  hdv2003$sexe == "Homme" ~ "Homme",
  hdv2003$sexe == "Homme" & hdv2003$age > 60 ~ "Homme de plus de 60 ans",
  TRUE ~ "Autre"
)

freq(hdv2003$statut)


# Comme la condition sexe == "Homme" est plus générale que sexe == "Homme" & age > 60, cette deuxième condition n’est jamais testée, et on n’obtiendra donc jamais la valeur correspondante.

# Pour que ce recodage fonctionne il faut donc changer l’ordre des conditions pour aller du plus spécifique au plus général.

hdv2003$statut <- case_when(
  hdv2003$sexe == "Homme" & hdv2003$age > 60 ~ "Homme de plus de 60 ans",
  hdv2003$sexe == "Homme" ~ "Homme",
  TRUE ~ "Autre"
)

freq(hdv2003$statut)

## 9.6 Découper une variable numérique en classes  -----

# Une autre opération courante consiste à découper une variable numérique en classes. Par exemple, on voudra transformer une variable revenu contenant le revenu mensuel en une variable qualitative avec des catégories Moins de 500 euros, 501-1000 euros, etc.

# On utilise pour cela la fonction cut() :

hdv2003$agecl <- cut(hdv2003$age, breaks = 5)

freq(hdv2003$agecl)

# Si on donne un nombre entier à l’argument breaks, un nombre correspondant de classes d’amplitudes égales sont automatiquement calculées. Comme il est souvent préférable d’avoir des limites “arrondies”, on peut aussi spécifier ces dernières manuellement en passant un vecteur à breaks.

hdv2003$agecl <- cut(
  hdv2003$age,
  breaks = c(18, 25, 35, 45, 55, 65, 97),
  include.lowest = TRUE,
  right = F
)

freq(hdv2003$agecl)

# Ici on a été obligé d’ajouter l’argument include.lowest = TRUE car sinon la valeur 18 n’aurait pas été incluse, et on aurait eu des valeurs manquantes.


# 10.  Travailler sur les variables textuelles  -----

# Les fonctions de forcats vues précédemment permettent de modifier des modalités d’une variables qualitative globalement. Mais parfois on a besoin de manipuler le contenu même du texte d’une variable de type chaîne de caractères : combiner, rechercher, remplacer…

# On va utiliser ici les fonctions de l’extension stringr. Celle-ci fait partie du coeur du tidyverse, elle est donc automatiquement chargée avec :

library(tidyverse)

# Dans ce qui suit on va utiliser le court tableau d’exemple d suivant :

d <- tibble(
  nom = c("Mr Félicien Machin", "Mme Raymonde Bidule", "M. Martial Truc", "Mme Huguette Chose"),
  adresse = c("3 rue des Fleurs", "47 ave de la Libération", "12 rue du 17 octobre 1961", "221 avenue de la Libération"),
  ville = c("Nouméa", "Marseille", "Vénissieux", "Marseille")
)


## 10.1. Expressions régulières  -----

# Les fonctions présentées ci-dessous sont pour la plupart prévues pour fonctionner avec des expressions régulières. Celles-ci constituent un mini-langage, qui peut paraître assez cryptique, mais qui est très puissant pour spécifier des motifs de chaînes de caractères.

# Elles permettent par exemple de sélectionner le dernier mot avant la fin d’une chaîne, l’ensemble des suites alphanumériques commençant par une majuscule, des nombres de 3 ou 4 chiffres situés en début de chaîne, et beaucoup beaucoup d’autres choses encore bien plus complexes.

# Pour donner un exemple concret, l’expression régulière suivante permet de détecter une adresse de courrier électronique1 :

# [\w\d+.-_]+@[\w\d.-]+\.[a-zA-Z]{2,}

# Par souci de simplicité, dans ce qui suit les exemples seront donnés autant que possible avec de simples chaînes de caractères, sans expression régulière. Mais si vous pensez manipuler des données textuelles, il peut être très utile de s’intéresser à cette syntaxe.


## 10.2 Concaténer des chaînes  -----

# La première opération de base consiste à concaténer des chaînes de caractères entre elles. On peut le faire avec la fonction paste.

# Par exemple, si on veut concaténer l’adresse et la ville :

paste(d$adresse, d$ville)

# Par défaut, paste concatène en ajoutant un espace entre les différentes chaînes. On peut spécifier un autre séparateur avec son argument sep :

paste(d$adresse, d$ville, sep = " - ")

# Il existe une variante, paste0, qui concatène sans mettre de séparateur, et qui est légèrement plus rapide :

paste0(d$adresse, d$ville)

# Note : À noter que paste et paste0 sont des fonctions R de base. L’équivalent pour stringr se nomme str_c.

# Parfois on cherche à concaténer les différents éléments d’un vecteur non pas avec ceux d’un autre vecteur, comme on l’a fait précédemment, mais entre eux. Dans ce cas paste seule ne fera rien :

paste(d$ville)

# Il faut lui ajouter un argument collapse, avec comme valeur la chaîne à utiliser pour concaténer les éléments :

paste(d$ville, collapse = ", ")

## 10.3 Convertir en majuscules / minuscules  -----

# Les fonctions str_to_lower, str_to_upper et str_to_title permettent respectivement de mettre en minuscules, mettre en majuscules, ou de capitaliser les éléments d’un vecteur de chaînes de caractères :

str_to_lower(d$nom)

str_to_upper(d$nom)

str_to_title(d$nom)

# La fonction str_split permet de “découper” une chaîne de caractère en fonction d’un délimiteur. On passe la chaîne en premier argument, et le délimiteur en second :

str_split("un-deux-trois", "-")

# On peut appliquer la fonction à un vecteur, dans ce cas le résultat sera une liste :

str_split(d$nom, " ")

## 10.4 Extraire des sous-chaînes par position  -----

# La fonction str_sub permet d’extraire des sous-chaînes par position, en indiquant simplement les positions des premier et dernier caractères :

str_sub(d$ville, 1, 3)

# La fonction R base substr() est elle aussi fort répandue:
substr(d$ville, 1, 3)

## 10.5 Détecter des motifs  -----

# str_detect permet de détecter la présence d’un motif parmi les élements d’un vecteur. Par exemple, si on souhaite identifier toutes les adresses contenant “Libération” :

str_detect(d$adresse, "Libération")


# str_count, compte le nombre d’occurrences d’une chaîne
# str_subset pour ne garder d’un vecteur que les éléments correspondant au motif


## 10.6 Extraire des motifs  -----

# str_extract permet d’extraire les valeurs correspondant à un motif. Si on lui passe comme motif une chaîne de caractère, cela aura peu d’intérêt :

str_extract(d$adresse, "Libération")

# C’est tout de suite plus intéressant si on utilise des expressions régulières. Par exemple la commande suivante permet d’isoler les numéros de rue.

str_extract(d$adresse, "^\\d+")

## 10.7 Remplacer des motifs  -----

# La fonction str_replace_all permet de remplacer une chaîne ou un motif par une autre.

# Par exemple, on peut remplacer les occurrence de “Mr” par “M.” dans notre variable nom :

str_replace_all(d$nom, "Mr", "M.")


# On peut également spécifier plusieurs remplacements en une seule fois :

str_replace_all(
  d$adresse,
  c("avenue" = "Avenue", "ave" = "Avenue", "rue" = "Rue")
)












