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
    var resultSearchArray : [Cocktail] = []
    
    //MARK: -VIEW LOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        network.currentRequestFrom = .search
    }
    
    func setupUI() {
        delegates()
        hideKeyboardSetting()
        
        navView.makeShadowAndRadius(shadow: true, opacity: 0.5, radius: 10)
        navView.backgroundColor = .white
        
        cleanButton.isHidden = true
    }
    
    func delegates() {
        NotificationCenter.default.addObserver(self, selector: #selector(CVUpdate), name: NSNotification.Name("updateSearchResult"), object: nil)
        
        self.ingrCV.delegate = self
        self.ingrCV.dataSource = self
    }
    
    
    @objc func CVUpdate() {
        self.ingrCV.reloadData()
    }
    
    @IBAction func cleanButtonTapped(_ sender: UIButton) {
        self.searchField.text = ""
        resultSearchArray.removeAll()
        AF.session.getAllTasks { (tasks) in
            tasks.forEach({$0.cancel()})
        }
       CVUpdate()
    }
    
    //MARK:COLLECTION VIEW
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resultSearchArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = ingrCV.dequeueReusableCell(withReuseIdentifier: "resCell", for: indexPath) as! ItemSearchCollectionViewCell
        if indexPath.row <= resultSearchArray.count - 1 {
            cell.cellCocktail = resultSearchArray[indexPath.row]
            cell.setupUI()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row <= resultSearchArray.count - 1 {
            reviewCocktail = resultSearchArray[indexPath.row]
            self.performSegue(withIdentifier: "searchToReview", sender: self)
        }
    }
    
    //MARK:FIELD
    @IBAction func searchStarted(_ sender: UITextField) {
        cleanButton.animateHidding(hidding: false)
    }
    
    @IBAction func searchChanged(_ sender: UITextField) {
        network.stopAllRequests {
            guard let text = sender.text else {
                self.resultSearchArray.removeAll()
                return
            }
            
            self.search(text)
        }
    }
    
    @IBAction func searchEnd(_ sender: UITextField) {
        cleanButton.animateHidding(hidding: true)
    }
    
}
