//
//  MainViewController.swift
//  ProdajMe
//
//  Created by Frane Sučić on 09.03.2023..
//

import UIKit

class MainViewController : UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        UITabBar.appearance().tintColor = #colorLiteral(red: 0.5576226711, green: 0.6372546554, blue: 0.9490506053, alpha: 1)
        UITabBar.appearance().backgroundColor = .systemGray5
    }
    
}
