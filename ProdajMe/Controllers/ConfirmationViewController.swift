//
//  ConfirmationViewController.swift
//  ProdajMe
//
//  Created by Frane Sučić on 21.03.2023..
//

import UIKit
import Pastel

class ConfirmationViewController: UIViewController {

    @IBOutlet weak var myLabel: UILabel!
    
    var text: String = "Oglas uspješno predan!"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        myLabel.text = text
        let pastelView = PastelView(frame: view.bounds)
        pastelView.startPastelPoint = .bottomLeft
        pastelView.endPastelPoint = .topRight
        pastelView.animationDuration = 0.5
        pastelView.setColors([UIColor(red: 0.0, green: 1, blue: 0.1, alpha: 1),
                              UIColor(red: 0.0, green: 1, blue: 0.2, alpha: 1),
                              UIColor(red: 0.0, green: 1, blue: 0.4, alpha: 1),
                              UIColor(red: 0.0, green: 1, blue: 0.6, alpha: 1),
                              UIColor(red: 0.0, green: 1, blue: 0.8, alpha: 1),
                              UIColor(red: 0.0, green: 1, blue: 1, alpha: 1),
                                ])
        pastelView.startAnimation()
        view.insertSubview(pastelView, at: 0)
    }

    @IBAction func confirmPressed(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
}
