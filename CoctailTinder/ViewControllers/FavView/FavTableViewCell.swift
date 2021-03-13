//
//  FavTableViewCell.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 05/03/2021.
//

import UIKit 

class FavTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var glassLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var ingrCV: UICollectionView!
    @IBOutlet weak var ingrCountLbl: UILabel!
    
    var cellCoctail : Coctail!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func updateUI() {
        self.makeShadowAndRadius(shadow: true, opacity: 0.5, radius: 10)
        
        ingrCV.delegate = self
        ingrCV.dataSource = self
        
        self.nameLbl.text = cellCoctail.name
        self.categoryLbl.text = cellCoctail.category
        self.glassLbl.text = cellCoctail.glass
        self.ingrCountLbl.text = "\(cellCoctail.ingrArray.count) Ingredients"
        
        self.img.makeShadowAndRadius(shadow: false, opacity: 0.5, radius: 10)
        
        
        if let cocImg = cellCoctail.image {
            img.image = cocImg
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    //MARK:COLLECTION VIEW
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellCoctail.ingrArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = ingrCV.dequeueReusableCell(withReuseIdentifier: "ingrCell", for: indexPath) as! IngrCollectionViewCell
        let ingr = cellCoctail.ingrArray[indexPath.row]
        
        cell.img.image = ingr.ingrImage
        cell.nameLbl.text = ingr.name
        
        return cell
    }
}
