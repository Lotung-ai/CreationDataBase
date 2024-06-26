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

