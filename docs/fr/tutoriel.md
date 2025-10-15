# Tutoriel pas à pas

Ce tutoriel vous guidera à travers les étapes d'installation et de configuration
de CoreView-PS.

## Prérequis

Avant de commencez, veuillez vous assurer que vous satisfaites les [prérequis].
<br>
Vous devez également avoir [téléchargé] le code source de CoreView-PS et avoir
procédé à son [installation].

<br>

## Importation du module

Lorsque le module est installé, vous pouvez l'importer dans n'importe quelle
session PowerShell 7 en utilisant la commande suivante:

```powershell
Import-Module 'C:\CoreView-PS\coreview-ps.psd1' -Force -Global  # modifiez le chemin au besoin
```

?> Notez que le chemin fourni dans l'exemple est `C:\CoreView-PS`. Vous devriez
   remplacer ce chemin par le chemin où vous avez extrait le code source de
   CoreView-PS.

<br>

## Connexion à CoreView

Pour vous connecter à CoreView, utilisez la commande `Connect-CvAPI`. Veuillez
noter que cette commande requiert l'utilisation d'un [\[SecureString\]] pour la
clé d'API. Vous pouvez créer un SecureString à partir de la clé d'API brute de
la manière suivante:

```powershell
$CleApi = '***************'
$CleApiSS = ConvertTo-SecureString -String $CleApi -AsPlainText -Force
```

Ensuite, vous pouvez vous connecter à CoreView en utilisant la commande
`Connect-CvAPI`:

```powershell
Connect-CvAPI -ApiKey $CleApiSS  # < votre clé d'API sous forme de SecureString
```

### Test de la connexion

Vous pouvez tester la connexion en utilisant la commande `Get-CvSessionInfo`:

```powershell
Get-CvSessionInfo
```

En cas de succès, la commande devrait retourner les informations de l'opérateur
présentement connecté ainsi que sur la session.

<br>

## Démarrage d'un flux

Une fois connecté à CoreView, vous pouvez désormais envoyer des requêtes à
l'API. Ces requêtes permettent d'accomplir diverses tâches, mais pour ce
tutoriel, nous allons seulement démarrer un flux CoreView. Pour démarrer un
flux, la première étape est toujours d'obtenir l'identifiant unique du flux.

Pour obtenir l'identifiant unique du flux, vous devez trouver le flux dans le
portail de CoreView et vous rendre sur la page de détails du flux. Vous y
trouverez le nom, la date de mise à jour et l'identifiant unique du flux. Pour
référence, l'identifiant unique d'un flux est une chaîne de caractères de 36
caractères, généralement sous la forme `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`.

Pour cet exemple, nous utiliserons le flux intitulé
`MED - Changement numéro de permis résident a permanent` et ayant l'identifiant
unique `abdef181-8b6e-****-****-************`.

### Obtention des paramètres d'entrée

Lorsque vous avez obtenu l'identifiant unique du flux, vous devez déterminer la
liste des paramètres requis pour démarrer le flux. Ces paramètres sont propres
à chaque flux et peuvent être trouvés à l'aide de la commande
`Get-CvCfFlowInputParameters`:

```powershell
$IdFlux = 'abdef181-8b6e-****-****-************'
Get-CvCfFlowInputParameters -FlowId $IdFlux
```

La commande devrait alors vous retourner la liste des paramètres attendus:

```plaintext
Nom du paramètre : UserPrincipalName
Nom d'affichage  : Nom d’utilisateur principal
Type             : chaîne de caractères
Est obligatoire  : Oui

Nom du paramètre         : NouveauNumeroPermis
Description du paramètre : Le nouveau numéro de permis
Type                     : chaîne de caractères
Est obligatoire          : Oui

Nom du paramètre         : AncienNumeroPermis
Description du paramètre : Le numéro débutant par le préfixe R
Type                     : chaîne de caractères
Est obligatoire          : Oui

Nom du paramètre         : AdresseCourrielPourErreurs
Description du paramètre : Inscrire une adresse courriel pour recevoir les messages d'erreur
Type                     : chaîne de caractères
Est obligatoire          : Oui
```

### Préparation de la charge utile

Une fois que vous avez les paramètres requis, vous pouvez préparer la charge
utile à envoyer au flux. La charge utile est un [\[Hashtable\]] contenant les
valeurs des paramètres requis par le flux:

```powershell
$ChargeUtile = @{
    UserPrincipalName = 'marcel.untel@adresse.courriel'
    NouveauNumeroPermis = '12345'
    AncienNumeroPermis = 'R98765'
    AdresseCourrielPourErreurs = 'mon@adresse.courriel'
}
```

### Démarrage du flux

Enfin, vous pouvez démarrer le flux en utilisant la commande
`New-CvCfFlowExecution`:

```powershell
New-CvCfFlowExecution -FlowId $IdFlux -InputParameters $ChargeUtile
```

En cas de succès, la commande devrait retourner l'ID d'exécution. Cet
identifiant est unique à chaque démarrage du flux et peut être utilisé pour
suivre l'exécution du flux dans le portail de CoreView.

### Script complet

Voici un script complet qui combine les étapes précédentes:

```powershell
# Importation du module CoreView-PS:
Import-Module 'C:\CoreView-PS\coreview-ps.psd1' -Force -Global  # modifiez le chemin au besoin

# Connexion à CoreView:
$CleApi = 'xxxxxx-xxxxxx-xxxxxx-xxxxxx-xxxxxx'
$CleApiSS = ConvertTo-SecureString -String $CleApi -AsPlainText -Force
Connect-CvAPI -ApiKey $CleApiSS

# Démarrage d'un flux:
$IdFlux = 'abdef181-8b6e-****-****-************'
$ChargeUtile = @{
    UserPrincipalName = 'marcel.untel@dresse.courriel'
    NouveauNumeroPermis = '12345'
    AncienNumeroPermis = 'R98765'
    AdresseCourrielPourErreurs = 'mon@adresse.courriel'
}
$IdExecution = New-CvCfFlowExecution -FlowId $IdFlux -InputParameters $ChargeUtile

# Affichage de l'ID d'exécution:
Write-Output "ID d'exécution: $IdExecution"
```

### Utilisation avancée

Pour une utilisation plus avancée, vous pouvez consulter la page
[Exécuter un flux](fr/demarrer-flux.md) pour plus d'informations.

[prérequis]: fr/prerequis.md
[téléchargé]: fr/telechargement.md
[installation]: fr/installation.md
[\[SecureString\]]: https://learn.microsoft.com/fr-ca/powershell/module/microsoft.powershell.security/convertto-securestring?view=powershell-7.4
[\[Hashtable\]]: https://learn.microsoft.com/fr-ca/powershell/module/microsoft.powershell.core/about/about_hash_tables?view=powershell-7.4
