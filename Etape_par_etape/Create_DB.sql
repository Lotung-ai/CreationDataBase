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
