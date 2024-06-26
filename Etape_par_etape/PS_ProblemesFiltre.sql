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
