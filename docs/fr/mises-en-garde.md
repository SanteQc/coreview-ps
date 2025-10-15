# Mises en garde

Veuillez lire attentivement les mises en garde suivantes avant de commencer à
utiliser les APIs de CoreView.

## Stockage des clés d'API

!> Les clés d'API sont sensibles et doivent être protégées. Ne les partagez pas
   publiquement et ne les stockez pas en clair dans des scripts ou des fichiers.

Si vous devez scripter des tâches automatisées qui nécessitent une clé d'API,
nous vous recommendons stocker la clé d'API à l'aide du module
[SecretManagement] afin de ne pas l'inclure en clair dans le script.

Consultez les articles suivants pour plus de détails:

- [Gestion des secrets avec SecretManagement](fr/SecretManagement.md) (tutoriel)
- [Prise en main du module SecretStore]
- [Utiliser secretStore dans l’automatisation]

<br>

## Portée des clés d'API

!> Les clés d'API sont délivrées pour des besoins spécifiques. Et doivent
    seulement être utilisées pour ces besoins.

Chaque clé d'API doit servir à __une seule__ automatisation, application ou
script. Si vous avez besoin de plusieures clés d'API pour différents besoins,
veuillez ouvrir une demande au Centre de services pour obtenir de nouvelles
clés. Les clés d'API ne doivent pas être partagées entre differents projets ou
équipes.

Cette restriction est en place pour des raisons de sécurité et de traçabilité.

<br>

## Expiration des clés d'API

!> Les clés d'API __ont une date d'expiration__. Il est de votre responsabilité
   de prendre en note la date d'expiration de la clé.

Vous devrez ouvrir une demande au Centre de services pour faire renouveler votre
clé d'API avant sa date d'expiration pour éviter toute interruption de service.
Le Centre vous fournira alors une nouvelle clé d'API à utiliser et vous pourrez
alors cesser d'utiliser l'ancienne.

<br>

## Limites d'utilisation

!> Les clés d'API sont __soumises aux mêmes limites d'utilisation__ que les
   comptes d'utilisateurs CoreView normaux.

Merci de ne pas lancer plus de 10 requêtes par seconde avec une clé d'API.
Veuillez aussi ne pas lancer plus de 100 exécutions de flux en parallèle en
heure de pointe. Si vous devez lancer plus de 100 exécutions de flux, veuillez
attendre que les exécutions en cours soient terminées avant d'en lancer de
nouvelles.

Vous pouvez scripter l'attente des exécutions en cours en utilisant la commande
[Wait-CvCfFlowExecution] pour attendre qu'une exécution de flux soit terminée
avant d'en lancer une nouvelle.

Il est possible de lancer plus de 100 exécutions de flux en parallèle entre
21h et 4h en semaine et entre 19h et 8h pendant la fin de semaine.

<br>

## Divulgation accidentelle d'une clé d'API

!> Si vous avez accidentellement divulgué une clé d'API, veuillez immédiatement
   ouvrir une demande au Centre de services pour faire révoquer la clé.

Les clés d'API agissent comme des mots de passe et doivent être traitées comme
tels. Si une clé d'API est divulguée, elle doit être révoquée et une nouvelle
clé doit être générée pour éviter tout accès non-autorisé à votre compte.

<br>

## Assistance

!> Sante.Québec n'offre aucun support pour les scripts ou les automatisations que
   vous pourriez mettre en place.

Si vous avez des questions ou des problèmes avec les scripts ou les
automatisations, veuillez consulter la documentation fournie pour le module
PowerShell. Si vous découvrez un bogue dans le module, veuillez ouvrir une
demande au Centre de services pour que le problème soit corrigé.

<br>

[Suite: téléchargement](fr/telechargement.md ":class=button")

[Wait-CvCfFlowExecution]: fr/cmdlets/Wait-CvCfFlowExecution.md

[SecretManagement]: https://learn.microsoft.com/fr-ca/powershell/utility-modules/secretmanagement/get-started/using-secretstore?view=ps-modules
[Prise en main du module SecretStore]: https://learn.microsoft.com/fr-ca/powershell/utility-modules/secretmanagement/get-started/using-secretstore?view=ps-modules
[Utiliser secretStore dans l’automatisation]: https://learn.microsoft.com/fr-ca/powershell/utility-modules/secretmanagement/how-to/using-secrets-in-automation?view=ps-modules
