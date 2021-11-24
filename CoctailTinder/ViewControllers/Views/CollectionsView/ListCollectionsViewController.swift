//
//  ListCollectionsViewController.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 17/03/2021.
//

import UIKit
import Alamofire

class ListCollectionsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    //MARK: -OUTLETS
    @IBOutlet weak var viewNameLbl: UILabel!
    
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var refreshButton: UIButton!
    
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var itemsCV: UICollectionView!

    private let network = NetworkService.shared
    private let dataService = DataService.shared
    
    //MARK: -VIEW LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewNameLbl.text = screenName
        network.currentRequestFrom = .collection
        
        checkRefreshButton()
        itemsCV.reloadData()
    }
    
    
    func checkRefreshButton() {
        if showingRequest == .new || showingRequest == .pop || showingRequest == .random {
            refreshButton.isHidden = true
        } else {
            refreshButton.isHidden = false
        }
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
    
    //MARK: BUTTONS
    @IBAction func refreshButtonTapped(_ sender: UIButton) {
        if colCurrentState == .categories {
            network.categoryRequest(showingRequest.getUrl(), showingRequest.getRequestType()) { cocktail in
                self.apply(cocktail)
            }
        } else {
            network.byIngredientSearch(screenName) { cocktail in
                self.apply(cocktail)
            }
        }
    }
    
    private func apply(_ cocktail: Cocktail?) {
        guard let cocktail = cocktail else { return }
        cocktail.getImages {
            self.update()
        }
        
        self.dataService.collectionCocktailSource.append(cocktail)
    }
    
    
    @IBAction func dismissTapped(_ sender: UIButton) {
        AF.session.getAllTasks { (tasks) in
            tasks.forEach({$0.cancel()})
        }
        
        self.dataService.collectionCocktailSource.removeAll()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK:COLLECTION VIEW
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataService.collectionCocktailSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = itemsCV.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as! ListItemCollectionViewCell
        cell.cellCocktail = self.dataService.collectionCocktailSource[indexPath.row]
        cell.setupUI()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cocktail = self.dataService.collectionCocktailSource[indexPath.row]
        reviewCocktail = cocktail
        
        self.performSegue(withIdentifier: "collectionToReview", sender: self)
    }
    
}
