-- On verfie si tous les sportifs de l'equipe sont du même pays
CREATE TRIGGER IF NOT EXISTS equipe_meme_pays
    BEFORE INSERT 
    ON SportifAppartientEquipe
    BEGIN
        SELECT RAISE (ABORT, "Pays du sportif imcompatible avec le pays des sportifs de l'equipe")
        FROM SportifAppartientEquipe JOIN LesSportifs USING(numSp)
        WHERE numEq=NEW.numEq AND 
        (SELECT pays -- On recupere le pays du sportif
        FROM LesSportifs 
        WHERE numSp = NEW.numSp
        ) <> pays ;
    END;
/
-- On verfie si le genre de la personne est compatible avec la categorie de l'epreuve
CREATE TRIGGER IF NOT EXISTS meme_genre_par_epreuve_invididuelle
    AFTER INSERT 
    ON ParticipeIndividuel
    BEGIN
        SELECT RAISE (ABORT, "Genre du sportif imcompatible avec la categorie de l'epreuve")
        FROM ParticipeIndividuel JOIN LesSportifs USING(numSp) JOIN LesEpreuves USING(numEp)
        WHERE (categorieEp = 'feminin' AND numSp=NEW.numSp AND categorieSp = 'masculin')
        OR 
              (categorieEp = 'masculin' AND numSp=NEW.numSp AND categorieSp = 'feminin');
    END;
/
-- On verfie que l'epreuve est bien individuel pour inscrire un sportif
CREATE TRIGGER IF NOT EXISTS categorie_indiv_pour_sportif
    BEFORE INSERT 
    ON ParticipeIndividuel
    BEGIN
        SELECT RAISE (ABORT, "L'epreuve n'est pas une epreuve individuelle ")
        FROM LesEpreuves
        WHERE numEp=NEW.numEp AND formeEp <>'individuelle' ;
    END;

/
-- On verfie si le genre de toute les personnes de l'equipe est compatible avec la categorie de l'epreuve

CREATE TRIGGER IF NOT EXISTS meme_genre_par_epreuve_equipe
    BEFORE INSERT 
    ON ParticipeEquipe
    BEGIN
        SELECT RAISE (ABORT, "Genre des sportif de l'equipe imcompatible avec la categorie de l'epreuve")
        FROM  SportifAppartientEquipe JOIN LesSportifs USING(numSp) JOIN LesEpreuves ON(numEp=NEW.numEp)
        WHERE (categorieEp = 'feminin' AND numEq=NEW.numEq AND categorieSp = 'masculin')
        OR 
              (categorieEp = 'masculin' AND numEq=NEW.numEq AND categorieSp = 'feminin');
    END;
/
-- On verfie que l'eperuve est bien par equipe pour inscrire une equipe
CREATE TRIGGER IF NOT EXISTS categorie_equipe_pour_equipe
    BEFORE INSERT 
    ON ParticipeEquipe
    BEGIN
        SELECT RAISE (ABORT, "L'epreuve n'est pas une epreuve par equipe ")
        FROM LesEpreuves
        WHERE numEp=NEW.numEp AND formeEp ='individuelle' ;
    END;
/
-- On vérifie au moment de l'inscription qu'une équipe comporte au moins 2 joueurs
-- On ne vérifie pas au moment de la création des équipes, sinon on ne pourrait rien créer
CREATE TRIGGER IF NOT EXISTS equipe_au_moins_2sportifs
    BEFORE INSERT 
    ON ParticipeEquipe
    BEGIN
        SELECT RAISE (ABORT, "L'equipe ne contient pas au moins 2 sportifs ")
        WHERE(SELECT COUNT(*)
              FROM SportifAppartientEquipe
              WHERE numEq=NEW.numEq) <2 ;
    END;


