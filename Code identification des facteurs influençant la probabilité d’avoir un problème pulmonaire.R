# ETUDE : Déterminants des problème pulmonaires

# 1. Chargement et préparation des donnée 

data_original <- read.csv("2_tabac.csv", stringsAsFactors = FALSE)

# Vérification structure et valeurs manquante
str(data_original)
summary(data_original)
colSums(is.na(data_original))

# Recodage de la variable cible

data_original$probleme_pulmonaire <- ifelse(data_original$probleme_pulmonaire == TRUE, 1, 0)
data_original$probleme_pulmonaire <- factor(data_original$probleme_pulmonaire, levels = c(0, 1))

# Conversion des variables explicative en facteur si nécessaire
data_original$sexe <- as.factor(data_original$sexe)
data_original$situation <- as.factor(data_original$situation)
data_original$tabac <- as.factor(data_original$tabac)
data_original$tabagisme_passif <- as.factor(data_original$tabagisme_passif)

# Création d'une variable catégorisée pour le tabac
data_original$classe_tabac <- cut(as.numeric(data_original$tabac),
                                  breaks = c(-1, 0, 5, 10, 15),
                                  labels = c("Non-fumeur", "Faible", "Moyen", "Fort"))

#  2. Statistique descriptive

nrow(data_original)                           
table(data_original$probleme_pulmonaire)      
prop.table(table(data_original$probleme_pulmonaire))
summary(data_original$age)                     
table(data_original$sexe)
table(data_original$situation)
table(data_original$tabac)
table(data_original$tabagisme_passif)

#  3. Graphique

library(ggplot2)

# Histogramme du niveau de tabac
hist(as.numeric(data_original$tabac), breaks = 15,
     main = "Distribution du niveau de consommation de tabac",
     xlab = "Niveau de tabac", col = "skyblue")

# L'âge selon la cible 
ggplot(data_original, aes(x = factor(probleme_pulmonaire), y = age)) +
  geom_boxplot(fill = "orange") +
  labs(title = "Âge selon la présence de problèmes pulmonaires",
       x = "Problème pulmonaire (0 = Non, 1 = Oui)", y = "Âge") +
  theme_minimal()

#  Classe de tabac vs problème 
ggplot(data_original, aes(x = factor(probleme_pulmonaire), fill = classe_tabac)) +
  geom_bar(position = "fill") +
  labs(title = "Problèmes pulmonaires selon le niveau de tabagisme",
       x = "Problème pulmonaire", y = "Proportion", fill = "Classe de tabac") +
  scale_fill_brewer(palette = "Set2") +
  theme_minimal()

# tabagisme passif vs problème 
ggplot(data_original, aes(x = factor(probleme_pulmonaire), fill = factor(tabagisme_passif))) +
  geom_bar(position = "fill") +
  labs(title = "Problèmes pulmonaires selon le tabagisme passif",
       x = "Problème pulmonaire", y = "Proportion", fill = "Tabagisme passif") +
  scale_fill_manual(values = c("grey70", "tomato")) +
  theme_minimal()

#  4. Modélisation : régression logistique 

modele_logit <- glm(probleme_pulmonaire ~ age + sexe + tabac + tabagisme_passif + situation,
                    data = data_original, family = binomial)

modele_simplifie <- glm(probleme_pulmonaire ~ age + sexe + classe_tabac + tabagisme_passif + situation,
                        data = data_original, family = binomial)

summary(modele_logit)
exp(coef(modele_logit))
confint.default(modele_logit)

summary(modele_simplifie)
exp(coef(modele_simplifie))
confint.default(modele_simplifie)

#  5. Évaluation du modèle 

library(pscl)
pR2(modele_logit)

library(pROC)
proba <- predict(modele_logit, type = "response")
roc_curve <- roc(data_original$probleme_pulmonaire, proba)
plot(roc_curve, col = "darkblue", lwd = 2, main = "Courbe ROC du modèle logistique")
auc(roc_curve)

pR2(modele_simplifie)
proba_2 <- predict(modele_simplifie, type = "response")
roc_curve2 <- roc(data_original$probleme_pulmonaire, proba_2)
plot(roc_curve2, col = "darkred", lwd = 2, main = "Courbe ROC du modèle simplifie")
auc(roc_curve2)

# Test du Chi2 (Test de vraisemblance) (Globalement significatif)

anova(modele_logit, test = "Chisq")
anova(modele_simplifie, test = "Chisq")

# Distribution des probabilités prédites
data_original$proba <- proba

ggplot(data_original, aes(x = proba, fill = factor(probleme_pulmonaire))) +
  geom_histogram(position = "identity", alpha = 0.6, bins = 30) +
  labs(title = "Distribution des probabilités prédites par classe",
       x = "Probabilité prédite", fill = "Problème pulmonaire") +
  theme_minimal()

# 6. Effets des variables (OR + IC), avec un autre modele plus simple. 

odds_ratios_simpl <- exp(coef(modele_simplifie))
or_ci_simpl <- exp(confint.default(modele_simplifie))

effets_simpl <- data.frame(
  Variable = rownames(or_ci_simpl),
  OR = odds_ratios_simpl,
  IC_inf = or_ci_simpl[, 1],
  IC_sup = or_ci_simpl[, 2])

ggplot(effets_simpl, aes(x = reorder(Variable, OR), y = OR)) +
  geom_point(size = 2) +
  geom_errorbar(aes(ymin = IC_inf, ymax = IC_sup), width = 0.2) +
  geom_hline(yintercept = 1, linetype = "dashed", color = "red") +
  coord_flip() +
  labs(title = "Effets des variables explicatives ",
       x = "Variables explicatives", y = "Odds Ratio ") +
  theme_minimal()
