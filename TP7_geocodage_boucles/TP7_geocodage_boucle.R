# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ----------------  TP 7 - Géocodage et boucles  -----------------
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# fonctions vues: phaco_setup_data, phaco_geocode,phaco_best_data_update

# package: phacochr

# source: https://phacochr.github.io/phacochr


# raccourcis:
# %>%  CTRL + SHIFT + m
# sauver CTRL + s
# annuler la dernière écriture CTRL + z
# rétablir la dernière écriture CTRL + SHIFT + z
# commenter/ décommenter plusieurs lignes CTRL + SHIFT + c

# 1. Géocodage avec PhacochR ----

# phacochr est un géocodeur pour la Belgique sous forme de package R. Son principe est de produire, à partir d’une base de données d’adresses, une série d’informations nécessaires pour l’analyse spatiale : les coordonnées X-Y mais également d’autres informations utiles comme le secteur statistique ou le quartier du monitoring pour Bruxelles. Le niveau de précision du géocodage est celui du bâtiment. Le package est très rapide pour géocoder de longues listes (la vitesse d’exécution se situe entre 0,4 et 0,8 secondes pour 100 adresses sur un ordinateur de puissance moyenne) et le taux de succès pour le géocodage est élevé (médiane de 97%). Voir la page Performances et fiabilité pour le détail des performances. Par ailleurs, le géocodage est réalisé entièrement en local, permettant une confidentialité maximale dans le cas d’adresses qui ne peuvent pas être envoyées sur des serveurs externes (permettant notamment un Géocodage anonymisé). phacochr constitue donc une alternative très performante face aux solutions existantes tout en reposant entièrement sur des données publiques et des procédures libres.

# Le programme fonctionne avec les données publiques BeST Address compilées par BOSA à partir des données régionales Urbis (Région de Bruxelles-Capitale), CRAB (Région flamande) et ICAR (Région wallonne). La logique de phacochr est de réaliser une jointure inexacte entre la liste à géocoder et les données BeST Address grâce aux fonctions des packages R fuzzyjoin et stringdist. phacochr dispose de plusieurs options : il peut notamment réaliser des corrections orthographiques (en français et néérlandais) préalables à la détection des rues ou procéder au géocodage au numéro le plus proche - de préférence du même côté de la rue - si les coordonnées du numéro indiqué sont inconnues (par exemple si l’adresse n’existe plus). En cas de non disponibilité du numéro de la rue, le programme indique les coordonnées du numéro médian de la rue. phacochr est compatible avec les 3 langues nationales : il géocode des adresses écrites en français, néérlandais ou allemand.

# Note de développement: Cette version de phacochr est encore une version de développement. Elle est néanmoins pleinement fonctionnelle et a passé l’épreuve de nombreux tests, au cours desquels des solutions ont été apportées aux problèmes posés par des structures de données diverses. La mise à disposition publique du package nous permettra de bénéficier de retours plus larges concernant des problèmes que nous n’aurions pas anticipés. Nous passerons phacochr en version 1.0 lorsque nous serons assurés que le package est suffisamment solide pour faire face à un grand nombre de situations. Néanmoins, dans un but de continuité d’utilisation, la logique d’utilisation de phacochr ne changera plus. Seuls quelques éléments seront encore certainement modifiés dans un avenir proche : il s’agit des noms des colonnes créées et des noms des arguments des fonctions, qui seront harmonisés et simplifiés, sans que cela impacte l’utilisation du programme.


## 1.1. Installation -----
# Vous pouvez installer le package phacochr depuis GitHub. Pour cela, il vous faut d’abord installer et charger le package devtools :

# Installer devtools si celui-ci n'est pas installé et charger le package
install.packages("devtools")
library(devtools)

# Installer phacochr
devtools::install_github("phacochr/phacochr")

# Il est indispensable lors de la première utilisation d’installer les données nécessaires à son utilisation via la fonction phaco_setup_data(). Ces fichiers (+/- 265Mo) sont téléchargés et stockés de manière permanente dans un répertoire de travail sur l’ordinateur (dépendant du système d’exploitation et renseigné par la fonction lors de l’installation).

# Charger phacochr
library(phacochr)

# Il est également possible pour l’utilisateur de mettre à jour lui-même les données BeST Address (actualisées de manière hebdomadaire par BOSA) vers les dernières données disponibles en ligne avec la fonction phaco_best_data_update(). Voir la page dédiée à la structure et la mise à jour des données pour plus de précisions.

# Installer les données nécessaires à phacochr
phaco_setup_data()

# Mettre à jour les données BestAdress

# phaco_best_data_update()

# Ceci peut prendre un peu de temps parce qu'il doit télécharger toutes les données et refaire les jointures spatiales pour toutes les adresses.



## 1.2. Exemple de géocodage -----

#  Voici un exemple de géocodage à partir des données d’exemples snacks contenues dans phacochr :
head(snacks, 8)

# Il s’agit des snacks à Bruxelles. Le géocodage se lance simplement avec la fonction phaco_geocode() appliquée au data.frame. Nous indiquons dans cet exemple 3 paramètres : les colonnes contenant la rue, le numéro de rue et le code postal, disponibles séparément dans la base de données. Il s’agit de la situation idéale, mais le programme est compatible avec d’autres configurations : celles-ci sont renseignée plus bas au point Format des données à géocoder. Mentionnons déjà que le numéro peut ne pas être renseigné ; phacochr trouve alors les coordonnées du numéro médian de la rue au code postal indiqué. La fonction dispose de plusieurs options, voir le dictionnaire des fonctions : https://phacochr.github.io/phacochr/reference/index.html.

result <- phaco_geocode(data_to_geocode = snacks,
                        colonne_num = "num",
                        colonne_rue = "rue",
                        colonne_code_postal = "code_postal")


# Le package dispose également d’une fonction de cartographie des adresses géocodées (reposant sur le packageR mapsf et des shapefiles intégrés aux données téléchargées). phaco_map_s() produit des cartes statiques à partir des données géocodées : il suffit de passer à la fonction l’objet data_geocoded_sf créé précédemment par phaco_geocode(). La fonction dessine alors les coordonnées des adresses sur une carte dont les frontières administratives sont également affichées. Si les adresses se restreignent à Bruxelles, la carte se limite automatiquement à la Région bruxelloise, comme c’est le cas pour cet exemple. Les options de la fonction sont également renseignées dans le dictionnaire des fonctions.

phaco_map_s(result$data_geocoded_sf,
            title_carto = "Snacks à Bruxelles")




# 2. Boucle for ----

# 2.1. Syntaxe ----

# Les boucles for permettent de de réaliser des opérations de façon itérative avec la synthaxe suivante:
for (i in 1:n){
  ## tâche à répéter n fois pour i variant de 1 à n
}

# Par exemple

for (i in 1:10){
  print(i)
}

# On peut réaliser n'importe quel opération et créer des objets à l'intérieur des boucles:


for (i in 1:10){
  tmp<-i+10
  print(tmp)
}

# On peut réaliser les itérations sur n'importe quel vecteur:

for (i in c("vive", "les", "boucles" )){
  print(i)
}

# 2.2. Concaténer un résultat ----

# On peut vouloir stocker le résultat des opérations réalisées dans la boucle. Pour pouvoir faire cela, il s'agit d'initialiser la boucle en créer un objet vide


result<- tibble()
for (i in 1:10){
  tmp<-tibble(x=i+10)
  result<- bind_rows(result, tmp)
}
result


# 2.3. Faire des cartes en séries ----


# On peut réaliser toute une série d'opération dans les boucles comme créer des cartes

# On charge des données de nationalités
nationalites<-read_delim("data/nationalites_bxl_2007_2.csv", delim=";")

secteurs_stats<- st_read ("data/sh_statbel_statistical_sectors_31370_20230101.gpkg")
nationalites_sec<-secteurs_stats%>%
  left_join(nationalites, by=c("cd_sector"="sscod")) %>%
  filter(tx_rgn_descr_fr=="Région de Bruxelles-Capitale")

# On prend les noms des variables 2 à 23
var<-names(nationalites)[2:23]

for (i in var){
  mf_map(x = nationalites_sec,col = "white", border = "grey")
  mf_map(nationalites_sec,
         var=i,
         type="prop",
         inches = 0.07,
         add=T)
}


# Si on souhaite enregistrer ces cartes on peut le faire de la façon suivante en créant un nom qui change selon le i :

# on sélectionne manuellement les variables à afficher
var<-c("FRANCE","ALLEMAGNE", "PORTUGAL", "MAROC", "TURQUIE", "JAPON")
for (i in var){
  mf_export(x = nationalites_sec,
            filename =paste0("carte_nationalite_", i,".png"),
            width = 800)
  mf_map(x = nationalites_sec,col = "white", border = "grey")
  mf_map(nationalites_sec,
         var=i,
         type="prop",
         inches = 0.10,
         add=T)
  dev.off()
}



