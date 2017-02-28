
set serveroutput on;

--=============

CREATE OR REPLACE TRIGGER auto_increment_idJeu 
BEFORE INSERT ON Jeu FOR EACH ROW
BEGIN
   SELECT primary_idJeu.nextval INTO :NEW.idJeu FROM dual;
END;
/

--=============


CREATE OR REPLACE TRIGGER auto_increment_cleJeu 
BEFORE INSERT ON Instance_Jeu FOR EACH ROW
BEGIN
   SELECT primary_cleJeu.nextval INTO :NEW.cleJeu FROM dual;
END;
/

--=============

CREATE OR REPLACE TRIGGER auto_increment_idMagasin 
BEFORE INSERT ON Magasin FOR EACH ROW
BEGIN
   SELECT primary_idMagasin.nextval INTO :NEW.idMagasin FROM dual;
END;
/

--=============

CREATE OR REPLACE TRIGGER auto_increment_idEditeur 
BEFORE INSERT ON Editeur FOR EACH ROW
BEGIN
   SELECT primary_idEditeur.nextval INTO :NEW.idEditeur FROM dual;
END;
/

--=============

CREATE OR REPLACE TRIGGER auto_increment_idPlateforme 
BEFORE INSERT ON Plateforme FOR EACH ROW
BEGIN
   SELECT primary_idPlateforme.nextval INTO :NEW.idPlateforme FROM dual;
END;
/

--=============


CREATE OR REPLACE TRIGGER auto_increment_idConstructeur 
BEFORE INSERT ON Constructeur FOR EACH ROW
BEGIN
   SELECT primary_idConstructeur.nextval INTO :NEW.idConstructeur FROM dual;
END;
/

--=============


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


CREATE OR REPLACE TRIGGER calcul_date_fin_garantie
BEFORE INSERT ON Achat FOR EACH ROW 
DECLARE 
	fin_garantie date;
	garantie_jeu Jeu.garantieJeu%type;
BEGIN
	SELECT garantieJeu INTO garantie_jeu FROM Jeu NATURAL JOIN Achat NATURAL JOIN Instance_Jeu WHERE cleJeu = :NEW.cleJeu;
END;
/



--============= PROCEDURES =============

CREATE OR REPLACE PROCEDURE memeCategorie (titreJeu IN VARCHAR)
IS
        catJeu Jeu.categorieJeu%type;
        titreTrouve Jeu.titre%type;
BEGIN	
		SELECT titre INTO titreTrouve FROM Jeu WHERE titre LIKE '%'||titreJeu||'%';

        SELECT categorieJeu INTO catJeu FROM Jeu WHERE titre = titreTrouve;
        
        dbms_output.put_line('Jeux trouve : ' || titreTrouve);
        dbms_output.put_line('Genre du jeu trouve : ' || catJeu);
        dbms_output.put_line('--------------');
        dbms_output.put_line('Jeux du meme genre : ');
        FOR jeu in (SELECT idJeu, titre FROM Jeu WHERE categorieJeu = catJeu AND titre <> titreTrouve) LOOP
                dbms_output.put_line('ID: '||jeu.idJeu||'        Titre:'||jeu.titre);
        END LOOP;
END;
/




--============= VUES =============


CREATE OR REPLACE VIEW plateforme_jeu AS 
SELECT titre as TitreJeu, nomPlateforme as Plateforme FROM Jeu, Instance_Jeu, Plateforme 
WHERE Jeu.idJeu = Instance_Jeu.idJeu AND Instance_Jeu.plateformeJeu = Plateforme.idPlateforme GROUP BY titre, nomPlateforme ORDER BY TitreJeu;



--============= INDEX =============


-- CREATE INDEX indexJeu on Jeu(idJeu);
-- CREATE INDEX indexMagasin on Magasin(idMagasin);
-- CREATE INDEX indexConstructeur on Constructeur(idConstructeur);
-- CREATE INDEX indexPlateforme on Plateforme(idPlateforme);



--============= PROCEDURES =============

-- CREATE OR REPLACE PROCEDURE 