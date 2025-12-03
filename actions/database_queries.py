# Fonction permettant lister les épreuves d'une discipline donnée
def liste_epreuves(data, discipline):
    print("\nListe des épreuves de " + discipline + " :")
    try:
        cursor = data.cursor()
        result = cursor.execute(
            """
                SELECT DISTINCT nomEp, formeEp
                FROM LesEpreuves
                WHERE nomDi = ?
                ORDER BY nomEp
            """,
            [discipline])
    except Exception as e:
        print("Impossible d'afficher les résultats : " + repr(e))
    else:
        for epreuve in result:
            print(epreuve[0] + " - " + epreuve[1])

def liste_sportifs(data):
    print("\nListe des sportifs avec leurs ages : ")
    print("\nNuméro Nom Prénom Pays Genre Date de Naissance Age :  \n")
    try:
        cursor = data.cursor()
        result = cursor.execute(
            """
                SELECT *
                FROM LesAgesSportifs
            """
        )
    except Exception as e:
        print("Impossible d'afficher les résultats : " + repr(e))
    else:
        for sportifs in result :
            print(sportifs)

def liste_nb_sportifs_par_equipe(data):
    print("\nListe des equipes avec le nombre de sportifs par équipe : ")
    print("\nNumEq nbSportifs :  \n")
    try:
        cursor = data.cursor()
        result = cursor.execute(
            """
                SELECT *
                FROM LesNbsEquipiers
            """
        )
    except Exception as e:
        print("Impossible d'afficher les résultats : " + repr(e))
    else:
        for equipe in result :
            print(equipe)

def Age_moyen_or_equipe(data):
    print("\n Age moyen des joueurs dans les equipes ayant obtenu une médaille d'or: ")
    print("\nNumEq Age Moyen :  \n")
    try:
        cursor = data.cursor()
        result = cursor.execute(
            """
                SELECT *
                FROM AgeORMoyen
            """
        )
    except Exception as e:
        print("Impossible d'afficher les résultats : " + repr(e))
    else:
        for equipe in result :
            print(equipe)

def Tableau_medailles(data):
    print("\n Tableau des medailles: ")
    print("\nPays OR ARGENT BRONZE :  \n")
    try:
        cursor = data.cursor()
        result = cursor.execute(
            """
                SELECT *
                FROM ClassementPays
            """
        )
    except Exception as e:
        print("Impossible d'afficher les résultats : " + repr(e))
    else:
        for pays in result :
            print(pays)


def insere_sportif_equipe(data):
    num_sp=input("Numero du sportif : ")
    num_eq=input("Numero de l'equipe : ")
    try:
        cursor = data.cursor()
        query="insert into SportifAppartientEquipe values ({},{})".format(num_sp,num_eq)
        print(query)
        cursor.execute(query)
    except Exception as e:
        print("Impossible d'inserer le sportif dans l'equipe : " + repr(e))
    else:
        print("le sportif " + num_sp + " a été insere dans " + num_eq)
        data.commit()

def inscrit_sportif_epreuve(data):
    num_sp=input("Numero du sportif : ")
    num_ep=input("Numero de l'epreuve : ")
    try:
        cursor = data.cursor()
        query="insert into ParticipeIndividuel values ({},{},null)".format(num_ep,num_sp)
        print(query)
        cursor.execute(query)
    except Exception as e:
        print("Impossible d'inscrire le sportif a l'épreuve : " + repr(e))
    else:
        print("le sportif " + num_sp + " a été inscrit dans l'epreuve " + num_ep)
        data.commit()

def inscrit_equipe_epreuve(data):
    num_eq=input("Numero de l'equipe : ")
    num_ep=input("Numero de l'epreuve : ")
    try:
        cursor = data.cursor()
        query="insert into ParticipeEquipe values ({},{},null)".format(num_ep,num_eq)
        print(query)
        cursor.execute(query)
    except Exception as e:
        print("Impossible d'inscrire l'équipe a l'épreuve : " + repr(e))
    else:
        print("l'équipe " + num_eq + " a été inscrit dans l'epreuve " + num_ep)
        data.commit()