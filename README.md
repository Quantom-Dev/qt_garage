# QT-Garage - Système de Garage pour ESX Legacy

##  Description
QT-Garage est un système de garage moderne et élégant pour votre serveur FiveM. Conçu spécifiquement pour ESX Legacy, ce script vous permet de stocker et récupérer vos véhicules dans différents points de la carte avec une interface utilisateur fluide et intuitive.

##  Caractéristiques
-  Compatible ESX Legacy
-  Interface utilisateur moderne et responsive
-  Affichage des images de véhicules
-  Informations détaillées sur chaque véhicule (plaque, état moteur, carrosserie, niveau de carburant)
-  Plusieurs emplacements de garage configurables
-  Fonction de recherche pour trouver rapidement vos véhicules
-  Système de fourrière intégré
-  Hautement configurable via le fichier config.lua

##  Prérequis
- ESX Legacy
- oxmysql

## Installation
1. Téléchargez les fichiers et placez-les dans votre dossier resources
2. Ajoutez `ensure qt_garage` à votre server.cfg
3. Assurez-vous que votre base de données contient une table `vehicles` avec les colonnes `model` et `price`
4. Redémarrez votre serveur

## Configuration
Vous pouvez personnaliser le script en modifiant le fichier `config.lua`:

- Emplacements des garages (coordonnées, type, PNJ)
- Messages de notification
- Comportement du stockage des véhicules au redémarrage du serveur

### Exemple de configuration de garage:
```lua
{
  garageType='normal', 
  npcHash='csb_prolsec', 
  npc=vector3(213.59, -809.34, 31.01), 
  npcHeading=0.0, 
  parking=vector3(215.68, -792.62, 29.83), 
  parkout=vector3(222.45, -801.44, 30.25), 
  vehicleHeading=246.89, 
  garageName='Garage'
}
```

## Utilisation
- Approchez-vous d'un PNJ de garage et appuyez sur E pour ouvrir l'interface
- Sélectionnez le véhicule que vous souhaitez sortir
- Pour garer un véhicule, conduisez-le jusqu'au marqueur de parking et appuyez sur E

## Images de véhicules
Pour ajouter des images personnalisées pour vos véhicules:
1. Placez vos images PNG dans le dossier `html/image/`
2. Nommez-les avec le nom du modèle en minuscules sans espaces ni caractères spéciaux (exemple: `adder.png`)

## Dépannage
- Si les images de véhicules ne s'affichent pas, vérifiez que leur nom correspond exactement au modèle
- Vérifiez les logs du serveur pour tout message d'erreur
- Assurez-vous que la table `owned_vehicles` contient les colonnes requises

## Support
Pour toute question ou problème, n'hésitez pas à ouvrir un ticket de support.

---
