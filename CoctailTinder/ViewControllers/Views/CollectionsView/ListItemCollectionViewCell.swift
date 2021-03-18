//
//  ListItemCollectionViewCell.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 17/03/2021.
//

import UIKit

class ListItemCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var cocktailImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var ingrCountLbl: UILabel!
    @IBOutlet weak var ingrCV: UICollectionView!
    
    var cellCocktail : Coctail!
    
    //MARK:UI
    func setupUI() {
        delegates()
        
        self.makeShadowAndRadius(shadow: true, opacity: 0.5, radius: 10)
        self.contentView.layer.cornerRadius = 10
        self.cocktailImg.layer.cornerRadius = 10
        
        ingrCountLbl.text = "\(cellCocktail.ingrArray.count) Ingredients"
        if cellCocktail.image != nil {
            cocktailImg.image = cellCocktail.image
        } else {
            cocktailImg.image = nil
            cocktailImg.backgroundColor = .systemGray6
        }
        
        nameLbl.text = cellCocktail.name
    }
    
    func delegates() {
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: NSNotification.Name("updateItemsCV"), object: nil)
        ingrCV.delegate = self
        ingrCV.dataSource = self
    }
    
    @objc func update() {
        ingrCV.reloadData()
    }
    
    //MARK:CV
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellCocktail.ingrArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = ingrCV.dequeueReusableCell(withReuseIdentifier: "ingrCell", for: indexPath) as! InsideIngrCollectionViewCell
        //MARK:FIXME
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
