


# ---------------------------------------------
#              TP 8 -  Exercices
# ---------------------------------------------

# Données:
# - immoweb_a_vendre.csv
# - indice_synthetique.csv

## Exercices  -----

# NOM
# PRENOM

# **Exercice 1. ** -----
#Pour cet exercice vous allez travailler sur les données de ventes sur Immoweb (immoweb_a_vendre.csv). Les prix de vente sont exprimé en milliers d'euro. Les adresses ont été géocodées avec Phacochr.

## **Exercice 1.1. ** -----
# Retirer les outliers en supprimant les 1% supérieurs et inférieurs pour les variables prix et surface et réaliser une graphique qui montre la relation entre le prix et la surface

# Pour geom_point: alpha=0.3,cex=0.5
# Pour ggsave: width=5, height=5



## **Exercice 1.2. ** -----
# Réaliser plusieurs modèles de régression pour expliquer le prix d'achat:
# modèle 1:  Prix = b1 + b2 surface
# modèle 2:  Prix = b1 + b2 surface + + b3 nombre de chambre
# modèle 3:  Prix = b1 + b2 surface + b3 nombre de chambre + b4 type
# modèle 4:  Prix = type * surface
# modèle 5:  Prix = b1 surface + b2 * surface^2



## **Exercice 1.3. ** -----
# Réaliser une carte de la moyenne des résidus du modèle 1 par secteur statistique (width=900)


## **Exercice 1.4. ** -----
# Introduisez l'indice synthétique de difficulté dans le modèle et réaliser une nouvelle carte des résidus.
# modèle 6:  Prix = b1 + b2 surface + b3 indice synthétique de difficulté








