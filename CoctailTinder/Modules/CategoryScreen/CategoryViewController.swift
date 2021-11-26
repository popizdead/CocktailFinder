//
//  CollectionsViewController.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 17/03/2021.
//

import UIKit
import Alamofire

class CategoryViewController: UIViewController {
 
    //MARK: -OUTLETS
    @IBOutlet weak var navView: UIView!
    
    @IBOutlet weak var catButtons: UIButton!
    @IBOutlet weak var ingrButton: UIButton!
    
    @IBOutlet weak var itemsCV: UICollectionView!
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var searchField: UITextField!
    
    let network = NetworkService.shared
    let dataService = DataService.shared
    let factory = Factory.shared
    
    var categoriesSource : [CategoryType] = []
    var categoriesSearch : [CategoryType] = []
    
    var ingredientSource : [CategoryIngredient] = []
    var ingredientSearch : [CategoryIngredient] = []
    
    var UIState : UIStateType = .categories
    var sourceState : SourceStateType = .all
    
    //MARK: -VIEW LOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        VCConfigure()
    }
    
    private func VCConfigure() {
        delegates()
        hideKeyboardSetting()
        
        UISetup()
        getSource()
    }
    
    //MARK: -UI
    private func UISetup(){
        navView.backgroundColor = .white
        itemsCV.backgroundColor = .white
        bgView.backgroundColor = .white
        
        navView.makeShadowAndRadius(shadow: true, opacity: 0.5, radius: 10)
        bgView.makeShadowAndRadius(shadow: true, opacity: 0.5, radius: 10)
    }
    
    private func delegates() {
        itemsCV.delegate = self
        itemsCV.dataSource = self
    }
    
    func UIUpdate() {
        itemsCV.reloadData()
        UIFillButtons()
    }
    
    private func UIFillButtons() {
        if UIState == .ingr {
            catButtons.setTitleColor(.lightGray, for: .normal)
            ingrButton.setTitleColor(.black, for: .normal)
        } else {
            catButtons.setTitleColor(.black, for: .normal)
            ingrButton.setTitleColor(.lightGray, for: .normal)
        }
    }
    
    
    @IBAction func navButtonTapped(_ sender: UIButton) {
        if sender == catButtons {
            UIState = .categories
        }
        else if sender == ingrButton {
            UIState = .ingr
        }
        
        UIUpdate()
    }
    
    //MARK: -FIELD
    @IBAction func searchStart(_ sender: UITextField) {
        sourceState = .search
        UIUpdate()
    }
    
    @IBAction func searchChanged(_ sender: UITextField) {
        if let text = sender.text {
            search(text)
        }
    }
    
    @IBAction func searchEnd(_ sender: UITextField) {
        if sender.text == "" {
            sourceState = .all
            UIUpdate()
        }
    }
}

//MARK: -COLLECTION VIEW
extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch sourceState {
        case .all:
            switch UIState {
            case .categories:
                return categoriesSource.count
            case .ingr:
                return ingredientSource.count
            }
        case .search:
            switch UIState {
            case .categories:
                return categoriesSearch.count
            case .ingr:
                return ingredientSearch.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var ingredient = CategoryIngredient(name: "", count: 0)
        var category = CategoryType.cocoa
        
        switch UIState {
        case .ingr:
            switch sourceState {
                case .all:
                ingredient = ingredientSource[indexPath.row]
                case .search:
                ingredient = ingredientSearch[indexPath.row]
            }
            
            return ingredientCell(ingredient, indexPath: indexPath)
        case .categories:
            switch sourceState {
                case .all:
                category = categoriesSource[indexPath.row]
                case .search:
                category = categoriesSearch[indexPath.row]
            }
            
            return categoryCell(category, indexPath: indexPath)
        }
    }
    
    //UI CELL CONFIGURE
    private func ingredientCell(_ item: CategoryIngredient, indexPath: IndexPath) -> IngredientCollectionViewCell {
        let cell = itemsCV.dequeueReusableCell(withReuseIdentifier: "ingredientCell", for: indexPath) as! IngredientCollectionViewCell
        cell.ingredient = item
        cell.setup()
        
        return cell
    }
    
    private func categoryCell(_ item: CategoryType, indexPath: IndexPath) -> CategoryCollectionViewCell {
        let cell = itemsCV.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCollectionViewCell
        cell.category = item
        cell.setup()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch UIState {
        case .ingr:
            var ingr = CategoryIngredient(name: "", count: 0)
            
            switch sourceState {
                case .all:
                ingr = ingredientSource[indexPath.row]
                case .search:
                ingr = ingredientSearch[indexPath.row]
            }
            
            dataService.categoryReview = .nonAlc
            dataService.ingrCategoryReview = Ingredient(name: ingr.name)
        case .categories:
            var category = CategoryType.cocoa
            
            switch sourceState {
                case .all:
                category = categoriesSource[indexPath.row]
                case .search:
                category = categoriesSearch[indexPath.row]
            }
            
            dataService.categoryReview = category
        }
        
        
        self.performSegue(withIdentifier: "toItemsList", sender: self)
    }
    
}
