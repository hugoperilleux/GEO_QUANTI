# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# --------------------- TP 11 - ChatGPT -------------------
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Ressources:

#https://botpress.com/fr/blog/quel-est-le-niveau-de-competence-de-chatgpt-en-matiere-d-ecriture-de-code

# https://www.youtube.com/watch?v=c0QbWr_Xm7c

# Il est de plus en plus tentant d'utiliser l'intelligence artificielle pour coder. L'objectif ici est de revenir sur quelques conseils pour "bien" utiliser ChatGPT pour coder en R.

# 1. Bien poser ses questions ----
# Pour espérer une réponse qui corresponde à ce que vous souhaitez, il faut arriver à bien poser votre question. Il s'agit souvent d'un exercice pas facile où on se met entrer dans un long dialogue. Voici donc quelques astuces:
#  - Vous pouvez aller à la ligne avec MAJ+ENTER ou écrire votre question dans un traitement de texte et ainsi ne pas hésiter à être un peu long et explicite.
#  - Présentez  votre set de données par exemple str() ou en affichant les objets sur lesquels vous travaillez
#  - Si vous faites face à un problème de "syntaxe", c'est-à-dire que vous vous demandez comment définir les arguments d'une fonction, et que vous pensez que ça fonctionnerait avec une fonction, vous pouvez orienter les réponses en suggérant l'utilisation de tel ou tel package/fonction.


# 2. Eviter les chemins alambiqués ----
#  ChatGPT peut facilement vous emmener vers des chemins que vous ne comprendrez pas. Vous avez alors le choix d'accpter un bout de code que vous ne comprenez pas. A la longue, celà peut être problèmatique car d'une part il peut se tromper et d'autre part si vous souhaitez ajuster et répeter l'opération vous serez coincés.
# Il faut savoir que si on pose la même question plusieurs fois, on n'obtient pas le même résultat. Il peut donc être vraiment intéressant d'orienter sa réponse vers quelque chose qu'on connait.



# 3. Adopter une posture compréhensive ----
# ChatGPT est bon pour expliquer le fonctionnement des fonctions
# Néanmoins, parfois rien ne vaut d'aller dans les manuels rédigés par les développeurs voir les différentes options (présentées de façon exhaustives et synthétiques), les avertissements et les exemples.

# Exercice à faire ensemble:
# écrire des regex pour extraire les noms de rue sans les "rue", "chaussée", "boulevard", etc.

library(phacochr)

data<-snacks

# Proposition de question à poser à ChatGPT

# je souhaite avoir un nouveau champ rue sans les "boulevards" "rue", "chaussée" etc avec des regex dans R
#
# # A tibble: 484 × 4
# nom                       rue             num   code_postal
# <chr>                     <chr>           <chr> <chr>
#   1 Snack Baraka              Boulevard Maur… 32    1000
# 2 Snack Les frères          Rue Marie-Chri… 121   1020
# 3 Snack Adil                Rue Marie-Chri… 132   1020
# 4 Efes Fritures             Rue Marie-Chri… 66    1020
# 5 Snack 2001                Rue Marie-Chri… 28    1020
# 6 snack friterie Chérif     Rue Stéphanie   165   1020
# 7 Chez les grecs            Rue Marie-Chri… 44    1020
# 8 Snack fransman            Rue Fransman    39    1020
# 9 Kaya                      Chaussée de He… 381   1030
# 10 Snack des Frères (Kardes) Rue Nestor De … 68    1030





