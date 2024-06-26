-- Insertion des produits
DECLARE @ProduitID1 INT, @ProduitID2 INT, @ProduitID3 INT, @ProduitID4 INT;

EXEC @ProduitID1 = InsertProduit @Nom = 'Trader en Herbe';
EXEC @ProduitID2 = InsertProduit @Nom = 'Maître des Investissements';
EXEC @ProduitID3 = InsertProduit @Nom = 'Planificateur d’Entraînement';
EXEC @ProduitID4 = InsertProduit @Nom = 'Planificateur d’Anxiété Sociale';

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
EXEC @StatutID2 = InsertStatut @StatutNom = 'Résolu';

DECLARE @ProduitVersionID1 INT, @ProduitVersionID2 INT, @ProduitVersionID3 INT, @ProduitVersionID4 INT, @ProduitVersionID5 INT, @ProduitVersionID6 INT, @ProduitVersionID7 INT, @ProduitVersionID8 INT, @ProduitVersionID9 INT, @ProduitVersionID10 INT, @ProduitVersionID11 INT, @ProduitVersionID12 INT;

-- Insérer les versions pour le produit 'Trader en Herbe'
EXEC @ProduitVersionID1 = InsertProduitVersion @NumeroVersion = '1.0', @ProduitNom = 'Trader en Herbe';
EXEC @ProduitVersionID2 = InsertProduitVersion @NumeroVersion = '1.1', @ProduitNom = 'Trader en Herbe';
EXEC @ProduitVersionID3 = InsertProduitVersion @NumeroVersion = '1.2', @ProduitNom = 'Trader en Herbe';
EXEC @ProduitVersionID4 = InsertProduitVersion @NumeroVersion = '1.3', @ProduitNom = 'Trader en Herbe';

-- Insérer les versions pour le produit 'Maître des Investissements'
EXEC @ProduitVersionID5 = InsertProduitVersion @NumeroVersion = '1.0', @ProduitNom = 'Maître des Investissements';
EXEC @ProduitVersionID6 = InsertProduitVersion @NumeroVersion = '2.0', @ProduitNom = 'Maître des Investissements';
EXEC @ProduitVersionID7 = InsertProduitVersion @NumeroVersion = '2.1', @ProduitNom = 'Maître des Investissements';

-- Insérer les versions pour le produit 'Planificateur d’Entraînement'
EXEC @ProduitVersionID8 = InsertProduitVersion @NumeroVersion = '1.0', @ProduitNom = 'Planificateur d’Entraînement';
EXEC @ProduitVersionID9 = InsertProduitVersion @NumeroVersion = '1.1', @ProduitNom = 'Planificateur d’Entraînement';
EXEC @ProduitVersionID10 = InsertProduitVersion @NumeroVersion = '2.0', @ProduitNom = 'Planificateur d’Entraînement';

-- Insérer les versions pour le produit 'Planificateur d’Anxiété Sociale'
EXEC @ProduitVersionID11 = InsertProduitVersion @NumeroVersion = '1.0', @ProduitNom = 'Planificateur d’Anxiété Sociale';
EXEC @ProduitVersionID12 = InsertProduitVersion @NumeroVersion = '1.1', @ProduitNom = 'Planificateur d’Anxiété Sociale';

-- Insertion des systèmes d'exploitation

EXEC  InsertSystemeExploitation @Nom = 'Linux';
EXEC  InsertSystemeExploitation @Nom = 'MacOS';
EXEC  InsertSystemeExploitation @Nom = 'Windows';
EXEC  InsertSystemeExploitation @Nom = 'Android';
EXEC  InsertSystemeExploitation @Nom = 'iOS';
EXEC  InsertSystemeExploitation @Nom = 'Windows Mobile';

-- Insérer les relations Version-Système d'exploitation en utilisant la procédure stockée InsertVersionSystemeExploitation
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

-- Maître des Investissements
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '1.0', @ProduitNom = 'Maître des Investissements', @SystemeExploitationNom = 'MacOS';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '1.0', @ProduitNom = 'Maître des Investissements', @SystemeExploitationNom = 'iOS';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '2.0', @ProduitNom = 'Maître des Investissements', @SystemeExploitationNom = 'MacOS';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '2.0', @ProduitNom = 'Maître des Investissements', @SystemeExploitationNom = 'Android';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '2.0', @ProduitNom = 'Maître des Investissements', @SystemeExploitationNom = 'iOS';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '2.1', @ProduitNom = 'Maître des Investissements', @SystemeExploitationNom = 'MacOS';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '2.1', @ProduitNom = 'Maître des Investissements', @SystemeExploitationNom = 'Windows';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '2.1', @ProduitNom = 'Maître des Investissements', @SystemeExploitationNom = 'Android';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '2.1', @ProduitNom = 'Maître des Investissements', @SystemeExploitationNom = 'iOS';

-- Planificateur d’Entraînement
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '1.0', @ProduitNom = 'Planificateur d’Entraînement', @SystemeExploitationNom = 'Linux';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '1.0', @ProduitNom = 'Planificateur d’Entraînement', @SystemeExploitationNom = 'MacOS';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '1.1', @ProduitNom = 'Planificateur d’Entraînement', @SystemeExploitationNom = 'Linux';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '1.1', @ProduitNom = 'Planificateur d’Entraînement', @SystemeExploitationNom = 'MacOS';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '1.1', @ProduitNom = 'Planificateur d’Entraînement', @SystemeExploitationNom = 'Windows';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '1.1', @ProduitNom = 'Planificateur d’Entraînement', @SystemeExploitationNom = 'Android';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '1.1', @ProduitNom = 'Planificateur d’Entraînement', @SystemeExploitationNom = 'iOS';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '1.1', @ProduitNom = 'Planificateur d’Entraînement', @SystemeExploitationNom = 'Windows Mobile';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '2.0', @ProduitNom = 'Planificateur d’Entraînement', @SystemeExploitationNom = 'MacOS';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '2.0', @ProduitNom = 'Planificateur d’Entraînement', @SystemeExploitationNom = 'Windows';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '2.0', @ProduitNom = 'Planificateur d’Entraînement', @SystemeExploitationNom = 'Android';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '2.0', @ProduitNom = 'Planificateur d’Entraînement', @SystemeExploitationNom = 'iOS';

-- Planificateur d’Anxiété Sociale
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '1.0', @ProduitNom = 'Planificateur d’Anxiété Sociale', @SystemeExploitationNom = 'MacOS';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '1.0', @ProduitNom = 'Planificateur d’Anxiété Sociale', @SystemeExploitationNom = 'Windows';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '1.0', @ProduitNom = 'Planificateur d’Anxiété Sociale', @SystemeExploitationNom = 'Android';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '1.0', @ProduitNom = 'Planificateur d’Anxiété Sociale', @SystemeExploitationNom = 'iOS';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '1.1', @ProduitNom = 'Planificateur d’Anxiété Sociale', @SystemeExploitationNom = 'MacOS';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '1.1', @ProduitNom = 'Planificateur d’Anxiété Sociale', @SystemeExploitationNom = 'Windows';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '1.1', @ProduitNom = 'Planificateur d’Anxiété Sociale', @SystemeExploitationNom = 'Android';
EXEC InsertProduitVersionSystemeExploitation @NumeroVersion = '1.1', @ProduitNom = 'Planificateur d’Anxiété Sociale', @SystemeExploitationNom = 'iOS';
