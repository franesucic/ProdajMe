//
//  LoginViewController.swift
//  ProdajMe
//
//  Created by Frane Sučić on 09.03.2023..
//

import UIKit
import FirebaseAuth

class LoginViewController : UIViewController {
    
    @IBOutlet weak var usernameLabel: CustomTextField!
    @IBOutlet weak var passwordLabel: CustomTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameLabel.text = "sucicfrane06@gmail.com"
        passwordLabel.text = "pacov222"
        usernameLabel.setupLeftImage(image: UIImage(systemName: "envelope")!)
        passwordLabel.setupLeftImage(image: UIImage(systemName: "lock")!)
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        if let username = usernameLabel.text, !username.isEmpty, let password = passwordLabel.text, !password.isEmpty {
            Auth.auth().signIn(withEmail: username, password: password) { authResult, error in
                if error != nil {
                    self.presentAlert(message: "Korisnički profil ne postoji")
                }
                self.performSegue(withIdentifier: "loginToMain", sender: self)
            }
        } else {
            presentAlert(message: "Molimo popunite sva polja")
        }
    }
    
    func presentAlert(message : String) {
        let alert = UIAlertController(title: "Greška", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Pokušaj ponovo", style: .cancel)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
}
