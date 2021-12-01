//
//  ItemSearchCollectionViewCell.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 18/03/2021.
//

import Foundation
import UIKit
import SwiftEntryKit

class ItemSearchCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgCocktail: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var ingrCountLbl: UILabel!
    
    @IBOutlet weak var insideIngrCV: UICollectionView!
    
    private let dataService = DataService.shared
    
    var cellCocktail : Cocktail?
    
    func setupUI() {
        guard let cellCocktail = cellCocktail else {
            return
        }
        
        insideIngrCV.delegate = self
        insideIngrCV.dataSource = self
        
        self.contentView.backgroundColor = .white
        self.makeShadowAndRadius(shadow: true, opacity: 0.5, radius: 10)
        
        self.contentView.layer.cornerRadius = 10
        self.imgCocktail.layer.cornerRadius = 10
        
        ingrCountLbl.text = "\(cellCocktail.ingrArray.count) Ingredients"
        nameLbl.text = cellCocktail.name
        
        if cellCocktail.image != nil {
            imgCocktail.image = cellCocktail.image
        } else {
            imgCocktail.image = nil
            imgCocktail.backgroundColor = .systemGray6
        }
        
        insideIngrCV.reloadData()
    }
}

//MARK: -COLLECTION VIEW
extension ItemSearchCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let cellCocktail = cellCocktail else {
            return 0
        }
        return cellCocktail.ingrArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = insideIngrCV.dequeueReusableCell(withReuseIdentifier: "ingrCell", for: indexPath) as! InsideIngrCollectionViewCell
        cell.img.layer.cornerRadius = 10
        guard let cellCocktail = cellCocktail else {
            return cell
        }
        
        //Bug catcher
        if indexPath.row <= cellCocktail.ingrArray.count - 1 {
            let ingr = cellCocktail.ingrArray[indexPath.row]
            if ingr.ingrImage != nil {
                cell.img.image = ingr.ingrImage
                cell.img.backgroundColor = .white
            } else {
                cell.img.image = nil
                cell.img.backgroundColor = .systemGray6
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cellCocktail = cellCocktail else {
            return
        }
        let ingrObject = cellCocktail.ingrArray[indexPath.row]
        showIngredient(ingrObject)
    }
    
    private func showIngredient(_ ingredient: Ingredient) {
        let board = UIStoryboard.init(name: "Main", bundle: nil)
        guard let vc = board.instantiateViewController(withIdentifier: "alertIngr") as? AlertIngredientViewController else {
            return
        }
        
        vc.ingredient = ingredient
        SwiftEntryKit.display(entry: vc, using: alertAttributes())
    }
    
    private func alertAttributes() -> EKAttributes {
        var attributes = EKAttributes.centerFloat
        
        let widthConstraint = EKAttributes.PositionConstraints.Edge.ratio(value: 0.8)
        let heightConstraint = EKAttributes.PositionConstraints.Edge.ratio(value: 0.3)
        attributes.positionConstraints.size = .init(width: widthConstraint, height: heightConstraint)
        
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 10, offset: .zero))
        attributes.roundCorners = .all(radius: 15)
        
        attributes.entryBackground = .color(color: .clear)
        attributes.screenBackground = .color(color: EKColor(UIColor(white: 0, alpha: 0.5)))

        attributes.entranceAnimation = .translation
        attributes.exitAnimation = .translation
        
        attributes.displayDuration = .infinity
        attributes.entryInteraction = .forward
        
        attributes.screenInteraction = .dismiss
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
        
        return attributes
    }
}
