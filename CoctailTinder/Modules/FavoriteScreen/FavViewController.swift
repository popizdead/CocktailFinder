//
//  FavViewController.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 05/03/2021.
//

import UIKit

class FavViewController: UIViewController {

    //MARK: -OUTLET
    //Views
    @IBOutlet weak var favCollectionView: UICollectionView!
    @IBOutlet weak var navView: UIView!
    
    //Buttons
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var hideButton: UIButton!
    @IBOutlet weak var searchField: UITextField!
    
    //Constraints
    @IBOutlet weak var cvFromTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelFromBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var settingButtonFromBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchButtonFromBottomConstraint: NSLayoutConstraint!
    
    var showingArray : [Cocktail] = []
    var favSearchArray : [Cocktail] = []

    var favoriteCurrentState : favoriteState = .hidden
    
    let UIService = UIUserService.shared
    let dataService = DataService.shared
    
    
    //MARK: -VIEW LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UISetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateAppearingArray()
    }
    
    //MARK: UI
    func UISetup() {
        searchViewAnimate(.hidden)
        
        observers()
        hideKeyboardSetting()
        
        self.navView.makeShadowAndRadius(shadow: true, opacity: 0.5, radius: 10)
        self.navView.backgroundColor = .white
        self.favCollectionView.backgroundColor = .white
    }
    
    func observers() {
        favCollectionView.delegate = self
        favCollectionView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(UIUpdate), name: Notification.Name("updateFavCV"), object: nil)
    }
    
    @objc func UIUpdate() {
        favCollectionView.reloadData()
    }
    
    
    //MARK:BUTTONS
    @IBAction func settingsButtonTapped(_ sender: UIButton) {
        displaySettings()
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        if favoriteCurrentState == .searching {
            searchViewAnimate(.hidden)
        } else {
            searchViewAnimate(.searching)
        }
    }
    
    @IBAction func hideButtonTapped(_ sender: UIButton) {
        searchViewAnimate(.hidden)
    }
    
    //MARK: -FIELD
    @IBAction func searchChanged(_ sender: UITextField) {
        searchInFavorite(text: sender.text!)
    }
    
}

//MARK: -COLLECTION VIEW
extension FavViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return showingArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if UIService.userFavoriteSetting == .card {
            let cell = favCollectionView.dequeueReusableCell(withReuseIdentifier: "favCell", for: indexPath) as! FavCollectionViewCell
            cell.cellCoctail = showingArray[indexPath.row]
            cell.updateUI()
            return cell
        } else {
            let cell = favCollectionView.dequeueReusableCell(withReuseIdentifier: "shortFavCell", for: indexPath) as! ShortFavCollectionViewCell
            cell.cellCocktail = showingArray[indexPath.row]
            cell.delegate = self
            
            cell.updateUI()
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dataService.reviewCocktail = showingArray[indexPath.row]
        
        self.performSegue(withIdentifier: "favToReview", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIService.userFavoriteSetting == .card {
            return CGSize(width: 350, height: 439)
        } else {
            return CGSize(width: 357, height: 178)
        }
    }
}
