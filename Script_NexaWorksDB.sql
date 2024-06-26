-- Vérifier si la base de données existe déjà et la supprimer
USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = N'NexaWorksDB')
BEGIN
    ALTER DATABASE NexaWorksDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE NexaWorksDB;
END
GO

-- Créer la base de données
CREATE DATABASE NexaWorksDB;
GO

USE NexaWorksDB;
GO

-- Créer les tables
CREATE TABLE Produit (
    ID INT PRIMARY KEY IDENTITY(1,1),
    Nom NVARCHAR(100) NOT NULL
);

CREATE TABLE Version (
    ID INT PRIMARY KEY IDENTITY(1,1),
    NumeroVersion NVARCHAR(50) NOT NULL
);

-- Table d'association many-to-many entre Produit et Version
CREATE TABLE Produit_Version(
    ProduitID INT,
    VersionID INT,
    FOREIGN KEY (ProduitID) REFERENCES Produit(ID),
    FOREIGN KEY (VersionID) REFERENCES Version(ID),
    PRIMARY KEY (ProduitID, VersionID)
);

CREATE TABLE SystemeExploitation (
    ID INT PRIMARY KEY IDENTITY(1,1),
    Nom NVARCHAR(100) NOT NULL
);

-- Table d'association many-to-many entre Version et SystemeExploitation
CREATE TABLE ProduitVersion_SystemeExploitation (
    ProduitID INT,
    VersionID INT,
    SystemeExploitationID INT,
    FOREIGN KEY (ProduitID, VersionID) REFERENCES Produit_Version(ProduitID, VersionID),
    FOREIGN KEY (SystemeExploitationID) REFERENCES SystemeExploitation(ID),
    PRIMARY KEY (ProduitID, VersionID, SystemeExploitationID)
);

CREATE TABLE Statut (
    ID INT PRIMARY KEY IDENTITY(1,1),
    Nom NVARCHAR(100) NOT NULL
);

CREATE TABLE Ticket (
    ID INT PRIMARY KEY IDENTITY(1,1),
    ProduitID INT,
    VersionID INT,
    SystemeExploitationID INT,
    DateCreation DATE NOT NULL,
    DateResolution DATE,
    StatutID INT,
    Probleme NVARCHAR(MAX) NOT NULL,
    Resolution NVARCHAR(MAX),
    FOREIGN KEY (StatutID) REFERENCES Statut(ID),
    FOREIGN KEY (ProduitID) REFERENCES Produit(ID),
    FOREIGN KEY (VersionID) REFERENCES Version(ID),
    FOREIGN KEY (SystemeExploitationID) REFERENCES SystemeExploitation(ID)
);

--Procédure stockée pour insérer les produits en vérifiant si les produits existes déjà
-- Supprimer la procédure existante si elle existe déjà
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'InsertProduit')
    DROP PROCEDURE InsertProduit;
GO

CREATE PROCEDURE InsertProduit
    @Nom NVARCHAR(100)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Produit WHERE Nom = @Nom)
    BEGIN
        INSERT INTO Produit (Nom) VALUES (@Nom);
        SELECT SCOPE_IDENTITY() AS NewID;
    END
    ELSE
    BEGIN
        PRINT 'Le produit avec le nom ' + @Nom + ' existe déjà.';
    END
END;
GO

--Procédure stockée pour insérer les versions en vérifiant si les versions existes déjà
-- Supprimer la procédure existante si elle existe déjà
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'InsertVersion')
    DROP PROCEDURE InsertVersion;
GO

CREATE PROCEDURE InsertVersion
    @NumeroVersion NVARCHAR(100)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Version WHERE NumeroVersion = @NumeroVersion)
    BEGIN
        INSERT INTO Version (NumeroVersion) VALUES (@NumeroVersion);
        SELECT SCOPE_IDENTITY() AS NewID;
    END
    ELSE
    BEGIN
        PRINT 'La version ' + @NumeroVersion + ' existe déjà.';
    END
END;
GO

--Procédure stockée pour insérer la relation produit-version en vérifiant si elles existes déjà
-- Supprimer la procédure existante si elle existe déjà
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'InsertProduitVersion')
    DROP PROCEDURE InsertProduitVersion;
GO

-- Créer la procédure stockée InsertProduitVersion
CREATE PROCEDURE InsertProduitVersion
    @ProduitNom NVARCHAR(100),
    @NumeroVersion NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ProduitID INT;
    DECLARE @VersionID INT;

    -- Récupérer l'ID du produit en fonction du nom
    SELECT @ProduitID = ID FROM Produit WHERE Nom = @ProduitNom;

    -- Vérifier si le produit existe
    IF @ProduitID IS NULL
    BEGIN
        THROW 50000, 'Le produit spécifié n''existe pas.', 1;
        RETURN;
    END;

    -- Récupérer l'ID de la version en fonction du numéro de version
    SELECT @VersionID = ID FROM Version WHERE NumeroVersion = @NumeroVersion;

    -- Vérifier si la version existe
    IF @VersionID IS NULL
    BEGIN
        THROW 50001, 'La version spécifiée n''existe pas.', 1;
        RETURN;
    END;

    -- Insérer la relation dans Produit_Version
    INSERT INTO Produit_Version (ProduitID, VersionID)
    VALUES (@ProduitID, @VersionID);

    -- Retourner un message de succès
    PRINT 'La relation entre le produit et la version a été insérée avec succès.';
END;
GO

--Procédure stockée pour insérer les Systemes Exploitation avec gestion d'erreurs
-- Supprimer la procédure existante InsertSystemeExploitation si elle existe déjà
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'InsertSystemeExploitation')
    DROP PROCEDURE InsertSystemeExploitation;
GO

-- Créer la procédure stockée InsertSystemeExploitation
CREATE PROCEDURE InsertSystemeExploitation
    @Nom NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    -- Vérifier si le système d'exploitation existe déjà
    IF EXISTS (SELECT 1 FROM SystemeExploitation WHERE Nom = @Nom)
    BEGIN
        THROW 50000, 'Le système d''exploitation existe déjà.', 1;
        RETURN;
    END;

    -- Insérer le système d'exploitation
    INSERT INTO SystemeExploitation (Nom)
    VALUES (@Nom);

    -- Retourner l'ID du nouveau système d'exploitation inséré
    SELECT SCOPE_IDENTITY() AS NewID;
END;
GO

-- Supprimer la procédure existante si elle existe déjà
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'InsertProduitVersionSystemeExploitation')
    DROP PROCEDURE InsertProduitVersionSystemeExploitation;
GO

-- Créer la procédure stockée InsertProduitVersionSystemeExploitation avec gestion d'erreur
CREATE PROCEDURE InsertProduitVersionSystemeExploitation
    @NumeroVersion NVARCHAR(50),
    @ProduitNom NVARCHAR(100),
    @SystemeExploitationNom NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ProduitID INT;
    DECLARE @VersionID INT;
    DECLARE @SystemeExploitationID INT;

    -- Vérifier si le produit existe et récupérer son ID
    SELECT @ProduitID = ID FROM Produit WHERE Nom = @ProduitNom;

    IF @ProduitID IS NULL
    BEGIN
        THROW 50000, 'Le produit spécifié n''existe pas.', 1;
        RETURN;
    END;

    -- Vérifier si la version existe pour ce produit et récupérer son ID
    SELECT @VersionID = V.ID
    FROM Version V
    INNER JOIN Produit_Version PV ON V.ID = PV.VersionID
    WHERE V.NumeroVersion = @NumeroVersion AND PV.ProduitID = @ProduitID;

    IF @VersionID IS NULL
    BEGIN
        THROW 50001, 'La version spécifiée n''existe pas pour ce produit.', 1;
        RETURN;
    END;

    -- Vérifier si le système d'exploitation existe et récupérer son ID
    SELECT @SystemeExploitationID = ID FROM SystemeExploitation WHERE Nom = @SystemeExploitationNom;

    IF @SystemeExploitationID IS NULL
    BEGIN
        THROW 50002, 'Le système d''exploitation spécifié n''existe pas.', 1;
        RETURN;
    END;

    -- Insérer la relation ProduitVersion-SystemeExploitation si elle n'existe pas déjà
    IF NOT EXISTS (
        SELECT 1 
        FROM ProduitVersion_SystemeExploitation PVSE
        WHERE PVSE.ProduitID = @ProduitID AND PVSE.VersionID = @VersionID AND PVSE.SystemeExploitationID = @SystemeExploitationID
    )
    BEGIN
        INSERT INTO ProduitVersion_SystemeExploitation (ProduitID, VersionID, SystemeExploitationID)
        VALUES (@ProduitID, @VersionID, @SystemeExploitationID);
        
        PRINT 'La relation Produit-Version-Système d''exploitation a été insérée avec succès.';
    END
    ELSE
    BEGIN
        PRINT 'La relation Produit-Version-Système d''exploitation existe déjà.';
    END;
END;
GO



-- Supprimer la procédure existante si elle existe déjà
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'InsertStatut')
    DROP PROCEDURE InsertStatut;
GO

-- Créer la procédure stockée InsertStatut avec gestion d'erreur
CREATE PROCEDURE InsertStatut
    @StatutNom NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ExistingStatutID INT;

    -- Vérifier si le statut existe déjà
    SELECT @ExistingStatutID = ID FROM Statut WHERE Nom = @StatutNom;

    -- Si le statut existe déjà, retourner un message d'erreur
    IF @ExistingStatutID IS NOT NULL
    BEGIN
        THROW 50000, 'Le statut spécifié existe déjà.', 1;
        RETURN;
    END;

    -- Insérer le nouveau statut
    INSERT INTO Statut (Nom)
    VALUES (@StatutNom);

    -- Retourner l'ID du nouveau statut inséré
    SELECT SCOPE_IDENTITY() AS NewID;
END;
GO

-- Supprimer la procédure existante si elle existe déjà
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'InsertTicket')
    DROP PROCEDURE InsertTicket;
GO

-- Créer la procédure stockée InsertTicket avec la prise en charge de @DateCreation
CREATE PROCEDURE InsertTicket
    @ProduitNom NVARCHAR(100),
    @NumeroVersion NVARCHAR(50),
    @SystemeExploitationNom NVARCHAR(100),
    @Statut NVARCHAR(50),
    @Probleme NVARCHAR(MAX),
    @DateCreation DATE = NULL,
    @DateResolution DATE = NULL,
    @Resolution NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ProduitID INT;
    DECLARE @VersionID INT;
    DECLARE @SystemeExploitationID INT;
    DECLARE @StatutID INT;

    -- Récupérer l'ID du produit en fonction du nom
    SELECT @ProduitID = ID FROM Produit WHERE Nom = @ProduitNom;

    -- Vérifier si le produit existe
    IF @ProduitID IS NULL
    BEGIN
        THROW 50000, 'Le produit spécifié n''existe pas.', 1;
        RETURN;
    END;

    -- Récupérer l'ID de la version en fonction du numéro de version et du produit
    SELECT @VersionID = ID FROM Version WHERE NumeroVersion = @NumeroVersion;

    -- Vérifier si la version existe
    IF @VersionID IS NULL
    BEGIN
        THROW 50001, 'La version spécifiée n''existe pas pour ce produit.', 1;
        RETURN;
    END;

    -- Récupérer l'ID du système d'exploitation en fonction du nom
    SELECT @SystemeExploitationID = ID FROM SystemeExploitation WHERE Nom = @SystemeExploitationNom;

    -- Vérifier si le système d'exploitation existe
    IF @SystemeExploitationID IS NULL
    BEGIN
        THROW 50002, 'Le système d''exploitation spécifié n''existe pas.', 1;
        RETURN;
    END;

    -- Récupérer l'ID du statut en fonction du nom
    SELECT @StatutID = ID FROM Statut WHERE Nom = @Statut;

    -- Vérifier si le statut existe
    IF @StatutID IS NULL
    BEGIN
        THROW 50004, 'Le statut spécifié n''existe pas.', 1;
        RETURN;
    END;

    -- Vérifier la relation entre la produit-version et le système d'exploitation
    IF NOT EXISTS (
        SELECT 1 FROM ProduitVersion_SystemeExploitation 
        WHERE ProduitID = @ProduitID AND VersionID = @VersionID AND SystemeExploitationID = @SystemeExploitationID
    )
    BEGIN
        THROW 50003, 'La version spécifiée n''est pas compatible avec le système d''exploitation spécifié.', 1;
        RETURN;
    END;

    -- Insérer le ticket
    INSERT INTO Ticket (ProduitID, VersionID, SystemeExploitationID, DateCreation, DateResolution, StatutID, Probleme, Resolution)
    VALUES (@ProduitID, @VersionID, @SystemeExploitationID, @DateCreation, @DateResolution, @StatutID, @Probleme, @Resolution);

    -- Retourner l'ID du nouveau ticket inséré
    SELECT SCOPE_IDENTITY() AS NewID;
END;
GO





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

-- Supprimer la procédure existante si elle existe déjà
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'ObtenirProblemesEnCours')
    DROP PROCEDURE ObtenirProblemesEnCours;
GO

-- Créer la procédure stockée ObtenirProblemesEnCours avec prise en compte de Statut
CREATE PROCEDURE ObtenirProblemesEnCours
    @ProduitNom NVARCHAR(100) = NULL,      -- Nom du produit (optionnel)
    @NumeroVersion NVARCHAR(50) = NULL,    -- Numéro de version du produit (optionnel)
    @StartDate DATE = NULL,                -- Date de début pour filtrer les problèmes (optionnel)
    @EndDate DATE = NULL,                  -- Date de fin pour filtrer les problèmes (optionnel)
    @Keywords NVARCHAR(MAX) = NULL         -- Mots-clés à rechercher dans les problèmes (optionnel)
AS
BEGIN
    SET NOCOUNT ON;

    -- Sélectionner les problèmes en cours avec les filtres optionnels et les noms associés
    SELECT 
        t.ID AS TicketID,
        p.Nom AS ProduitNom,
        v.NumeroVersion AS VersionNumero,
        se.Nom AS SystemeExploitationNom,
        t.DateCreation,
        t.DateResolution,
        s.Nom AS Statut,          -- Utilisation du nom du statut
        t.Probleme,
        t.Resolution
    FROM Ticket t
    JOIN Produit p ON t.ProduitID = p.ID
    LEFT JOIN Version v ON t.VersionID = v.ID
    LEFT JOIN SystemeExploitation se ON t.SystemeExploitationID = se.ID
    JOIN Statut s ON t.StatutID = s.ID   -- Jointure avec la table Statut pour obtenir le nom du statut
    WHERE s.Nom = 'En Cours'             -- Filtrer par nom de statut
      AND (@ProduitNom IS NULL OR p.Nom = @ProduitNom)                     -- Filtrer par produit si spécifié
      AND (@NumeroVersion IS NULL OR v.NumeroVersion = @NumeroVersion)     -- Filtrer par version si spécifié
      AND (@StartDate IS NULL OR t.DateCreation >= @StartDate)             -- Filtrer par date de début si spécifiée
      AND (@EndDate IS NULL OR t.DateCreation <= @EndDate)                 -- Filtrer par date de fin si spécifiée
      AND (@Keywords IS NULL OR EXISTS (
          SELECT 1
          FROM STRING_SPLIT(@Keywords, ',') AS kw
          WHERE CHARINDEX(LTRIM(RTRIM(kw.value)), t.Probleme) > 0
      ));     -- Filtrer par mots-clés si spécifiés
END;
GO

-- Supprimer la procédure existante si elle existe déjà
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'ObtenirProblemesResolus')
    DROP PROCEDURE ObtenirProblemesResolus;
GO

-- Créer la procédure stockée ObtenirProblemesResolus avec prise en compte de Statut
CREATE PROCEDURE ObtenirProblemesResolus
    @ProduitNom NVARCHAR(100) = NULL,      -- Nom du produit (optionnel)
    @NumeroVersion NVARCHAR(50) = NULL,    -- Numéro de version du produit (optionnel)
    @StartDate DATE = NULL,                -- Date de début pour filtrer les problèmes résolus (optionnel)
    @EndDate DATE = NULL,                  -- Date de fin pour filtrer les problèmes résolus (optionnel)
    @Keywords NVARCHAR(MAX) = NULL         -- Mots-clés à rechercher dans les problèmes (optionnel)
AS
BEGIN
    SET NOCOUNT ON;

    -- Sélectionner les problèmes résolus avec les filtres optionnels et les noms associés
    SELECT 
        t.ID AS TicketID,
        p.Nom AS ProduitNom,
        v.NumeroVersion AS VersionNumero,
        se.Nom AS SystemeExploitationNom,
        t.DateCreation,
        t.DateResolution,
        s.Nom AS Statut,          -- Utilisation du nom du statut
        t.Probleme,
        t.Resolution
    FROM Ticket t
    JOIN Produit p ON t.ProduitID = p.ID
    LEFT JOIN Version v ON t.VersionID = v.ID
    LEFT JOIN SystemeExploitation se ON t.SystemeExploitationID = se.ID
    JOIN Statut s ON t.StatutID = s.ID   -- Jointure avec la table Statut pour obtenir le nom du statut
    WHERE s.Nom = 'Résolu'               -- Filtrer par nom de statut
      AND (@ProduitNom IS NULL OR p.Nom = @ProduitNom)                     -- Filtrer par produit si spécifié
      AND (@NumeroVersion IS NULL OR v.NumeroVersion = @NumeroVersion)     -- Filtrer par version si spécifié
      AND (@StartDate IS NULL OR t.DateResolution >= @StartDate)           -- Filtrer par date de début si spécifiée
      AND (@EndDate IS NULL OR t.DateResolution <= @EndDate)               -- Filtrer par date de fin si spécifiée
      AND (@Keywords IS NULL OR EXISTS (
          SELECT 1
          FROM STRING_SPLIT(@Keywords, ',') AS kw
          WHERE CHARINDEX(LTRIM(RTRIM(kw.value)), t.Probleme) > 0
      ));     -- Filtrer par mots-clés si spécifiés
END;
GO
