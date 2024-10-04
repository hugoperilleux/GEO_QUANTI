# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ----------------  TP 8 - Régression  ------------------
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# package: jtools, ggstats, performance

# données utilisées:

# - immoweb_louer.csv
# - census_2011_logements.xls
# - cantons_judiciaires_bxl_2018.gpkg


# 1. Préparation  -----

# Pour manipuler les données on utilisera les packages suivants:

library(tidyverse)
library(readxl)
library(sf)
library(mapsf)
library(modelr)

# On va utiliser les nouveaux packages suivants:
library(jtools)
library(huxtable)
library(ggstats)
library(performance)

# Pour réaliser cet exemple, on utilisera les données issues d'un scraping de Immoweb des logements à louer pour Bruxelles. Les adresses ont été géocodées avec Phacochr.

loyers_data<-read_delim("data/immoweb_louer.csv", delim = ";")


# 2. Analyse de régression ----

## 2.1. Visualiser et supprimer les outliers ----

# On peut analyser la relation entre la variable loyer et la variable surface, on peut simplement réaliser un graphique avec un geom_point:

loyers_data %>%
ggplot( aes(surface, loyer)) +
  geom_point(alpha=0.5,cex=1)

# Pour analyser la relation entre les deux variables, il peut être utile de supprimer les valeurs abérantes (outliers). Ceci peut se faire de façon simple en retirant 1% de chaque côté de la distribution en appliquant un filtre et en conservant les loyer par surface supérieur au quantile 0.01 et inférieur au quantile 0.99:
loyers_data<- loyers_data %>%
  filter(
    loyer > quantile(loyer, prob = 0.01, na.rm = TRUE),
    loyer < quantile(loyer, prob = 0.99, na.rm = TRUE),
    surface > quantile(surface, prob = 0.01, na.rm = TRUE),
    surface < quantile(surface, prob = 0.99, na.rm = TRUE))

# Pour supprimer les outliers, il est possible également d'utiliser de filtre plus "réfléchi" en analysant les données ou en utilisant des méthodes plus complexes : https://delladata.fr/comment-detecter-les-outliers-avec-r/

# On peut alors revisualiser les données et on observe une relation beaucoup plus claire:

loyers_data %>%
    ggplot( aes(surface, loyer)) +
    geom_point(alpha=0.3,cex=0.5)


# On peut ajouter une droite de régression sur le graphique grâce à geom_smooth:

loyers_data %>%
  ggplot( aes(surface, loyer)) +
  geom_point(alpha=0.3,cex=0.5)+
  geom_smooth(formula = y ~ x, method = "lm")


## 2.2. Régression simple ----

# On peut réaliser une analyse de régression grâce à la fonction lm où Y = aX +b ce traduit par Y ~ X. Dans notre cas, on tente d'évaluer le loyer (Y) en fonction de la surface (X):

model1<-lm(loyer ~ surface, data=loyers_data)

# Pour afficher un résumé des résultats on utilise la fonction summary sur l'objet créer par la fonction lm:

summary(model1)

# Notez que l'objet model est un objet list qui contient une série de choses qu'il est possible d'aller chercher grâce au $ :
model1$coefficients # les coefficients
model1$residuals # les résidus
model1$fitted.values # les valeurs prédites


# De même il est possible d'aller rechercher des éléments du résultat de summary appliqué sur le modèle:
summary(model1)$r.squared # le R²

## 2.3. Régression multiple ----

# On peut décider de rajouter des variables dans le modèle en modifiant la formule Y = X1 + X2 + X3 + ...

model2<-lm(loyer ~ surface +  type + PEB + nb_chambres, data=loyers_data)
summary(model2)



## 2.4. Régression polynomiale ----

### 2.4.1. Logarithme ----

# Plutôt que de modéliser loyer en fonction de la surface, on pourrait avoir envie de modéliser le loyer selon le logarithme de la surface.

#Alors on soit créer une nouvelle variable et réaliser la régression:

loyers_data$log_surface <- log(loyers_data$surface)

model3<- lm(loyer ~ log_surface +  type + PEB + nb_chambres, data=loyers_data)
summary(model3)


# soit indiquer le logarithme directement dans la formule du lm

model3<- lm(loyer ~ log(surface) +  type + PEB + nb_chambres, data=loyers_data)
summary(model3)

loyers_data %>%
  ggplot( aes(surface, loyer)) +
  geom_point(alpha=0.3,cex=0.5)+
  geom_smooth(formula = y ~ log(x), method = "lm")

### 2.4.2. Division ----


# On peut vouloir modéliser le loyer par surface en fonction de la surface:

loyers_data <- loyers_data %>%
  mutate(loyer_surface= loyer/surface,
         inv_surface= 1/surface)

model4<- lm(loyer_surface ~ inv_surface +  type + PEB + nb_chambres, data=loyers_data)
summary(model4)

loyers_data %>%
  ggplot( aes(surface, loyer_surface)) +
  geom_point(alpha=0.3,cex=0.5)+
  geom_smooth(formula = y ~ I(1/x), method = "lm")

### 2.4.3. Exposants ----


# On pourrait directement placer ces changements dans la formule mais alors il faut utiliser la fonction I() qui permet de réaliser ces opérations. La fonction I ( "come si" / "as is") permet d'indiquer qu'il s'agit d'une formule et non pas une opération sur un vecteur et le ~ "est dépendant de ".

model5<- lm(loyer~ surface + I(surface^2) +  type + PEB + nb_chambres, data=loyers_data)
summary(model5)

loyers_data %>%
  ggplot( aes(surface, loyer)) +
  geom_point(alpha=0.3,cex=0.5)+
  geom_smooth(formula = y ~ I(x+x^2), method = "lm")

# De nouveau il faut bien utiliser I dans la formule.



## 2.5. Visualisation ----

# Il existe beaucoup de package pour faciliter la visualisation des résultats. # Par exemple pour visualiser rapidement le résultat de plusieurs modèle jtools permet de réaliser un tableau synthétique utile:

library(jtools)
export_summs(model1, model2, model3, model4, model5)

# On peut également exporter ce résultat en format pdf de la façon suivante:

export_summs(model1, model2,model3, model4,to.file = "html", file.name = "TP08/tableau_regression.html")

# On peut visualiser un forest plot de cette façon grâce au package ggstats:

library(ggstats)
ggcoef_model(model2)
ggcoef_table(model2)

# voir ici pour plus de détails: https://cran.r-project.org/web/packages/ggstats/vignettes/ggcoef_model.html


## 2.6. Réaliser les tests des hypothèses ----

# La réalisation de modèle de régression s'appuie sur une série d'hypothèses qu'il s'agit de vérifier dont:
# - la linéarité des résidus,
# - la constance de la variance des résidus,
# - la faible influence d'outliers,
# - la non colinéarité entre les variables explicatives,
# - la normalité des résidus.

# https://easystats.github.io/performance/index.html


library(performance)

png("TP08/check_model.png", height= 1000, width=1000)
check_model(model2)
dev.off()


# 3. Analyse géographique ----

## 3.1. Analyse géographique simple ----

# On peut réaliser une carte du loyer moyen par secteur statistique. On calculer par secteur statistique le nombre d'annonces et le loyer moyen:

loyer_moyen<-loyers_data%>%
  group_by(cd_sector) %>%
  summarise(
    n=n(),
    loy_moyen= mean(loyer, na.rm=T)
  )

# On charge les secteurs statistiques

secteurs_stats<- st_read ("data/sh_statbel_statistical_sectors_31370_20230101.gpkg")

# On fait une jointure entre le résultat du calcul précédent et les secteurs statistiques

loyer_moyen_sec<-secteurs_stats %>%
  left_join(loyer_moyen, by=c("cd_sector")) %>%
  filter(tx_rgn_descr_fr=="Région de Bruxelles-Capitale")

# On réalise la carte

mf_map(x = loyer_moyen_sec,col = "white", border = "grey")
mf_map(loyer_moyen_sec,
       var= c("n", "loy_moyen"),
       type="prop_choro",
       pal= "Viridis",
       inches=0.14,
       nbreaks=5,
       add=T)


## 3.2. Cartographier les résidus ----

# Les résidus de la régression se trouve dans l'objet model produit par la fonction lm. Néanmoins il s'agit d'un objet list où le valeur manquantes ont été supprimée. Le package modelr permet de faire facilement la jointure entre les données de base et les résidus et calculer une moyenne des résidus par secteurs statistiques:

library(modelr)

resid<-loyers_data %>%
  add_residuals( model2) %>%
  group_by(cd_sector) %>%
  summarise(moyenne_residus= mean(resid, na.rm=T),
            n=n())


# On joint les résidus au fichier des secteurs statistiques

resid_sec<-secteurs_stats%>%
  left_join(resid, by=c("cd_sector")) %>%
  filter(tx_rgn_descr_fr=="Région de Bruxelles-Capitale")


# On fait une carte des résidus moyen par secteurs stats

mf_map(x = resid_sec,col = "white", border = "grey")
mf_map(resid_sec,
       var= c("n", "moyenne_residus"),
       type="prop_choro",
       pal= "Viridis",
       inches=0.15,
       nbreaks=5,
       add=T)

# On peut alors observer là où le loyer est en moyenne pus élevé ou moins élevé que prédit par le modèle.


## 3.3. Ajouter une variable géographique ----

# On peut ajouter une variable géographique comme l'indice de difficulté par secteur statistique de 2010 pour Bruxelles qui une bonne approximation de la division sociale de l'espace bruxellois:

indice <- read_delim("data/indice_synthetique.csv", delim= ";")


indice_sec<-secteurs_stats%>%
  left_join(indice, by=c("cd_sector"="Secteur statistique")) %>%
  filter(tx_rgn_descr_fr=="Région de Bruxelles-Capitale")

mf_map(indice_sec,
       var="Indice synthétique de difficulté 2010",
       type="choro",
       pal= "Viridis",
       nbreaks=5)


# On peut alors ajouter cet indice dans un troisième modèle. Pour réaliser ceci on doit d'abord joindre les données

loyers_data<-loyers_data %>%
  left_join(indice, by=c("cd_sector"="Secteur statistique"))

model6<-lm(loyer ~ surface + PEB+type+nb_chambres +`Indice synthétique de difficulté 2010`, data=loyers_data)

export_summs(model1, model2, model6)

# Notez que ici le modèle semble se détériorer puisque le R2 diminue. Ceci peut s'expliquer par le fait que le modèle est réaliser sur un nombre plus petit de variables.


## 3.4. Analyse de corrélation spatiale ----

# On peut également réaliser des régressions sur des entités spatiales. Ici on prend les données expulisions et on va analyser la correlation avec la division sociale de l'espace et les cantons pour mesurer un possible "effet juge".

# On importe les données:

expulsions <- read_delim("data/expulsions_2018_secteursstat.csv", delim= ";")
indice <- read_delim("data/indice_synthetique.csv", delim= ";")
logements <- read_excel("data/census_2011_logements.xls")
secteurs_stats<- st_read ("data/sh_statbel_statistical_sectors_31370_20230101.gpkg")
cantons<- st_read ("data/cantons_judiciaires_bxl_2018.gpkg") %>%
  st_zm()


# On réalise la jointure spatiale entre les canton et les centroïdes des secteurs statistiques:
canton_secteurs<-cantons %>%
  st_join(st_point_on_surface(secteurs_stats), join= st_intersects) %>%
  as.data.frame() %>%
  select(CANTON, cd_sector)

### 3.4.1. Analyse visuelle ----

# On peut réaliser une cartographie des trois jeux de données

# 1. Les expulsions

secteurs_stats_epulsions<-secteurs_stats %>%
  left_join(expulsions,  by=c("cd_sector"="ID_SS_bis")) %>%
  left_join(logements, by= c("cd_sector"="Secteur statistique")) %>%
  filter(tx_rgn_descr_fr=="Région de Bruxelles-Capitale") %>%
  mutate(tx_expulsion=100*exp_total /`Logements loués`)

mf_map(x = secteurs_stats_epulsions,col = "white", border = "grey")
mf_map(secteurs_stats_epulsions,
       var=c("exp_total", "tx_expulsion"),
       type="prop_choro",
       pal= "Viridis",
       inches=0.11,
       nbreaks=5,
       add=T)

# 2. Les cantons:

secteurs_stats_cantons<-secteurs_stats %>%
  left_join(canton_secteurs, by="cd_sector") %>%
  filter(tx_rgn_descr_fr=="Région de Bruxelles-Capitale")

mf_map(secteurs_stats_cantons,
       var= "CANTON",
       type="typo")

# 3. L'indice synthétique de difficulté:

secteurs_stats_indice<-secteurs_stats %>%
  left_join(indice, by= c("cd_sector"="Secteur statistique")) %>%
  filter(tx_rgn_descr_fr=="Région de Bruxelles-Capitale")

mf_map(secteurs_stats_indice,
       var= "Indice synthétique de difficulté 2010",
       type="choro",
       pal= "Viridis")


### 3.4.2. Régression ----


# On réalise les jointures, on calcul un taux d'expulsions et on ne garde que les secteurs statistiques bruxellois qui ont plus de 200 logements loués

secteurs_stats_expulsions<-secteurs_stats %>%
  left_join(expulsions, by=c("cd_sector"="ID_SS_bis")) %>%
  left_join(logements, by= c("cd_sector"="Secteur statistique")) %>%
  left_join(indice, by= c("cd_sector"="Secteur statistique")) %>%
  left_join(canton_secteurs,by= c("cd_sector")) %>%
  mutate(tx_expulsion=100*exp_total /`Logements loués`) %>%
  filter(tx_rgn_descr_fr=="Région de Bruxelles-Capitale") %>%
  filter (`Logements loués`>200)



# On peut analyser le lien entre indice synthétique et le taux d'expulsion:

secteurs_stats_expulsions%>%
  ggplot( aes(`Indice synthétique de difficulté 2010`, tx_expulsion)) +
  geom_point(alpha=0.3,cex=0.5)+
  geom_smooth(formula = y ~ x, method = "lm")

# Et réaliser une régression

model1<-lm(tx_expulsion~ `Indice synthétique de difficulté 2010`,data= secteurs_stats_expulsions )
summary(model1)


# On peut à nouveau cartographier les résidus

secteurs_stats_expulsions1<-secteurs_stats_expulsions %>%
  add_residuals( model1)

mf_map(x = filter(secteurs_stats, tx_rgn_descr_fr=="Région de Bruxelles-Capitale"),
       col = "white", border = "grey")
mf_map(secteurs_stats_expulsions1,
       var=c("exp_total", "resid"),
       type="prop_choro",
       pal= "Viridis",
       inches=0.11,
       nbreaks=5,
       add=T)


# On peut pondéré la régression par le nombre de logements loués. Dans le cas où on a des entités de tailles très différentes cela peut avoir du sens

model2<-lm(tx_expulsion~ `Indice synthétique de difficulté 2010`, weights = `Logements loués`,data= secteurs_stats_expulsions )
summary(model2)

secteurs_stats_expulsions%>%
  ggplot( aes(x=`Indice synthétique de difficulté 2010`,y= tx_expulsion)) +
  geom_point(alpha=0.3, aes( size= `Logements loués` ) )+
  geom_smooth(formula = y ~ x, method = "lm", mapping = aes(weight = `Logements loués`))


# On peut ajouter la variable canton pour mesurer "l'effet juge"

model3<-lm(tx_expulsion~ `Indice synthétique de difficulté 2010`+ CANTON,data= secteurs_stats_expulsions )

library(ggstats)
ggcoef_table(model3)















