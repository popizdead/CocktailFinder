//
//  ItemSearchCollectionViewCell.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 18/03/2021.
//

import UIKit

class ItemSearchCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var imgCocktail: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var ingrCountLbl: UILabel!
    
    @IBOutlet weak var insideIngrCV: UICollectionView!
    
    var cellCocktail : Coctail!
    var isDownloading = false
    
    func setupUI() {
        insideIngrCV.delegate = self
        insideIngrCV.dataSource = self
        
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
            cell.img.image = ingr.ingrImage
        }
        return cell
    }
}
