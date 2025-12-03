import sqlite3
from actions import database_functions
from actions import database_queries

# Connexion à la base de données
data = sqlite3.connect("data/jo.db")

# Fonction permettant de quitter le programme
def quitter():
    print("Au revoir !")
    exit(0)

# Association des actions aux fonctions
actions = {
    "1": lambda: database_functions.database_create(data),
    "2": lambda: database_functions.database_insert(data),
    "3": lambda: database_functions.database_delete(data),
    "4": lambda: database_queries.liste_epreuves(data, "Ski alpin"),
    "5": lambda: database_queries.insere_sportif_equipe(data),
    "6": lambda: database_queries.inscrit_sportif_epreuve(data),
    "7": lambda: database_queries.inscrit_equipe_epreuve(data),
    "8": lambda: database_queries.liste_sportifs(data),
    "9": lambda: database_queries.liste_nb_sportifs_par_equipe(data),
    "10": lambda: database_queries.Age_moyen_or_equipe(data),
    "11": lambda: database_queries.Tableau_medailles(data),
    "q": quitter
}

# Fonctions d'affichage du menu
def menu():
    print("\n=== Menu principal ===")
    print("1  - Créer la base de données")
    print("2  - Insérer les données du fichier Excel")
    print("3  - Supprimer la base de données")
    print("4  - Liste des épreuves de ski alpin")
    print("5  - Inserer un sportif dans une equipe") #Utiliser pour tester les triggers
    print("6  - Inscrire un sportif dans une épreuve") #Utiliser pour tester les triggers(genre et formeEp)
    print("7  - Inscrire une équipe dans une épreuve") #Utiliser pour tester les triggers
    print("8  - Informations sur les sportifs")#Affiche la vue LesAgesSportifs
    print("9  - Affiche le nombre de sportifs par équipe")#Affiche la vue NbsEquipiers
    print("10 - Affiche l'age moyen des sportifs dans les équipe ayant obtenu une médaille d'or")#Affiche la vue AgeORMoyen
    print("11 - Affiche le tableau des médailles ")#Affiche la vue ClassementPays
    print("q  - Quitter")

# Fonction principale
def main():
     # Appel du menu en boucle et gestion du choix
    while True:
        menu()
        choix = input("Votre choix : ").strip()
        action = actions.get(choix)
        if action:
            action()
        else:
            print("Choix invalide.")

# Appel de la fonction principale
main()