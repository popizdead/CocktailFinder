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
    
    //MARK:VIEW LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        designSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favCollectionView.reloadData()
    }
    
    //MARK:UI
    func designSetup() {
        observers()
        self.navView.makeShadowAndRadius(shadow: true, opacity: 0.5, radius: 10)
        self.navView.backgroundColor = .white
        self.favCollectionView.backgroundColor = .white
    }
    
    func observers() {
        favCollectionView.delegate = self
        favCollectionView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: Notification.Name("updateFavCV"), object: nil)
    }
    
    @objc func update() {
        favCollectionView.reloadData()
    }
    
    //MARK:COLLECTION VIEW
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
