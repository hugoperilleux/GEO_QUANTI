# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# --------   TP 1 - Introduction à R  -----------
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# source : https://juba.github.io/tidyverse/
# fonctions vues: sum, mean length, min, max, range, unique, seq, help

# package : rbase

# raccourcis:
# sauver CTRL + s
# annuler la dernière écriture CTRL + z
# rétablir la dernière écriture CTRL + SHIFT + z
# commenter/ décommenter plusieurs lignes CTRL + SHIFT + c
# exécuter une ligne: CTRL + ENTER

# Pour mettre à la ligne le code: Tools>GlobalOptions>Code> Soft-warp R source file

# 1. La prise en main ----

# Une fois R et RStudio installés sur votre machine, nous n'allons pas lancer R mais plutôt RStudio.

# RStudio n'est pas à proprement parler une interface graphique qui permettrait d'utiliser R de manière "classique" via la souris, des menus et des boîtes de dialogue. Il s'agit plutôt de ce qu'on appelle un * Environnement de développement intégré * (IDE) qui facilite l'utilisation de R et le développement de scripts.


## 1.1. La console -----

### 1.1.1. L'invite de commandes -----

# Au premier lancement de RStudio, l'interface est organisée en trois grandes zones.
# La zone de gauche se nomme la *Console*. À son démarrage, RStudio a lancé une nouvelle session de R et
# c'est dans cette fenêtre que nous allons pouvoir interagir avec lui.
#
# La *Console* doit normalement afficher un texte de bienvenue ressemblant à ceci:
#
# R version 4.2.2 Patched (2022-11-10 r83330) -- "Innocent and Trusting"
# Copyright (C) 2022 The R Foundation for Statistical Computing
# Platform: x86_64-pc-linux-gnu (64-bit)
#
# R est un logiciel libre livré sans AUCUNE GARANTIE.
# Vous pouvez le redistribuer sous certaines conditions.
# Tapez 'license()' ou 'licence()' pour plus de détails.
#
# Natural language support but running in an English locale
#
# R is a collaborative project with many contributors.
# Type 'contributors()' for more information and
# 'citation()' on how to cite R or R packages in publications.
#
# Tapez 'demo()' pour des démonstrations, 'help()' pour l'aide
# en ligne ou 'help.start()' pour obtenir l'aide au format HTML.
# Tapez 'q()' pour quitter R.
#
#
# suivi d'une ligne commençant par le caractère `>` et sur laquelle devrait se trouver votre curseur. Cette ligne est appelée l'*invite de commande* (ou *prompt* en anglais). Elle signifie que R est disponible et en attente de votre prochaine instruction.

# Nous pouvons tout de suite lui fournir une première commande, en saisissant le texte suivant puis en appuyant sur `Entrée`:

2 + 2

# R nous répond immédiatement, et nous pouvons constater avec soulagement qu'il sait faire des additions à un chiffre. On peut donc continuer avec d'autres opérations:

5 - 7
4 * 12
-10 / 3
5^2

# Cette dernière opération utilise le symbole `^` qui représente l'opération *puissance*. `5^2` signifie donc "5 au carré".

### 1.1.1. Précisions concernant la saisie des commandes -----

# Lorsqu'on saisit une commande, les espaces autour des opérateurs n'ont pas d'importance. Les trois commandes suivantes sont donc équivalentes, mais on privilégie en général la deuxième pour des raisons de lisibilité du code.

10+2
10 + 2
10   +   2

# Quand vous êtes dans la console, vous pouvez utiliser les flèches vers le haut `↑` et vers le bas `↓` de votre clavier pour naviguer dans l'historique des commandes que vous avez tapées précédemment. Vous pouvez à tout moment modifier la commande affichée, et l'exécuter en appuyant sur `Entrée`.

# Enfin, il peut arriver qu'on saisisse une commande de manière incomplète: oubli d'une parenthèse, faute de frappe, etc. Dans ce cas, R remplace l'invite de commande habituel par un signe `+`.

4 *

# Cela signifie qu'il "attend la suite". On peut alors soit compléter la commande sur cette nouvelle ligne et appuyer sur `Entrée`, soit, si on est perdu, tout annuler et revenir à l'invite de commandes normal  en appuyant sur `Esc` ou `Échap`.


## 1.2. Objets -----

### 1.2.1. Objets simples -----

# Faire des calculs c'est bien, mais il serait intéressant de pouvoir stocker un résultat quelque part pour pouvoir le réutiliser ultérieurement sans avoir à faire du copier/coller.

# Pour conserver le résultat d'une opération, on peut le stocker dans un *objet* à l'aide de l'opérateur d'assignation `<-`. Cette "flèche" stocke ce qu'il y a à sa droite dans un objet dont le nom est indiqué à sa gauche.

# Prenons tout de suite un exemple.

x <- 2

# Cette commande peut se lire *"prend la valeur 2 et mets la dans un objet qui s'appelle `x`"*.

# Si on exécute une commande comportant juste le nom d'un objet, R affiche son contenu.

x

# On voit donc que notre objet `x` contient bien la valeur 2.

# On peut évidemment réutiliser cet objet dans d'autres opérations: R le remplacera alors par sa valeur.

x + 4

# On peut créer autant d'objets qu'on le souhaite.

x <- 2
y <- 5
resultat <- x + y
resultat

#Les noms d'objets peuvent contenir des lettres, des chiffres, les symboles `.` et `_`. Ils ne peuvent pas commencer par un chiffre. Attention, R fait la différence entre minuscules et majuscules dans les noms d'objets, ce qui signifie que `x` et `X` seront deux objets différents, tout comme `resultat` et `Resultat`.

# De manière générale, il est préférable d'éviter les majuscules (pour les risques d'erreur) et les caractères accentués (pour des questions d'encodage) dans les noms d'objets. De même, il faut essayer de trouver un équilibre entre clarté du nom (comprendre à quoi sert l'objet, ce qu'il contient) et sa longueur. Par exemple, on préfèrera comme nom d'objet `taille_conj1` à `taille_du_conjoint_numero_1` (trop long) ou à `t1` (pas assez explicite).


# Quand on assigne une nouvelle valeur à un objet déjà existant, la valeur précédente est perdue.
# Les objets n'ont pas de mémoire.

x <- 2
x <- 5
x

# De la même manière, assigner un objet à un autre ne crée pas de "lien" entre les deux. Cela copie juste la valeur de l'objet de droite dans celui de gauche:

x <- 1
y <- 3
x <- y
x
## Si on modifie y, cela ne modifie pas x
y <- 4
x

# On le verra, les objets peuvent contenir tout un tas d'informations. Jusqu'ici on n'a stocké que des nombres, mais ils peuvent aussi contenir des chaînes de caractères (du texte), qu'on délimite avec des guillemets simples ou doubles (`'` ou `"`):

chien <- "Chihuahua"
chien


### 1.2.2. Vecteurs -----

# Imaginons maintenant qu'on a demandé la taille en centimètres de 5 personnes et qu'on souhaite calculer leur taille moyenne. On pourrait créer autant d'objets que de tailles et faire l'opération mathématique qui va bien:

taille1 <- 156
taille2 <- 164
taille3 <- 197
taille4 <- 147
taille5 <- 173
(taille1 + taille2 + taille3 + taille4 + taille5) / 5

# Cette manière de faire n'est clairement pas pratique du tout. On va donc plutôt stocker l'ensemble de nos tailles dans un seul objet, de type *vecteur*, avec la syntaxe suivante:

tailles <- c(156, 164, 197, 147, 173)

#Si on affiche le contenu de cet objet, on voit qu'il contient bien l'ensemble des tailles saisies.

tailles

# Un *vecteur* dans R est un objet qui peut contenir plusieurs informations du même type, potentiellement en très grand nombre.
#
# L'avantage d'un vecteur est que lorsqu'on lui applique une opération, celle-ci s'applique à toutes les valeurs qu'il contient. Ainsi, si on veut la taille en mètres plutôt qu'en centimètres, on peut faire:

tailles_m <- tailles / 100
tailles_m

# Cela fonctionne pour toutes les opérations de base.

tailles + 10
tailles^2

# Imaginons maintenant qu'on a aussi demandé aux cinq mêmes personnes leur poids en kilos. On peut créer un deuxième vecteur:

poids <- c(45, 59, 110, 44, 88)

# On peut alors effectuer des calculs utilisant nos deux vecteurs `tailles` et `poids`. On peut par exemple calculer l'indice de masse corporelle (IMC) de chacun de nos enquêtés en divisant leur poids en kilo par leur taille en mètre au carré:

imc <- poids / (tailles / 100) ^ 2
imc

# Un vecteur peut contenir des nombres, mais il peut aussi contenir du texte. Imaginons qu'on a demandé aux 5 mêmes personnes leur niveau de diplôme: on peut regrouper l'information dans un vecteur de *chaînes de caractères*. Une chaîne de caractère contient du texte libre, délimité par des guillemets simples ou doubles.

diplome <- c("CAP", "Bac", "Bac+2", "CAP", "Bac+3")
diplome

#L'opérateur `:`, lui, permet de générer rapidement un vecteur comprenant tous les nombres entre deux valeurs, opération assez courante sous R:

x <- 1:10
x

# la fonction `seq` permet également de générer un vecteur comprenant tous les nombres entre deux valeurs en décidant l’intervalle seq(from= , to= , by=):
x <- seq(1,10,1)
x
x <- seq(1,10,2)
x

# Enfin, notons qu'on peut accéder à un élément particulier d'un vecteur en faisant suivre le nom du vecteur de crochets contenant le numéro de l'élément désiré.

diplome[2]

# Cette opération, qui utilise l'opérateur `[]`, permet donc la sélection d'éléments d'un vecteur.

# Dernière remarque, si on affiche dans la console un vecteur avec beaucoup d'éléments, ceux-ci seront répartis sur plusieurs lignes. Par exemple, si on a un vecteur de 50 nombres on peut obtenir quelque chose comme:

# [1] 294 425 339 914 114 896 716 648 915 587 181 926 489
# [14] 848 583 182 662 888 417 133 146 322 400 698 506 944
# [27] 237 324 333 443 487 658 793 288 897 588 697 439 697
# [40] 914 694 126 969 744 927 337 439 226 704 635

# On remarque que R ajoute systématiquement un nombre entre crochets au début de chaque ligne: il s'agit en fait de la position du premier élément de la ligne dans le vecteur. Ainsi, le 848 de la deuxième ligne est le 14e élément du vecteur, le 914 de la dernière ligne est le 40e, etc.

# Ceci explique le `[1]` qu'on obtient quand on affiche un simple nombre [Et permet de constater que pour R, un nombre est un vecteur à un seul élément.]:

# [1] 4



## 1.3. Fonctions  -----

### 1.3.1. Principe -----

# Nous savons désormais effectuer des opérations arithmétiques de base sur des nombres et des vecteurs, et stocker des valeurs dans des objets pour pouvoir les réutiliser plus tard.

# Pour aller plus loin, nous devons aborder les *fonctions* qui sont, avec les objets, un deuxième concept de base de R. On utilise des fonctions pour effectuer des calculs, obtenir des résultats et accomplir des actions.

# Formellement, une fonction a un *nom*, elle prend en entrée entre parenthèses un ou plusieurs *arguments* (ou *paramètres*), et retourne un *résultat*.

# Prenons tout de suite un exemple. Si on veut connaître le nombre d'éléments du vecteur `tailles` que nous avons construit précédemment, on peut utiliser la fonction `length`, de cette manière:
tailles
length(tailles)

# Ici, `length` est le nom de la fonction, on l'appelle en lui passant un argument entre parenthèses (en l'occurrence notre vecteur `tailles`), et elle nous renvoie un résultat, à savoir le nombre d'éléments du vecteur passé en paramètre.
# Autre exemple, les fonctions `min` et `max` retournent respectivement les valeurs minimales et maximales d'un vecteur de nombres.

min(tailles)
max(tailles)

# La fonction `mean` calcule et retourne la moyenne d'un vecteur de nombres.

mean(tailles)

# La fonction `sum` retourne la somme de tous les éléments du vecteur.

sum(tailles)

# Jusqu'à présent on n'a vu que des fonctions qui calculent et retournent un unique nombre. Mais une fonction peut renvoyer d'autres types de résultats. Par exemple, la fonction `range` (étendue) renvoie un vecteur de deux nombres, le minimum et le maximum.

range(tailles)

# Ou encore, la fonction `unique`, qui supprime toutes les valeurs en double dans un vecteur, qu'il s'agisse de nombres ou de chaînes de caractères.

diplome <- c("CAP", "Bac", "Bac+2", "CAP", "Bac+3") # Il y a deux fois "CAP"
unique(diplome)


### 1.3.2. Arguments -----

# Une fonction peut prendre plusieurs arguments, dans ce cas on les indique entre parenthèses en les séparant par des virgules.

# On a déjà rencontré un exemple de fonction acceptant plusieurs arguments: la fonction `c`, qui combine l'ensemble de ses arguments en un vecteur^[`c` est l'abbréviation de *combine*, son nom est très court car on l'utilise très souvent].

tailles <- c(156, 164, 197, 181, 173)

# Ici, `c` est appelée en lui passant cinq arguments, les cinq tailles séparées par des virgules, et elle renvoie un vecteur numérique regroupant ces cinq valeurs.

# Supposons maintenant que dans notre vecteur `tailles` nous avons une valeur manquante (une personne a refusé de répondre, ou notre mètre mesureur était en panne). On symbolise celle-ci dans R avec le code interne `NA`.

tailles <- c(156, 164, 197, NA, 173)
tailles

# `NA` est l'abbréviation de *Not available*, non disponible. Cette valeur particulière peut être utilisée pour indiquer une valeur manquante, qu'il s'agisse d'un nombre, d'une chaîne de caractères, etc.

# Si on calcule maintenant la taille moyenne à l'aide de la fonction `mean`, on obtient:

mean(tailles)

# En effet, R considère par défaut qu'il ne peut pas calculer la moyenne si une des valeurs n'est pas disponible. Dans ce cas il considère que la moyenne est elle-même "non disponible" et renvoie donc `NA` comme résultat.

# On peut cependant indiquer à `mean` d'effectuer le calcul en ignorant les valeurs manquantes. Ceci se fait en ajoutant un argument supplémentaire, nommé `na.rm` (abbréviation de *NA remove*, "enlever les NA"), et de lui attribuer la valeur `TRUE` (code interne de R signifiant *vrai*).

mean(tailles, na.rm = TRUE)

tailles_sansna <- c(156, 164, 197, 173)
mean(tailles_sansna)


# Positionner le paramètre `na.rm` à `TRUE`  indique à la fonction `mean` de ne pas tenir compte des valeurs manquantes dans le calcul.

# Si on ne dit rien à la fonction `mean`, cet argument a une valeur par défaut, en l'occurrence `FALSE` (faux), qui fait qu'il ne supprime pas les valeurs manquantes. Les deux commandes suivantes sont donc rigoureusement équivalentes:

mean(tailles)
mean(tailles, na.rm = FALSE)

# Lorsqu'on passe un argument à une fonction de cette manière, c'est-à-dire sous la forme `nom = valeur`, on parle d'*argument nommé*.

# C'est valables pour `sum`, `max`, `min`, etc.
sum(tailles)
sum(tailles, na.rm = T) # On peut remplacer le `TRUE` par `T` et le `FALSE` par `F`

max(tailles)
max(tailles, na.rm = T)

min(tailles)
min(tailles, na.rm = T)

### 1.3.3. Aide sur une fonction -----

# Il est fréquent de ne pas savoir (ou d'avoir oublié) quels sont les arguments d'une fonction, ou comment ils se nomment. On peut à tout moment faire appel à l'aide intégrée à R en passant le nom de la fonction (entre guillemets) à la fonction `help`.

help("mean")

# On peut aussi utiliser le raccourci

?mean

# Ces deux commandes affichent une page (en anglais) décrivant la fonction, ses paramètres, son résultat, le tout accompagné de diverses notes, références et exemples. Ces pages d'aide contiennent à peu près tout ce que vous pourrez chercher à savoir, mais elles ne sont pas toujours d'une lecture aisée.

# Dans RStudio, les pages d'aide en ligne s'ouvriront par défaut dans la zone en bas à droite,sous l'onglet *Help*. Un clic sur l'icône en forme de maison vous affichera la page d'accueil de l'aide.


## 1.4. Regrouper ses commandes dans des scripts  -----

# Jusqu'ici on a utilisé R de manière "interactive", en saisissant des commandes directement dans la console. Ça n'est cependant pas la manière dont on va utiliser R au quotidien, pour une raison simple: lorsque R ou RStudio redémarre, tout ce qui a été effectué dans la console est perdu.

# Plutôt que de saisir nos commandes dans la console, on va donc les regrouper dans des scripts (de simples fichiers texte), qui vont garder une trace de toutes les opérations effectuées, et ce sont ces scripts, sauvegardés régulièrement, qui seront le "coeur" de notre travail. C'est en rouvrant les scripts et en réexécutant les commandes qu'ils contiennent qu'on pourra "reproduire" le chargement des données, leur traitement, les analyses et leurs résultats.

# Pour créer un script, il suffit de sélectionner le menu *File*, puis *New file* et *R script*. Une quatrième zone apparaît alors en haut à gauche de l'interface de RStudio. On peut enregistrer notre script à tout moment dans un fichier avec l'extension `.R`, en cliquant sur l'icône de disquette ou en choissant *File* puis *Save*.

# Un script est un fichier texte brut, qui s'édite de la manière habituelle. À la différence de la console, quand on appuie sur `Entrée`, cela n'exécute pas la commande en cours mais insère un saut de ligne (comme on pouvait s'y attendre).

# Pour exécuter une commande saisie dans un script, il suffit de positionner le curseur sur la ligne de la commande en question, et de cliquer sur le bouton *Run* dans la barre d'outils juste au-dessus de la zone d'édition du script. On peut aussi utiliser le raccourci clavier `Ctrl + Enter` (`Cmd + Enter` sous Mac). On peut enfin sélectionner plusieurs lignes avec la souris ou le clavier et cliquer sur *Run* (ou utiliser le raccourci clavier), et l'ensemble des lignes est exécuté d'un coup.

# Au final, un script pourra ressembler à quelque chose comme ça:

tailles <- c(156, 164, 197, 147, 173)
poids <- c(45, 59, 110, 44, 88)

mean(tailles)
mean(poids)

imc <- poids / (tailles / 100) ^ 2
min(imc)
max(imc)

### Commentaires

# Les commentaires sont un élément très important d'un script. Il s'agit de texte libre, ignoré par R, et qui permet de décrire les étapes du script, sa logique, les raisons pour lesquelles on a procédé de telle ou telle manière... Il est primordial de documenter ses scripts à l'aide de commentaires, car il est très facile de ne plus se retrouver dans un programme qu'on a produit soi-même, même après une courte interruption.

# Pour ajouter un commentaire, il suffit de le faire précéder d'un ou plusieurs symboles `#`. En effet, dès que R rencontre ce caractère, il ignore tout ce qui se trouve derrière, jussqu'à la fin de la ligne.

# On peut donc documenter le script précédent:

# Saisie des tailles et poids des enquêtés
tailles <- c(156, 164, 197, 147, 173)
poids <- c(45, 59, 110, 44, 88)

# Calcul des tailles et poids moyens
mean(tailles)
mean(poids)

# Calcul de l'IMC (poids en kilo divisé par les tailles en mètre au carré)
imc <- poids / (tailles / 100) ^ 2
# Valeurs extrêmes de l'IMC
min(imc)
max(imc)

# On peut commenter (ou décommenter) plusieurs lignes grâce au raccourci CTRL + SHIFT + c

## 1.5. Lister et supprimer les objets -----
# lister les objets
ls()

# supprimer un objet
rm(tailles)

# Si on refait `ls()` on observe que l'objet tailles a été supprimer
ls()

# supprimer tous les objets
rm(list = ls())
