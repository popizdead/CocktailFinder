//
//  FavViewController.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 05/03/2021.
//

import UIKit

class FavViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var favCollectionView: UICollectionView!
    @IBOutlet weak var navView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        favCollectionView.delegate = self
        favCollectionView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: Notification.Name("updateFavCV"), object: nil)
        designSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favCollectionView.reloadData()
    }
    
    func designSetup() {
        self.navView.makeShadowAndRadius(shadow: true, opacity: 0.5, radius: 10)
    }
    
    @objc func update() {
        favCollectionView.reloadData()
        print("\(favArray.count) saved!!!!!")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = favCollectionView.dequeueReusableCell(withReuseIdentifier: "favCell", for: indexPath) as! FavCollectionViewCell
        cell.cellCoctail = favArray[indexPath.row]
        cell.updateUI()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        reviewCocktail = favArray[indexPath.row]
        self.performSegue(withIdentifier: "favToReview", sender: self)
    }
    
}
