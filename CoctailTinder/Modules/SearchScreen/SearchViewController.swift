//
//  SearchViewController.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 18/03/2021.
//

import UIKit
import Alamofire

class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var ingrCV: UICollectionView!
    @IBOutlet weak var searchField: UITextField!
    
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var cleanButton: UIButton!
    
    let network = NetworkService.shared
    private let dataService = DataService.shared
    
    var resultSearchArray : [Cocktail] = []
    weak var selectedCocktail : Cocktail?
    
    //MARK: -VIEW LOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    //MARK: -UI
    private func delegates() {
        self.ingrCV.delegate = self
        self.ingrCV.dataSource = self
    }
    
    private func setupUI() {
        delegates()
        hideKeyboardSetting()
        
        navView.makeShadowAndRadius(shadow: true, opacity: 0.5, radius: 10)
        navView.backgroundColor = .white
        
        cleanButton.isHidden = true
    }
    
    func CVUpdate() {
        self.ingrCV.reloadData()
    }
    
    //MARK: -ACTION
    @IBAction func cleanButtonTapped(_ sender: UIButton) {
        self.searchField.text = ""
        resultSearchArray.removeAll()
        self.CVUpdate()
        
        network.stopAllRequests { }
    }
    
    //MARK: -COLLECTION VIEW
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resultSearchArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = ingrCV.dequeueReusableCell(withReuseIdentifier: "resCell", for: indexPath) as! ItemSearchCollectionViewCell
        
        //Bag catcher
        if indexPath.row <= resultSearchArray.count - 1 {
            cell.cellCocktail = resultSearchArray[indexPath.row]
            cell.setupUI()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row <= resultSearchArray.count - 1 {
            selectedCocktail = resultSearchArray[indexPath.row]
            self.performSegue(withIdentifier: "searchToReview", sender: self)
        }
    }
    
    //MARK: -FIELD
    @IBAction func searchStarted(_ sender: UITextField) {
        cleanButton.animateHidding(hidding: false)
    }
    
    @IBAction func searchChanged(_ sender: UITextField) {
        guard let text = sender.text else {
            self.resultSearchArray.removeAll()
            return
        }
        
        network.stopAllRequests { [weak self] in
            self?.search(text)
        }
    }
    
    @IBAction func searchEnd(_ sender: UITextField) {
        cleanButton.animateHidding(hidding: true)
    }
    
}
