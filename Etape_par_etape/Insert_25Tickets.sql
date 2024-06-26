--Insertions des 25 tickets exemples
EXEC InsertTicket 
    @ProduitNom = 'Trader en Herbe',
    @NumeroVersion = '1.0',
    @SystemeExploitationNom = 'Linux',
    @Statut = 'R�solu',
    @Probleme = 'L�application se fige lors de la visualisation du graphique de tendance.',
    @DateCreation = '2022-12-20',
    @DateResolution = '2023-01-15',
    @Resolution = 'Mise � jour du module de rendu graphique pour corriger le bug';

EXEC InsertTicket 
    @ProduitNom = 'Trader en Herbe',
    @NumeroVersion = '1.2',
    @SystemeExploitationNom = 'iOS',
    @Statut = 'R�solu',
    @Probleme = 'L�utilisateur re�oit des notifications en double.',
    @DateCreation = '2023-01-05',
    @DateResolution = '2023-02-20',
    @Resolution = 'Correction du script de notification pour �viter les envois multiples';

EXEC InsertTicket 
    @ProduitNom = 'Ma�tre des Investissements',
    @NumeroVersion = '1.0',
    @SystemeExploitationNom = 'MacOS',
    @Statut = 'R�solu',
    @Probleme = 'L�application plante lors de la mise � jour du portefeuille.',
    @DateCreation = '2023-01-10',
    @DateResolution = '2023-03-18',
    @Resolution = 'Correction du bug dans le module de mise � jour des donn�es';

EXEC InsertTicket 
    @ProduitNom = 'Planificateur d�Entra�nement',
    @NumeroVersion = '1.1',
    @SystemeExploitationNom = 'Android',
    @Statut = 'R�solu',
    @Probleme = 'Les rappels de s�ance ne fonctionnent pas correctement.',
    @DateCreation = '2023-01-15',
    @DateResolution = '2023-04-22',
    @Resolution = 'Ajustement des param�tres de notifications dans le code';

EXEC InsertTicket 
    @ProduitNom = 'Planificateur d�Anxi�t� Sociale',
    @NumeroVersion = '1.0',
    @SystemeExploitationNom = 'Windows',
    @Statut = 'R�solu',
    @Probleme = 'L�application ne sauvegarde pas les nouvelles entr�es.',
    @DateCreation = '2023-01-20',
    @DateResolution = '2023-05-30',
    @Resolution = 'Correction du bug de sauvegarde des donn�es utilisateur';

EXEC InsertTicket 
    @ProduitNom = 'Trader en Herbe',
    @NumeroVersion = '1.3',
    @SystemeExploitationNom = 'Windows',
    @Statut = 'En cours',
    @Probleme = 'Probl�me d�affichage des informations de portefeuille apr�s une mise � jour',
    @DateCreation = '2023-02-01';

EXEC InsertTicket 
    @ProduitNom = 'Planificateur d�Entra�nement',
    @NumeroVersion = '2.0',
    @SystemeExploitationNom = 'MacOS',
    @Statut = 'R�solu',
    @Probleme = 'L�application ne se synchronise pas avec le calendrier de l�utilisateur.',
    @DateCreation = '2023-02-10',
    @DateResolution = '2023-07-10',
    @Resolution = 'R��criture du code de synchronisation pour assurer la compatibilit� avec les calendriers externes';

EXEC InsertTicket 
    @ProduitNom = 'Ma�tre des Investissements',
    @NumeroVersion = '2.1',
    @SystemeExploitationNom = 'Android',
    @Statut = 'En cours',
    @Probleme = 'Probl�me de connexion aux serveurs de donn�es en utilisant les r�seaux mobiles',
    @DateCreation = '2023-02-15';

EXEC InsertTicket 
    @ProduitNom = 'Planificateur d�Anxi�t� Sociale',
    @NumeroVersion = '1.1',
    @SystemeExploitationNom = 'iOS',
    @Statut = 'R�solu',
    @Probleme = 'Les sessions de coaching ne s�enregistrent pas correctement.',
    @DateCreation = '2023-02-20',
    @DateResolution = '2023-07-22',
    @Resolution = 'R�vision du module d�enregistrement des sessions';

EXEC InsertTicket 
    @ProduitNom = 'Trader en Herbe',
    @NumeroVersion = '1.1',
    @SystemeExploitationNom = 'MacOS',
    @Statut = 'En cours',
    @Probleme = 'L�application plante lors de l�analyse technique avanc�e',
    @DateCreation = '2023-03-01';

EXEC InsertTicket 
    @ProduitNom = 'Ma�tre des Investissements',
    @NumeroVersion = '2.0',
    @SystemeExploitationNom = 'iOS',
    @Statut = 'R�solu',
    @Probleme = 'Les notifications push ne fonctionnent pas sur Windows 11.',
    @DateCreation = '2023-03-10',
    @DateResolution = '2023-08-05',
    @Resolution = 'Mise � jour des param�tres de notification pour la compatibilit� avec Windows 11';

EXEC InsertTicket 
    @ProduitNom = 'Planificateur d�Entra�nement',
    @NumeroVersion = '1.1',
    @SystemeExploitationNom = 'Windows Mobile',
    @Statut = 'R�solu',
    @Probleme = 'Probl�me de compatibilit� avec les capteurs de fr�quence cardiaque.',
    @DateCreation = '2023-03-15',
    @DateResolution = '2023-08-12',
    @Resolution = 'Mise � jour du module de gestion des capteurs';

EXEC InsertTicket 
    @ProduitNom = 'Planificateur d�Anxi�t� Sociale',
    @NumeroVersion = '1.0',
    @SystemeExploitationNom = 'MacOS',
    @Statut = 'R�solu',
    @Probleme = 'L�application ne d�marre pas apr�s l�installation.',
    @DateCreation = '2023-03-20',
    @DateResolution = '2023-08-20',
    @Resolution = 'Correction du script d�installation pour Linux';

EXEC InsertTicket 
    @ProduitNom = 'Trader en Herbe',
    @NumeroVersion = '1.2',
    @SystemeExploitationNom = 'Windows Mobile',
    @Statut = 'En cours',
    @Probleme = 'Probl�me de synchronisation des donn�es de trading en temps r�el',
    @DateCreation = '2023-04-01';

EXEC InsertTicket 
    @ProduitNom = 'Ma�tre des Investissements',
    @NumeroVersion = '1.0',
    @SystemeExploitationNom = 'MacOS',
    @Statut = 'R�solu',
    @Probleme = 'Les utilisateurs ne peuvent pas se connecter apr�s une mise � jour de s�curit�.',
    @DateCreation = '2023-04-05',
    @DateResolution = '2023-08-30',
    @Resolution = 'R�vision du module de connexion pour r�soudre les probl�mes de compatibilit�';

EXEC InsertTicket 
    @ProduitNom = 'Planificateur d�Entra�nement',
    @NumeroVersion = '2.0',
    @SystemeExploitationNom = 'iOS',
    @Statut = 'R�solu',
    @Probleme = 'Les donn�es d�entra�nement ne se synchronisent pas avec l�application Sant�.',
    @DateCreation = '2023-04-10',
    @DateResolution = '2023-09-05',
    @Resolution = 'Ajustement de l�API pour garantir une synchronisation correcte';

EXEC InsertTicket 
    @ProduitNom = 'Planificateur d�Anxi�t� Sociale',
    @NumeroVersion = '1.1',
    @SystemeExploitationNom = 'Android',
    @Statut = 'En cours',
    @Probleme = 'L�application consomme trop de batterie en arri�re-plan',
    @DateCreation = '2023-04-15';

EXEC InsertTicket 
    @ProduitNom = 'Trader en Herbe',
    @NumeroVersion = '1.3',
    @SystemeExploitationNom = 'MacOS',
    @Statut = 'En cours',
    @Probleme = 'L�application ne se lance pas sur les nouvelles versions de macOS',
    @DateCreation = '2023-04-20';

EXEC InsertTicket 
    @ProduitNom = 'Ma�tre des Investissements',
    @NumeroVersion = '2.1',
    @SystemeExploitationNom = 'Windows',
    @Statut = 'R�solu',
    @Probleme = 'Les graphiques de performance ne se chargent pas correctement.',
    @DateCreation = '2023-05-01',
    @DateResolution = '2023-09-20',
    @Resolution = 'R��criture du module de chargement des graphiques pour am�liorer les performances';

EXEC InsertTicket 
    @ProduitNom = 'Planificateur d�Entra�nement',
    @NumeroVersion = '1.0',
    @SystemeExploitationNom = 'Linux',
    @Statut = 'R�solu',
    @Probleme = 'Probl�me de compatibilit� avec certains appareils Linux sp�cifiques.',
    @DateCreation = '2023-05-05',
    @DateResolution = '2023-09-25',
    @Resolution = 'Mise � jour du code pour am�liorer la compatibilit� avec diff�rents noyaux Linux';

EXEC InsertTicket 
    @ProduitNom = 'Planificateur d�Anxi�t� Sociale',
    @NumeroVersion = '1.0',
    @SystemeExploitationNom = 'MacOS',
    @Statut = 'En cours',
    @Probleme = 'Les sessions de coaching ne s�enregistrent pas correctement sur macOS',
    @DateCreation = '2023-05-10';

EXEC InsertTicket 
    @ProduitNom = 'Trader en Herbe',
    @NumeroVersion = '1.2',
    @SystemeExploitationNom = 'Android',
    @Statut = 'R�solu',
    @Probleme = 'Les notifications push ne fonctionnent pas correctement.',
    @DateCreation = '2023-05-15',
    @DateResolution = '2023-10-05',
    @Resolution = 'Correction des param�tres de notification pour Android';

EXEC InsertTicket 
    @ProduitNom = 'Ma�tre des Investissements',
    @NumeroVersion = '2.0',
    @SystemeExploitationNom = 'Android',
    @Statut = 'R�solu',
    @Probleme = 'L�application ne se lance pas apr�s une mise � jour du noyau.',
    @DateCreation = '2023-05-20',
    @DateResolution = '2023-10-10',
    @Resolution = 'Ajustement du script de lancement pour la compatibilit� avec les nouvelles versions du noyau';

EXEC InsertTicket 
    @ProduitNom = 'Planificateur d�Entra�nement',
    @NumeroVersion = '1.1',
    @SystemeExploitationNom = 'iOS',
    @Statut = 'En cours',
    @Probleme = 'Les donn�es de fr�quence cardiaque ne se synchronisent pas avec l�application',
    @DateCreation = '2023-05-25';

EXEC InsertTicket 
    @ProduitNom = 'Planificateur d�Anxi�t� Sociale',
    @NumeroVersion = '1.1',
    @SystemeExploitationNom = 'Android',
    @Statut = 'R�solu',
    @Probleme = 'L�application ne se lance pas apr�s une mise � jour du syst�me.',
    @DateCreation = '2023-06-01',
    @DateResolution = '2023-10-20',
    @Resolution = 'Correction du module de d�marrage pour la compatibilit� avec la mise � jour du syst�me';