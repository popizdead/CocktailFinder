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
    @IBOutlet weak var deleteButton: UIButton!
    
    func setupUI() {
        self.makeShadowAndRadius(shadow: true, opacity: 0.5, radius: 10)
        self.contentView.layer.cornerRadius = 10
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        if currentState == .bar {
            ingrBarArray = ingrBarArray.filter({$0.name != self.nameLbl.text})
            deleteSavedIngredient(name: self.nameLbl.text!)
        }
        else if currentState == .buyList {
            userBuyList = userBuyList.filter({$0.name != self.nameLbl.text})
            deleteBuyListItem(name: self.nameLbl.text!)
        }
        NotificationCenter.default.post(name: NSNotification.Name("updateBar"), object: nil)
    }
    
}
