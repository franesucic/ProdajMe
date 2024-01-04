//
//  MyProfileViewController.swift
//  ProdajMe
//
//  Created by Frane Sučić on 20.03.2023..
//

import UIKit
import FirebaseAuth

class MyProfileViewController: UITableViewController {
    
    let fields: [String] = ["Moji podaci", "Postavke", "Informacije", "Odjavi se"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fields.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath)
        cell.textLabel?.text = fields[indexPath.row]
        if cell.textLabel?.text == "Odjavi se" {
            cell.textLabel?.textColor = .systemRed
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cellText = tableView.cellForRow(at: indexPath)?.textLabel?.text
        if cellText == "Informacije" {
            performSegue(withIdentifier: "toHelp", sender: self)
        } else if cellText == "Postavke" {
            performSegue(withIdentifier: "toSettings", sender: self)
        } else if cellText == "Moji podaci" {
            performSegue(withIdentifier: "toMyData", sender: self)
        } else {
            if let window = UIApplication.shared.connectedScenes.first as? UIWindowScene, let startNavCont = window.keyWindow?.rootViewController as? UINavigationController {
                do {
                    try Auth.auth().signOut()
                } catch {
                    presentAlert(message: "Greška prilikom odjavljivanja")
                }
                startNavCont.popToRootViewController(animated: true)
            }
            
        }
    }
    
    func presentAlert(message : String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Try again", style: .cancel)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
}
