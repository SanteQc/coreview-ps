# Exécuter un flux

## Obtention de l'identifiant unique

Pour démarrer un flux, la première étape est toujours d'obtenir l'identifiant
unique du flux.

Pour obtenir l'identifiant unique du flux, vous devez trouver le flux dans le
portail de CoreView et vous rendre sur la page de détails du flux. Vous y
trouverez le nom, la date de mise à jour et l'identifiant unique du flux. Pour
référence, l'identifiant unique d'un flux est une chaîne de caractères de 36
caractères, généralement sous la forme `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`.

Pour cet exemple, nous utiliserons le flux intitulé
`MED - Changement numéro de permis résident a permanent` et ayant l'identifiant
unique `abcdef181-8b6e-****-****-************`.

## Obtention des paramètres d'entrée

Lorsque vous avez obtenu l'identifiant unique du flux, vous devez déterminer la
liste des paramètres requis pour démarrer le flux. Ces paramètres sont propres
à chaque flux et peuvent être trouvés à l'aide de la commande
`Get-CvCfFlowInputParameters`:

```powershell
$IdFlux = 'abcdef181-8b6e-****-****-************'
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

## Préparation de la charge utile

Une fois que vous avez les paramètres requis, vous pouvez préparer la charge
utile à envoyer au flux. La charge utile est un [\[Hashtable\]] contenant les
valeurs des paramètres requis par le flux:

```powershell
$ChargeUtile = @{
    UserPrincipalName = 'marcel.untel@adresse.courriel'
    NouveauNumeroPermis = '12345'
    AncienNumeroPermis = 'R67891'
    AdresseCourrielPourErreurs = 'mon@adresse.courriel'
}
```

?> Si vous désirez démarrer un flux qui ne possède pas de paramètres d'entrée,
   vous pouvez simplement utiliser une table de hachage vide (`@{}`).

## Démarrage d'un flux

Enfin, vous pouvez démarrer le flux en utilisant la commande
`New-CvCfFlowExecution`:

```powershell
$IdExecution = New-CvCfFlowExecution -FlowId $IdFlux -InputParameters $ChargeUtile
```

En cas de succès, la commande devrait retourner l'ID d'exécution. Cet
identifiant est unique à chaque démarrage du flux et peut être utilisé pour
suivre l'exécution du flux dans le portail de CoreView.

## Attendre la fin de l'exécution d'un flux

Pour obtenir le résultat de l'exécution d'un flux, vous devez d'abord attendre
que le flux soit terminé. Vous pouvez utiliser la commande
`Wait-CvCfFlowExecution` pour attendre la fin de l'exécution d'un flux:

```powershell
Wait-CvCfFlowExecution -ExecutionId $IdExecution
```

Lorsque le flux est en cours d'exécution, la commande bloquera l'exécution de
votre script jusqu'à ce que le flux soit terminé. Vous pouvez spécifier un
intervalle de temps à attendre entre chaque vérification de l'état du flux en
utilisant le paramètre `-Interval` (en secondes). Par défaut, l'intervalle est
de 5 secondes. Vous pouvez également spécifier un délai d'attente maximal en
utilisant le paramètre `-Timeout` (en secondes). Par défaut, le délai d'attente
est de 30 minutes.

Lorsque le flux est terminé, la commande cessera de bloquer et vous pourrez
alors obtenir le résultat de l'exécution du flux.

## Obtenir le résultat de l'exécution d'un flux

Pour obtenir le résultat de l'exécution d'un flux, vous pouvez utiliser la
commande `Get-CvCfFlowExecution`:

```powershell
$Execution = Get-CvCfFlowExecution -ExecutionId $IdExecution
```

Cette commande retourne une table de hachage:

```plaintext
Status           :  "Failed" | "Succeeded" | "Finished" | "Running"
Error            :  Cause de l'erreur, si le flux a échoué.
Input            :  Paramètres donnés en entrée au flux.
ExecutionHistory :  Liste des étapes de l'exécution du flux retournant des
                    données. Cette propriété peut être utilisée pour obtenir
                    les résultats de l'exécution du flux, tels que visibles dans
                    le portail de CoreView.
```

Voici un exemple de retour, lorsque convertit en JSON:

```json
{
    "ExecutionId": "12345678-dfa3-****-*****-************",
    "FlowId": "abcde98e9-92e5-****-****-************",
    "Status": "Failed",
    "Error": {
        "StepName": "Arrêter le flux si le nouvel établissement est interdit",
        "Details": "Action execution timed out",
        "Message": "States.Timeout",
        "Cause": "Workflow execution failed"
    },
    "Input": {
        "UserPrincipalName": "maxime.untel.med@ssss.gouv.qc.ca",
        "AcronymesEtablissements": "ETABLISSEMENT",
        "Action": "Ajout",
        "AdresseCourrielPourErreurs": "solange.untel@domaine.courriel"
    },
    "ExecutionHistory": [
        {
            "Output": {
                "NoPermis": "E12345678",
                "LstAncienNoPermis": [],
                "Identifiant": "EXT",
                "LstEtablissements": [
                    "ETAB"
                ],
                "Attribut11Canonique": "EXT-E12345678-ETAB-",
                "Etablissements": "ETAB",
                "NouvelleValeurAttribut11": "EXT-E12345678-ETAB-",
                "AncienNoPermis": ""
            },
            "StepName": "Extraire l'ancien attribut 11"
        },
        {
            "Output": {
                "Erreur": "Le code de médecin `EXT-E12345678-ETAB-` est invalide : \nL'acronyme d'établissement `ETAB` n'est pas permis. Seuls les établissements suivants sont autorisés:X,Y,Z,ETAB.\nVeuillez consulter la nomenclature de l'attribut 11 pour connaître les modalités qui s'appliquent aux comptes externes."
            },
            "StepName": "Évaluer les problèmes avec l'ajout"
        }
    ]
}
```

[\[Hashtable\]]: https://learn.microsoft.com/fr-ca/powershell/module/microsoft.powershell.core/about/about_hash_tables?view=powershell-7.4
