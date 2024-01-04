//
//  MyAdvertsTableViewController.swift
//  ProdajMe
//
//  Created by Frane Sučić on 24.03.2023..
//

import UIKit
import Firebase
import FirebaseDatabase

class MyAdvertsTableViewController: UITableViewController {
    
    let db = Firestore.firestore()
    
    var myAdverts = [Advert]()
    
    var username: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "MyAdvertCell", bundle: nil), forCellReuseIdentifier: "myAdvertCell")
        tableView.rowHeight = 80
        getUserName()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadMyAdverts()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadMyAdverts()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        myAdverts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myAdvertCell", for: indexPath) as! MyAdvertCell
        cell.title.text = myAdverts[indexPath.row].title
        cell.price.text = myAdverts[indexPath.row].price + " €"
        let date = Date(timeIntervalSince1970: myAdverts[indexPath.row].time)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        cell.date.text = dateFormatter.string(from: date)
        cell.cellImage.image = myAdverts[indexPath.row].image
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toModify", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toModify" {
            let destinationVC = segue.destination as! ModifyAdvertViewController
            if let index = tableView.indexPathForSelectedRow?.row {
                destinationVC.adverts = myAdverts
                destinationVC.chosenAdvert = myAdverts[index]
            }
        }
    }
    
    func loadMyAdverts() {
        db.collection("adverts").order(by: "time").addSnapshotListener { querySnapshot, error in
            self.myAdverts = []
            if let e = error {
                self.presentAlert(message: "There was a problem with getting data from Database, \(e.localizedDescription)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for data in snapshotDocuments {
                        let id = data.documentID
                        let doc = data.data()
                        if let title = doc["title"] as? String, let user = doc["user"] as? String, let contact = doc["contact"] as? String, let description = doc["description"] as? String, let condition = doc["condition"] as? String, let adress = doc["adress"] as? String, let subject = doc["subject"] as? String, let price = doc["price"] as? String, let time = doc["time"] as? TimeInterval {
                            if user == self.username {
                                var newAdvert: Advert
                                if let imageData = doc["image"] as? Data {
                                    newAdvert = Advert(id: id,user: user, title: title, description: description, subject: subject, price: price, condition: condition, contact: contact, adress: adress, time: time, image: UIImage(data: imageData))
                                } else {
                                    newAdvert = Advert(id: id,user: user, title: title, description: description, subject: subject, price: price, condition: condition, contact: contact, adress: adress, time: time, image: UIImage(named: "Logo"))
                                }
                                self.myAdverts.append(newAdvert)
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getUserName() {
        let currentEmail = Auth.auth().currentUser?.email
        print(currentEmail!)
        db.collection("users").addSnapshotListener { querySnapshot, error in
            if let e = error {
                self.presentAlert(message: "Error while fetching data from database, \(e.localizedDescription)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for data in snapshotDocuments {
                        let doc = data.data()
                        if let email = doc["email"] as? String, let myUsername = doc["username"] as? String {
                            
                            if email == currentEmail {
                                self.username = myUsername
                            }
                        }
                    }
                }
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
