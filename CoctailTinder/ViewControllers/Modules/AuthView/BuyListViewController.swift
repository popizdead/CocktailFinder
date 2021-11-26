//
//  AuthViewController.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 10/03/2021.
//

import UIKit

class BuyListViewController: UIViewController {
    
    //MARK: -OUTLETS
    @IBOutlet weak var ingredientsCV: UICollectionView!
    @IBOutlet weak var navView: UIView!
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
//    var ingrNameArray : [String] = []
//    var imgDict : [String:UIImage] = [:]
//    var searchArray : [String] = []
//
//    var sourceArray : [String] = []
    
    var searchSource : [Ingredient] = []
    var ingredientsSource : [Ingredient] = []
    //var appearingSource : [Ingredient] = []
    
    let network = NetworkService.shared
    
    var appearingState : VCState = .all
    
    //MARK: -VIEW LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        VCConfigure()
    }
    
    //MARK: VC SETUP
    private func VCConfigure() {
        setupUI()
        delegates()
        
        allIngredientsRequest()
    }
    
    private func delegates() {
        ingredientsCV.delegate = self
        ingredientsCV.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(UIUpdate), name: NSNotification.Name("updateAuthCV"), object: nil)
    }
    
    @objc func UIUpdate() {
        self.ingredientsCV.reloadData()
    }
    
    func setupUI() {
        hideKeyboardSetting()
        delegates()
        
        self.doneButton.layer.cornerRadius = 10
        navView.makeShadowAndRadius(shadow: true, opacity: 0.5, radius: 10)
        
        UIUpdate()
    }
    
    //MARK: -BUTTONS
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: -SEARCH
    @IBAction func fieldStart(_ sender: UITextField) {
        appearingState = .searching
        UIUpdate()
    }
    
    @IBAction func fieldChanged(_ sender: UITextField) {
        searchSource.removeAll()
        search(sender.text)
    }
    
    @IBAction func fieldEnd(_ sender: UITextField) {
        if sender.text == "" {
            searchSource.removeAll()
            appearingState = .all
            
            UIUpdate()
        }
    }
}

//MARK: -CV
extension BuyListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch appearingState {
        case .searching:
            return searchSource.count
        case .all:
            return ingredientsSource.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = ingredientsCV.dequeueReusableCell(withReuseIdentifier: "ingrCell", for: indexPath) as! ItemCollectionViewCell
        var ingredient = Ingredient(name: "")
        
        switch appearingState {
        case .all:
            ingredient = ingredientsSource[indexPath.row]
        case .searching:
            ingredient = searchSource[indexPath.row]
        }
        
        cell.ingredient = ingredient
        cell.configure()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = ingredientsCV.dequeueReusableCell(withReuseIdentifier: "ingrCell", for: indexPath) as! ItemCollectionViewCell
        var ingredient = Ingredient(name: "")
        
        switch appearingState {
        case .all:
            ingredient = ingredientsSource[indexPath.row]
        case .searching:
            ingredient = searchSource[indexPath.row]
        }
        
        cell.ingredient = ingredient
        cell.action()
        
        //ingredientsCV.reloadData()
    }
    
}
