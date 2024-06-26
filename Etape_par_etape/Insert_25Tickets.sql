--Insertions des 25 tickets exemples
EXEC InsertTicket 
    @ProduitNom = 'Trader en Herbe',
    @NumeroVersion = '1.0',
    @SystemeExploitationNom = 'Linux',
    @Statut = 'Résolu',
    @Probleme = 'L’application se fige lors de la visualisation du graphique de tendance.',
    @DateCreation = '2022-12-20',
    @DateResolution = '2023-01-15',
    @Resolution = 'Mise à jour du module de rendu graphique pour corriger le bug';

EXEC InsertTicket 
    @ProduitNom = 'Trader en Herbe',
    @NumeroVersion = '1.2',
    @SystemeExploitationNom = 'iOS',
    @Statut = 'Résolu',
    @Probleme = 'L’utilisateur reçoit des notifications en double.',
    @DateCreation = '2023-01-05',
    @DateResolution = '2023-02-20',
    @Resolution = 'Correction du script de notification pour éviter les envois multiples';

EXEC InsertTicket 
    @ProduitNom = 'Maître des Investissements',
    @NumeroVersion = '1.0',
    @SystemeExploitationNom = 'MacOS',
    @Statut = 'Résolu',
    @Probleme = 'L’application plante lors de la mise à jour du portefeuille.',
    @DateCreation = '2023-01-10',
    @DateResolution = '2023-03-18',
    @Resolution = 'Correction du bug dans le module de mise à jour des données';

EXEC InsertTicket 
    @ProduitNom = 'Planificateur d’Entraînement',
    @NumeroVersion = '1.1',
    @SystemeExploitationNom = 'Android',
    @Statut = 'Résolu',
    @Probleme = 'Les rappels de séance ne fonctionnent pas correctement.',
    @DateCreation = '2023-01-15',
    @DateResolution = '2023-04-22',
    @Resolution = 'Ajustement des paramètres de notifications dans le code';

EXEC InsertTicket 
    @ProduitNom = 'Planificateur d’Anxiété Sociale',
    @NumeroVersion = '1.0',
    @SystemeExploitationNom = 'Windows',
    @Statut = 'Résolu',
    @Probleme = 'L’application ne sauvegarde pas les nouvelles entrées.',
    @DateCreation = '2023-01-20',
    @DateResolution = '2023-05-30',
    @Resolution = 'Correction du bug de sauvegarde des données utilisateur';

EXEC InsertTicket 
    @ProduitNom = 'Trader en Herbe',
    @NumeroVersion = '1.3',
    @SystemeExploitationNom = 'Windows',
    @Statut = 'En cours',
    @Probleme = 'Problème d’affichage des informations de portefeuille après une mise à jour',
    @DateCreation = '2023-02-01';

EXEC InsertTicket 
    @ProduitNom = 'Planificateur d’Entraînement',
    @NumeroVersion = '2.0',
    @SystemeExploitationNom = 'MacOS',
    @Statut = 'Résolu',
    @Probleme = 'L’application ne se synchronise pas avec le calendrier de l’utilisateur.',
    @DateCreation = '2023-02-10',
    @DateResolution = '2023-07-10',
    @Resolution = 'Réécriture du code de synchronisation pour assurer la compatibilité avec les calendriers externes';

EXEC InsertTicket 
    @ProduitNom = 'Maître des Investissements',
    @NumeroVersion = '2.1',
    @SystemeExploitationNom = 'Android',
    @Statut = 'En cours',
    @Probleme = 'Problème de connexion aux serveurs de données en utilisant les réseaux mobiles',
    @DateCreation = '2023-02-15';

EXEC InsertTicket 
    @ProduitNom = 'Planificateur d’Anxiété Sociale',
    @NumeroVersion = '1.1',
    @SystemeExploitationNom = 'iOS',
    @Statut = 'Résolu',
    @Probleme = 'Les sessions de coaching ne s’enregistrent pas correctement.',
    @DateCreation = '2023-02-20',
    @DateResolution = '2023-07-22',
    @Resolution = 'Révision du module d’enregistrement des sessions';

EXEC InsertTicket 
    @ProduitNom = 'Trader en Herbe',
    @NumeroVersion = '1.1',
    @SystemeExploitationNom = 'MacOS',
    @Statut = 'En cours',
    @Probleme = 'L’application plante lors de l’analyse technique avancée',
    @DateCreation = '2023-03-01';

EXEC InsertTicket 
    @ProduitNom = 'Maître des Investissements',
    @NumeroVersion = '2.0',
    @SystemeExploitationNom = 'iOS',
    @Statut = 'Résolu',
    @Probleme = 'Les notifications push ne fonctionnent pas sur Windows 11.',
    @DateCreation = '2023-03-10',
    @DateResolution = '2023-08-05',
    @Resolution = 'Mise à jour des paramètres de notification pour la compatibilité avec Windows 11';

EXEC InsertTicket 
    @ProduitNom = 'Planificateur d’Entraînement',
    @NumeroVersion = '1.1',
    @SystemeExploitationNom = 'Windows Mobile',
    @Statut = 'Résolu',
    @Probleme = 'Problème de compatibilité avec les capteurs de fréquence cardiaque.',
    @DateCreation = '2023-03-15',
    @DateResolution = '2023-08-12',
    @Resolution = 'Mise à jour du module de gestion des capteurs';

EXEC InsertTicket 
    @ProduitNom = 'Planificateur d’Anxiété Sociale',
    @NumeroVersion = '1.0',
    @SystemeExploitationNom = 'MacOS',
    @Statut = 'Résolu',
    @Probleme = 'L’application ne démarre pas après l’installation.',
    @DateCreation = '2023-03-20',
    @DateResolution = '2023-08-20',
    @Resolution = 'Correction du script d’installation pour Linux';

EXEC InsertTicket 
    @ProduitNom = 'Trader en Herbe',
    @NumeroVersion = '1.2',
    @SystemeExploitationNom = 'Windows Mobile',
    @Statut = 'En cours',
    @Probleme = 'Problème de synchronisation des données de trading en temps réel',
    @DateCreation = '2023-04-01';

EXEC InsertTicket 
    @ProduitNom = 'Maître des Investissements',
    @NumeroVersion = '1.0',
    @SystemeExploitationNom = 'MacOS',
    @Statut = 'Résolu',
    @Probleme = 'Les utilisateurs ne peuvent pas se connecter après une mise à jour de sécurité.',
    @DateCreation = '2023-04-05',
    @DateResolution = '2023-08-30',
    @Resolution = 'Révision du module de connexion pour résoudre les problèmes de compatibilité';

EXEC InsertTicket 
    @ProduitNom = 'Planificateur d’Entraînement',
    @NumeroVersion = '2.0',
    @SystemeExploitationNom = 'iOS',
    @Statut = 'Résolu',
    @Probleme = 'Les données d’entraînement ne se synchronisent pas avec l’application Santé.',
    @DateCreation = '2023-04-10',
    @DateResolution = '2023-09-05',
    @Resolution = 'Ajustement de l’API pour garantir une synchronisation correcte';

EXEC InsertTicket 
    @ProduitNom = 'Planificateur d’Anxiété Sociale',
    @NumeroVersion = '1.1',
    @SystemeExploitationNom = 'Android',
    @Statut = 'En cours',
    @Probleme = 'L’application consomme trop de batterie en arrière-plan',
    @DateCreation = '2023-04-15';

EXEC InsertTicket 
    @ProduitNom = 'Trader en Herbe',
    @NumeroVersion = '1.3',
    @SystemeExploitationNom = 'MacOS',
    @Statut = 'En cours',
    @Probleme = 'L’application ne se lance pas sur les nouvelles versions de macOS',
    @DateCreation = '2023-04-20';

EXEC InsertTicket 
    @ProduitNom = 'Maître des Investissements',
    @NumeroVersion = '2.1',
    @SystemeExploitationNom = 'Windows',
    @Statut = 'Résolu',
    @Probleme = 'Les graphiques de performance ne se chargent pas correctement.',
    @DateCreation = '2023-05-01',
    @DateResolution = '2023-09-20',
    @Resolution = 'Réécriture du module de chargement des graphiques pour améliorer les performances';

EXEC InsertTicket 
    @ProduitNom = 'Planificateur d’Entraînement',
    @NumeroVersion = '1.0',
    @SystemeExploitationNom = 'Linux',
    @Statut = 'Résolu',
    @Probleme = 'Problème de compatibilité avec certains appareils Linux spécifiques.',
    @DateCreation = '2023-05-05',
    @DateResolution = '2023-09-25',
    @Resolution = 'Mise à jour du code pour améliorer la compatibilité avec différents noyaux Linux';

EXEC InsertTicket 
    @ProduitNom = 'Planificateur d’Anxiété Sociale',
    @NumeroVersion = '1.0',
    @SystemeExploitationNom = 'MacOS',
    @Statut = 'En cours',
    @Probleme = 'Les sessions de coaching ne s’enregistrent pas correctement sur macOS',
    @DateCreation = '2023-05-10';

EXEC InsertTicket 
    @ProduitNom = 'Trader en Herbe',
    @NumeroVersion = '1.2',
    @SystemeExploitationNom = 'Android',
    @Statut = 'Résolu',
    @Probleme = 'Les notifications push ne fonctionnent pas correctement.',
    @DateCreation = '2023-05-15',
    @DateResolution = '2023-10-05',
    @Resolution = 'Correction des paramètres de notification pour Android';

EXEC InsertTicket 
    @ProduitNom = 'Maître des Investissements',
    @NumeroVersion = '2.0',
    @SystemeExploitationNom = 'Android',
    @Statut = 'Résolu',
    @Probleme = 'L’application ne se lance pas après une mise à jour du noyau.',
    @DateCreation = '2023-05-20',
    @DateResolution = '2023-10-10',
    @Resolution = 'Ajustement du script de lancement pour la compatibilité avec les nouvelles versions du noyau';

EXEC InsertTicket 
    @ProduitNom = 'Planificateur d’Entraînement',
    @NumeroVersion = '1.1',
    @SystemeExploitationNom = 'iOS',
    @Statut = 'En cours',
    @Probleme = 'Les données de fréquence cardiaque ne se synchronisent pas avec l’application',
    @DateCreation = '2023-05-25';

EXEC InsertTicket 
    @ProduitNom = 'Planificateur d’Anxiété Sociale',
    @NumeroVersion = '1.1',
    @SystemeExploitationNom = 'Android',
    @Statut = 'Résolu',
    @Probleme = 'L’application ne se lance pas après une mise à jour du système.',
    @DateCreation = '2023-06-01',
    @DateResolution = '2023-10-20',
    @Resolution = 'Correction du module de démarrage pour la compatibilité avec la mise à jour du système';