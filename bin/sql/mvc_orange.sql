DROP DATABASE IF EXISTS mvc_orange;
CREATE DATABASE mvc_orange;
USE mvc_orange;

CREATE TABLE user (
   id_utilisateur INT PRIMARY KEY AUTO_INCREMENT,
   nom VARCHAR(255) NOT NULL,
   prenom VARCHAR(255) NOT NULL,
   email VARCHAR(255) NOT NULL UNIQUE,
   code_postal VARCHAR(5) NOT NULL,
   adresse VARCHAR(255) NOT NULL,
   telephone VARCHAR(50) NOT NULL,
   mot_de_passe VARCHAR(255) NOT NULL,
  --  avatar VARCHAR(400),
   date_inscription TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
   date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
   date_archive TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
   role ENUM("client","admin","technicien") NOT NULL
);

CREATE TABLE user_archive (
   id_utilisateur INT PRIMARY KEY,
   nom VARCHAR(255) NOT NULL,
   prenom VARCHAR(255) NOT NULL,
   email VARCHAR(255) NOT NULL,
   code_postal VARCHAR(5) NOT NULL,
   adresse VARCHAR(255) NOT NULL,
   telephone VARCHAR(50) NOT NULL,
   mot_de_passe VARCHAR(255) NOT NULL,
  --  avatar VARCHAR(400),
   date_inscription TIMESTAMP NOT NULL,
   date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
   date_archive TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
   role ENUM("client","admin","technicien") NOT NULL
);

DELIMITER $
CREATE TRIGGER before_delete_user
BEFORE DELETE ON user FOR EACH ROW
BEGIN
    INSERT INTO user_archive SELECT * FROM user WHERE id_utilisateur = OLD.id_utilisateur;
END$
DELIMITER ;

CREATE INDEX idx_user_email ON user(email);

CREATE TABLE categorie (
  id_categorie INT PRIMARY KEY AUTO_INCREMENT,
  nom VARCHAR(50) NOT NULL,
  description VARCHAR(100) NOT NULL
);

CREATE TABLE materiel (
  id_materiel INT PRIMARY KEY AUTO_INCREMENT,
  nom VARCHAR(50) NOT NULL,
  description VARCHAR(100) NOT NULL,
  id_categorie INT NOT NULL,
  FOREIGN KEY (id_categorie) REFERENCES categorie(id_categorie)
);

CREATE TABLE logiciel (
  id_logiciel INT PRIMARY KEY AUTO_INCREMENT,
  nom VARCHAR(50) NOT NULL,
  description VARCHAR(100) NOT NULL,
  version VARCHAR(50) NOT NULL,
  id_categorie INT NOT NULL,
  FOREIGN KEY (id_categorie) REFERENCES categorie(id_categorie)
);

CREATE TABLE categorie_intervention (
  categorie_intervention_id INT PRIMARY KEY AUTO_INCREMENT,
  categorie_intervention_nom VARCHAR(50) NOT NULL,
  categorie_intervention_description VARCHAR(200) NOT NULL
);

CREATE TABLE intervention (
  id_intervention INT PRIMARY KEY AUTO_INCREMENT,
  date_debut DATETIME,
  date_fin DATETIME,
  date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  status VARCHAR(100) NOT NULL,
  date_archive TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
--   status enum ('En cours', 'Termine', 'Annulé') NOT NULL,
  description VARCHAR(200) NOT NULL,
  id_technicien INT NULL,
  id_utilisateur INT NOT NULL,
  id_materiel INT,
  id_logiciel INT,
  id_categorie_intervention INT,
  FOREIGN KEY (id_utilisateur) REFERENCES user(id_utilisateur),
  FOREIGN KEY (id_categorie_intervention) REFERENCES categorie_intervention(categorie_intervention_id),
  FOREIGN KEY (id_technicien) REFERENCES user(id_utilisateur),
  FOREIGN KEY (id_logiciel) REFERENCES logiciel(id_logiciel),
  FOREIGN KEY (id_materiel) REFERENCES materiel(id_materiel)
);

DELIMITER $
CREATE TRIGGER before_delete_intervention
BEFORE DELETE ON intervention FOR EACH ROW
BEGIN
    INSERT INTO archive_intervention SELECT * FROM intervention WHERE id_intervention = OLD.id_intervention;
END$
DELIMITER ;

CREATE TABLE archive_intervention (
  id_intervention INT PRIMARY KEY,
  date_debut DATETIME,
  date_fin DATETIME,
  date_creation TIMESTAMP NOT NULL,
  date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  date_archive TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  status VARCHAR(100) NOT NULL,
  description VARCHAR(200) NOT NULL,
  id_utilisateur INT NOT NULL,
  id_materiel INT NOT NULL,
  id_logiciel INT NOT NULL,
  id_technicien INT NOT NULL,
  id_categorie_intervention INT NOT NULL
);

DELIMITER $
CREATE FUNCTION create_intervention(
    date_debut DATETIME,
    date_fin DATETIME,
    status VARCHAR(50),
    description VARCHAR(200),
    id_technicien INT,
    id_logiciel INT,
    id_materiel INT,
    id_utilisateur INT,
    id_categorie_intervention INT
)
RETURNS VARCHAR(200)
BEGIN
    INSERT INTO intervention (
        date_debut,
        date_fin,
        status,
        description,
        id_technicien,
        id_logiciel,
        id_materiel,
        id_utilisateur,
        id_categorie_intervention
    ) VALUES (
        date_debut,
        date_fin,
        status,
        description,
        id_technicien,
        id_logiciel,
        id_materiel,
        id_utilisateur,
        id_categorie_intervention
    );
    RETURN CONCAT('Création faite, id=', last_insert_id());
END$
DELIMITER ;


-- CREATE TABLE jonction_materiel_categorie (
--   id_materiel INT NOT NULL,
--   id_categorie INT NOT NULL,
--   PRIMARY KEY (id_materiel, id_categorie),
--   FOREIGN KEY (id_materiel) REFERENCES materiel(id_materiel),
--   FOREIGN KEY (id_categorie) REFERENCES categorie(id_categorie)
-- );

-- CREATE TABLE jonction_logiciel_categorie (
--   id_logiciel INT NOT NULL,
--   id_categorie INT NOT NULL,
--   PRIMARY KEY (id_logiciel, id_categorie),
--   FOREIGN KEY (id_logiciel) REFERENCES logiciel(id_logiciel),
--   FOREIGN KEY (id_categorie) REFERENCES categorie(id_categorie)
-- );

-- DELIMITER $
-- CREATE TRIGGER insert_materiel
-- AFTER INSERT ON materiel FOR EACH ROW
-- BEGIN
--    INSERT INTO junction_materiel_categorie(id_materiel, id_categorie) VALUES (NEW.id_materiel, NEW.id_categorie);
-- END$
-- DELIMITER ;

-- DELIMITER $
-- CREATE TRIGGER insert_logiciel
-- AFTER INSERT ON logiciel FOR EACH ROW
-- BEGIN
--    INSERT INTO junction_logiciel_categorie(id_logiciel, id_categorie) VALUES (NEW.id_logiciel, NEW.id_categorie);
-- END$
-- DELIMITER ;


CREATE VIEW intervention_view AS
SELECT *
FROM intervention
JOIN categorie_intervention ON intervention.id_categorie_intervention = categorie_intervention.categorie_intervention_id;

-- CREATE TABLE intervention (
--   id_intervention INT PRIMARY KEY AUTO_INCREMENT,
--   date_debut DATETIME NOT NULL,
--   date_fin DATETIME,
--   date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
--   date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
--   status VARCHAR(50) NOT NULL,
--   description VARCHAR(200) NOT NULL,
--   id_technicien INT NOT NULL,
--   id_categorie_intervention INT NOT NULL,
--   FOREIGN KEY (id_technicien) REFERENCES technicien(id_technicien)
-- )

CREATE VIEW users_view AS (
    SELECT *
    FROM user
);
CREATE VIEW techniciens_view AS (
    SELECT *
    FROM user
    WHERE role = 'technicien'
);
CREATE VIEW admin_view AS (
    SELECT *
    FROM user
    WHERE role = 'admin'
);
CREATE VIEW client_view AS (
    SELECT *
    FROM user
    WHERE role = 'client'
);

CREATE VIEW categorie_intervention_view AS (
   SELECT * FROM categorie_intervention
);
CREATE VIEW categorie_view AS (
   SELECT * FROM categorie
);
CREATE VIEW materiel_view AS (
   SELECT * FROM categorie
);
CREATE VIEW logiciel_view AS (
   SELECT * FROM categorie
);


INSERT INTO user (nom, prenom, email, code_postal, adresse, telephone, mot_de_passe, role) VALUES
('Dupont', 'Jean', 'client1@email.com', '75001', '123 Rue de Paris', '0123456789', 'password123', 'client'),
('Martin', 'Alice', 'technicien@email.com', '69001', '456 Avenue de Lyon', '0987654321', 'password123', 'technicien'),
('Bernard', 'Lucas', 'admin@email.com', '31000', '789 Rue de Toulouse', '1122334455', 'password123', 'admin'),
('Petit', 'Chloé', 'client2@email.com', '33000', '321 Rue de Bordeaux', '2233445566', 'password123', 'client');
INSERT INTO categorie (nom, description) VALUES
('Ordinateurs', 'Catégorie pour tous les ordinateurs'),
('Imprimantes', 'Catégorie pour toutes les imprimantes'),
('Logiciels de Sécurité', 'Catégorie pour les logiciels de sécurité'),
('Périphériques', 'Catégorie pour les périphériques informatiques');
INSERT INTO materiel (nom, description, id_categorie) VALUES
('Ordinateur Portable', 'Un ordinateur portable de haute performance',1),
('Imprimante Laser', 'Imprimante laser haute performance',2),
('Disque Dur Externe', 'Disque dur externe de 1To',3),
('Souris sans fil', 'Souris ergonomique sans fil',4);
INSERT INTO logiciel (nom, description, version, id_categorie) VALUES
('Antivirus Pro', 'Logiciel antivirus avancé', '2023',2),
('Photoshop', "Logiciel de traitement d'image", '2023',4),
("Système d'exploitation XYZ", "Nouveau système d'exploitation", '10.0',1);
INSERT INTO categorie_intervention (categorie_intervention_nom, categorie_intervention_description) VALUES
('Installation logicielle', 'Installation de divers logiciels'),
('Réparation matériel', 'Réparation de divers équipements informatiques'),
('Mise à jour système', "Mise à jour de systèmes d'exploitation et logiciels"),
('Nettoyage informatique', 'Nettoyage physique et logiciel des systèmes informatiques');
-- INSERT INTO technicien (id_utilisateur, expertise) VALUES
-- (2, 'Réseaux'),
-- (3, 'Maintenance');

-- INSERT INTO admin (id_utilisateur, grade_admin) VALUES
-- (3, 2);

-- INSERT INTO client (id_utilisateur, info_additionnel) VALUES
-- (1, 'Informations client Dupont'),
-- (4, 'Informations client Petit');
INSERT INTO intervention (date_debut, date_fin, status, description, id_technicien,id_materiel,id_logiciel, id_categorie_intervention, id_utilisateur) VALUES
('2023-01-01 08:00:00', '2023-01-01 12:00:00', 'En cours', "Installation d'antivirus",null,1,null,1,4);
-- INSERT INTO jonction_materiel_categorie (id_materiel, id_categorie) VALUES
-- (1, 1);

-- INSERT INTO jonction_logiciel_categorie (id_logiciel, id_categorie) VALUES
-- (1, 3);