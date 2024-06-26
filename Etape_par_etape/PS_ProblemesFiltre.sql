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
