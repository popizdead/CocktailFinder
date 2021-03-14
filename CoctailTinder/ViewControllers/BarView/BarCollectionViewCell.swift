//
//  BarCollectionViewCell.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 13/03/2021.
//

import UIKit

class BarCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var ingrImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    func setupUI() {
        self.makeShadowAndRadius(shadow: true, opacity: 0.5, radius: 10)
        self.contentView.layer.cornerRadius = 10
    }
}
