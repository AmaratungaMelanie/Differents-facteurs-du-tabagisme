# Differents-facteurs-du-tabagisme
Projet d’analyse statistique – Régression logistique & visualisation des données

Contexte

Les maladies respiratoires chroniques constituent un enjeu majeur de santé publique. Leur prévalence augmente notamment en raison de l’exposition au tabagisme et à divers facteurs environnementaux et démographiques.
Ce projet vise à identifier les variables individuelles influençant la probabilité de développer des problèmes pulmonaires.

Objectif

Analyser un jeu de données de 100 individus pour déterminer quels facteurs — âge, sexe, tabagisme, exposition au tabagisme passif, situation familiale — sont associés à l’apparition de troubles pulmonaires.

Jeu de données

100 individus

Variables :

Démographiques : âge, sexe

Sociales : situation (célibataire, en couple, marié, veuf)

Comportementales : consommation de tabac, tabagisme passif

Variable cible : probleme_pulmonaire (binaire)

Préparation incluse :

Nettoyage des données

Recodage des variables qualitatives

Création de classes de consommation de tabac via cut()

Conversion de la cible en facteur binaire (0/1)

Analyses descriptives & graphiques

Plusieurs visualisations exploratoires ont été produites :

Histogrammes des niveaux de tabac

Boxplots de l’âge selon l’état pulmonaire

Graphiques en barres empilées (tabac, tabagisme passif)

Visualisation des probabilités prédites
Ces graphiques permettent d'observer :

Une tendance à des âges plus élevés chez les individus atteints

Une augmentation apparente du risque avec le tabagisme

Un lien visuel entre tabagisme passif et troubles pulmonaires

Modélisation : Régression logistique

Deux modèles ont été construits :

Modèle complet avec la variable tabac non regroupée → résultats peu lisibles

Modèle simplifié avec variable classe_Tabac (Non-fumeur / Faible / Moyen / Fort)

Le second modèle permet une interprétation beaucoup plus claire et stable.

Résultats principaux

Les seules variables statistiquement significatives :

Âge

Classe_TabacMoyen

Variables non significatives :

Sexe

Tabagisme passif

Tabagisme fort

Situation familiale

Interprétation :

L’âge et une consommation modérée de tabac augmentent significativement la probabilité de souffrir de problèmes pulmonaires.

Évaluation du modèle

Plusieurs indicateurs confirment la qualité du modèle :

Métrique	| Résultat	| Interprétation
Pseudo R² de McFadden	| Satisfaisant | Bonne qualité d'ajustement
Test du chi² (likelihood ratio)	| p < 0.05	| Modèle globalement significatif
AUC de la courbe | ROC	0.9879 |	Excellent pouvoir discriminant

Les distributions des probabilités prédites montrent une séparation nette entre individus malades et sains.

Conclusion

L’étude met en évidence que :

L’âge et le tabagisme modéré sont les seuls facteurs réellement associés aux troubles pulmonaires dans l’échantillon.

La régression logistique s’est révélée pertinente pour modéliser cette relation.

Les résultats peuvent guider des actions de prévention ciblant les personnes exposées au tabac.

Technologies & ressources

Langage : R

Packages : ggplot2, pscl, pROC

Ressources utilisées :

TP : https://rpubs.com/tchalioui/TP_REG_LOG

Intervalles de confiance : datatab.fr

Vidéos explicatives (IC & logit)
