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
    
    var cellIndex = Int()
    
    func setupUI() {
        let cellName = sourceArray[cellIndex]
        nameLbl.text = cellName
        if let img = imgDict[cellName] {
            self.img.image = img
            self.img.backgroundColor = .white
        } else {
            AF.request("https://www.thecocktaildb.com/images/ingredients/\(cellName.makeUrlable()).png").responseData { (response) in
                if let data = response.data {
                    if let img = UIImage(data: data) {
                        imgDict[cellName] = img
                        NotificationCenter.default.post(name: NSNotification.Name("updateAuthCV"), object: nil)
                    }
                }
            }
            self.img.image = nil
            self.img.backgroundColor = .systemGray6
            
        }
        self.makeShadowAndRadius(shadow: true, opacity: 0.5, radius: 10)
        self.contentView.layer.cornerRadius = 10
        self.img.layer.cornerRadius = 10
        
        if userBuyList.contains(where: {$0.name == cellName}) {
            self.contentView.backgroundColor = .systemPink
            self.nameLbl.textColor = .white
        } else {
            self.contentView.backgroundColor = .white
            self.nameLbl.textColor = .black
        }
        
    }
    
    func tappedCell() {
        let cellName = sourceArray[cellIndex]
        if userBuyList.contains(where: {$0.name == cellName}) {
            userBuyList = userBuyList.filter({$0.name != cellName})
            deleteBuyListItem(name: cellName)
        } else {
            let ingr = Ingredient(name: cellName)
            if let img = imgDict[cellName] {
                ingr.ingrImage = img
            }
            userBuyList.append(ingr)
            saveBuyListItem(ingr: ingr)
        }
        NotificationCenter.default.post(name: NSNotification.Name("updateBar"), object: nil)
        self.setupUI()
    }
}
