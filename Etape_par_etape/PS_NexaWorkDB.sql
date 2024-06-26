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

