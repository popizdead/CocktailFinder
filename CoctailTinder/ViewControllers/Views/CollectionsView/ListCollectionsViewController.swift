//
//  ListCollectionsViewController.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 17/03/2021.
//

import UIKit

class ListCollectionsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var viewNameLbl: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    
    @IBOutlet weak var itemsCV: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        delegates()
    }
    
    func delegates() {
        itemsCV.delegate = self
        itemsCV.dataSource = self
    }
    
    //MARK:COLLECTION VIEW
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sourceItemsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = itemsCV.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as! ListItemCollectionViewCell
        cell.cellCocktail = sourceItemsArray[indexPath.row]
        cell.setupUI()
        return cell
    }
    
}
