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
    
    func configureUI(_ ingr: Ingredient) {
        self.img.layer.cornerRadius = 10
        self.nameLbl.text = ingr.name
        if let img = ingr.ingrImage {
            self.img.image = img
            self.img.backgroundColor = .white
        } else {
            self.img.image = nil
            self.img.backgroundColor = .systemGray6
        }
    }
}
