//
//  ItemCollectionViewCell.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 10/03/2021.
//

import UIKit
import Alamofire

class ItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    var ingredient: Ingredient?
    
    private let dataService = DataService.shared
    
    func configure() {
        guard let ingredient = ingredient else {
            return
        }

        nameLbl.text = ingredient.name
        imageSet(ingredient)
        
        favoriteFill()
        UIConfigure()
    }
    
    private func imageSet(_ ingr: Ingredient) {
        if let image = ingr.ingrImage {
            self.img.image = image
            self.img.backgroundColor = .white
        } else {
            if ingr.isDownloading == false {
                ingr.getImage {
                    NotificationCenter.default.post(name: NSNotification.Name("updateAuthCV"), object: nil)
                }
            }
            
            self.img.image = nil
            self.img.backgroundColor = .systemGray6
        }
    }
    
    private func UIConfigure() {
        self.makeShadowAndRadius(shadow: true, opacity: 0.5, radius: 10)
        self.contentView.layer.cornerRadius = 10
        self.img.layer.cornerRadius = 10
    }
    
    private func favoriteFill() {
        if isFavorite() {
            self.contentView.backgroundColor = .darkGray
            self.nameLbl.textColor = .white
        } else {
            self.contentView.backgroundColor = .white
            self.nameLbl.textColor = .black
        }
    }
    
    func action() {
        guard let ingredient = ingredient else {
            return
        }

        if isFavorite() {
            dataService.buyListAction(ingredient, .remove)
        } else {
            dataService.buyListAction(ingredient, .add)
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("updateBar"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("updateAuthCV"), object: nil)
    }
    
    private func isFavorite() -> Bool {
        guard let ingredient = ingredient else {
            return false
        }

        return dataService.userBuyList.contains(where: {$0.name == ingredient.name})
    }
}
