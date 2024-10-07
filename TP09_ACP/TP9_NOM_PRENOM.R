# ---------------------------------------------
#              TP 9 -  Exercices
# ---------------------------------------------

## Exercices  -----

# NOM
# PRENOM


# **Exercice 1. ** -----
# Pour cet exercice vous allez réaliser une ACP sur une série de variables (ACP_BXL.xls) choisies a priori pour résumer la division en quadrant et centre-périphérie de Bruxelles. Trois variables (PSOC123,PSOC456 ,PSOC78910) sont redondante avec DEC_SOCX, retirez les du set de données. Retirez également de l'analyse les secteurs statistiques où la population est égale à 0.
# Astuce: Dans read_excel, vous pouvez spécifier quelle feuille importer avec  sheet=1 pour importer la première feuille.


# SS	Secteur statistique
# POP_2018	Population 2018
# MEN_2011	Nb ménages 2011
# SOC_MOY	Nscore socioéconomique moyen
# SOC_ECTYP	Ecart-type socioéconomique
# DEC_SOC01	part décile 1 socioéconomique
# DEC_SOC02	part décile 2 socioéconomique
# DEC_SOC03	part décile 3 socioéconomique
# DEC_SOC04	part décile 4 socioéconomique
# DEC_SOC05	part décile 5 socioéconomique
# DEC_SOC06	part décile 6 socioéconomique
# DEC_SOC07	part décile 7 socioéconomique
# DEC_SOC08	part décile 8 socioéconomique
# DEC_SOC09	part décile 9 socioéconomique
# DEC_SOC10	part décile 10 socioéconomique
# NBCAR_MEN nombre de voiture par ménage
# P_J	Part logements avec jardin
# P_JP50	Part logements avec jardin de plus de 50m²
# PSOC123	Part déciles soco 123
# PSOC456	Part déciles soco 456
# PSOC78910	Part déciles soco 78910
# PAG0015	Part 0-15 ans
# PAG65P	Part 65 ans e§t plus
# PMEN_ISO	Part ménages d'isolé;e.s
# PMEN_COU0	Part des couples sans enfant
# PMEN_4P	Part de sménages de 4 personnes et pkus
# TX_ROT	Taux de rotation résidentielle
# PD_A19	Part des logements construits avant 1919
# PD_19_45	Part des logements construits entre 1919 et 1945
# PD_45_60	Part des logements construits entre 1945 et 1960
# PD_60_75	Part des logements construits entre 1960 et 1975
# PD_75_90	Part des logements construits entre 1975 et 1990
# PD_90_PL	Part des logements construits après 1990
# PM4	Part des maisons 4 façades
# PM3	Part des maisons 3 façades
# PM2	Part des maisons 2 façades
# PAPP	Part des appartements
# P_LOC	Part des locataires
# P_LT_SINF	Part des displômes du secondaire inférieur max
# P_SUPC	Part des diplômés du supérieur court
# P_SUPL	Part des diplômés du supérieur long
# TPSTC_MY	Temps moyen d'accès en transports publics vers les écoles, pôles de commerces, etc.
# V_TC_MY	Vitessse moyenne pour atteindre les destinations en transports publics
# TURQUIE	Part nationalité = turquie
# AFR_N	Part nationalités = Afrique du N
# AFR_SUBS	Part nationalités = Afrique subsaharienne
# P_AMLAT	Part nationalités = Amérique latine
# P_EU14	Part nationalités = Europe 14
# P_FR	Part nationalité = France
# P_NUE	Part nationalités = UE membres >= 2004
# P_OCDE	Part nationalités = autre OCDE


# **Exercice 1.1. ** -----
# Matrice de corrélation:
# Réalisez une matrice de corrélation avec corrplot entre toutes les variables.



# **Exercice 1.2. ** -----
# Une carte par variable:
# Réalisez un carte par variable pour toutes les variables prises dans l'ACP en faisant varier la taille par le nombre d'habitants et la couleur selon la valeur de la variable représentée.
# Astuce: vous pouvez réaliser la boucle sur l'indexation for (i in 1:n){ names(data)[i]}


# **Exercice 1.3. ** -----
# ACP:
# Réalisez une ACP en pondérant chaque secteur statistique par le nombre d'habitant-es en 2018 et réalisez deux cercles de correlations (variables 1 et 2 ainsi que 1 et 3) ainsi que le screeplot (pourcentage de variance expliquée par chaque ). Inversez la deuxième dimension pour une meilleure compréhension, utilisez le package repel pour les étiquettes et faites varier la couleur selon la capacité des axes à expliquer la variance des variables (cos2).



# **Exercice 1.4. ** -----
# Carte des scores:
# Réalisez une carte des scores pour les 3 premières dimensions




