//
//  IngredientTableViewCell.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 13/03/2021.
//

import UIKit

class IngredientTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ingrImage: UIImageView!
    @IBOutlet weak var ingrName: UILabel!
    
    func setupUI() {
        self.makeShadowAndRadius(shadow: true, opacity: 0.5, radius: 10)
        self.contentView.layer.cornerRadius = 10
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
