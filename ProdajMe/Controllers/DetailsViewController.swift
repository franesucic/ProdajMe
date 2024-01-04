//
//  DetailsViewController.swift
//  ProdajMe
//
//  Created by Frane Sučić on 27.04.2023..
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var detailsImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var adressLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var userView: UIView!
    var thisAdvert: Advert? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userView.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        userView.layer.cornerRadius = userView.frame.height/6
        titleLabel.text = thisAdvert?.title
        descriptionLabel.text = thisAdvert?.description
        userLabel.text = thisAdvert?.user
        conditionLabel.text = "Stanje: " + thisAdvert!.condition
        adressLabel.text = thisAdvert?.adress
        contactLabel.text = thisAdvert?.contact
        priceLabel.text = thisAdvert!.price + " €"
        subjectLabel.text = "Kolegij: " + thisAdvert!.subject
        self.navigationController?.navigationBar.backItem?.title = "no"
        if let image = thisAdvert?.image {
            detailsImage.image = image
        } else {
            detailsImage.image = UIImage(named: "ZavrsniLogo")
        }
    }

    @IBAction func callNumber(_ sender: UIButton) {
        if let phoneNumber = thisAdvert?.contact {
            if let phoneNumberURL = URL(string: "tel://\(phoneNumber)") {
                let application: UIApplication = UIApplication.shared
                if application.canOpenURL(phoneNumberURL) {
                    application.open(phoneNumberURL, options: [:], completionHandler: nil)
                }
            }
        }
    }
}
