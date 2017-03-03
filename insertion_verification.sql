
-- Violation contrainte check : date < 2001

INSERT INTO ACHAT VALUES(1100, to_date('2-9-1999','dd-mm-yyyy'), to_date('01-01-2000','dd-mm-yyyy'), 4);


-- Violation contrainte d'achat dans le futur

INSERT INTO ACHAT VALUES(1101, to_date('2-9-2020','dd-mm-yyyy'), to_date('01-01-2000','dd-mm-yyyy'), 4);

