# Gestion des secrets avec SecretManagement

Le module [SecretManagement] de PowerShell permet de gérer des secrets de
manière sécurisée afin de ne pas les stocker en clair dans les scripts
PowerShell.

!> Nous vous recommandons de stocker votre clé d'API à l'aide du module
   [SecretManagement] afin de ne pas l'inclure en clair dans le script.

Vous trouverez ci-dessous un exemple d'utilisation du module [SecretManagement]
pour stocker une clé d'API.

<br>

## Installation de SecretManagement et de SecretStore

Pour commencer, vous devez installer les modules [SecretManagement] et
[SecretStore]. Vous pouvez le faire en exécutant les commandes suivantes dans
une session PowerShell 7:

```powershell
Install-Module -Name Microsoft.PowerShell.SecretManagement -Force -AllowClobber -Scope CurrentUser
Install-Module -Name Microsoft.PowerShell.SecretStore -Force -AllowClobber -Scope CurrentUser
Import-Module -Name Microsoft.PowerShell.SecretManagement
Import-Module -Name Microsoft.PowerShell.SecretStore
```

<br>

## Création du coffre-fort

Pour stocker votre clé d'API, vous devez d'abord créer un coffre-fort à l'aide
du module [SecretStore]. Vous pouvez le faire en exécutant les commandes
suivantes dans une session PowerShell 7:

```powershell
# Création du mot de passe du coffre-fort:
$MdpCoffre = Get-SecureRandom ('!'..'~') -Count 64 | Join-String | ConvertTo-SecureString -AsPlainText -Force

# Création du coffre-fort:
Register-SecretVault -Name 'SecretStore' -ModuleName Microsoft.PowerShell.SecretStore -AllowClobber -DefaultVault

# Assignation du mot de passe au coffre-fort:
Set-SecretStoreConfiguration -Authentication Password -Password $MdpCoffre -Interaction None -Default -Confirm:$false

# Exportation de la clé du coffre-fort pour une utilisation ultérieure:
New-Item -Path "$env:USERPROFILE\.secretstore" -ItemType Directory -Force | Out-Null
$MdpCoffre | Export-Clixml -Path "$env:USERPROFILE\.secretstore\cle.xml"
```

La dernière commande crée un fichier `cle.xml` dans le répertoire `.secretstore`
de votre profil utilisateur. Ce fichier contient le mot de passe du coffre-fort
et vous permettra de déverrouiller le coffre-fort ultérieurement. Veuillez noter
que seul l'utilisateur qui a créé le coffre-fort et le fichier `cle.xml` pourra
le déverrouiller.

!> **L'utilisateur qui crée le coffre-fort et le fichier cle.xml doit être le
   même que celui qui utilisera le coffre-fort.** Par exemple, si l'utilisateur
   `Paul` crée le coffre-fort et l'utilisateur `CS` tente de l'utiliser dans un
   script, cela ne fonctionnera pas.

<br>

## Stockage de la clé d'API

Une fois le coffre-fort créé, vous pouvez stocker votre clé d'API en utilisant
le module [SecretManagement]. Vous pouvez le faire en exécutant les commandes
suivantes dans une session PowerShell 7:

```powershell
$CleApi = '************'
$NomDeLaCle = 'CleApiCoreView'

# Sauvegarde de la clé d'API dans le coffre-fort:
$MdpCoffre = Import-Clixml -Path "$env:USERPROFILE\.secretstore\cle.xml"
Unlock-SecretStore -Password $MdpCoffre
$CleApiSS = ConvertTo-SecureString -String $CleApi -AsPlainText -Force
Set-Secret -Name $NomDeLaCle -Secret $CleApiSS
```

?> La valeur de `$NomDeLaCle` est arbitraire et peut être remplacée par un nom
   plus significatif pour votre clé d'API. Vous devrez utiliser ce même nom pour
   récupérer la clé d'API dans vos scripts.

?> Vous pouvez utiliser les mêmes commandes pour mettre à jour une clé d'API
   déjà enregistrée dans le coffre-fort. Assurez-vous d'utiliser le même nom
   de clé pour remplacer la clé existante.

<br>

## Utilisation dans un script

Vous pouvez maintenant utiliser votre clé d'API stockée dans le coffre-fort
dans vos scripts PowerShell. Voici un exemple d'utilisation:

```powershell
$NomDeLaCle = 'CleApiCoreView'

# Récupération de la clé d'API depuis le coffre-fort:
Unlock-SecretStore -Password (Import-Clixml -Path "$env:USERPROFILE\.secretstore\cle.xml")
$CleApiSS = Get-Secret -Name $NomDeLaCle

# Connexion à l'API de CoreView:
Connect-CvAPI -APIKey $CleApiSS
```

[SecretManagement]: https://learn.microsoft.com/fr-ca/powershell/utility-modules/secretmanagement/get-started/using-secretstore?view=ps-modules
[SecretStore]: https://learn.microsoft.com/fr-ca/powershell/utility-modules/secretmanagement/get-started/using-secretstore?view=ps-modules
