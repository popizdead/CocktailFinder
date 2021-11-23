//
//  IngrCollectionViewCell.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 10/03/2021.
//

import UIKit

class IngrCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var mesureLbl: UILabel!
    
    var ingrCell : Ingredient!
    
    func configureUI() {
        self.img.layer.cornerRadius = 10
        self.nameLbl.text = ingrCell.name
        if let img = ingrCell.ingrImage {
            self.img.image = img
            self.img.backgroundColor = .white
        } else {
            self.img.image = nil
            self.img.backgroundColor = .systemGray6
        }
    }
}
