//
//  ModifyAdvertViewController.swift
//  ProdajMe
//
//  Created by Frane Sučić on 29.03.2023..
//

import UIKit
import FirebaseDatabase
import Firebase

class ModifyAdvertViewController: UIViewController {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var adressLabel: UILabel!
    
    var adverts = [Advert]()
    var chosenAdvert: Advert?
    
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        backView.layer.cornerRadius = 70
        titleLabel.text = chosenAdvert?.title
        subjectLabel.text = chosenAdvert?.subject
        priceLabel.text = "\(chosenAdvert?.price ?? "0") €"
        contactLabel.text = chosenAdvert?.contact
        adressLabel.text = chosenAdvert?.adress
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Obriši", message: "Jeste li sigurni da želite obrisati ovaj oglas?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Poništi", style: .cancel)
        let deleteAction = UIAlertAction(title: "Obriši", style: .destructive) { action in
            if let advertId = self.chosenAdvert?.id {
                self.db.collection("adverts").document(advertId).delete() { error in
                    if let e = error {
                        self.presentAlert(message: "Greška prilikom brisanja oglasa, \(e)")
                    }
                }
                for i in 0..<self.adverts.count {
                    if self.adverts[i].id == self.chosenAdvert?.id {
                        self.adverts.remove(at: i)
                        break
                    }
                }
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! AddNewViewController
        destinationVC.currentAdvert = chosenAdvert
        destinationVC.showNavBar = false
    }
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toChange", sender: self)
    }

    func presentAlert(message : String) {
        let alert = UIAlertController(title: "Greška", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Pokušaj ponovo", style: .cancel)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
}
