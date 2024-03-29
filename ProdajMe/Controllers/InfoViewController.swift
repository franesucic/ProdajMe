//
//  InfoViewController.swift
//  ProdajMe
//
//  Created by Frane Sučić on 24.03.2023..
//

import UIKit
import Pastel

class InfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let pastelView = PastelView(frame: view.bounds)
        pastelView.startPastelPoint = .bottomLeft
        pastelView.endPastelPoint = .topRight
        pastelView.animationDuration = 3.0
        pastelView.setColors([UIColor(red: 0.2225827873, green: 0.7157251239, blue: 1, alpha: 1),
                                UIColor(red: 156/255, green: 39/255, blue: 176/255, alpha: 1.0),
                                  UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1.0),
                                  UIColor(red: 123/255, green: 31/255, blue: 162/255, alpha: 1.0),
                                  UIColor(red: 32/255, green: 76/255, blue: 255/255, alpha: 1.0),
                                  UIColor(red: 90/255, green: 120/255, blue: 127/255, alpha: 1.0),
                                  UIColor(red: 58/255, green: 255/255, blue: 217/255, alpha: 1.0)])
        pastelView.startAnimation()
        view.insertSubview(pastelView, at: 0)
    }

}
