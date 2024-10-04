
# ------------------------------------------------------------------------------ #
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
#
#                       SIG et cartographie dans R
#                            avec sf et mapsf
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
# ------------------------------------------------------------------------------ #



setwd("/mnt/data/ownCloud/ULB/GEO/GEOG F 404/TP6_cartographie/formation_carte/")

#install.packages("sf")
#install.packages("mapsf")



# ------------------------------------------------------------------------------ #
#
#     Lire/écrire des fichiers vectoriels et réaliser des traitements SIG
#                                  avec sf
#
# ------------------------------------------------------------------------------ #

library(sf)
library (tidyverse)
# comprend les librairies:
# - GEOS (bibliothèque d'opération géométrique)
# - GDAL (bibliothèque pour lire la plupart des formats de données spatiales matricels et vectoriels)
# - PROJ (bibliothèque de projections cartographique)

# Importer les données
communes <- st_read ("Apn_AdMu.shp")

# écrire un fichier vectoriel ("plat")
#st_write( obj= st_transform(communes, crs=31370), dsn= "communes_31370.gpkg")
#st_write( obj= st_transform(communes, crs=31370), dsn= "communes_31370.shp")
# où st_stransform permet de reprojeter



# Faire des cartes en natif avec plot
plot(st_geometry(communes))
# où st_geometry qui permet d'extraire la géométrie d'une couche

# Traitements SIG

# création de centroid
communes_centroid <- st_centroid(communes)

plot(st_geometry(communes))
plot(st_geometry(communes_centroid), add=TRUE, cex=0.5, col="red", pch=20)

# où add= TRUE permet d'ajouter le second plot au premier, cex la taille, col la couleur et pch le type de point

# faire des matrices de distance
mat <- st_distance(x=communes_centroid,y=communes_centroid)
mat[1:5,1:5]

# agréger des polygones

belgique <- st_union(communes)
plot(st_geometry(communes), col="lightblue")
plot(st_geometry(belgique), add=T, lwd=2, border = "red")

bruxelles <- st_union(communes %>% filter(str_sub(AdMuKey, 1,2)==21))
wallonie <- st_union(communes %>% filter(str_sub(AdMuKey, 1,2)==21))

#st_union dans un group_by (st_sf créé un objet sf)
arrondissements<- communes %>% group_by(AdDiKey)%>% summarize(geometry = st_union(geometry))
arrondissements<- st_sf(arrondissements)
plot(st_geometry(arrondissements))

provinces<- communes %>% group_by(AdPrKey)%>% summarize(geometry = st_union(geometry))
provinces<- st_sf(provinces)
plot(st_geometry(provinces))

regions<- communes %>% group_by(AdReKey)%>% summarize(geometry = st_union(geometry))
regions<- st_sf(regions)
plot(st_geometry(regions))


# réaliser des zones tampon

belgique_buffer <- st_buffer(x = belgique, dist = 5000)
plot(st_geometry(communes), col="lightblue")
plot(st_geometry(belgique), add=T, lwd=2)
plot(st_geometry(belgique_buffer), add=T, lwd=2, border = "red")



# créer un rectangle sur base de coordonnées
m <- rbind(c(141954,179089), c(141954,131498), c(192576,131498),
           c(192576,179089), c(141954,179089))

rectangle <- st_transform(st_sf(st_sfc(st_polygon(list(m)), crs = 31370 )), crs= st_crs(communes))
rm(m)
# st_crs permet d'extraire la projection de la couche commune
# st_polygone permet de créer un polygone à partir d'une liste de point
# st_sfc permet d'associer une projection à une couche
# st_sf permet de créer un objet sf
# st_transform pour reprojeter

plot(st_geometry(communes))
plot(rectangle, border="red", lwd=2, add=TRUE)

#réaliser une intersection avec découpage

intersection <- st_intersection(x = communes, y = rectangle)
plot(st_geometry(communes))
plot(st_geometry(intersection), col="red", border="green", add=T)


# Réaliser une sélection par localisation (opération= intersection)

selection_localisation <-st_intersects(x = communes, y = rectangle)
communes_selection_logical = lengths(selection_localisation) > 0
communes_selection<- communes[communes_selection_logical,]
plot(st_geometry(communes_selection))

# une autre façon

plot (st_geometry(communes %>%
                          st_filter(rectangle, .predicate = st_intersects)))

#supprimer les objets inutiles pour la suite
rm(belgique_buffer, communes_centroid, rectangle, intersection, selection_localisation,
   communes_selection_logical,communes_selection, mat)

# Plus d'info
# https://r-spatial.github.io/sf/
# https://geocompr.robinlovelace.net/spatial-class.html
# https://rcarto.github.io/geoteca_mapsf/#16


# ------------------------------------------------------------------------------ #
#
#                           Réaliser des cartes
#                                  avec mapsf
#
# ------------------------------------------------------------------------------ #

#importer donnée de revenu et population à l'échelle de la commune
communes <- st_read ("Apn_AdMu.shp")
revenus <- read.csv(file= "fisc2019_C_FR.csv")
pop <- read.csv(file= "Population_par_commune_2019.csv")

#lister les variables
str(communes)
str(revenus)
str(pop)
#convertir le champ de jointure en texte comme les autres
revenus$code_ins<- as.character(revenus$code_ins)
#joindre les fichiers
communes<-communes %>%  left_join (revenus, by =c("AdMuKey"="code_ins"))
communes<-communes %>%  left_join (pop, by =c("AdMuKey"="code_ins"))

str(communes)

# Carto
library(mapsf)
#carte de base
mf_map(x = communes, col = "orange",border = "white")
#cercle prop
mf_map(x = communes, type = "prop", var = "pop_2019",
       leg_title = "Population", add = TRUE)

# carte par plage ("choro")
communes$densite <- 10000*communes$pop_2019/ st_area(communes)
mf_map(x = communes, type = "choro", var = "densite",  breaks = "quantile", nbreaks = 8,  pal = "RdYlBu")


#carte cercle prop et couleur
mf_export(x = communes,
          filename =("carte_pop_belgique.png" ), # nom du fichier en sortie
          width = 800) #résolution
mf_map(x = communes, col = "white",border = "grey")
mf_map(x = communes, type = "prop_choro", var = c("pop_2019", "revenu_median_decla"),
       pal = "RdYlBu",breaks = "quantile", nbreaks = 5,
       leg_title = "Population", add = TRUE)
mf_layout(title = "Belgique",
          credits = "Sources: Statbel, 2019")
dev.off() # fin de la carte





# Carte un peu plus élaborée

# calcul revenu mensuel et population en milliers
communes<- communes %>%
  mutate(revenu_med_mois= revenu_median_decla/12,
         pop_2019_mil= pop_2019/1000)


mf_export(x = communes,
          filename =("carte_pop_liege.png" ),
          width = 800)
mf_init(communes %>% filter(AdPrKey=="60000"),
        expandBB=c(0,0,0,0.1)) # Initialize a map with a specific extent
mf_map(x = communes,
       col = "white",
       border = "grey",
       add=T) # fond de carte
mf_map(x= st_cast (provinces,"MULTILINESTRING"),
       add=T) # limite des communes
mf_map(x = communes ,
       type = "prop_choro",
       var = c("pop_2019_mil", "revenu_med_mois"),
       inches = 0.4,
       lwd= 0.5,
       pal = "Viridis",breaks = "quantile", nbreaks = 5,# 5 classes, méthode de quantile, palette Viridis
       leg_title =  c("Nombre d'habitants\n(en milliers)","Revenu fiscal\nmensuel médian") ,
       leg_pos = c(c(791026,605806.6 ), c(791026,655031.9 )),
       leg_val_rnd = c(-1, -2),
       add = TRUE) # cercle prop colorés selon une seconde variable
#mf_label(x = mtq, var = "entite_adm", halo = TRUE, cex = 0.8,overlap = T, lines = FALSE)
mf_layout(title = "Province de Liège",
          credits = "Hugo Périlleux - IGEAT - ULB\nSources: Statbel, 2019",
          arrow=F,
          frame=T)# ajoute les crédits et une échelle, arrow =flèche Nord, frame = un rectangle autour de la carte
mf_inset_on(x= belgique ,
            pos = "topright") #début de l'inset avec la carte de la Belgique
mf_map(belgique)
mf_map(provinces %>% filter(AdPrKey=="60000"),
       col= "black",
       add=T)
mf_map(st_cast (regions,"MULTILINESTRING"),
       add=T)
mf_inset_off()# fin de l'inset
dev.off()


#pour trouver une position sur un graphique
locator()


## carte revenus -----------


secteurs <- st_read("sh_statbel_statistical_sectors.sqlite", quiet=T, crs=31370 )
communes_bxl <- st_read("communes_bxl.gpkg")

revenu_pop <- st_read("revenu_pop_2015.gpkg")
str(revenu_pop)

mf_export(x = secteurs,
          filename =("carte_revenus_2015.png" ),
          width = 800)
mf_init(communes_bxl,  expandBB = rep(0, 4))
mf_map(x = secteurs[secteurs$cd_rgn_refnis==4000 ,], # iltre pour garder que les secteurs bruxellois
       col = "white",
       border = "grey",
       add=T) # fond de carte
mf_map(x= st_cast (communes_bxl,"MULTILINESTRING"),
       add=T) # limite des communes
mf_map(x = revenu_pop,
       type = "prop_choro",
       var = c("popTOTAL","fisc_par_mois_Revenu_médian_par_déclaratio"),
       col = "grey",
       border = "black",
       inches = 0.11, # taille du plus grand cercle
       lwd= 0.3,
       nbreaks=5, # 5 classes, par quantile
       #breaks = c(0,10,30,50,70,90,100),
       pal = "Viridis",
       leg_title =  c("Population totale", "Médiane du revenu mensuel\nnet par déclaration (en 2015)"),
       leg_pos= c(c(139330.8,173093.9),c(139330.8,178093.9)),
       leg_val_rnd = c(-1,-2),
       add = TRUE) # cercle prop colorés selon une seconde variable
mf_layout(title = "Revenu médian par déclaration",
          credits = "Hugo Périlleux - IGEAT - ULB\nSources: Statbel, 2016",
          arrow=F,
          frame=T)
dev.off()


