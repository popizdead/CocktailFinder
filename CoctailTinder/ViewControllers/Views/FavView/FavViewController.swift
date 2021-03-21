//
//  FavViewController.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 05/03/2021.
//

import UIKit
import SwiftEntryKit

class FavViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    //MARK:OUTLET
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
    
    //MARK:VIEW LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        designSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favCollectionView.reloadData()
    }
    
    func observers() {
        favCollectionView.delegate = self
        favCollectionView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: Notification.Name("updateFavCV"), object: nil)
    }
    
    @objc func update() {
        favCollectionView.reloadData()
    }
    
    //MARK:UI
    func designSetup() {
        hideView()
        observers()
        self.navView.makeShadowAndRadius(shadow: true, opacity: 0.5, radius: 10)
        self.navView.backgroundColor = .white
        self.favCollectionView.backgroundColor = .white
    }
    
    func hideView() {
        hideButton.isHidden = true
        searchField.isHidden = true
        UIView.animate(withDuration: 0.5) { [self] in
            self.labelFromBottomConstraint.constant = self.labelFromBottomConstraint.constant - 42
            self.settingButtonFromBottomConstraint.constant = self.settingButtonFromBottomConstraint.constant - 42
            self.searchButtonFromBottomConstraint.constant = self.searchButtonFromBottomConstraint.constant - 42
            self.cvFromTopConstraint.constant = self.cvFromTopConstraint.constant - 42
        }
        favoriteCurrentState = .hidden
    }
    
    func openView() {
        UIView.animate(withDuration: 0.5) { [self] in
            self.labelFromBottomConstraint.constant = self.labelFromBottomConstraint.constant + 42
            self.settingButtonFromBottomConstraint.constant = self.settingButtonFromBottomConstraint.constant + 42
            self.searchButtonFromBottomConstraint.constant = self.searchButtonFromBottomConstraint.constant + 42
            self.cvFromTopConstraint.constant = self.cvFromTopConstraint.constant + 42
        }
        hideButton.animateHidding(hidding: false)
        searchField.animateHidding(hidding: false)
        favoriteCurrentState = .searching
    }
    
    //MARK:BUTTONS
    @IBAction func settingsButtonTapped(_ sender: UIButton) {
        SwiftEntryKit.display(entry: storyboard!.instantiateViewController(withIdentifier:"favSettings"), using: setupAttributes())
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        if favoriteCurrentState == .searching {
            hideView()
        } else {
            openView()
        }
    }
    
    @IBAction func hideButtonTapped(_ sender: UIButton) {
        hideView()
    }
    
    //MARK:COLLECTION VIEW
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if favoriteCurrentView == .card {
            let cell = favCollectionView.dequeueReusableCell(withReuseIdentifier: "favCell", for: indexPath) as! FavCollectionViewCell
            cell.cellCoctail = favArray[indexPath.row]
            cell.updateUI()
            return cell
        } else {
            let cell = favCollectionView.dequeueReusableCell(withReuseIdentifier: "shortFavCell", for: indexPath) as! ShortFavCollectionViewCell
            cell.cellCocktail = favArray[indexPath.row]
            cell.updateUI()
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        reviewCocktail = favArray[indexPath.row]
        self.performSegue(withIdentifier: "favToReview", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if favoriteCurrentView == .card {
            return CGSize(width: 350, height: 439)
        } else {
            return CGSize(width: 357, height: 178)
        }
    }
    
    //MARK:ATTRIBUTES
    func setupAttributes() -> EKAttributes {
        var attributes = EKAttributes.centerFloat
        
        let widthConstraint = EKAttributes.PositionConstraints.Edge.ratio(value: 0.95)
        let heightConstraint = EKAttributes.PositionConstraints.Edge.ratio(value: 0.5)
        attributes.positionConstraints.size = .init(width: widthConstraint, height: heightConstraint)
        
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.8, radius: 10, offset: .zero))
        attributes.roundCorners = .all(radius: 15)
        
        // Set its background to white
        attributes.entryBackground = .color(color: .clear)
        attributes.screenBackground = .color(color: EKColor(UIColor(white: 0, alpha: 0.5)))

        // Animate in and out using default translation
        attributes.entranceAnimation = .translation
        attributes.exitAnimation = .translation
        
        attributes.displayDuration = .infinity
        attributes.entryInteraction = .forward
        
        attributes.screenInteraction = .dismiss
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
        
        return attributes
    }
    
}
