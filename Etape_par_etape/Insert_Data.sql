-- Insertion des produits
DECLARE @ProduitID1 INT, @ProduitID2 INT, @ProduitID3 INT, @ProduitID4 INT;

EXEC @ProduitID1 = InsertProduit @Nom = 'Trader en Herbe';
EXEC @ProduitID2 = InsertProduit @Nom = 'Ma�tre des Investissements';
EXEC @ProduitID3 = InsertProduit @Nom = 'Planificateur d�Entra�nement';
EXEC @ProduitID4 = InsertProduit @Nom = 'Planificateur d�Anxi�t� Sociale';

-- Insertion des versions
DECLARE @VersionID1 INT, @VersionID2 INT, @VersionID3 INT, @VersionID4 INT, @VersionID5 INT, @VersionID6 INT;

EXEC @VersionID1 = InsertVersion @NumeroVersion = '1.0';
EXEC @VersionID2 = InsertVersion @NumeroVersion = '1.1';
EXEC @VersionID3 = InsertVersion @NumeroVersion = '1.2';
EXEC @VersionID4 = InsertVersion @NumeroVersion = '1.3';
EXEC @VersionID5 = InsertVersion @NumeroVersion = '2.0';
EXEC @VersionID6 = InsertVersion @NumeroVersion = '2.1';

-- Insertion des statuts
DECLARE @StatutID1 INT, @StatutID2 INT;

EXEC @StatutID1 = InsertStatut @StatutNom = 'En Cours';
EXEC @StatutID2 = InsertStatut @StatutNom = 'R�solu';

DECLARE @ProduitVersionID1 INT, @ProduitVersionID2 INT, @ProduitVersionID3 INT, @ProduitVersionID4 INT, @ProduitVersionID5 INT, @ProduitVersionID6 INT, @ProduitVersionID7 INT, @ProduitVersionID8 INT, @ProduitVersionID9 INT, @ProduitVersionID10 INT, @ProduitVersionID11 INT, @ProduitVersionID12 INT;

-- Ins�rer les versions pour le produit 'Trader en Herbe'
EXEC @ProduitVersionID1 = InsertProduitVersion @NumeroVersion = '1.0', @ProduitNom = 'Trader en Herbe';
EXEC @ProduitVersionID2 = InsertProduitVersion @NumeroVersion = '1.1', @ProduitNom = 'Trader en Herbe';
EXEC @ProduitVersionID3 = InsertProduitVersion @NumeroVersion = '1.2', @ProduitNom = 'Trader en Herbe';
EXEC @ProduitVersionID4 = InsertProduitVersion @NumeroVersion = '1.3', @ProduitNom = 'Trader en Herbe';

-- Ins�rer les versions pour le produit 'Ma�tre des Investissements'
EXEC @ProduitVersionID5 = InsertProduitVersion @NumeroVersion = '1.0', @ProduitNom = 'Ma�tre des Investissements';
EXEC @ProduitVersionID6 = InsertProduitVersion @NumeroVersion = '2.0', @ProduitNom = 'Ma�tre des Investissements';
EXEC @ProduitVersionID7 = InsertProduitVersion @NumeroVersion = '2.1', @ProduitNom = 'Ma�tre des Investissements';

-- Ins�rer les versions pour le produit 'Planificateur d�Entra�nement'
EXEC @ProduitVersionID8 = InsertProduitVersion @NumeroVersion = '1.0', @ProduitNom = 'Planificateur d�Entra�nement';
EXEC @ProduitVersionID9 = InsertProduitVersion @NumeroVersion = '1.1', @ProduitNom = 'Planificateur d�Entra�nement';
EXEC @ProduitVersionID10 = InsertProduitVersion @NumeroVersion = '2.0', @ProduitNom = 'Planificateur d�Entra�nement';

-- Ins�rer les versions pour le produit 'Planificateur d�Anxi�t� Sociale'
EXEC @ProduitVersionID11 = InsertProduitVersion @NumeroVersion = '1.0', @ProduitNom = 'Planificateur d�Anxi�t� Sociale';
EXEC @ProduitVersionID12 = InsertProduitVersion @NumeroVersion = '1.1', @ProduitNom = 'Planificateur d�Anxi�t� Sociale';

-- Insertion des syst�mes d'exploitation

EXEC  InsertSystemeExploitation @Nom = 'Linux';
EXEC  InsertSystemeExploitation @Nom = 'MacOS';
EXEC  InsertSystemeExploitation @Nom = 'Windows';
EXEC  InsertSystemeExploitation @Nom = 'Android';
EXEC  InsertSystemeExploitation @Nom = 'iOS';
EXEC  InsertSystemeExploitation @Nom = 'Windows Mobile';

-- Ins�rer les relations Version-Syst�me d'exploitation en utilisant la proc�dure stock�e InsertVersionSystemeExploitation
-- Trader en Herbe
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '1.0', @ProduitNom = 'Trader en Herbe', @SystemeExploitationNom = 'Linux';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '1.0', @ProduitNom = 'Trader en Herbe', @SystemeExploitationNom = 'Windows';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '1.1', @ProduitNom = 'Trader en Herbe', @SystemeExploitationNom = 'Linux';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '1.1', @ProduitNom = 'Trader en Herbe', @SystemeExploitationNom = 'MacOS';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '1.1', @ProduitNom = 'Trader en Herbe', @SystemeExploitationNom = 'Windows';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '1.2', @ProduitNom = 'Trader en Herbe', @SystemeExploitationNom = 'Linux';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '1.2', @ProduitNom = 'Trader en Herbe', @SystemeExploitationNom = 'MacOS';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '1.2', @ProduitNom = 'Trader en Herbe', @SystemeExploitationNom = 'Windows';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '1.2', @ProduitNom = 'Trader en Herbe', @SystemeExploitationNom = 'Android';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '1.2', @ProduitNom = 'Trader en Herbe', @SystemeExploitationNom = 'iOS';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '1.2', @ProduitNom = 'Trader en Herbe', @SystemeExploitationNom = 'Windows Mobile';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '1.3', @ProduitNom = 'Trader en Herbe', @SystemeExploitationNom = 'MacOS';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '1.3', @ProduitNom = 'Trader en Herbe', @SystemeExploitationNom = 'Windows';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '1.3', @ProduitNom = 'Trader en Herbe', @SystemeExploitationNom = 'Android';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '1.3', @ProduitNom = 'Trader en Herbe', @SystemeExploitationNom = 'iOS';

-- Ma�tre des Investissements
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '1.0', @ProduitNom = 'Ma�tre des Investissements', @SystemeExploitationNom = 'MacOS';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '1.0', @ProduitNom = 'Ma�tre des Investissements', @SystemeExploitationNom = 'iOS';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '2.0', @ProduitNom = 'Ma�tre des Investissements', @SystemeExploitationNom = 'MacOS';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '2.0', @ProduitNom = 'Ma�tre des Investissements', @SystemeExploitationNom = 'Android';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '2.0', @ProduitNom = 'Ma�tre des Investissements', @SystemeExploitationNom = 'iOS';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '2.1', @ProduitNom = 'Ma�tre des Investissements', @SystemeExploitationNom = 'MacOS';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '2.1', @ProduitNom = 'Ma�tre des Investissements', @SystemeExploitationNom = 'Windows';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '2.1', @ProduitNom = 'Ma�tre des Investissements', @SystemeExploitationNom = 'Android';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '2.1', @ProduitNom = 'Ma�tre des Investissements', @SystemeExploitationNom = 'iOS';

-- Planificateur d�Entra�nement
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '1.0', @ProduitNom = 'Planificateur d�Entra�nement', @SystemeExploitationNom = 'Linux';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '1.0', @ProduitNom = 'Planificateur d�Entra�nement', @SystemeExploitationNom = 'MacOS';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '1.1', @ProduitNom = 'Planificateur d�Entra�nement', @SystemeExploitationNom = 'Linux';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '1.1', @ProduitNom = 'Planificateur d�Entra�nement', @SystemeExploitationNom = 'MacOS';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '1.1', @ProduitNom = 'Planificateur d�Entra�nement', @SystemeExploitationNom = 'Windows';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '1.1', @ProduitNom = 'Planificateur d�Entra�nement', @SystemeExploitationNom = 'Android';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '1.1', @ProduitNom = 'Planificateur d�Entra�nement', @SystemeExploitationNom = 'iOS';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '1.1', @ProduitNom = 'Planificateur d�Entra�nement', @SystemeExploitationNom = 'Windows Mobile';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '2.0', @ProduitNom = 'Planificateur d�Entra�nement', @SystemeExploitationNom = 'MacOS';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '2.0', @ProduitNom = 'Planificateur d�Entra�nement', @SystemeExploitationNom = 'Windows';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '2.0', @ProduitNom = 'Planificateur d�Entra�nement', @SystemeExploitationNom = 'Android';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '2.0', @ProduitNom = 'Planificateur d�Entra�nement', @SystemeExploitationNom = 'iOS';

-- Planificateur d�Anxi�t� Sociale
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '1.0', @ProduitNom = 'Planificateur d�Anxi�t� Sociale', @SystemeExploitationNom = 'MacOS';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '1.0', @ProduitNom = 'Planificateur d�Anxi�t� Sociale', @SystemeExploitationNom = 'Windows';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '1.0', @ProduitNom = 'Planificateur d�Anxi�t� Sociale', @SystemeExploitationNom = 'Android';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '1.0', @ProduitNom = 'Planificateur d�Anxi�t� Sociale', @SystemeExploitationNom = 'iOS';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '1.1', @ProduitNom = 'Planificateur d�Anxi�t� Sociale', @SystemeExploitationNom = 'MacOS';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '1.1', @ProduitNom = 'Planificateur d�Anxi�t� Sociale', @SystemeExploitationNom = 'Windows';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '1.1', @ProduitNom = 'Planificateur d�Anxi�t� Sociale', @SystemeExploitationNom = 'Android';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '1.1', @ProduitNom = 'Planificateur d�Anxi�t� Sociale', @SystemeExploitationNom = 'iOS';
