-- V�rifier si la base de donn�es existe d�j� et la supprimer
USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = N'NexaWorksDB')
BEGIN
    ALTER DATABASE NexaWorksDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE NexaWorksDB;
END
GO

-- Cr�er la base de donn�es
CREATE DATABASE NexaWorksDB;
GO

USE NexaWorksDB;
GO

-- Cr�er les tables
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

--Proc�dure stock�e pour ins�rer les produits en v�rifiant si les produits existes d�j�
-- Supprimer la proc�dure existante si elle existe d�j�
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
        PRINT 'Le produit avec le nom ' + @Nom + ' existe d�j�.';
    END
END;
GO

--Proc�dure stock�e pour ins�rer les versions en v�rifiant si les versions existes d�j�
-- Supprimer la proc�dure existante si elle existe d�j�
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
        PRINT 'La version ' + @NumeroVersion + ' existe d�j�.';
    END
END;
GO

--Proc�dure stock�e pour ins�rer la relation produit-version en v�rifiant si elles existes d�j�
-- Supprimer la proc�dure existante si elle existe d�j�
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'InsertProduitVersion')
    DROP PROCEDURE InsertProduitVersion;
GO

-- Cr�er la proc�dure stock�e InsertProduitVersion
CREATE PROCEDURE InsertProduitVersion
    @ProduitNom NVARCHAR(100),
    @NumeroVersion NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ProduitID INT;
    DECLARE @VersionID INT;

    -- R�cup�rer l'ID du produit en fonction du nom
    SELECT @ProduitID = ID FROM Produit WHERE Nom = @ProduitNom;

    -- V�rifier si le produit existe
    IF @ProduitID IS NULL
    BEGIN
        THROW 50000, 'Le produit sp�cifi� n''existe pas.', 1;
        RETURN;
    END;

    -- R�cup�rer l'ID de la version en fonction du num�ro de version
    SELECT @VersionID = ID FROM Version WHERE NumeroVersion = @NumeroVersion;

    -- V�rifier si la version existe
    IF @VersionID IS NULL
    BEGIN
        THROW 50001, 'La version sp�cifi�e n''existe pas.', 1;
        RETURN;
    END;

    -- Ins�rer la relation dans Produit_Version
    INSERT INTO Produit_Version (ProduitID, VersionID)
    VALUES (@ProduitID, @VersionID);

    -- Retourner un message de succ�s
    PRINT 'La relation entre le produit et la version a �t� ins�r�e avec succ�s.';
END;
GO

--Proc�dure stock�e pour ins�rer les Systemes Exploitation avec gestion d'erreurs
-- Supprimer la proc�dure existante InsertSystemeExploitation si elle existe d�j�
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'InsertSystemeExploitation')
    DROP PROCEDURE InsertSystemeExploitation;
GO

-- Cr�er la proc�dure stock�e InsertSystemeExploitation
CREATE PROCEDURE InsertSystemeExploitation
    @Nom NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    -- V�rifier si le syst�me d'exploitation existe d�j�
    IF EXISTS (SELECT 1 FROM SystemeExploitation WHERE Nom = @Nom)
    BEGIN
        THROW 50000, 'Le syst�me d''exploitation existe d�j�.', 1;
        RETURN;
    END;

    -- Ins�rer le syst�me d'exploitation
    INSERT INTO SystemeExploitation (Nom)
    VALUES (@Nom);

    -- Retourner l'ID du nouveau syst�me d'exploitation ins�r�
    SELECT SCOPE_IDENTITY() AS NewID;
END;
GO

-- Supprimer la proc�dure existante si elle existe d�j�
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'InsertProduitVersionSystemeExploitation')
    DROP PROCEDURE InsertProduitVersionSystemeExploitation;
GO

-- Cr�er la proc�dure stock�e InsertProduitVersionSystemeExploitation avec gestion d'erreur
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

    -- V�rifier si le produit existe et r�cup�rer son ID
    SELECT @ProduitID = ID FROM Produit WHERE Nom = @ProduitNom;

    IF @ProduitID IS NULL
    BEGIN
        THROW 50000, 'Le produit sp�cifi� n''existe pas.', 1;
        RETURN;
    END;

    -- V�rifier si la version existe pour ce produit et r�cup�rer son ID
    SELECT @VersionID = V.ID
    FROM Version V
    INNER JOIN Produit_Version PV ON V.ID = PV.VersionID
    WHERE V.NumeroVersion = @NumeroVersion AND PV.ProduitID = @ProduitID;

    IF @VersionID IS NULL
    BEGIN
        THROW 50001, 'La version sp�cifi�e n''existe pas pour ce produit.', 1;
        RETURN;
    END;

    -- V�rifier si le syst�me d'exploitation existe et r�cup�rer son ID
    SELECT @SystemeExploitationID = ID FROM SystemeExploitation WHERE Nom = @SystemeExploitationNom;

    IF @SystemeExploitationID IS NULL
    BEGIN
        THROW 50002, 'Le syst�me d''exploitation sp�cifi� n''existe pas.', 1;
        RETURN;
    END;

    -- Ins�rer la relation ProduitVersion-SystemeExploitation si elle n'existe pas d�j�
    IF NOT EXISTS (
        SELECT 1 
        FROM ProduitVersion_SystemeExploitation PVSE
        WHERE PVSE.ProduitID = @ProduitID AND PVSE.VersionID = @VersionID AND PVSE.SystemeExploitationID = @SystemeExploitationID
    )
    BEGIN
        INSERT INTO ProduitVersion_SystemeExploitation (ProduitID, VersionID, SystemeExploitationID)
        VALUES (@ProduitID, @VersionID, @SystemeExploitationID);
        
        PRINT 'La relation Produit-Version-Syst�me d''exploitation a �t� ins�r�e avec succ�s.';
    END
    ELSE
    BEGIN
        PRINT 'La relation Produit-Version-Syst�me d''exploitation existe d�j�.';
    END;
END;
GO



-- Supprimer la proc�dure existante si elle existe d�j�
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'InsertStatut')
    DROP PROCEDURE InsertStatut;
GO

-- Cr�er la proc�dure stock�e InsertStatut avec gestion d'erreur
CREATE PROCEDURE InsertStatut
    @StatutNom NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ExistingStatutID INT;

    -- V�rifier si le statut existe d�j�
    SELECT @ExistingStatutID = ID FROM Statut WHERE Nom = @StatutNom;

    -- Si le statut existe d�j�, retourner un message d'erreur
    IF @ExistingStatutID IS NOT NULL
    BEGIN
        THROW 50000, 'Le statut sp�cifi� existe d�j�.', 1;
        RETURN;
    END;

    -- Ins�rer le nouveau statut
    INSERT INTO Statut (Nom)
    VALUES (@StatutNom);

    -- Retourner l'ID du nouveau statut ins�r�
    SELECT SCOPE_IDENTITY() AS NewID;
END;
GO

-- Supprimer la proc�dure existante si elle existe d�j�
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'InsertTicket')
    DROP PROCEDURE InsertTicket;
GO

-- Cr�er la proc�dure stock�e InsertTicket avec la prise en charge de @DateCreation
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

    -- R�cup�rer l'ID du produit en fonction du nom
    SELECT @ProduitID = ID FROM Produit WHERE Nom = @ProduitNom;

    -- V�rifier si le produit existe
    IF @ProduitID IS NULL
    BEGIN
        THROW 50000, 'Le produit sp�cifi� n''existe pas.', 1;
        RETURN;
    END;

    -- R�cup�rer l'ID de la version en fonction du num�ro de version et du produit
    SELECT @VersionID = ID FROM Version WHERE NumeroVersion = @NumeroVersion;

    -- V�rifier si la version existe
    IF @VersionID IS NULL
    BEGIN
        THROW 50001, 'La version sp�cifi�e n''existe pas pour ce produit.', 1;
        RETURN;
    END;

    -- R�cup�rer l'ID du syst�me d'exploitation en fonction du nom
    SELECT @SystemeExploitationID = ID FROM SystemeExploitation WHERE Nom = @SystemeExploitationNom;

    -- V�rifier si le syst�me d'exploitation existe
    IF @SystemeExploitationID IS NULL
    BEGIN
        THROW 50002, 'Le syst�me d''exploitation sp�cifi� n''existe pas.', 1;
        RETURN;
    END;

    -- R�cup�rer l'ID du statut en fonction du nom
    SELECT @StatutID = ID FROM Statut WHERE Nom = @Statut;

    -- V�rifier si le statut existe
    IF @StatutID IS NULL
    BEGIN
        THROW 50004, 'Le statut sp�cifi� n''existe pas.', 1;
        RETURN;
    END;

    -- V�rifier la relation entre la produit-version et le syst�me d'exploitation
    IF NOT EXISTS (
        SELECT 1 FROM ProduitVersion_SystemeExploitation 
        WHERE ProduitID = @ProduitID AND VersionID = @VersionID AND SystemeExploitationID = @SystemeExploitationID
    )
    BEGIN
        THROW 50003, 'La version sp�cifi�e n''est pas compatible avec le syst�me d''exploitation sp�cifi�.', 1;
        RETURN;
    END;

    -- Ins�rer le ticket
    INSERT INTO Ticket (ProduitID, VersionID, SystemeExploitationID, DateCreation, DateResolution, StatutID, Probleme, Resolution)
    VALUES (@ProduitID, @VersionID, @SystemeExploitationID, @DateCreation, @DateResolution, @StatutID, @Probleme, @Resolution);

    -- Retourner l'ID du nouveau ticket ins�r�
    SELECT SCOPE_IDENTITY() AS NewID;
END;
GO





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

-- Supprimer la proc�dure existante si elle existe d�j�
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'ObtenirProblemesEnCours')
    DROP PROCEDURE ObtenirProblemesEnCours;
GO

-- Cr�er la proc�dure stock�e ObtenirProblemesEnCours avec prise en compte de Statut
CREATE PROCEDURE ObtenirProblemesEnCours
    @ProduitNom NVARCHAR(100) = NULL,      -- Nom du produit (optionnel)
    @NumeroVersion NVARCHAR(50) = NULL,    -- Num�ro de version du produit (optionnel)
    @StartDate DATE = NULL,                -- Date de d�but pour filtrer les probl�mes (optionnel)
    @EndDate DATE = NULL,                  -- Date de fin pour filtrer les probl�mes (optionnel)
    @Keywords NVARCHAR(MAX) = NULL         -- Mots-cl�s � rechercher dans les probl�mes (optionnel)
AS
BEGIN
    SET NOCOUNT ON;

    -- S�lectionner les probl�mes en cours avec les filtres optionnels et les noms associ�s
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
      AND (@ProduitNom IS NULL OR p.Nom = @ProduitNom)                     -- Filtrer par produit si sp�cifi�
      AND (@NumeroVersion IS NULL OR v.NumeroVersion = @NumeroVersion)     -- Filtrer par version si sp�cifi�
      AND (@StartDate IS NULL OR t.DateCreation >= @StartDate)             -- Filtrer par date de d�but si sp�cifi�e
      AND (@EndDate IS NULL OR t.DateCreation <= @EndDate)                 -- Filtrer par date de fin si sp�cifi�e
      AND (@Keywords IS NULL OR EXISTS (
          SELECT 1
          FROM STRING_SPLIT(@Keywords, ',') AS kw
          WHERE CHARINDEX(LTRIM(RTRIM(kw.value)), t.Probleme) > 0
      ));     -- Filtrer par mots-cl�s si sp�cifi�s
END;
GO

-- Supprimer la proc�dure existante si elle existe d�j�
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'ObtenirProblemesResolus')
    DROP PROCEDURE ObtenirProblemesResolus;
GO

-- Cr�er la proc�dure stock�e ObtenirProblemesResolus avec prise en compte de Statut
CREATE PROCEDURE ObtenirProblemesResolus
    @ProduitNom NVARCHAR(100) = NULL,      -- Nom du produit (optionnel)
    @NumeroVersion NVARCHAR(50) = NULL,    -- Num�ro de version du produit (optionnel)
    @StartDate DATE = NULL,                -- Date de d�but pour filtrer les probl�mes r�solus (optionnel)
    @EndDate DATE = NULL,                  -- Date de fin pour filtrer les probl�mes r�solus (optionnel)
    @Keywords NVARCHAR(MAX) = NULL         -- Mots-cl�s � rechercher dans les probl�mes (optionnel)
AS
BEGIN
    SET NOCOUNT ON;

    -- S�lectionner les probl�mes r�solus avec les filtres optionnels et les noms associ�s
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
    WHERE s.Nom = 'R�solu'               -- Filtrer par nom de statut
      AND (@ProduitNom IS NULL OR p.Nom = @ProduitNom)                     -- Filtrer par produit si sp�cifi�
      AND (@NumeroVersion IS NULL OR v.NumeroVersion = @NumeroVersion)     -- Filtrer par version si sp�cifi�
      AND (@StartDate IS NULL OR t.DateResolution >= @StartDate)           -- Filtrer par date de d�but si sp�cifi�e
      AND (@EndDate IS NULL OR t.DateResolution <= @EndDate)               -- Filtrer par date de fin si sp�cifi�e
      AND (@Keywords IS NULL OR EXISTS (
          SELECT 1
          FROM STRING_SPLIT(@Keywords, ',') AS kw
          WHERE CHARINDEX(LTRIM(RTRIM(kw.value)), t.Probleme) > 0
      ));     -- Filtrer par mots-cl�s si sp�cifi�s
END;
GO
