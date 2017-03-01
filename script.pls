
set serveroutput on;

--============================== TRIGGERS ==============================

--======= TRIGGERS AUTO-INCREMENT ======= 

-- Auto-increment de la clé primaire de JEU (idJeu)


CREATE OR REPLACE TRIGGER auto_increment_idJeu 
BEFORE INSERT ON Jeu FOR EACH ROW
BEGIN
   SELECT primary_idJeu.nextval INTO :NEW.idJeu FROM dual;
END;
/

--=============

-- Auto-increment de la clé primaire de INSTANCE_JEU (cleJeu)

CREATE OR REPLACE TRIGGER auto_increment_cleJeu 
BEFORE INSERT ON Instance_Jeu FOR EACH ROW
BEGIN
   SELECT primary_cleJeu.nextval INTO :NEW.cleJeu FROM dual;
END;
/

--=============

-- Auto-increment de la clé primaire de MAGASIN (idMagasin)

CREATE OR REPLACE TRIGGER auto_increment_idMagasin 
BEFORE INSERT ON Magasin FOR EACH ROW
BEGIN
   SELECT primary_idMagasin.nextval INTO :NEW.idMagasin FROM dual;
END;
/

--=============

-- Auto-increment de la clé primaire de EDITEUR (idEditeur)

CREATE OR REPLACE TRIGGER auto_increment_idEditeur 
BEFORE INSERT ON Editeur FOR EACH ROW
BEGIN
   SELECT primary_idEditeur.nextval INTO :NEW.idEditeur FROM dual;
END;
/

--=============

-- Auto-increment de la clé primaire de PLATEFORME (idPlateforme)

CREATE OR REPLACE TRIGGER auto_increment_idPlateforme 
BEFORE INSERT ON Plateforme FOR EACH ROW
BEGIN
   SELECT primary_idPlateforme.nextval INTO :NEW.idPlateforme FROM dual;
END;
/

--=============

-- Auto-increment de la clé primaire de CONSTRUCTEUR (idConstructeur)

CREATE OR REPLACE TRIGGER auto_increment_idConstructeur 
BEFORE INSERT ON Constructeur FOR EACH ROW
BEGIN
   SELECT primary_idConstructeur.nextval INTO :NEW.idConstructeur FROM dual;
END;
/


--======= AUTRES TRIGGERS ======= 

-- Verification de la date d'achat d'un jeu : invalide si la date est plus grande que la date d'aujourd'hui

CREATE OR REPLACE TRIGGER check_date_achat 
BEFORE INSERT OR UPDATE ON Achat FOR EACH ROW
DECLARE
	date_futur EXCEPTION;
BEGIN
	IF :NEW.dateAchat > SYSDATE THEN
		RAISE date_futur;
	END IF;
EXCEPTION
	WHEN date_futur THEN
		RAISE_APPLICATION_ERROR(-20001, 'Date invalide');			
END;
/


--=============

-- Calcul de la donnée calculable dateFinGarantie à partir de la garantie du jeu.

CREATE OR REPLACE TRIGGER calcul_date_fin_garantie
BEFORE INSERT ON Achat FOR EACH ROW 
DECLARE 	
	garantie_jeu Jeu.garantieJeu%type;
BEGIN
	SELECT garantieJeu INTO garantie_jeu FROM Jeu NATURAL JOIN Achat NATURAL JOIN Instance_Jeu WHERE cleJeu = :NEW.cleJeu;

  :NEW.dateFinGarantie = add_months(:NEW.dateAchat,12*garantie_jeu);
END;
/



--============================== PROCEDURES ==============================

-- Récupère le jeu dont le titre se rapproche le plus du titre passé en paramètre. Récupère la categorie du jeu et propose à l'utilisateur une liste de jeux du même genre qui pourrait l'interresser.


CREATE OR REPLACE PROCEDURE memeCategorie (titreJeu IN VARCHAR)
IS
    catJeu Jeu.categorieJeu%type;
    titreTrouve Jeu.titre%type;


BEGIN	
		SELECT titre INTO titreTrouve FROM Jeu WHERE titre LIKE '%'||titreJeu||'%' AND rownum = 1;

    SELECT categorieJeu INTO catJeu FROM Jeu WHERE titre = titreTrouve;

    dbms_output.put_line('Jeux trouve : ' || titreTrouve);
    dbms_output.put_line('Categorie du jeu trouve : ' || catJeu);
    dbms_output.put_line('--------------');
    dbms_output.put_line('Jeux du meme genre : ');
    FOR jeu in (SELECT idJeu, titre FROM Jeu WHERE categorieJeu = catJeu AND titre <> titreTrouve) LOOP
            dbms_output.put_line('ID: '||jeu.idJeu||'        Titre : '||jeu.titre);
    END LOOP;
    

EXCEPTION 
    WHEN NO_DATA_FOUND THEN       
      dbms_output.put_line('Aucun jeu ne correspond a la recherche : '||titreJeu);
END;
/




--============================== VUES ==============================

-- Vue permettant de récupérer facilement les différentes plateformes disponibles pour un même jeu.

CREATE OR REPLACE VIEW plateforme_jeu AS 
SELECT titre as TitreJeu, nomPlateforme as Plateforme FROM Jeu, Instance_Jeu, Plateforme 
WHERE Jeu.idJeu = Instance_Jeu.idJeu AND Instance_Jeu.plateformeJeu = Plateforme.idPlateforme GROUP BY titre, nomPlateforme ORDER BY TitreJeu;



--============================== INDEX ==============================


-- CREATE INDEX indexJeu on Jeu(idJeu);
-- CREATE INDEX indexMagasin on Magasin(idMagasin);
-- CREATE INDEX indexConstructeur on Constructeur(idConstructeur);
-- CREATE INDEX indexPlateforme on Plateforme(idPlateforme);

