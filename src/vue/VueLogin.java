package vue;

import java.awt.Color;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;

import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JPasswordField;
import javax.swing.JTextField;

import controleur.Controleur;
import controleur.OrangeProjetMvc;
import controleur.Admin;

public class VueLogin extends JFrame implements ActionListener, KeyListener
{
	private JButton btConnexion = new JButton("Se Connecter"); 
	private JButton btAnnuler = new JButton("Annuler"); 
	
	private JTextField txtEmail = new JTextField(""); 
	private JPasswordField txtMdp = new JPasswordField(""); 

	public VueLogin () {
		this.setTitle("Orange");
		this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		this.setBounds(200, 200, 600, 300);
		this.getContentPane().setBackground(new Color (255, 200, 100));
		this.setLayout(null);
		this.setResizable(false);
		
		//installer le logo 
		ImageIcon uneImage = new  ImageIcon ("src/images/logo.png"); 
		JLabel labelLogo = new JLabel(uneImage); 
		labelLogo.setBounds(20, 20, 220, 220);
		this.add(labelLogo); 
		
		//installation du panel connexion 
		JPanel panelConnexion = new JPanel (); 
		panelConnexion.setBounds(260, 40, 300, 200);
		panelConnexion.setBackground(new Color (255, 200, 100));
		panelConnexion.setLayout(new GridLayout(3, 2));
		
		panelConnexion.add(new JLabel("Email : ")); 
		panelConnexion.add(this.txtEmail); 
		panelConnexion.add(new JLabel("MDP :")); 
		panelConnexion.add(this.txtMdp); 
		panelConnexion.add(this.btAnnuler); 
		panelConnexion.add(this.btConnexion); 
		panelConnexion.setVisible(true);
		this.add(panelConnexion); 
		
		//on rend les boutons ecoutables 
		this.btAnnuler.addActionListener(this);
		this.btConnexion.addActionListener(this);
		//on rend les champs de saisie écoutables 
		this.txtEmail.addKeyListener(this);
		this.txtMdp.addKeyListener(this);
		
		this.setVisible(true);
	}

	@Override
	public void actionPerformed(ActionEvent e) {
		 
		if (e.getSource()==this.btAnnuler) {
			this.txtEmail.setText("");
			this.txtMdp.setText("");
		}
		else if (e.getSource() == this.btConnexion) {
			this.VerifConnexion();
		}
	}
	public void VerifConnexion ()
	{
		String email = this.txtEmail.getText(); 
		String mdp = new String (this.txtMdp.getPassword()); 
		
		//on vérifie dans la base de données à travers le modèle
		Admin unAdmin = Controleur.selectWhereAdmin(email, mdp); 
		if (unAdmin == null) {
			JOptionPane.showMessageDialog(this, "Veuillez vérifier vos identifiants!");
			this.txtEmail.setText("");
			this.txtMdp.setText("");
		}else{
			//on lance la vue générale et on réduit la vue connexion 
			OrangeProjetMvc.rendreVisibleGenerale(true, unAdmin);
			OrangeProjetMvc.rendreVisibleConnexion(false);
		}	
	}
	@Override
	public void keyTyped(KeyEvent e) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void keyPressed(KeyEvent e) {
		 if (e.getKeyCode() == KeyEvent.VK_ENTER) {
			 this.VerifConnexion();
		 }
		
	}

	@Override
	public void keyReleased(KeyEvent e) {
		// TODO Auto-generated method stub
		
	}
}












