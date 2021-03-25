//
//  ShortFavCollectionViewCell.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 21/03/2021.
//

import UIKit

class ShortFavCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var ingrCountLbl: UILabel!
    @IBOutlet weak var insideIngrCV: UICollectionView!
    @IBOutlet weak var deleteButton: UIButton!
    
    var cellCocktail : Coctail!
    
    func delegates() {
        insideIngrCV.delegate = self
        insideIngrCV.dataSource = self
    }
    
    func updateUI() {
        delegates()
        self.makeShadowAndRadius(shadow: true, opacity: 0.5, radius: 10)
        self.contentView.layer.cornerRadius = 10
        
        self.nameLbl.text = cellCocktail.name
        self.ingrCountLbl.text = "\(cellCocktail.ingrArray.count) Ingredients"
        
        self.img.makeShadowAndRadius(shadow: false, opacity: 0.5, radius: 10)
        
        if let cocImg = cellCocktail.image {
            img.image = cocImg
        }
        
        self.insideIngrCV.reloadData()
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        favArray = favArray.filter({$0.name != cellCocktail.name})
        updateFavShowingArray()
        NotificationCenter.default.post(name: Notification.Name("updateFavCV"), object: nil)
        deleteSavedCocktail(name: cellCocktail.name)
    }
    
    //MARK:COLLECTION VIEW
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellCocktail.ingrArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = insideIngrCV.dequeueReusableCell(withReuseIdentifier: "ingrCell", for: indexPath) as! InsideIngrCollectionViewCell
        if indexPath.row <= cellCocktail.ingrArray.count {
            let ingr = cellCocktail.ingrArray[indexPath.row]
            
            cell.img.image = ingr.ingrImage
        }
        return cell
    }
}
