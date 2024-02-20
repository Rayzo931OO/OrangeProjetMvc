package controleur;

import vue.VueLogin;
import vue.VueGeneral;

public class OrangeProjetMvc {

	private static VueLogin uneVueConnexion;
	private static VueGeneral uneVueGenerale ; 
	
	public static void main (String args[]) {
		//instanciation de la vueConnexion 
		uneVueConnexion = new VueLogin(); 
	}
	
	public static void rendreVisibleConnexion (boolean action) {
		uneVueConnexion.setVisible(action);
	}
	public static void rendreVisibleGenerale (boolean action, Admin unAdmin) {
		if (action == true) {
			uneVueGenerale = new VueGeneral(unAdmin); 
			uneVueGenerale.setVisible(true);
		}else {
			uneVueGenerale.dispose();
		}
	}
}





















