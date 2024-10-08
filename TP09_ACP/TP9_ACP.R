
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ---------- TP 9 - Analyse en Composantes Principales -----------
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# Sources:
# http://www.sthda.com/english/wiki/wiki.php?id_contents=7851
# http://factominer.free.fr/index_fr.html


# Données:

# - données des élections présidentielles 2022 par communes : pres2022comm.csv
# source: https://unehistoireduconflitpolitique.fr/telecharger.html
# Ce fichier contient les résultats des élections présidentielles de 2022 en format csv. Ces fichiers ont été générés à partir des résultats électoraux disponibles sur le site du Ministère de l’Intérieur et sur data.gouv.fr. J. Cagé et T. Piketty (2023) : Une histoire du conflit politique. Élections et inégalités sociales en France, 1789-2022. Le Seuil.

# - communes: communes-20220101.shp (1)
# - arrondissement municipaux: arrondissements_municipaux-20180711.shp (2)
# - table commune - région : commune2021.csv  (3)
# - revenus par commune : FILO2021_DEC_COM.xlsx  (4)
# - population par commune: population_insee_2021.xlsx  (5)

# (1) INSEE:  https://www.data.gouv.fr/fr/datasets/decoupage-administratif-communal-francais-issu-d-openstreetmap/
# (2) INSEE:  https://www.data.gouv.fr/fr/datasets/decoupage-administratif-communal-francais-issu-d-openstreetmap/
# (3) INSEE:  https://www.insee.fr/fr/information/2560452
# (4) INSEE: https://www.insee.fr/fr/statistiques/7756855?sommaire=7756859
# (5) INSEE : https://www.insee.fr/fr/statistiques/7739582?sommaire=7728826



# Pour ce TP nous utiliserons les packages suivants:

# De façon maintenant habituelle:
library(tidyverse)
library(sf)
library(mapsf)
library(readxl)



library(remotes)
install_version("estimability", "1.4.1")

install.packages("FactoMineR")
install.packages("factoextra")


# Et deux packages développés pour réaliser des ACP et visualiser les résultats:
library(FactoMineR)
library(factoextra)

# Les objectifs pour réaliser une ACP sont généralement :
# 1. Débroussailler un large set de données avec plein de variables
# 2. Réaliser un indicateur synthétique
# 3. Préparer à une classification

# Dans le cas ici, on va plutôt réaliser une ACP suivant le premier objectif sur les votes exprimés aux élections en Île de France aux élections présidentielles de 2022. L'objectif sera de voir on retrouve des structures dans la géographie de cette élection.

# 1. Importation des données ----

## 1.1. Élections 2022 ----

data<-read_delim("data/France/pres2022_csv/pres2022_csv/pres2022comm.csv", delim=",") %>%
  select(1:19) %>%
  filter(codecommune!="75056") # %>% # On enlève la communes de Paris


# On prend une table pour sélectionner que l'Ile de France:
communes_table<-read_delim("data/France/commune2021.csv")

data<-data %>%
  left_join(communes_table, by=c("codecommune"="COM"))%>%
  filter(REG==11) %>%
  select(-c(20:30))


## 1.2. Communes ----
communes<- st_read("data/France/communes-20220101-shp/communes-20220101.shp") %>%
  filter(insee!="75056") %>%
  select(-surf_ha)

arrond_lyon_mars_paris<- st_read("data/France/arrondissements_municipaux-20180711-shp/arrondissements_municipaux-20180711.shp")%>%
  select(-surf_km2) # On importe les arrondissements de Paris, Lyon et Marseille

communes<-bind_rows(communes,arrond_lyon_mars_paris) # On joint communes et arrondissements
rm(arrond_lyon_mars_paris)


# On ne garde que les communes de l'Ile de France
communes<-communes %>%
  left_join(communes_table, by=c("insee"="COM"))%>%
  filter(REG==11) %>%
  select(-c(5:15))

# On calcul la densité par communes

communes<-communes %>%
  mutate(surface=as.numeric(st_area(geometry))/10000) # On calcul le superficie de chaque communes


# On créé un objet département pour la cartographie
departements_Paris<-communes %>%
  left_join(communes_table, by=c("insee"="COM")) %>%
  filter(REG==11) %>%
  group_by(DEP,REG) %>%
  summarise(geometry=st_union(geometry))

rm(communes_table)
# 2. Recodage ----

# Pour réaliser l'ACP il faut d'abord recoder les variables. On utilise généralement des variables en proportion.

data<-data %>%
  mutate(ARTHAUD=voixARTHAUD/exprimes,
         POUTOU=voixPOUTOU/exprimes,
         ROUSSEL=voixROUSSEL/exprimes,
         MELENCHON=voixMELENCHON/exprimes,
         JADOT=voixJADOT/exprimes,
         HIDALGO=voixHIDALGO/exprimes,
         LASSALLE=voixLASSALLE/exprimes,
         MACRON=voixMACRON/exprimes,
         PECRESSE=voixPECRESSE/exprimes,
         ZEMMOUR=voixZEMMOUR/exprimes,
         DUPONTAIGNAN=voixDUPONTAIGNAN/exprimes,
         MLEPEN=voixMLEPEN/exprimes)


# De façon raccourcie, il est possible de réaliser de la façon suivante:

# - en utilisant des pivot (tidyr) et un group by
# data<-data %>%
#   pivot_longer(cols= 8:19,names_to ="candidat", values_to = "voix" ) %>%
#   mutate(voix=voix/exprimes) %>%
#   pivot_wider(values_from = "voix", names_from = "candidat")

# - de façon encore plus synthétique, en utilisant un across:
# data<-data %>%
#  mutate(across(8:19, ~ . /exprimes))


# 3. Première visualisation des données ----

communes_voix<-communes %>%
  left_join(data, by=c("insee"="codecommune"))

## 3.1. Une carte par variable ----
# On peut réaliser une carte pour chaque candidat:



for (i in 12:23) {
  mf_export(x = communes_voix ,
            filename =paste0("TP09/cartes_candidats/carte_",names(communes_voix)[i],".png" ),
            width = 900)
  mf_map(x = communes_voix, col = NA, border = "gray25", lwd = 0.1)
  mf_map(x = departements_Paris, col = NA, border = "gray25", lwd = 1, add=T)
  mf_map(communes_voix ,
         var= c(names(communes_voix)[i], names(communes_voix)[i+12]),
         #val_max=max(unlist(communes_voix[,11:22])),
         type="prop_choro",
         pal="Viridis",
         inches=0.1,
         add=T)
  dev.off()
}



rm(i)

## 3.2. Matrice de corrélation ----
# On peut réaliser une matrice de corrélation:

cor.mat <- round(cor(data[,20:31], use="complete.obs"),2) # round(,2) permet d'arrondir à deux décimale et use="complete.obs" permet d'exclure les NA
cor.mat

# Le package corrplot permet de visualiser cette matrice de correlation de façon plus intuitive

library("corrplot")
corrplot(cor.mat, tl.col="black")


# On peut exporter le résultat avec la fonction png de la façon suivante:

png(file="TP09/matrice_correlation.png", width = 1000, height = 1000)
corrplot(cor.mat, tl.col="black")
dev.off()


# On voit entre autres des corrélations :
# - positives entre :
#   - le vote pour Hidalgo, Jadot et Macron,
#   - le vote Pécresse, Zemmour et Macron
# -négative
#   - le vote Marine Le Pen et le vote Jadot-Macron
#   - le vote Mélanchon et le vote Pecresse-Zemmour
# Très peu de corrélation entre les vote Zemmour et Marine Lepene

rm(cor.mat)

# 4. Réaliser l'ACP ----

## 4.1. Une ACP non pondérée ----

pca<-PCA(data[,20:31], graph=T, ncp = NULL)

# L'objet pca est une liste dans lequel se trouve tous les résultats de l'ACP. On peut y accéder directement ou utiliser des fonctions préfaites pour visualiser les résultats.

# name               description
# 1  "$eig"             "eigenvalues"
# 2  "$var"             "results for the variables"
# 3  "$var$coord"       "coord. for the variables"
# 4  "$var$cor"         "correlations variables - dimensions"
# 5  "$var$cos2"        "cos2 for the variables"
# 6  "$var$contrib"     "contributions of the variables"
# 7  "$ind"             "results for the individuals"
# 8  "$ind$coord"       "coord. for the individuals"
# 9  "$ind$cos2"        "cos2 for the individuals"
# 10 "$ind$contrib"     "contributions of the individuals"
# 11 "$call"            "summary statistics"
# 12 "$call$centre"     "mean of the variables"
# 13 "$call$ecart.type" "standard error of the variables"
# 14 "$call$row.w"      "weights for the individuals"
# 15 "$call$col.w"      "weights for the variables"


## 4.2. Pondérer le calcul de l'ACP ----

# Dans le cas précédent chacuns des individus à le même poid et chaque variable également. On peut décider de modifier les poids.

# Pourtant, il existe de grandes différences entre communes:

mf_export(x = communes_voix ,
          filename =paste0("TP09/cartes_votes_exprimes.png" ),
          width = 900)
mf_map(x = communes_voix, col = NA, border = "gray25", lwd = 0.1)
mf_map(x = departements_Paris, col = NA, border = "gray25", lwd = 1, add=T)
mf_map(communes_voix ,
       var= "exprimes",
       type="prop",
       inches=0.1,
       add=T)
dev.off()
rm(communes_voix)

# Si on souhaite pondérer les entités on peut utiliser row.w =
pca<-PCA(data[,20:31], row.w =data$exprimes,ncp = NULL)

# Pour pondérer les variables on peut utiliser col.w
# Attention: pour pondérer, il faut que tous les poids soient >0. Dans le cas présent ça ne pose pas de problème.


# 5. Visualiser les résultats ----

## 5.1. Cercles de corrélation ----

# Ce résultat sont stocker dans l'objet pca
pca$var$coord


# Les cercle de corrélation permettent de visualiser entre les variables et les dimensions produites par l'ACP.

cercle_1_2<-fviz_pca_var(pca,  axes = c(1, 2))+
  theme_minimal()
cercle_1_2

ggsave(cercle_1_2,filename="TP09/cercle_correlation_1_2.png", width=7, height=7, bg="white")
rm(cercle_1_2)

# On peut décider de visualiser d'autres axes en modifiant le paramètre axes

cercle_1_3<-fviz_pca_var(pca,  axes = c(1, 3))+
  theme_minimal()
cercle_1_3

ggsave(cercle_1_3,filename="TP09/cercle_correlation_1_3.png", width=7, height=7, bg="white")
rm(cercle_1_3)


# Pour faciliter la lecture, on peut inverser un axe en multipliant par -1 (dans notre cas, il est plus intuitif d'avoir la gauche politique à gauche et la droite à droite):
pca$var$coord[,1]<- -1*pca$var$coord[,1]

cercle_1_2<-fviz_pca_var(pca,  axes = c(1, 2) )+
  theme_minimal()
cercle_1_2
ggsave(cercle_1_2,filename="TP09/cercle_correlation_1_2.png", width=7, height=7, bg="white")

# Il faut alors aussi le faire sur les coordonnées des individus

pca$ind$coord[,1]<- -1* pca$ind$coord[,1]

# On peut décider de ne pas afficher toutes les variables (si il y en a trop ça devient illisible). Ici, on décide d'afficher surtout (en modifiant la tranparance) celles qui ont le plus contribué à la construction de les deux axes (alpha.var="contrib") ou celle qui sont le plus prise en compte par les deux axes (alpha.var="cos2"), soit encore de sélectionner celles qui ont un cos2 supérieur à un seuil (select.var = list(cos2 = 0.75) ) ou les 3 qui contribuent le plus (select.var = list(contrib = 3)))

fviz_pca_var(pca,  axes = c(1, 2), alpha.var="contrib")+theme_minimal()
fviz_pca_var(pca,  axes = c(1, 2), alpha.var="cos2")+ theme_minimal()
fviz_pca_var(pca,  axes = c(1, 2), select.var = list(cos2 = 0.75))+ theme_minimal()
fviz_pca_var(pca,  axes = c(1, 2), select.var = list(contrib = 3))+ theme_minimal()

# Il est peut aussi être pertinent d'utiliser l'argument repel=T pour utiliser le package repel pour les étiquettes et éviter qu'elle ne se chevauches

fviz_pca_var(pca,  axes = c(1, 2), repel=T )+  theme_minimal()


## 5.2. Contributions de chaque variables ----

# La contribution de chaque variable à la construction de chacune de dimension
pca$var$contrib

# On peut également afficher de façon graphique avec fviz_contrib
fviz_contrib(pca, choice = "var", axes = 1, top = 10)
fviz_contrib(pca, choice = "var", axes = 2, top = 10)


## 5.3. Valeurs propres et % de la variance expliquée ----

# Pour afficher les valeurs propres (eigen value) et le pourcentage de variance expliquée, on peut simplement afficher le tableau compris dans l'objet pca
pca$eig

# On peut faire un graphique de la variance expliquées
fviz_screeplot(pca, ncp=10)

# Ces informations sont utiles pour nous aider à décider combien de composante retenir. Généralement, on s'arrange avec ces règles non-strictes:
# - eigenvalue > 1
# - variance cumulée > 70%
# - gain faible d'une composante supplémentaire (ajouter une dimension supplémentaire ne permet pas de gagner beaucoup en variance expliquée)

## 5.4. Carte de scores ----

# Chaque individus est reprojeter sur les nouvelles dimensions. Leurs scores sont stocké dans l'objet pca:

pca$ind$coord

# On peut souhaiter les visualiser dans un graphique à deux dimensiosn:

fviz_pca_ind(pca)

# Forcément cela à du sens que si on a peu d'individus. Si les individus sont des entités géographiques, on peut souhaiter en faire des cartes.


# On peut récupérer les score de chaque individus en collant avec bind_rows les coordonnées avec le set de données initiale:
data_pca<-bind_cols(data,
                    pca$ind$coord)

# On réalise une boucle pour visualiser les 3 premières dimensions en faisant d'abord la jointure entre nos résultats et l'objet commune


communes_pca<-communes %>%
  inner_join(data_pca, by=c("insee"="codecommune"))


for (i in 1:3){
  mf_export(x = communes_pca ,
            filename =paste0("TP09/carte_acp_dim",i,".png" ),
            width = 900)
  mf_map(communes_pca ,
         var= paste0("Dim.",i),
         type="choro",
         pal= "Viridis",
         lwd=0.001)
  mf_map(x = departements_Paris, col = NA, border = "gray25", lwd = 1, add=T)
  dev.off()
}
rm(i,communes_pca)


# 6. Ajouter des variables supplémentaires ----

# Pour aider à l'interprétation des axes, il peut être utile d'importer des nouvelles variables qui ne seront pas utilisées dans l'ACP mais qu'on pourra néanmoins utiliser comme repère.

## 6.1. Importation des données ----
### 6.1.1. Population ----

# On importe les données de population


pop<-read_excel("data/France/population_insee_2021.xlsx", sheet="Communes") %>%
  mutate(codecommune=paste0(`Code département`, `Code commune`)) %>%
  filter(`Code région`=="11") # on garde que la France métropolitaine

# On joint avec le fichier spatial des communes et calcul la densité de population
communes_pop<- communes %>%
  left_join(pop, by=c("insee"="codecommune")) %>%
  mutate(densite_ha=`Population totale`/surface) %>%
  select(insee, densite_ha)

# On peut réaliser une carte de la densité de population

mf_export(x = communes_pop ,
          filename =paste0("TP09/carte_densite.png" ),
          width = 900)
mf_map(communes_pop ,
       var= "densite_ha",
       type="choro",
       pal= "Viridis",
       lwd=0.001)
mf_map(x = departements_Paris, col = NA, border = "red", lwd = 1, add=T)
dev.off()

# On enlève transforme l'objet en dataframe et on enlève la colonne geometry
communes_pop_df<-communes_pop %>%
  as.data.frame() %>%
  select(-geometry)

# On réalise la jointure avec les données de base
data<-data %>%
  left_join(communes_pop_df, by=c("codecommune"="insee"))

rm(pop,communes_pop, communes_pop_df)

### 6.1.2. Revenus ----

# On importe les données de revenus, on conserve les champ qui nous intéresse et on transforme le champ revenu médian en numeric

revenus<-read_excel("data/France/FILO2021_DEC_COM.xlsx", sheet=2) %>%
  mutate(revenus=as.numeric(revenu_median)) %>%
  select(CODGEO, revenus)

# On joint avec le fichier spatial des communes et les revenus

communes_revenus<- communes %>%
  left_join(revenus, by=c("insee"="CODGEO"))


# On peut réaliser une carte de revenu

mf_export(x = communes_revenus ,
          filename =paste0("TP09/carte_revenus.png" ),
          width = 900)
mf_map(communes_revenus ,
       var= "revenus",
       type="choro",
       pal= "Viridis",
       lwd=0.001)
mf_map(x = departements_Paris, col = NA, border = "red", lwd = 1, add=T)
dev.off()

rm(communes_revenus)

# On réalise la jointure avec les données de base

data<-data %>%
  left_join(revenus, by=c("codecommune"="CODGEO"))
rm(revenus)

## 6.2. ACP avec les variables supplémentaires ----

pca<-PCA(data[,20:33], quanti.sup = 13:14, row.w =data$exprimes, graph=F, ncp = NULL)

cercle_1_2<-fviz_pca_var(pca,  axes = c(1, 2))+
  theme_minimal()
ggsave(cercle_1_2,filename="TP09/cercle_correlation_1_2_revenu_pop.png", width=7, height=7, bg="white")
rm(cercle_1_2)


cercle_1_3<-fviz_pca_var(pca,  axes = c(1, 3))+
  theme_minimal()
ggsave(cercle_1_3,filename="TP09/cercle_correlation_1_3_revenu_pop.png", width=7, height=7, bg="white")
rm(cercle_1_3)


# On observe des fortes corrélations entre la première dimension qui dépeind une opposition gauche-droite et la variable de revenus, les revenus élevés étant associés aux communes où le vote de droite est important.
# La seconde dimension est quant à elle fortement corrélée à la densité de population et permet d'interprétée cette dernière comme l'opposition centre urbain-périphérie


# 7. Aller plus loin ----

# Il est possible de faire des ACP sur des données d'enquêtes soit en utilisant les poids comme présenté précédement soit grâce au package :svyprcomp
#https://r-survey.r-forge.r-project.org/survey/html/svyprcomp.html

# On peut vouloir réaliser des légères rotations des axes pour améliorer la lecture des axes:
# https://stats.stackexchange.com/questions/59213/how-to-compute-varimax-rotated-principal-components-in-r
# https://dimension.usherbrooke.ca/pages/87
# https://sites.google.com/site/rgraphiques/4--stat/machine-learning-biostatistiques-analyse-de-donn%C3%A9es/analyse-en-composantes-principales/la-rotation-varimax
































