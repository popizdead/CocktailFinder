//
//  ListCollectionsViewController.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 17/03/2021.
//

import UIKit

class ReviewCategoryViewController: UIViewController {

    //MARK: -OUTLETS
    @IBOutlet weak var viewNameLbl: UILabel!
    
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var refreshButton: UIButton!
    
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var itemsCV: UICollectionView!

    let network = NetworkService.shared
    let dataService = DataService.shared
    
    var requestFrom : UIStateType = .ingr
    
    var categoryCocktailSource : [Cocktail] = []
    weak var selectedCocktail : Cocktail?
    
    //MARK: -VIEW LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewNameLbl.text = ""
        sourceUpdate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        network.stopAllRequests { }    
    }
    
    private func delegates() {
        itemsCV.delegate = self
        itemsCV.dataSource = self
    }
    
    //MARK: -UI
    private func setupUI() {
        delegates()
        
        navView.backgroundColor = .white
        navView.makeShadowAndRadius(shadow: true, opacity: 0.5, radius: 10)
    }
    
    @objc func update() {
        switch requestFrom {
        case .ingr:
            self.viewNameLbl.text = dataService.ingrCategoryReview.name
        case .categories:
            self.viewNameLbl.text = dataService.categoryReview.getTitle()
        }
        
        UIRefreshButton()
        itemsCV.reloadData()
    }
    
    private func UIRefreshButton() {
        let showingCategory = dataService.categoryReview
        let isHidden = showingCategory == .new || showingCategory == .pop || showingCategory == .random
        
        refreshButton.isHidden = isHidden
    }
    
    //MARK: BUTTONS
    @IBAction func refreshButtonTapped(_ sender: UIButton) {
        sourceUpdate()
    }
    
    @IBAction func dismissTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: -COLLECTION VIEW
extension ReviewCategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categoryCocktailSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = itemsCV.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as! ListItemCollectionViewCell
        cell.cellCocktail = self.categoryCocktailSource[indexPath.row]
        cell.setupUI()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cocktail = categoryCocktailSource[indexPath.row]
        selectedCocktail = cocktail
        
        self.performSegue(withIdentifier: "collectionToReview", sender: self)
    }
}
