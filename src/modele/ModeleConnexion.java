package modele;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

import controleur.Admin;
import controleur.Intervention;
import controleur.Materiel;
import controleur.viewTech;

public class Modele {
	private static Bdd uneBdd = new Bdd ("localhost","mvc_orange","root","");
	
public static Admin selectWhereAdmin (String email, String mot_de_passe)
{
	Admin unAdmin = null; 
	String requete = "select * from user where email='"+email
			+ "' and mot_de_passe ='"+mot_de_passe+"' and role = admin; ";
	try {
		uneBdd.seConnecter();
		//création d'un curseur pour exécuter la requete 
		Statement unStat = uneBdd.getMaConnexion().createStatement(); 
		//execution de la requete et récuperation d'un resultat 
		ResultSet unRes = unStat.executeQuery(requete); 
		//s'il y a un resultat, on récupere les champs 
		if (unRes.next()) {
			unAdmin = new Admin (
					unRes.getInt("idadmin"),   
					unRes.getString("nom"), 
					unRes.getString("prenom"),  
					unRes.getString("email"), 
					unRes.getString("mdp")
					);
		}
		unStat.close();
		uneBdd.seDeConnecter();
	}
	catch (SQLException exp) {
		System.out.println("Erreur de requete : " +requete);
	}
	
	return unAdmin; 
	}
}
