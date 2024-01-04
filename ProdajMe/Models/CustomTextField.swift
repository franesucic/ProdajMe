//
//  CustomTextField.swift
//  ProdajMe
//
//  Created by Frane Sučić on 24.03.2023..
//

import Foundation
import UIKit

class CustomTextField : UITextField {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUnderlinedTextField()
    }
    
    func setupUnderlinedTextField() {
        let bottomLayer = CALayer()
        bottomLayer.frame = CGRect(x: 0, y: self.frame.height, width: self.frame.width-30, height: 1)
        bottomLayer.backgroundColor = UIColor.darkGray.cgColor
        self.layer.addSublayer(bottomLayer)
    }
    
    func setupLeftImage(image: UIImage) {
        self.leftViewMode = .always
        let leftView = UIImageView(frame: CGRect(x: 0, y: self.frame.height/2-10, width: 25, height: 20))
        leftView.tintColor = .darkGray
        leftView.image = image
        self.addSubview(leftView)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 30, y: 0, width: bounds.width, height: bounds.height)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 30, y: 0, width: bounds.width, height: bounds.height)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 30, y: 0, width: bounds.width, height: bounds.height)
    }
    
    
    
}
