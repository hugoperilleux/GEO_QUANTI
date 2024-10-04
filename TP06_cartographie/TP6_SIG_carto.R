# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ----------------  TP 6 - SIG et cartographie  ------------------
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# fonctions vues:

# package: sf, mapsf

# source: https://r-spatial.github.io/sf/
# source: https://riatelab.github.io/mapsf/
# source: https://maeltheuliere.github.io/rspatial/index.html


# Données:
# secteurs statistiques: https://statbel.fgov.be/fr/open-data/secteurs-statistiques-2023


# raccourcis:
# %>%  CTRL + SHIFT + m
# sauver CTRL + s
# annuler la dernière écriture CTRL + z
# rétablir la dernière écriture CTRL + SHIFT + z
# commenter/ décommenter plusieurs lignes CTRL + SHIFT + c

# Installation des packages
#install.packages("sf")
#install.packages("mapsf")

setwd("/mnt/data/ownCloud/ULB/GEO/GEOG F 404/")


# 1. Analyse vectorielle   -----

library(sf)
# comprend les librairies:
# - GEOS (bibliothèque d'opération géométrique)
# - GDAL (bibliothèque pour lire la plupart des formats de données spatiales matricels et vectoriels)
# - PROJ (bibliothèque de projections cartographique)

# Le package tidyverse nous sera aussi utile pour la suite des exemples.
library (tidyverse)


## 1.1. Importer et exporter des données  -----


### 1.1.1. Importer un fichier vectoriel

# st_read() permet de lire des données spatiales disponibles en fichier plat. Le format de fichier plat le plus populaire en géomatique est ESRI Shapefile (.shp). Ce format, en plus de ne pas être un format ouvert, a des limites bien documentées. Avec l’avènement du web, le format GeoJSON se développe beaucoup, bien qu’il soit aussi limité. Le format considéré comme le plus prometeur est le format OGC GeoPackage (.gpkg) promu par l’Open Geospatial Consortium. Mais la liste des formats lisibles par sf est bien plus vaste. Pour l’obtenir, on peut utiliser st_drivers()

# Dans certains cas, une dimension z peut être ajoutée. Elle peut être supprimée grâce à la fonction zm()

# https://statbel.fgov.be/fr/open-data/secteurs-statistiques-2023

# secteurs_stats<- st_read ("data/sh_statbel_statistical_sectors_31370_20230101.sqlite") %>%
#  st_zm()

### 1.1.2. Exporter un fichier vectoriel  -----

# st_write() permet d'exporter des données. Il faut bien indiquer l'extention qu'on souhaite utiliser (ici .gpkg). Le paramètre append=FALSE permet d'écraser un fichier existant.

#st_write(secteurs_stats, "data/sh_statbel_statistical_sectors_31370_20230101.gpkg", append=F)
secteurs_stats<-st_read( "data/sh_statbel_statistical_sectors_31370_20230101.gpkg")

# Vous noterez que le champ géométrie qui s'appelle généralement geom, geometry ou the_geom, avait le nom GEOMETRY dans lorsqu'on a importer le fichier .sqlite et qu'il s'appelle geom dans le fichier .gpkg.

# On peut faire une première carte avec la fonction native plot. En appliquant la fonction st_geometry on extrait juste la géométrie nécessaire pour la carte:

plot(st_geometry(secteurs_stats))


### 1.1.3. Créer un fichier spatial à partir de coordoonées  -----


# On peut construire un rectangle à partir de coordonnées
m <- rbind(c(141954,179089), c(141954,131498), c(192576,131498),
           c(192576,179089), c(141954,179089))
rectangle <- st_transform(st_sf(st_sfc(st_polygon(list(m)), crs = 31370 )), crs= st_crs(secteurs_stats))
rm(m)
plot(rectangle)

# st_crs permet d'extraire la projection d'une couche
# st_polygone permet de créer un polygone à partir d'une liste de point
# st_sfc permet de définir la projection d'une couche (attention à ne pas confondre avec la reprojection)
# st_sf permet de créer un objet sf
# st_transform pour reprojeter c'est-à-dire que des nouvelles coordonnées vont être calculées pour correspondre au nouveau système de projection


### 1.1.4. Reprojection  -----

# On peut dès reprojet une couche facilement grâce à st_transform. Par exemple ici en WGS84 (CRS=4326), on voit bien que les coordonnées sont en latitude - longitude:

secteurs_stats %>%
  st_transform(crs=4326)


# Les objets  spatiaux fonctionnent un peu comme des objets dataframe (ou tibble), on peut réaliser les opérations de dplyr. Par exemple, on peut réaliser un filtre de la façon suivante:

secteurs_stats_bxl <- secteurs_stats %>%
  filter(tx_rgn_descr_fr== "Région de Bruxelles-Capitale")
plot(st_geometry(secteurs_stats_bxl))

# Comme pour les dataframe et les tibbles on peut facile contruire des nouvelles variables grâce au verbe mutate. On peut calculer la surface de chaque polygone grâce à la fonction st_area qui s'applique sur le champ géomtrie (geom)
secteurs_stats %>%
  mutate(surface= st_area(geom))

# On peut convertir en numérique pour enelever les unités
secteurs_stats %>%
  mutate(surface= as.numeric(st_area(geom)))


## 1.3. Opérations qui modifient les géométries  -----


### 1.3.1. Dissolution  -----

belgique <- st_union(secteurs_stats)
plot(belgique)

# On peut utiliser la syntaxe de dplyr (group_by et summarise) pour fusionner les secteurs statistiques sur base de leur attributs et ainsi recréer les régions, communes, provinces. On définit une nouvelle géométrie (geom) à partir des géométrie de la couche secteurs stats et en appliquant le fonction st_union.

# Régions:

region <- secteurs_stats %>%
  group_by(tx_rgn_descr_fr) %>%
  summarise(geom= st_union(geom))%>%
  ungroup()

plot(st_geometry(region))

# Provinces:
provinces <- secteurs_stats %>%
  group_by(cd_prov_refnis, tx_prov_descr_fr) %>% # ici on mets le code province, le nom des pvinces en français pour conserver les deux champs
  summarise(geom= st_union(geom))%>%
  ungroup()

plot(st_geometry(provinces))

# Communes:
communes <- secteurs_stats %>%
  group_by(cd_munty_refnis, tx_munty_descr_fr, tx_rgn_descr_fr) %>% # ici on mets le code NIS, le nom de la région, le nom en français pour conserver les deux champs
  summarise(geom= st_union(geom)) %>%
  ungroup()

# On peut alors conserver que les communes de Bruxelles
communes_bxl<-communes %>%
  filter(tx_rgn_descr_fr== "Région de Bruxelles-Capitale")

plot(st_geometry(communes_bxl))

# ou uniquement la commune de Anderlecht

anderlecht<-communes %>%
  filter(tx_munty_descr_fr== "Anderlecht")
plot(st_geometry(anderlecht))



### 1.3.2. Centroïdes  -----

# La fonction st_centroid() permet de calculer le centroïde.

# Si on ne prend que les secteursde Bruxelles

secteurs_stats_bxl_centroid <- secteurs_stats_bxl %>%
  st_centroid()
plot(st_geometry(secteurs_stats_bxl))
plot(st_geometry(secteurs_stats_bxl_centroid), cex=0.2, add=T)

# On peut faire la même chose avec les communes de Bruxelles:

communes_bxl_centroid<- communes_bxl %>%
  st_centroid()

plot(st_geometry(communes_bxl))
plot(st_geometry(communes_bxl_centroid), cex=0.2, add=T) # ici on ajouter une couche grâce au paramètre add=TRUE et on détermine la taille du point grâce à cex=0.2


# Vous remarquerez que le centroide de la commune de la Ville de Bruxelles est en dehors de la région, ce qui peut poser problème pour des représentations. De façon alternative on peut utiliser la fonction st_point_on_surface() qui permet de placer un point qui sera obligatoirement dans le polygone:

communes_bxl_centroid<- communes_bxl %>%
  st_point_on_surface()

plot(st_geometry(communes_bxl))
plot(st_geometry(communes_bxl_centroid), cex=0.2, add=T)



### 1.3.3. Tampons  -----

# On peut réaliser des tampons grâce à la fonction st_buffer où le paramètre dist indique la distance utilisée pour réaliser le buffer.

communes_bxl_buffer <- st_buffer(x = communes_bxl, dist = 1000)
plot(st_geometry(communes_bxl_buffer))

# Si on souhaite fussioner les buffers, alors il faut ajouter la fonction st_union
communes_bxl_buffer <- st_buffer(x = communes_bxl, dist = 1000) %>%
  st_union()
plot(st_geometry(communes_bxl_buffer))


### 1.3.4. Intersection avec découpage   -----

# Si on reprend le rectangle ainsi que les communes:
plot(st_geometry(rectangle))
plot(st_geometry(communes), add=T)

# on peut réaliser une intersection (st_intersection) "avec découpage". Des nouvelles géométrie sont créées et les tables d'attribut sont le croisement des deux couches (dès lors l'ordre de X et Y ne compte pas):

decoupage<-st_intersection(communes, rectangle)
plot(st_geometry(decoupage))

# Il est aussi possible de faire des différences avec découpage avec la fonction st_difference()

# decoupage<-st_difference(communes, rectangle)
# plot(st_geometry(decoupage))


## 1.4. Opération à partir des géométries  -----

### 1.4.1. Sélection par localisation  -----

# Les sélection par localisation peuvent être réalisée grâce à la fonction st_filter et la paramètre .predicate (ne pas oublier le point) permet de définir l'opérateur topologique :
# st_within,
# st_touches,
# st_intersects,
# st_disjoint,
# st_is_within_distance,
# st_contains,
# st_crosses,
# st_covers,
# st_covered_by,
# st_equals,
# st_equals_exact,
# st_contains_properly,
# st_overlaps).
# Contrairement à l'intersection avec découpage, la sélection par localisation sélectionne des éléments (en conservant les géométries) de X suivant des conditions sur les relations topologique des éléments X vis-à-vis des éléments Y et seule la table d'attribut X est conservée (dès lors l'ordre de X et Y compte).


selection_localisation<-st_filter(communes, rectangle,.predicate =st_intersects)

plot(st_geometry(rectangle),border="red")
plot(st_geometry(selection_localisation), add=T)


# Ici on sélectionne parmi l'objet secteurs_stats_bxl_centroid les points qui sont à l'intérieur (within) de la commune d'Anderlecht
secteurs_stats_anderlecht_centroid<-secteurs_stats_bxl_centroid %>%
  st_filter(anderlecht, .predicate = st_within)

plot(st_geometry(anderlecht))
plot(st_geometry(secteurs_stats_anderlecht_centroid),cex=0.2,add=T)

# On peut faire l'inverse et sélectionner ceux qui sont disjoint de la commune d'Anderlecht

secteurs_stats_anderlecht_centroid<-secteurs_stats_bxl_centroid %>%
  st_filter(anderlecht, .predicate = st_disjoint)

plot(st_geometry(secteurs_stats_anderlecht_centroid),cex=0.2)
plot(st_geometry(anderlecht),add=T)


# On peut également sélectionner les points qui sont à distance de moins de 2000 m (unité du système de projection, ici Lambert Belge 1972)

secteurs_stats_anderlecht_centroid<-secteurs_stats_bxl_centroid %>%
  st_filter(anderlecht, .predicate = st_is_within_distance, dist=3000)


plot(st_geometry(secteurs_stats_anderlecht_centroid),cex=0.2)
plot(st_geometry(anderlecht),add=T)


### 1.4.2. Jointure spatiale  -----

# On peut réaliser des jointures spatiales grâce à la fonction st_join où join= permet de définir l'opérateur topologique (voir infra pour la liste des opérateurs topologique) utilisé pour la jointure:

jointure<-communes_bxl %>%
  st_join(communes_bxl_centroid, join= st_intersects)

View(jointure)

plot(st_geometry(communes_bxl))
plot(st_geometry(communes_bxl_centroid),cex=0.2,add=T)


# Notez qu'il peut être intéressant de passer par les centroïdes pour réaliser des jointures spatiales. En effet, les limites des polygones peuvent être un peut différentes. Par exemple pour faire la jointure entre les secteurs statistiques (STATBEL) avec les quartiers du monitoring (IBSA) le passage par les centroïdes rend la jointure spatiale plus sûre.:

# Prenons une couche des quartiers (monitoring) publié par l'IBSA:
quartiers<-st_read("data/ibsa-revenu-imposable-median-des-declarations_2019_quartier.geojson")

quartiers %>%
  st_join(secteurs_stats_bxl_centroid, join= st_intersects) %>%
  as.data.frame() %>%
  select(id, cd_sector)


### 1.4.3. Matrice de distances  -----

# On peut calculer une matrice de distance grâce à la fonction st_distance:

matrice_distance <- st_distance(x=communes_bxl_centroid,y=communes_bxl_centroid)
matrice_distance


# 2. Cartographie  -----


## 2.1. Carte avec plot  -----

# Avec plot on peut déjà facile faire une carte. le paramètre add=TRUE permet de rajouter des couches


plot(st_geometry(region), lty="dashed")
plot(st_geometry(belgique), add=T)


## 2.2. Carte avec mapsf  -----

# Pour réaliser les cartes on va utiliser le package mapsf qui permet plus de facilité pour créer les cartes.

# 1/ L’initialisation :
#
# mf_init() : permet de définir la couche qui servira de cadre à la carte
# mf_theme() : permet de customiser le style global de la carte (définition des couleurs des typographies, etc.)
#
# 2/ La cartographie à proprement parler :
#
# mf_map() : fonction générique de représentation en vecteur ; peut aussi s’utiliser avec des formes plus précises selon le type de représentation choisie : mf_choro(), mf_typo(), etc.
# mf_raster() : représentation en raster
# mf_label() : représentation d’étiquettes (noms des communes, etc.)
#
# 3/ L’habillage annexe :
#
# mf_inset_on() / mf_inset_off() : insérer un carton ou un graphique annexe.
# mf_legend() : paramétrage de la légende “à la main”
# mf_annotation() : ajout de texte
#
# 4/ Disposition et mise en page :
#
# mf_layout() : insertion d’un titre, des sources, d’une orientation, d’une échelle, etc.

# Voiri https://riatelab.github.io/mapsf/  pour plus de détails

library(mapsf)

### 2.2.1. Initialisation  -----


# La fonction mf_map est la fonction principale de mapsf On peut montrer les géométrie simplement avec mf_map

# Un carte des régions
mf_map(region)

# Une carte des provinces
mf_map(provinces)

# Pour réaliser la carte suivante on va charger les données de population par secteurs statistiques

library(readxl)

pop<-read_excel("data/OPEN DATA_SECTOREN_2019.xlsx")

# On joint par le code du secteur statistique et on créer une variable densite eton sélectionne que les secteurs bruxellois

secteurs_stats_pop<-secteurs_stats %>%
  left_join(pop, by=c("cd_sector"="CD_SECTOR")) %>%
  mutate(densite=as.numeric(10000*POPULATION/st_area(geom))) %>%
  filter(tx_rgn_descr_fr== "Région de Bruxelles-Capitale")


### 2.2.2. Carte par plage (choroplèthe)  -----

# On peut alors faire une carte par plafe avec mf_map où type ="choro" pour choroplèthe

mf_map(secteurs_stats_pop,
       var= "densite",
       type="choro")


### 2.2.3. Ajouter des couches (choroplèthe)  -----

# On peut ajouter des couches comme avec plot en ajoutant des mf_map avec le add=TRUE

mf_map(secteurs_stats_pop,
       var= "densite",
       type="choro")
mf_map(x = communes, #%>%filter(tx_rgn_descr_fr== "Région de Bruxelles-Capitale"),#avec un filtre
         col = NA,
       border = "gray10",
       lwd = 1.5,
       add = TRUE)

### 2.2.4. Modifier la mise en page  -----


# On peut modifier la mise en page grâce à toute une série de paramètres

mf_map(secteurs_stats_pop,
       var= "densite",
       type="choro",
       nbreaks=5, # le nombre de classe
       pal= "Viridis", # le choix de la palette de couleur
       leg_pos="topleft", # la position de la légende
       leg_title= "Densité de population\n(hab./ha)") # le titre de la légende
mf_map(x = comunes_bxl, col = NA, border = "gray10", lwd = 1.5, add = TRUE)

### 2.2.5. Carte de cercle proportionnels  -----


# On peut réaliser des cartes de cercles proportionnels avec var="prop"

mf_map(x = secteurs_stats_pop)
mf_map(x = secteurs_stats_pop,
       var = "POPULATION",
       type = "prop",
       leg_pos = "topright",
       inches=0.03,
       add=T)


### 2.2.6. Carte bivariée (cercle proportionnels colorés)  -----


# On peut également réaliser des cartes bi-variées où la taille du cercle est proportionnelle


# On importe les données de revenus
#revenus<-read_delim("data/revenu_imposable_median_decla_2019.csv", delim=",")

revenus<-read_excel("data/fisc2019_D_FR.xls")


# On réalise la jointure
secteurs_stats_pop_revenu<- secteurs_stats_pop %>%
  left_join(revenus, by=c("cd_sector"))


mf_map(x = secteurs_stats_pop,col = "white", border = "grey")
mf_map(x = secteurs_stats_pop_revenu,
       var = c("POPULATION","revenu_median_decla"),
       type = "prop_choro",
       inches=0.08,
       nbreaks=5,
       leg_pos=c("bottomleft","topleft"),
       pal = "Viridis",
       add = TRUE)



### 2.2.7. Exporter une carte mapsf  -----

#Pour exporter une carte mapsf il faut commencer le code par mf_export() où x est une des couches utilisée, filename= "le/chemin/vers/la/carte.png" et width= la résolution en pixels et on termine par dev.off()

#mf_export(x = secteurs,
#          filename ="figures/carte_revenus_2015.png",
#          width = 800)
# TOUT LE CODE DE LA CARTE ICI
#dev.off()


# Par exemple:

mf_export(x = secteurs_stats_pop,
          filename ="TP6_cartographie/carte_exemple.png",
          width = 800)
mf_map(x = secteurs_stats_pop,col = "white", border = "grey65")
mf_map(x = secteurs_stats_pop_revenu,
       var = c("POPULATION","revenu_median_decla"),
       type = "prop_choro",
       inches=0.13,
       nbreaks=5,
       leg_pos=c("topleft","topright"),
       leg_title= c("Nombre d'habitant-es","Revenu médian par\ndéclaration (2019"),# \n permet d'aller à la ligne
       leg_val_rnd = c(-1,-2), #permet d'arrondir à la dizaine et la centaine
       pal = "Viridis",
       add = TRUE)
mf_layout(title = "Revenu médian par déclaration",
          credits = "Hugo Périlleux - IGEAT - ULB\nSources: IBSA, 2019",
          arrow=F,
          frame=T)
dev.off()









