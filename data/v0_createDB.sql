PRAGMA Foreign_keys = on ;
CREATE TABLE LesSportifs
(
  numSp NUMBER(4),
  nomSp VARCHAR2(20),
  prenomSp VARCHAR2(20),
  pays VARCHAR2(20),
  categorieSp VARCHAR2(10),
  dateNaisSp DATE,
  CONSTRAINT SP_PK PRIMARY KEY (numSp),
  CONSTRAINT SP_CK1 CHECK(numSp >= 1000 AND numSp <=1500),
  CONSTRAINT SP_CK2 CHECK(categorieSp IN ('feminin','masculin'))
);

CREATE TABLE LesEpreuves
(
  numEp NUMBER(3),
  nomEp VARCHAR2(20),
  formeEp VARCHAR2(13),
  nomDi VARCHAR2(25),
  categorieEp VARCHAR2(10),
  nbSportifsEp NUMBER(2),
  dateEp DATE,
  CONSTRAINT EP_PK PRIMARY KEY (numEp),
  CONSTRAINT EP_CK1 CHECK (formeEp IN ('individuelle','par equipe','par couple')),
  CONSTRAINT EP_CK2 CHECK (categorieEp IN ('feminin','masculin','mixte')),
  CONSTRAINT EP_CK3 CHECK (numEp > 0),
  CONSTRAINT EP_CK4 CHECK (nbSportifsEp > 0)
);

CREATE TABLE LesDisciplines
( 
  nomDi VARCHAR2(25),
  CONSTRAINT DI_PK PRIMARY KEY (nomDi)
);

CREATE TABLE LesEquipes
(
    numEq NUMBER(3),
  CONSTRAINT EQ_PK PRIMARY KEY (numEq),
  CONSTRAINT EQ_CK1 CHECK (numEq > 0 AND numEq <=100)
);

CREATE TABLE SportifAppartientEquipe
(
  numSp NUMBER(4), 
  numEq NUMBER(3),  
  CONSTRAINT SAE_PK PRIMARY KEY (numSp,numEq),
  CONSTRAINT FK_SP FOREIGN KEY (numSp)
      REFERENCES LesSportifs (numSp)
  CONSTRAINT FK_EQ FOREIGN KEY (numEq)
      REFERENCES LesEquipes (numEq)
);

CREATE TABLE ParticipeEquipe
(
  numEp NUMBER(3),
  numEq NUMBER(3),
  TypeM VARCHAR2(8)
  CONSTRAINT PE_CK1 CHECK (TypeM IN ('or','argent','bronze')),
  CONSTRAINT PE_PK PRIMARY KEY (numEp,numEq),
  CONSTRAINT FK_EP FOREIGN KEY (numEp)
      REFERENCES LesEpreuves (numEp)
  CONSTRAINT FK_EQ FOREIGN KEY (numEq)
      REFERENCES LesEquipes (numEq)
);
CREATE TABLE ParticipeIndividuel
(
  numEp NUMBER(3),
  numSp NUMBER(4),
  TypeM VARCHAR2(8)
  CONSTRAINT PI_CK1 CHECK (TypeM IN ('or','argent','bronze')),
  CONSTRAINT PI_PK PRIMARY KEY (numEp,numSp),
  CONSTRAINT FK_EP FOREIGN KEY (numEp)
      REFERENCES LesEpreuves (numEp)
  CONSTRAINT FK_SP FOREIGN KEY (numSp)
      REFERENCES LesSportifs (numSp)
);

/* Créer une vue LesAgesSportifs 
(numSp, nomSp, prenomSp, pays, categorieSp, dateNaisSp, ageSp)*/
CREATE VIEW LesAgesSportifs AS
  SELECT numSp, nomSp, prenomSp, pays, categorieSp, dateNaisSp,
	CAST((julianday('now') - julianday(dateNaisSp)) / 365.25 AS INTEGER) AS ageSp
	FROM LesSportifs ;

/*Créer une vue LesNbsEquipiers(numEq, nbEquipiersEq)*/
CREATE VIEW LesNbsEquipiers AS
  SELECT numEq , COUNT(numSp) AS nbEquipiersEq
  FROM SportifAppartientEquipe
  GROUP BY numEq ;

/*Créer une vue calculant l’âge moyen des équipes 
qui ont gagné une médaille d’or*/
CREATE VIEW AgeORMoyen AS
  SELECT numEq, AVG(ageSp) AS AgeMoy
  FROM SportifAppartientEquipe JOIN LesAgesSportifs USING (numSp)
     JOIN ParticipeEquipe USING (numEq)
	GROUP BY numEq
	HAVING TypeM = 'or' ;

/*Créer une vue donnant le classement des pays 
selon leur nombre de médailles (pays,
nbOr, nbArgent, nbBronze)*/
CREATE VIEW ClassementPays AS
	SELECT pays, SUM(nbOr) as nbOr, SUM(nbArgent) as nbArgent, SUM(nbBronze) as nbBronze
	FROM
		(SELECT numEp, pays, SUM(TypeM='or') as nbOr, SUM(TypeM='argent') as nbArgent, SUM(TypeM='bronze') as nbBronze
		FROM ParticipeIndividuel JOIN LesSportifs USING (numSp)
		WHERE TypeM IS NOT NULL
		GROUP BY pays

		UNION 

		SELECT numEp, pays, SUM(TypeM='or') as nbOr, SUM(TypeM='argent') as nbArgent, SUM(TypeM='bronze') as nbBronze
		FROM SportifAppartientEquipe JOIN LesAgesSportifs USING (numSp)
			 JOIN ParticipeEquipe USING (numEq)
		WHERE TypeM IS NOT NULL
		GROUP BY numSp ) AS totResultat
	GROUP BY pays
	ORDER BY nbOr DESC, nbArgent DESC, nbBronze DESC ;