package vue;

import java.awt.Color;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JPanel;

//import controleur.OrangeEvent;
//import controleur.Technicien;

public class VueGeneral extends JFrame implements ActionListener
{
	private JButton btUtilisateur = new JButton("Utilisateur"); 
	private JButton btProfil = new JButton("Profil");
	private JButton btInterventions = new JButton("Interventions");
	private JButton btMateriels = new JButton("Materiels");
	private JButton btLogiciels = new JButton("Logiciels");
	private JButton btQuitter = new JButton("Quitter");
	
	private JPanel panelMenu = new JPanel ();  
	private static PanelUtilisateur unPanelUtilisateur = new PanelUtlisateur();
	private static PanelProfil unPanelProfil ;
	private static PanelLogiciels unPanelLogiciels = new PanelLogiciels();
	private static PanelMateriels unPanelMateriels = new PanelMateriels();
	private static PanelInterventions unPanelInterventions = new PanelInterventions();
	
	
	public  VueGeneral(Utilisateur unUtilisateur) {
		
		unPanelProfil =  new PanelProfil(unUtilisateur);
		
		this.setTitle("Orange");
		this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		this.setBounds(100, 100, 1000, 600);
		this.getContentPane().setBackground(new Color (255,200,100));
		this.setLayout(null);
		this.setResizable(false); 
		//installation du panel menu 
		panelMenu.setBounds(100, 20, 800, 30);
		panelMenu.setLayout(new GridLayout(1, 6));
		panelMenu.setBackground(new Color (255,200,100));
		panelMenu.add(this.btProfil); 
		panelMenu.add(this.btUtilisateur); 
		panelMenu.add(this.btInterventions);
		panelMenu.add(this.btMateriels);
		panelMenu.add(this.btLogiciels);
		panelMenu.add(this.btQuitter);
		this.add(panelMenu);
		
		//rendre les boutons cliquables 
		this.btQuitter.addActionListener(this);
		this.btUtilisateur.addActionListener(this);
		this.btMateriels.addActionListener(this);
		this.btInterventions.addActionListener(this);
		this.btLogiciels.addActionListener(this);
		this.btProfil.addActionListener(this);
		
		//ajout des pannels dans la fenetre 
		this.add(unPanelProfil); 
		this.add(unPanelUtilisateur); 
		this.add(unPanelMateriels); 
		this.add(unPanelInterventions); 
		this.add(unPanelLogiciels); 
		
		this.setVisible(true);
	}
	
	public void afficher (int choix) {
		unPanelProfil.setVisible(false);
		unPanelUtilisateur.setVisible(false);
		unPanelMateriels.setVisible(false);
		unPanelInterventions.setVisible(false);
		unPanelLogiciels.setVisible(false);
		
		switch (choix) {
		case 1 : unPanelProfil.setVisible(true); break;
		case 2 : unPanelUtilisateur.setVisible(true); break;
		case 3 : unPanelMateriels.setVisible(true); break;
		case 4 : unPanelInterventions.setVisible(true); break;
		case 5 : unPanelLogiciels.setVisible(true); break;
		}
	}
	
	@Override
	public void actionPerformed(ActionEvent e) {
		 
		if (this.btQuitter == e.getSource())
		{
			OrangeProjetMvc.rendreVisibleGenerale(false, null);
			OrangeProjetMvc.rendreVisibleConnexion(true);
		}
		else if (e.getSource() == this.btProfil) {
			afficher(1);
		}
		else if (e.getSource() == this.btUtilisateur) {
			afficher(2);
		}
		else if (e.getSource() == this.btMateriels) {
			afficher(3);
		}
		else if (e.getSource() == this.btInterventions) {
			afficher(4);
		}
		else if (e.getSource() == this.btLogiciels) {
			afficher(5);
		}
	}

}






















