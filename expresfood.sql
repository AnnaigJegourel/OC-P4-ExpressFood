-- MySQL Script generated by MySQL Workbench
-- Tue Jun  7 10:47:19 2022
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering


-- -----------------------------------------------------
-- Schema expressfood
-- -----------------------------------------------------
DROP DATABASE IF EXISTS `expressfood`;
CREATE DATABASE `expressfood` CHARACTER SET utf8;
USE `expressfood`;

-- -----------------------------------------------------
-- Table `Utilisateur`
-- -----------------------------------------------------
CREATE TABLE `Utilisateur` (
  `id` INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  `prenom` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `telephone` INT(10) UNSIGNED ZEROFILL NOT NULL,
  `mot_de_passe` VARCHAR(255) NOT NULL,
  `role` VARCHAR(10)
  ) ENGINE = InnoDB;

INSERT INTO `Utilisateur`
(`nom`, `prenom`, `email`, `telephone`, `mot_de_passe`, `role`)
VALUES
('Martin', 'Nadia', 'nadiamartin@youpi.fr', 0654342768, 'cecinestpas1MPD', 'livreur'),
('Pasin', 'Utile', 'pasinutile@yogurt.fr', 0457742768, 'the4questionS', 'client');


-- -----------------------------------------------------
-- Table `Adresse`
-- -----------------------------------------------------
CREATE TABLE `Adresse` (
  `id` INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  `utilisateur_id` INT UNSIGNED NOT NULL,
  `ville` VARCHAR(45) NOT NULL,
  `code_postal` MEDIUMINT(5) UNSIGNED ZEROFILL NOT NULL,
  `voie` VARCHAR(45) NOT NULL,
  `numero` SMALLINT(4) UNSIGNED,
  `complement` VARCHAR(45),
  CONSTRAINT `adresse_fk_utilisateur_id`
    FOREIGN KEY (`utilisateur_id`)
    REFERENCES `Utilisateur` (`id`)
) ENGINE = InnoDB;

INSERT INTO `Adresse`
(`utilisateur_id`, `ville`, `code_postal`, `voie`, `numero`, `complement`)
VALUES
(2, 'Nancy', 54000, 'rue Marie Marvingt', 2, 'bis');


-- -----------------------------------------------------
-- Table `Admin`
-- -----------------------------------------------------
CREATE TABLE `Admin` (
  `utilisateur_id` INT UNSIGNED PRIMARY KEY,
  `code_de_securite` VARCHAR(255) NOT NULL,
  CONSTRAINT `admin_fk_utilisateur_id`
    FOREIGN KEY (`utilisateur_id`)
    REFERENCES `Utilisateur` (`id`)
) ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Livreur`
-- -----------------------------------------------------
CREATE TABLE `Livreur` (
  `utilisateur_id` INT UNSIGNED PRIMARY KEY,
  `statut` VARCHAR(20) NOT NULL,
  `latitude` FLOAT,
  `longitude` FLOAT,
  CONSTRAINT `livreur_fk_utilisateur_id`
    FOREIGN KEY (`utilisateur_id`)
    REFERENCES `Utilisateur` (`id`)
) ENGINE = InnoDB;

INSERT INTO `Livreur`
(`utilisateur_id`, `statut`)
VALUES
(1, 'en livraison');


-- -----------------------------------------------------
-- Table `Client`
-- -----------------------------------------------------
CREATE TABLE `Client` (
  `utilisateur_id` INT UNSIGNED  PRIMARY KEY,
  `numero_cb` VARCHAR(16),
  `date_fin_cb` DATE,
  `crypto_cb` SMALLINT(3) UNSIGNED ZEROFILL,
  CONSTRAINT `client_fk_utilisateur_id`
    FOREIGN KEY (`utilisateur_id`)
    REFERENCES `Utilisateur` (`id`)
) ENGINE = InnoDB;

INSERT INTO `Client`
(`utilisateur_id`, `numero_cb`, `date_fin_cb`, `crypto_cb`)
VALUES
(2, '0111222233334444', '2024-11-23', 045);


-- -----------------------------------------------------
-- Table `Plat`
-- -----------------------------------------------------
CREATE TABLE `Plat` (
  `id` INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  `est_plat_principal` TINYINT(1) UNSIGNED NOT NULL,
  `est_plat_du_jour` TINYINT(1) UNSIGNED NOT NULL,
  `prix` FLOAT(4,2) NOT NULL,
  `image` VARCHAR(255),
  `description` VARCHAR(100)
) ENGINE = InnoDB;

INSERT INTO `Plat`
(`nom`, `est_plat_principal`, `est_plat_du_jour`, `prix`)
VALUES
('Lasagnes', 1, 0, 12.5),
('Couscous', 1, 0, 12.5),
('Tiramisu', 0, 1, 8),
('Salade de fruits', 0, 0, 6),
('Moussaka', 1, 1, 14.5),
('Choucroute', 1, 1, 10.5),
('Mousse au chocolat', 0, 1, 6),
('Compotée de blabla', 1, 0, 8);


-- -----------------------------------------------------
-- Table `PlatDuJour`     
-- -----------------------------------------------------
CREATE TABLE `PlatDuJour` (
  `id` INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  `plat_id` INT UNSIGNED NOT NULL,
  `jour` DATE NOT NULL,
  CONSTRAINT `plat_du_jour_fk_plat_id`
    FOREIGN KEY (`plat_id`)
    REFERENCES `Plat` (`id`)
) ENGINE = InnoDB;

INSERT INTO `PlatDuJour`
(`plat_id`, `jour`)
VALUES
(6, '2022-07-01'),
(5, '2022-07-01'),
(7, '2022-07-01'),
(3, '2022-07-01'),
(2, '2022-07-02');


-- -----------------------------------------------------
-- Table `Commande`
-- -----------------------------------------------------
CREATE TABLE `Commande` (
  `id` INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  `client_utilisateur_id` INT UNSIGNED NOT NULL,
  `paiement_fait` TINYINT(1) UNSIGNED NOT NULL,
  `montant` FLOAT (4,2) NOT NULL,
  CONSTRAINT `commande_fk_client_utilisateur_id`
    FOREIGN KEY (`client_utilisateur_id`)
    REFERENCES `Client` (`utilisateur_id`)
) ENGINE = InnoDB;

INSERT INTO `Commande`
(`client_utilisateur_id`, `paiement_fait`, `montant`)
VALUES
(2, 0, 42.5);


-- -----------------------------------------------------
-- Table `LigneDeCommande`
-- -----------------------------------------------------
CREATE TABLE `LigneDeCommande`( 
  `id` INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  `commande_id` INT UNSIGNED NOT NULL, 
  `plat_du_jour_id` INT UNSIGNED NOT NULL, 
  `quantite`TINYINT(2) UNSIGNED NOT NULL, 
  CONSTRAINT `ligne_fk_commande` 
    FOREIGN KEY (`commande_id`) 
    REFERENCES `Commande` (`id`), 
  CONSTRAINT `ligne_fk_plat_du_jour` 
    FOREIGN KEY (`plat_du_jour_id`) 
    REFERENCES `PlatDuJour` (`id`)
) ENGINE = InnoDB;

INSERT INTO `LigneDeCommande`
(`commande_id`, `plat_du_jour_id`, `quantite`)
VALUES
(1, 1, 2);


-- -----------------------------------------------------
-- Table `Livraison`
-- -----------------------------------------------------
CREATE TABLE `Livraison` (
  `id` INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  `livreur_utilisateur_id` INT UNSIGNED NOT NULL,
  `commande_id` INT UNSIGNED NOT NULL,
  `statut` VARCHAR(10) NOT NULL,
  `heure_debut` TIME,
  `heure_fin` TIME,
  CONSTRAINT `livraison_fk_livreur_utilisateur_id`
    FOREIGN KEY (`livreur_utilisateur_id`)
    REFERENCES `Livreur` (`utilisateur_id`),
  CONSTRAINT `livraison_fk_commande_id`  
    FOREIGN KEY (`commande_id`)
    REFERENCES `Commande` (`id`)
) ENGINE = InnoDB;

INSERT INTO `Livraison`
(`livreur_utilisateur_id`, `commande_id`, `statut`, `heure_debut`, `heure_fin`)
VALUES
(1, 1, 'en cours', '12:03:34', NULL);