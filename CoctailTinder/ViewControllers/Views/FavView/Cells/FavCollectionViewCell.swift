//
//  FavCollectionViewCell.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 13/03/2021.
//

import UIKit

class FavCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var glassLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var ingrCV: UICollectionView!
    @IBOutlet weak var ingrCountLbl: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    var cellCoctail : Coctail!
    
    func delegates() {
        ingrCV.delegate = self
        ingrCV.dataSource = self
    }
    
    func updateUI() {
        delegates()
        self.makeShadowAndRadius(shadow: true, opacity: 0.5, radius: 10)
        self.contentView.layer.cornerRadius = 10
        
        self.nameLbl.text = cellCoctail.name
        self.categoryLbl.text = cellCoctail.category
        self.glassLbl.text = cellCoctail.glass
        self.ingrCountLbl.text = "\(cellCoctail.ingrArray.count) Ingredients"
        
        self.img.makeShadowAndRadius(shadow: false, opacity: 0.5, radius: 10)
        
        if let cocImg = cellCoctail.image {
            img.image = cocImg
        }
        
        self.ingrCV.reloadData()
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        favArray = favArray.filter({$0.name != cellCoctail.name})
        updateFavShowingArray()
        NotificationCenter.default.post(name: Notification.Name("updateFavCV"), object: nil)
        deleteSavedCocktail(name: cellCoctail.name)
    }
    
    //MARK:COLLECTION VIEW
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellCoctail.ingrArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = ingrCV.dequeueReusableCell(withReuseIdentifier: "ingrCell", for: indexPath) as! IngrCollectionViewCell
        if indexPath.row <= cellCoctail.ingrArray.count {
            let ingr = cellCoctail.ingrArray[indexPath.row]
            
            cell.img.image = ingr.ingrImage 
            cell.nameLbl.text = ingr.name
        }
        return cell
    }
    
    
}
