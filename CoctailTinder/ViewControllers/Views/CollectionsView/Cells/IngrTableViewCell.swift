//
//  IngrTableViewCell.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 22/03/2021.
//

import UIKit

class IngrTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var countLbl: UILabel!
    
    var ingrCell : modelIngredient!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI() {
        self.makeShadowAndRadius(shadow: true, opacity: 0.5, radius: 10)
        self.contentView.layer.cornerRadius = 10
        
        self.nameLbl.text = ingrCell.name
        self.countLbl.text = "\(ingrCell.count)"
    }
}
