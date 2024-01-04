//
//  AdvertsViewCell.swift
//  ProdajMe
//
//  Created by Frane Sučić on 29.03.2023..
//

import UIKit

class AdvertsViewCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var dateCell: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.layer.cornerRadius = backView.frame.height / 8
        cellImage.layer.cornerRadius = cellImage.frame.height / 8
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
