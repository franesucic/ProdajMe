//
//  MyDataViewController.swift
//  ProdajMe
//
//  Created by Frane Sučić on 03.04.2023..
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class MyDataViewController: UIViewController {
    
    let db = Firestore.firestore()

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    var password: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backView.layer.cornerRadius = backView.frame.height / 7
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func loadData() {
        let currentMail = Auth.auth().currentUser?.email ?? ""
        db.collection("users").getDocuments { querySnapshot, error in
            if let e = error {
                self.presentAlert(message: "Nešto je pošlo po zlu, \(e.localizedDescription)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for snapshot in snapshotDocuments {
                        let doc = snapshot.data()
                        if let username = doc["username"] as? String, let email = doc["email"] as? String, let phoneNumber = doc["phoneNumber"] as? String, let password = doc["password"] as? String {
                            if (currentMail == email) {
                                self.mailLabel.text = email
                                self.usernameLabel.text = username
                                self.phoneLabel.text = phoneNumber
                                self.password = password
                            }
                        }
                    }
                }
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
