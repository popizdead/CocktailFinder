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
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var itemsCV: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewNameLbl.text = screenName
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        responseArray.removeAll()
        sourceItemsArray.removeAll()
    }
    
    func delegates() {
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: NSNotification.Name("updateItemsCV"), object: nil)
        itemsCV.delegate = self
        itemsCV.dataSource = self
    }
    
    func setupUI() {
        delegates()
        navView.backgroundColor = .white
        navView.makeShadowAndRadius(shadow: true, opacity: 0.5, radius: 10)
    }
    
    @objc func update() {
        itemsCV.reloadData()
    }
    
    @IBAction func dismissTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cocktail = sourceItemsArray[indexPath.row]
        reviewCocktail = cocktail
        self.performSegue(withIdentifier: "collectionToReview", sender: self)
    }
    
}
