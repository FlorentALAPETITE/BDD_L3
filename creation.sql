spool creation_insertion_tables.log
prompt *************************************************************
prompt ******************** DROP TABLE *****************************
prompt *************************************************************

DROP TABLE LIEN CASCADE CONSTRAINTS;
DROP TABLE ACHAT CASCADE CONSTRAINTS;
DROP TABLE INSTANCE_JEU CASCADE CONSTRAINTS;
DROP TABLE PLATEFORME CASCADE CONSTRAINTS;
DROP TABLE CONSTRUCTEUR CASCADE CONSTRAINTS;
DROP TABLE JEU CASCADE CONSTRAINTS;
DROP TABLE EDITEUR CASCADE CONSTRAINTS;
DROP TABLE MAGASIN CASCADE CONSTRAINTS;

DROP SEQUENCE primary_idJeu;
DROP SEQUENCE primary_cleJeu;
DROP SEQUENCE primary_idPlateforme;
DROP SEQUENCE primary_idEditeur;
DROP SEQUENCE primary_idMagasin;
DROP SEQUENCE primary_idConstructeur;


prompt *************************************************************
prompt ******************** CREATE TABLE ***************************
prompt *************************************************************



CREATE TABLE MAGASIN (
	idMagasin 			NUMBER,
	nomMagasin			VARCHAR2(50),
	adresseMagasin 		VARCHAR2(150),
	CONSTRAINT pk_magasin PRIMARY KEY(idMagasin)
);


CREATE TABLE EDITEUR(
    idEditeur NUMBER,
    nomEditeur VARCHAR2(50),
    CONSTRAINT pk_editeur PRIMARY KEY(idEditeur)
);

CREATE TABLE JEU (
	idJeu 			NUMBER,
	titre			VARCHAR2(50),
	prix			NUMBER,
	categorieJeu	VARCHAR2(35),
	editeurJeu		NUMBER,
	garantieJeu		NUMBER,
	CONSTRAINT pk_jeu PRIMARY KEY(idJeu),
	CONSTRAINT fk_editeurJeu FOREIGN KEY(editeurJeu) REFERENCES EDITEUR(idEditeur)
);


CREATE TABLE CONSTRUCTEUR(
    idConstructeur NUMBER,
    nomConstructeur VARCHAR2(50),
    CONSTRAINT pk_constructeur PRIMARY KEY(idConstructeur)
);



CREATE TABLE PLATEFORME (
	idPlateforme 		NUMBER,
	nomPlateforme 		VARCHAR2(80),
	constructeur		NUMBER,
	CONSTRAINT pk_plateforme PRIMARY KEY(idPlateforme),
	CONSTRAINT fk_constructeur FOREIGN KEY(constructeur) REFERENCES CONSTRUCTEUR(idConstructeur)
);


CREATE TABLE INSTANCE_JEU(
    cleJeu NUMBER,
    idJeu NUMBER,
    plateformeJeu NUMBER,
    CONSTRAINT pk_instance PRIMARY KEY(cleJeu),
    CONSTRAINT fk_Jeu FOREIGN KEY (idJeu) REFERENCES JEU(idJeu),
    CONSTRAINT fk_plateforme FOREIGN KEY (plateformeJeu) REFERENCES PLATEFORME(idPlateforme)
);



CREATE TABLE ACHAT (	
	cleJeu				NUMBER,
	dateAchat			DATE,
	dateFinGarantie 	DATE,
	magasinAchat		NUMBER,
	CONSTRAINT pk_achat PRIMARY KEY(cleJeu),
	CONSTRAINT fk_cleJeu FOREIGN KEY(cleJeu) REFERENCES INSTANCE_JEU(cleJeu),
	CONSTRAINT fk_magasinAchat FOREIGN KEY(magasinAchat) REFERENCES MAGASIN(idMagasin),
	CONSTRAINT ck_date CHECK (dateAchat>=date '2000-01-01')
);


CREATE TABLE LIEN(
    cleJeu NUMBER,
    idMagasin NUMBER,
    idEditeur NUMBER,
    idPlateforme NUMBER,
    idConstructeur NUMBER,   
    CONSTRAINT pk_lien PRIMARY KEY(cleJeu, idMagasin, idEditeur, idPlateforme, idConstructeur),
    CONSTRAINT fk_lien_instance FOREIGN KEY (cleJeu) REFERENCES INSTANCE_JEU(cleJeu),
    CONSTRAINT fk_lien_magasin FOREIGN KEY (idMagasin) REFERENCES MAGASIN(idMagasin),
    CONSTRAINT fk_lien_editeur FOREIGN KEY (idEditeur) REFERENCES EDITEUR(idEditeur),
    CONSTRAINT fk_lien_plateforme FOREIGN KEY (idPlateforme) REFERENCES PLATEFORME(idPlateforme),
    CONSTRAINT fk_lien_constructeur FOREIGN KEY (idConstructeur) REFERENCES CONSTRUCTEUR(idConstructeur)
);


-- SEQUENCES

prompt *****************************************************************
prompt ******************** CREATE SEQUENCES ***************************
prompt *****************************************************************


CREATE SEQUENCE primary_idJeu
	START WITH     1
	INCREMENT BY   1
	NOCYCLE;


CREATE SEQUENCE primary_cleJeu
	START WITH     1000
	INCREMENT BY   1
	NOCYCLE;


CREATE SEQUENCE primary_idConstructeur
	START WITH     1
	INCREMENT BY   1
	NOCYCLE;

CREATE SEQUENCE primary_idEditeur
	START WITH     1
	INCREMENT BY   1
	NOCYCLE;


CREATE SEQUENCE primary_idPlateforme
	START WITH     1
	INCREMENT BY   1
	NOCYCLE;



CREATE SEQUENCE primary_idMagasin
	START WITH     1
	INCREMENT BY   1
	NOCYCLE;




@script
