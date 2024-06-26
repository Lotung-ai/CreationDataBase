# OCProjet6
Modélisez et créez une base de données pour une application .NET

Ce projet contient des fichiers SQL qui doivent être chargés dans une base de données SQL Server. Vous trouverez ci-dessous les instructions pour télécharger SQL Server Management Studio (SSMS) et importer les fichiers SQL stockés dans ce dépôt.

## Prérequis

Avant de commencer, assurez-vous d'avoir installé les éléments suivants :

- [SQL Server](https://www.microsoft.com/en-us/sql-server/sql-server-downloads)
- [SQL Server Management Studio (SSMS)](https://docs.microsoft.com/fr-fr/sql/ssms/download-sql-server-management-studio-ssms)

## Installation de SSMS

1. Allez sur le [site de téléchargement de SSMS](https://docs.microsoft.com/fr-fr/sql/ssms/download-sql-server-management-studio-ssms).
2. Cliquez sur le lien de téléchargement pour obtenir le programme d'installation de la dernière version de SSMS.
3. Une fois le fichier téléchargé, exécutez le programme d'installation et suivez les instructions à l'écran pour installer SSMS.

## Cloner le dépôt

Clonez ce dépôt sur votre machine locale en utilisant Git. Si vous n'avez pas Git installé, téléchargez-le [ici](https://git-scm.com/).

```bash
git clone https://github.com/Lotung-ai/OCProjet6.git
cd OCProjet6
```

## Ouvrir les fichiers SQL dans SSMS

1.  Ouvrez SQL Server Management Studio (SSMS).
2.  Connectez-vous à votre instance de SQL Server.
3.  Ouvrez le fichier SQL "Script_NexaWorksDB.sql" stockés dans ce dépôt. Pour ce faire, allez dans Fichier -> Ouvrir -> Fichier et sélectionnez le fichier SQL à charger.
4.  Cliquez sur le bouton Exécuter ou appuyez sur F5 pour exécuter le script SQL.

## Charger étape par étape
Si le script est trop lourd à charger il est possible de charger la base de donnée étape par étape.
Pour ce faire :

1.  Ouvrez SQL Server Management Studio (SSMS).
2.  Connectez-vous à votre instance de SQL Server.
3.  Allez dans Fichier -> Ouvrir -> Fichier et sélectionnez le dossier Etape_par_etape et charger et exécuter les fichier SQL dans cette ordre.
  a.  Create_DB.sql
  b.  PS_NexaWorkDB.sql
  c.  InsertData.sql
  d.  Insert_25Tickets.sql
  e. PS_ProblemesFiltre
