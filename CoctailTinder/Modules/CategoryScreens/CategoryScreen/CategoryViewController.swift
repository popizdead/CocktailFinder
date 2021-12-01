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
    
    var source = CategorySource()
    
    var UIState = UIStateType.categories
    var sourceState = SourceStateType.all
    
    var categorySelected : CategoryType?
    var ingredientSelected : Ingredient?
    
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
        let items : [UIView] = [navView, bgView]
        items.forEach({
            $0.backgroundColor = .white
            $0.makeShadowAndRadius(shadow: true, opacity: 0.5, radius: 10)
        })
        
        itemsCV.backgroundColor = .white
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
                return source.categoriesSource.count
            case .ingr:
                return source.ingredientSource.count
            }
        case .search:
            switch UIState {
            case .categories:
                return source.categoriesSearch.count
            case .ingr:
                return source.ingredientSearch.count
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
                ingredient = source.ingredientSource[indexPath.row]
                case .search:
                ingredient = source.ingredientSearch[indexPath.row]
            }
            
            return ingredientCell(ingredient, indexPath: indexPath)
        case .categories:
            switch sourceState {
                case .all:
                category = source.categoriesSource[indexPath.row]
                case .search:
                category = source.categoriesSearch[indexPath.row]
            }
            
            return categoryCell(category, indexPath: indexPath)
        }
    }
    
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
            switch sourceState {
                case .all:
                    let name = source.ingredientSource[indexPath.row].name
                    ingredientSelected = Ingredient(name: name)
                case .search:
                    let name = source.ingredientSearch[indexPath.row].name
                    ingredientSelected = Ingredient(name: name)
            }
        case .categories:
            switch sourceState {
                case .all:
                categorySelected = source.categoriesSource[indexPath.row]
                case .search:
                categorySelected = source.categoriesSearch[indexPath.row]
            }
        }
        
        self.performSegue(withIdentifier: "toItemsList", sender: self)
    }
    
}
