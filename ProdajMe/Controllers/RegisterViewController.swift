//
//  ViewController.swift
//  ProdajMe
//
//  Created by Frane Sučić on 09.03.2023..
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase

class RegisterViewController : UIViewController {

    @IBOutlet weak var emailLabel: CustomTextField!
    @IBOutlet weak var usernameLabel: CustomTextField!
    @IBOutlet weak var phoneNumberLabel: CustomTextField!
    @IBOutlet weak var passwordLabel: CustomTextField!
    @IBOutlet weak var confirmPasswordLabel: CustomTextField!
    
    var loggedUser: User? = nil
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailLabel.setupLeftImage(image: UIImage(systemName: "envelope")!)
        usernameLabel.setupLeftImage(image: UIImage(systemName: "person")!)
        phoneNumberLabel.setupLeftImage(image: UIImage(systemName: "phone")!)
        passwordLabel.setupLeftImage(image: UIImage(systemName: "key")!)
        confirmPasswordLabel.setupLeftImage(image: UIImage(systemName: "key.fill")!)
    }

    @IBAction func registerPressed(_ sender: UIButton) {
        if let mail = emailLabel.text,  let username = usernameLabel.text, let phoneNumber = phoneNumberLabel.text, let password = passwordLabel.text, let confirmPassword = confirmPasswordLabel.text {
            if !mail.isEmpty, !username.isEmpty, !phoneNumber.isEmpty, !password.isEmpty, !confirmPassword.isEmpty {
                if password.count >= 7 {
                    if password == confirmPassword {
                        Auth.auth().createUser(withEmail: mail, password: password) { authResult, error in
                            if error != nil {
                                self.presentAlert(message: "Error while creating user, \(error!.localizedDescription)")
                                return
                            } else {
                                guard let userId = authResult?.user.uid else {
                                    self.presentAlert(message: "Error while getting user id")
                                    return
                                }
                                let currentUser = User(userId: userId, email: mail, username: username, phoneNumber: phoneNumber, password: password)
                                self.loggedUser = currentUser
                                self.db.collection("users").addDocument(data: [
                                    "userId": currentUser.userId,
                                    "username": currentUser.username,
                                    "email":currentUser.email,
                                    "phoneNumber":currentUser.phoneNumber,
                                    "password":currentUser.password
                                ]) { error in
                                    if error != nil {
                                        self.presentAlert(message: "Error while adding user data, \(error!.localizedDescription)")
                                        return
                                    }
                                }
                                self.performSegue(withIdentifier: "registerToMain", sender: self)
                            }
                        }
                    } else {
                        presentAlert(message: "Lozinke se ne podudaraju")
                        return
                    }
                } else {
                    presentAlert(message: "Lozinka je pre kratka, min. 7 znakova")
                    return
                }
            } else {
                presentAlert(message: "Molimo popunite sva polja")
            }
        }
    }
    
    
    
    func presentAlert(message : String) {
        let alert = UIAlertController(title: "Greška", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Pokušaj ponovo", style: .cancel)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
}

