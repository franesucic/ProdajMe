//
//  AdvertsTableViewController.swift
//  ProdajMe
//
//  Created by Frane Sučić on 21.03.2023..
//

import UIKit
import Firebase
import FirebaseDatabase

class AdvertsTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let db = Firestore.firestore()
    var allAdverts = [Advert]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        tableView.register(UINib(nibName: "AdvertsViewCell", bundle: nil), forCellReuseIdentifier: "advertCell")
        tableView.separatorStyle = .none
        tableView.rowHeight = 130
        searchBar.barTintColor = #colorLiteral(red: 0.5576226711, green: 0.6372546554, blue: 0.9490506053, alpha: 1)
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadAdverts()
        tableView.reloadData()
    }
    
    func loadAdverts() {
        db.collection("adverts").order(by: "time",descending: true).addSnapshotListener { querySnapshot, error in
            self.allAdverts = []
            if let e = error {
                self.presentAlert(message: "There was a problem with getting data from Database, \(e.localizedDescription)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for data in snapshotDocuments {
                        let id = data.documentID
                        let doc = data.data()
                        if let title = doc["title"] as? String, let user = doc["user"] as? String, let contact = doc["contact"] as? String, let description = doc["description"] as? String, let condition = doc["condition"] as? String, let adress = doc["adress"] as? String, let subject = doc["subject"] as? String, let price = doc["price"] as? String, let time = doc["time"] as? TimeInterval {
                            var newAdvert: Advert
                            if let imageData = doc["image"] as? Data {
                                newAdvert = Advert(id: id,user: user, title: title, description: description, subject: subject, price: price, condition: condition, contact: contact, adress: adress, time: time, image: UIImage(data: imageData))
                            } else {
                                newAdvert = Advert(id: id,user: user, title: title, description: description, subject: subject, price: price, condition: condition, contact: contact, adress: adress, time: time, image: UIImage(named: "Logo"))
                            }
                            self.allAdverts.append(newAdvert)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allAdverts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "advertCell", for: indexPath) as! AdvertsViewCell
        cell.titleLabel.text = allAdverts[indexPath.row].title
        let date = Date(timeIntervalSince1970: allAdverts[indexPath.row].time)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        cell.dateCell.text = dateFormatter.string(from: date)
        cell.priceLabel.text = allAdverts[indexPath.row].price + " €"
        cell.backgroundColor = #colorLiteral(red: 0.5576226711, green: 0.6372546554, blue: 0.9490506053, alpha: 1)
        cell.cellImage.image = allAdverts[indexPath.row].image
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetails", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! DetailsViewController
        if let index = tableView.indexPathForSelectedRow?.row {
            destination.thisAdvert = allAdverts[index]
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            loadAdverts()
            tableView.reloadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else {
            allAdverts = allAdverts.filter({ elem in
                return elem.title.lowercased().contains(searchBar.text!.lowercased())
            })
            tableView.reloadData()
        }
        
    }

}
