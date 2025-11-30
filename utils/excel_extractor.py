import sqlite3, pandas
from sqlite3 import IntegrityError

# Fonction permettant de lire le fichier Excel des JO et d'insérer les données dans la base
def read_excel_file(data:sqlite3.Connection, file):
    # Lecture de l'onglet du fichier excel LesSportifsEQ, en interprétant toutes les colonnes comme des strings
    # pour construire uniformement la requête
    df_sportifs = pandas.read_excel(file, sheet_name='LesSportifsEQ', dtype=str)
    df_sportifs = df_sportifs.where(pandas.notnull(df_sportifs), 'null')

    cursor = data.cursor()
    for ix, row in df_sportifs.iterrows():
        try:
            query = "insert into LesSportifs values ({},'{}','{}','{}','{}','{}')".format(
                row['numSp'], row['nomSp'], row['prenomSp'], row['pays'], row['categorieSp'], row['dateNaisSp'])
            # On affiche la requête pour comprendre la construction. A enlever une fois compris.
            print(query)
            cursor.execute(query)
        except IntegrityError as err:
            print(err)

    # Lecture de l'onglet LesEpreuves du fichier excel, en interprétant toutes les colonnes comme des string
    # pour construire uniformement la requête
    df_epreuves = pandas.read_excel(file, sheet_name='LesEpreuves', dtype=str)
    df_epreuves = df_epreuves.where(pandas.notnull(df_epreuves), 'null')

    cursor = data.cursor()
    for ix, row in df_epreuves.iterrows():
        try:
            query = "insert into LesEpreuves values ({},'{}','{}','{}','{}',{},".format(
                row['numEp'], row['nomEp'], row['formeEp'], row['nomDi'], row['categorieEp'], row['nbSportifsEp'])

            if row['dateEp'] != 'null':
                query = query + "'{}')".format(row['dateEp'])
            else:
                query = query + "null)"
            # On affiche la requête pour comprendre la construction. A enlever une fois compris.
            print(query)
            cursor.execute(query)
        except IntegrityError as err:
            print(f"{err} : \n{row}")
        cursor = data.cursor()
    
    #On construit la requete pour la table LesDisciplines avec LesEpreuves lu precedemment
    for ix, row in df_epreuves.iterrows():
        try:
            query = "insert into LesDisciplines values ('{}')".format(row['nomDi'])
            # On affiche la requête pour comprendre la construction. A enlever une fois compris.
            #print(query)
            cursor.execute(query)
        except IntegrityError as err:
            print(f"{err} : \n{row}")


    # Lecture de l'onglet LesInscriptions du fichier excel, en interprétant toutes les colonnes comme des string
    # pour construire uniformement la requête
    df_inscriptions = pandas.read_excel(file, sheet_name='LesInscriptions', dtype=str)
    df_inscriptions = df_inscriptions.where(pandas.notnull(df_inscriptions), 'null')

    cursor = data.cursor()
    for ix, row in df_inscriptions.iterrows():
        try:
            if int(row['numIn']) <=100 :
                query = "insert into LesEquipes values ({})".format(row['numIn'])
                # On affiche la requête pour comprendre la construction. A enlever une fois compris.
                print(query)
                cursor.execute(query)
        except IntegrityError as err:
            print(f"{err} : \n{row}")

    #Construction a l'aide des lectures précédante de table SportifAppartientEquipe qui est
    #relation entre Sportif et numEq
    cursor = data.cursor()
    for ix, row in df_sportifs.iterrows():
        try:
            if row['numEq'] != 'null' :
                query = "insert into SportifAppartientEquipe values ({},{})".format(
                    row['numSp'], row['numEq'])
                # On affiche la requête pour comprendre la construction. A enlever une fois compris.
                print(query)
                cursor.execute(query)
        except IntegrityError as err:
            print(err)
    # Lecture de l'onglet LesResultats du fichier excel, en interprétant toutes les colonnes comme des string
    # pour construire uniformement la requête
    #Requete permettant de construire participe indivuel qui comprend les numSp les epreuves ou ils sont inscrit 
    # et si ils ont obtenu une médaille dans cette épreuve
    df_resultats = pandas.read_excel(file, sheet_name='LesResultats', dtype=str)
    df_resultats = df_resultats.where(pandas.notnull(df_resultats), 'null')     
    dico_medailles=df_resultats.set_index('numEp').to_dict('index')
    cursor = data.cursor()
    medaille_gagner = ''
    for ix, row in df_inscriptions.iterrows():
        try:
            numero_epreuve=row['numEp']
            numero_inscription=row['numIn']
            if int(numero_inscription) > 100 :
                medailles=dico_medailles.get(numero_epreuve)
                if medailles :
                    if medailles['gold'] == numero_inscription :
                        medaille_gagner= 'or'
                    elif medailles['silver'] == numero_inscription :
                        medaille_gagner ='argent'
                    elif medailles['bronze'] ==numero_inscription :
                        medaille_gagner = 'bronze'
                    else :
                        medaille_gagner ='null'
                else :
                    medaille_gagner ='null'
                if medaille_gagner != 'null' :
                    query = "insert into ParticipeIndividuel values ({},{},'{}')".format(
                numero_epreuve,numero_inscription, medaille_gagner)
                else :
                    query = "insert into ParticipeIndividuel values ({},{},null)".format(
                    numero_epreuve,numero_inscription)
                print(query)
                cursor.execute(query)
        except IntegrityError as err:
            print(err)

    #Requete permettant de construire participe indivuel qui comprend les numSp les epreuves ou ils sont inscrit 
    # et si ils ont obtenu une médaille dans cette épreuve
    cursor = data.cursor()
    medaille_gagner = ''
    for ix, row in df_inscriptions.iterrows():
        try:
            numero_epreuve=row['numEp']
            numero_inscription=row['numIn']
            if int(numero_inscription) <=100 :
                medailles=dico_medailles.get(numero_epreuve)
                if medailles :
                    if medailles['gold'] == numero_inscription :
                        medaille_gagner= 'or'
                    elif medailles['silver'] == numero_inscription :
                        medaille_gagner ='argent'
                    elif medailles['bronze'] ==numero_inscription :
                        medaille_gagner = 'bronze'
                    else :
                        medaille_gagner ='null'
                else :
                    medaille_gagner ='null'
                if medaille_gagner != 'null' :
                    query = "insert into ParticipeEquipe values ({},{},'{}')".format(
                numero_epreuve,numero_inscription, medaille_gagner)
                else :
                    query = "insert into ParticipeEquipe values ({},{},null)".format(
                    numero_epreuve,numero_inscription)
                print(query)
                cursor.execute(query)
        except IntegrityError as err:
            print(err)