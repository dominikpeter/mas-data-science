
library(MASS)

# Datensatz: survey

# Konfidenzintervall
t.test(survey$Height)
# 95 percent confidence interval:
#   171.0380 173.7237

# Problem: Bestimmen Sie benötigte Stichprobengrösse für die
# durchschnittliche Körpergrösse bei einem Fehlerbereich von 1:2 cm
# und einem Konfidenzniveau von 95%.

# NA's herausfiltern
height_response <- na.omit(survey$Height)

# Quantil bestimmen
# (habe die Fläche, will die Zahl -> in R ein q-Befehl)
zstar <- qnorm(.975)

# Wert unten wäre
qnorm(.025)

# Soweit die Vorgabe, nun die Standardabweichung berechnen
s <- sd(height_response)
E <- 1.2

# Formel von Seite 25 anwenden
zstar^2 * s^2/E^2
# (Ich müsste mindestens 258 Personen befragen (258.695) 
#           <- Mit Normalverteilung, was nicht korrekt ist bei unbekannter sd)
# Die t-Verteilung kann ich nicht nehmen, weil ich die Stichprobengrösse ja bestimmen will
# und ich diese für den degree of freedom für die die t-Verteilung haben müsste.
# (Deshalb macht man die Mischrechnung - Ab 30 Stichproben ist die Verteilung der 
# Normalverteilung nahe)

# Der Anteil in der Stichprobe ^p ist ein guter Schätzwert für den
# Anteil in der Population p.

# Problem: Bestimmen Sie eine Punktschätzung für den Anteil der
# weiblichen Studierenden in survey.

survey$Sex

gender_response <- na.omit(survey$Sex)
n <- length(gender_response)
k <- sum(gender_response == "Female") # True wird intern als 1 geführt (shrug)

# Schätzwert (Punktschätzer)
pbar <- k/n

# Punktschätzung ohne etwas anzugeben macht nie Sinn, da sich wahrer Wert
# Unterscheidet -> Konfidenzintervall angeben

# Intervallschätzung eines Populationsanteils p
# Für die Stichprobengrösse gilt np > 10 und n(1 􀀀 p) > 10.
# -> Sollte mindestens 10 Frauen und 10 Männer befragen

# Problem: Bestimmen Sie den Fehlerbereich und die Intervallschätzung
# für den Anteil der weiblichen Studierenden aus survey bei einem
# Konfidenzniveau von 95%.

# Standardfehler
SE <- sqrt(pbar * (1-pbar)/n) 

# Quantil
zstar <- qnorm(.975)

# Fehler(Standarfehler und Quantil)
E <- SE * zstar

pbar + c(-E,E)
# [1] 0.4362086 0.5637914 (Konfidenzintervall)

# Oder einfach mit der entsprechenden Methode
prop.test(k, n, conf.level = .95, correct = FALSE)

# Der wahre Anteil der weiblichen Studenten liegt zwischen 46.7 und 56.3 Prozent
# (Bei einem Konfidenzintervall von 95%)

# Stichprobengrösse beim Populationsanteil p

# Problem: Bestimmen Sie die Stichprobengrösse einer Umfrage zur
# Bestimmung des Anteils der weiblichen Studierenden. Der
# Fehlerbereich soll 5% betragen. Sie vermuten aus früheren Umfragen
# eine Anteil in der Grösse von p = 0:5. Das Konfidenzniveau ist 95%.

zstar <- qnorm(.975)
p <- .5 # Worst-Case
E <- .05
zstar^2 * p * (1-p)/E^2
# 384.1459 

# Testing

# Cola-Experiment 
# Raten ob Zero oder Light
# Nullhypothese: Beide Getränke sind ununterscheidbar
# -> Binomialverteilung
dbinom(0, 12, .5) # erster Versuch (auch .5^12)

treffer <- 0:12
dbinom(treffer, 12, .5)
plot(dbinom(treffer, 12, .5), type = "l")

# Wenn jetzt jemand kommt und 12 richtige hat (Wahrscheinlichkeit 0.00024)
# (Vermutlich eher Annahme falsch)

# Wir bestimmen Signifikanzniveau (alpha)
# Zweiseitigen Test, da auch immer das falsche gesagt zu unterscheibar führt
# alpha = 0.05 (Wenn etwas mit einer Wahrscheinlichkeit kleiner als 5% auftaucht, 
# dann werden wir stutzig)
# -> Bei 0 bis 2 Treffer, resp 10 bis 12 Treffer (zusammengezählt) sind wir bei 
# der Grenze

# Problem: Ein Hersteller von Glühbirnen behauptet eine
# Mindestlebensdauer von 100000 Stunden für seine Glühbirnen. Der
# Mittelwert einer Stichprobe aus 30 Glühbirnen ergab einen
# Stichprobenmittelwert von 90900 Stunden. Die Standardabweichung
# der Population beträgt 120 Stunden. Können wir bei einem
# Signifikanzniveau von 5% die Behauptung des Herstellers verwerfen?

xbar <- 9900
mu0 <- 10000
sigma <- 120
n <- 30
z <- (xbar - mu0)/(sigma/sqrt(n))

# Wo muss ich den Wert setzten, damit nur noch 5% enthalten sind
alpha <- .05 # Signifikanzniveau 5%
z.alpha <- qnorm(alpha)

# anderer Weg
# Wie gross müsste das Signifikanzniveau sein damit der Wert möglich ist
pval <- pnorm(z)

# Diese Fläche ist deutlich kleiner als 5% und Nullhypothese kann auch
# verworfen werden

# Überprüfung den andern weg (Standardfehler von Mittelwerten)
# Standardabweichung wird durch Wurzel-n geteilt -> deshalb können wir it
# der Stichprobengrösse die Genauigkeit verbessern
qnorm(.05, 10000, 120/sqrt(30))

library(TeachingDemos)
z.test(9900, mu = 10000, stdev = 120, n = 30, alternative = "less" )

# Rechtsseitiger Test

# Problem: Ein Produzent von Keksen behauptet, dass seine Produkte
# ein Höchstanteil an gesättigten Fettsäuren von 2 g pro Keks enthalten.
# In einer Stichprobe von 35 Keksen wurde ein Mittelwert von 2:1 g
# gemessen. Nehmen Sie eine Standardabweichung von 0:25 g an.
# Kann die Behauptung bei einem Signifikanzniveau von 5% verworfen
# werden?

# direkt
qnorm(.95, mean = 2, sd = .25/(sqrt(35)))
# 2.069508 

# Es kann bis 2.07g gehen, dass es noch mit der Hypothese verträglich ist
# Nullhypothese muss verworfen werden

# Wenn Mittelwerte, dann Wurzel aus Anzahl Stichproben

# Lange Variante mit Standardisieren
xbar <- 2.1
mu0 <- 2
sigma <- 0.25
n <- 35
z <- (xbar-mu0)/(sigma/sqrt(n))

## [1] 2.366432

alpha <- 0.05
z.critical <- qnorm(1-alpha)
z.critical
## [1] 1.644854
z > z.critical # H0 wird verworfen
## [1] TRUE

# oder über p-Wert
pnorm(2.1, mean = 2, sd = .25/sqrt(35), lower.tail = FALSE)
# p-Wert ist unter 5% (0.008980239)

z.test(2.1, mu = 2, stdev = .25, alternative = "greater", n = 35)
# p-value = 0.00898