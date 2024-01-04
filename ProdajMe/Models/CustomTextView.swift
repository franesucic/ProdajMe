//
//  CustomTextView.swift
//  ProdajMe
//
//  Created by Frane Sučić on 24.03.2023..
//

import UIKit

class CustomTextView: UITextView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let bottomLayer = CALayer()
        bottomLayer.frame = CGRect(x: 0, y: self.frame.height-1, width: self.frame.width, height: 1)
        bottomLayer.backgroundColor = UIColor.darkGray.cgColor
        self.layer.addSublayer(bottomLayer)
    }
    
}
