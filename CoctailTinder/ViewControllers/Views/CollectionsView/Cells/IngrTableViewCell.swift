//
//  IngrTableViewCell.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 22/03/2021.
//

import UIKit

class IngrTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var ingrImg: UIImageView!
    @IBOutlet weak var countLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
