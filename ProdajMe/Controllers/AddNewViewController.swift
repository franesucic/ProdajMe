//
//  AddNewViewController.swift
//  ProdajMe
//
//  Created by Frane Sučić on 21.03.2023..
//

import UIKit
import Firebase
import FirebaseDatabase

class AddNewViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var currentAdvert: Advert? = nil
    var showNavBar: Bool = true
    let conditions: [String] = ["Novo", "Rabljeno", "Oštećeno"]
    var selectedCondition: String = "Novo"
    var username: String = ""
    var imageData: Data? = nil
    let maxLength = 190
    
    let db = Firestore.firestore()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return conditions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return conditions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCondition = conditions[row]
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        myImageView.image = image
        dismiss(animated: true)
    }
    
    @IBAction func addPhotoPressed(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var descriptionField: CustomTextView!
    @IBOutlet weak var subjectField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var contactField: CustomTextField!
    @IBOutlet weak var adressField: CustomTextField!
    @IBOutlet weak var picker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !showNavBar {
            //navigationController?.isNavigationBarHidden = true
            if let advert = currentAdvert {
                titleField.text = advert.title
                descriptionField.text = advert.description
                subjectField.text = advert.subject
                priceField.text = advert.price
                contactField.text = advert.contact
                adressField.text = advert.adress
                myImageView.image = advert.image
            }
        }
        picker.delegate = self
        picker.dataSource = self
        descriptionField.delegate = self
        getUserName()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let currentText = textView.text else {
            return false
        }
        let newLength = currentText.count + text.count - range.length
        if newLength > maxLength {
            return false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if !showNavBar {
            let destinationVC = segue.destination as! ConfirmationViewController
            destinationVC.text = "Oglas uspješno izmjenjen!"
        }
    }
    
    @IBAction func publishPressed(_ sender: UIButton) {
        
        if !showNavBar {
            if let title = titleField.text, let description = descriptionField.text, let subject = subjectField.text, let price = priceField.text, let contact = contactField.text, let adress = adressField.text, let id = currentAdvert?.id {
                if !title.isEmpty, !description.isEmpty, !subject.isEmpty, !price.isEmpty, !contact.isEmpty {
                    if let image = myImageView.image {
                        if let myImage = image.jpegData(compressionQuality: 0.8) {
                            imageData = myImage
                        }
                    } else {
                        imageData = UIImage(named: "Logo")?.jpegData(compressionQuality: 0.8)
                    }
                    db.collection("adverts").document(id).updateData([
                        "user": username,
                        "title": title,
                        "description": description,
                        "condition": selectedCondition,
                        "subject": subject,
                        "price": price,
                        "contact": contact,
                        "adress": adress,
                        "time": currentAdvert?.time as Any,
                        "image": imageData!
                    ])
                } else {
                    presentAlert(message: "Molimo ispunite sva polja.")
                }
            }
            
        } else {
            if let title = titleField.text, let description = descriptionField.text, let subject = subjectField.text, let price = priceField.text, let contact = contactField.text, let adress = adressField.text {
                if !title.isEmpty, !description.isEmpty, !subject.isEmpty, !price.isEmpty, !contact.isEmpty {
                    if let image = myImageView.image {
                        if let myImage = image.jpegData(compressionQuality: 0.8) {
                            imageData = myImage
                        }
                    } else {
                        imageData = UIImage(named: "Logo")?.jpegData(compressionQuality: 0.8)
                    }
                    db.collection("adverts").addDocument(data: [
                        "user": username,
                        "title": title,
                        "description": description,
                        "condition": selectedCondition,
                        "subject": subject,
                        "price": price,
                        "contact": contact,
                        "adress": adress,
                        "time": Date().timeIntervalSince1970,
                        "image": imageData!
                    ]) { error in
                        if let e = error {
                            self.presentAlert(message: "Error while adding new Advert, \(e.localizedDescription)")
                            return
                        }
                    }
                } else {
                    presentAlert(message: "Molimo vas da ispunite sva polja.")
                    return
                }
            }
        }
        performSegue(withIdentifier: "toConfirmation", sender: self)
        }
        
        func presentAlert(message : String) {
            let alert = UIAlertController(title: "Greška", message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "Pokušaj ponovo", style: .cancel)
            alert.addAction(action)
            present(alert, animated: true)
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
        
    }
