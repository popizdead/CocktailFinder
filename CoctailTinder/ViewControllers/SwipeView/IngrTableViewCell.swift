//
//  IngrTableViewCell.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 05/03/2021.
//

import UIKit

class IngrTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.makeShadowAndRadius(shadow: false, opacity: 0.5, radius: 10)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var nameLbl: UILabel!
}
