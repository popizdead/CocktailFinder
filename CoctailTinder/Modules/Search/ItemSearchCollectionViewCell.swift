//
//  ItemSearchCollectionViewCell.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 18/03/2021.
//

import Foundation
import UIKit
import SwiftEntryKit

class ItemSearchCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var imgCocktail: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var ingrCountLbl: UILabel!
    
    @IBOutlet weak var insideIngrCV: UICollectionView!
    
    private let dataService = DataService.shared
    
    var cellCocktail : Cocktail!
    var isDownloading = false
    
    func setupUI() {
        insideIngrCV.delegate = self
        insideIngrCV.dataSource = self
        
        self.contentView.backgroundColor = .white
        self.makeShadowAndRadius(shadow: true, opacity: 0.5, radius: 10)
        self.contentView.layer.cornerRadius = 10
        self.imgCocktail.layer.cornerRadius = 10
        
        ingrCountLbl.text = "\(cellCocktail.ingrArray.count) Ingredients"
        if cellCocktail.image != nil {
            imgCocktail.image = cellCocktail.image
        } else {
            imgCocktail.image = nil
            imgCocktail.backgroundColor = .systemGray6
        }
        
        nameLbl.text = cellCocktail.name
        insideIngrCV.reloadData()
    }
    
    //MARK:COLLECTION VIEW
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellCocktail.ingrArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = insideIngrCV.dequeueReusableCell(withReuseIdentifier: "ingrCell", for: indexPath) as! InsideIngrCollectionViewCell
        
        if indexPath.row <= cellCocktail.ingrArray.count - 1 {
            cell.img.layer.cornerRadius = 10
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
        let ingrObject = cellCocktail.ingrArray[indexPath.row]
        let stor = UIStoryboard.init(name: "Main", bundle: nil)
        
        dataService.alertIngredient = ingrObject
        SwiftEntryKit.display(entry: stor.instantiateViewController(withIdentifier:"alertIngr"), using: setupAttributes())
    }
    
    func setupAttributes() -> EKAttributes {
        var attributes = EKAttributes.centerFloat
        
        let widthConstraint = EKAttributes.PositionConstraints.Edge.ratio(value: 0.8)
        let heightConstraint = EKAttributes.PositionConstraints.Edge.ratio(value: 0.3)
        
        attributes.positionConstraints.size = .init(width: widthConstraint, height: heightConstraint)
        
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 10, offset: .zero))
        attributes.roundCorners = .all(radius: 15)
        
        // Set its background to white
        attributes.entryBackground = .color(color: .clear)
        attributes.screenBackground = .color(color: EKColor(UIColor(white: 0, alpha: 0.5)))

        // Animate in and out using default translation
        attributes.entranceAnimation = .translation
        attributes.exitAnimation = .translation
        
        attributes.displayDuration = .infinity
        attributes.entryInteraction = .forward
        
        attributes.screenInteraction = .dismiss
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
        
        return attributes
    }
}
