# ---------------------------------------------
#              TP 4 -  Exercices
# ---------------------------------------------

## Exercices  -----

# NOM
# PRENOM

# **Exercice 1. ** -----

# Construire le vecteur suivant, et le convertir en vecteur numérique
x <- c("12", "3.5", "421", "2,4")



# **Exercice 2. ** -----

# Construire un vecteur f à l’aide du code suivant:
f <- c("Jan", "Jan", "Fev", "Juil")
# et recoder le vecteur à l’aide de la fonction fct_recode pour obtenir le résultat suivant :

#> [1] Janvier Janvier Février Juillet
#> Levels: Février Janvier Juillet




# **Exercice 3 ** ----

# Les exercices suivant seront réalisé à partir des données hdv2003:
data(hdv2003)

# À l’aide de l’interface graphique de questionr, recoder la variable nivetud pour obtenir le tri à plat suivant (il se peut que l’ordre des modalités dans le tri à plat soit différent) :

#>                                           n    % val%
#> N'a jamais fait d'etudes                 39  2.0  2.1
#> Études primaires                        427 21.3 22.6
#> 1er cycle                               204 10.2 10.8
#> 2eme cycle                              183  9.2  9.7
#> Enseignement technique ou professionnel 594 29.7 31.5
#> Enseignement superieur                  441 22.0 23.4
#> NA                                      112  5.6   NA




# **Exercice 4. ** -----

# À l’aide de la fonction ifelse, créer une nouvelle variable cinema_bd permettant d’identifier les personnes qui vont au cinéma et déclarent lire des bandes dessinées.

# Vous devriez obtenir le tableau de fréquence (freq() ) suivant pour cette nouvelle variable :

#>                 n    % val%
#> Autre        1971 98.6 98.6
#> Cinéma et BD   29  1.5  1.5



# **Exercice 5. ** -----

# À l’aide de la fonction case_when, créer une nouvelle variable ayant les modalités suivantes :
#
# Homme ayant plus de 2 frères et soeurs
# Femme ayant plus de 2 frères et soeurs
# Autre
#
# Vous devriez obtenir le tri à plat suivant :

#>                                           n    % val%
#> Autre                                  1001 50.0 50.0
#> Femme ayant plus de 2 frères et soeurs  546 27.3 27.3
#> Homme ayant plus de 2 frères et soeurs  453 22.7 22.7



# **Exercice 6. ** -----

# Dans le jeu de données hdv2003, découper la variable heures.tv en classes de manière à obtenir au final le tableau de fréquence suivant :

  #>          n    % val%
  #> [0,1]  684 34.2 34.3
  #> (1,2]  535 26.8 26.8
  #> (2,4]  594 29.7 29.8
  #> (4,6]  138  6.9  6.9
  #> (6,12]  44  2.2  2.2
  #> NA       5  0.2   NA



