CREATE TABLE LesSportifs
(
  numSp NUMBER(4),
  nomSp VARCHAR2(20),
  prenomSp VARCHAR2(20),
  pays VARCHAR2(20),
  categorieSp VARCHAR2(10),
  dateNaisSp DATE,
  CONSTRAINT SP_PK PRIMARY KEY (nomSp,prenomSp),
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
  CONSTRAINT EP_CK3 CHECK (numEq > 0 AND numEq <=100)
);

CREATE TABLE SportifAppartientEquipe
(
  prenomSp VARCHAR2(20),
  nomSp VARCHAR2(20), 
  numEq NUMBER(3),  
  CONSTRAINT SAE_PK PRIMARY KEY (nomSp,prenomSp,numEq),
  CONSTRAINT FK_SP FOREIGN KEY (nomSp,prenomSp)
      REFERENCES LesSportifs (nomSp,prenomSp)
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
  nomSp VARCHAR2(20),
  prenomSp VARCHAR2(20),
  TypeM VARCHAR2(8)
  CONSTRAINT PI_CK1 CHECK (TypeM IN ('or','argent','bronze')),
  CONSTRAINT PI_PK PRIMARY KEY (numEp,nomSp,prenomSp),
  CONSTRAINT FK_EP FOREIGN KEY (numEp)
      REFERENCES LesEpreuves (numEp)
  CONSTRAINT FK_SP FOREIGN KEY (nomSp,prenomSp)
      REFERENCES LesSportifs (nomSp,prenomSp)
);


