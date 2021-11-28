//
//  SwipeViewController.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 05/03/2021.
//

import UIKit
import SwiftEntryKit

class SwipeViewController: UIViewController {

    //MARK: -OUTLETS
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var swipeView: UIView!
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet var cardPenRecognizer: UIPanGestureRecognizer!
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var ingrCountLbl: UILabel!
    
    @IBOutlet weak var instructionButton: UIButton!

    @IBOutlet weak var ingredientCollectionView: UICollectionView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    let network = NetworkService.shared
    private let dataService = DataService.shared
    
    var cardCocktail : Cocktail?
    
    //MARK: -VIEW LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataService.getSavedData()
        VCConfigure()
    }
    
    //MARK: -CONFIGURE VC
    private func VCConfigure() {
        delegates()
        setupUI()
        
        request()
    }
    
    private func delegates() {
        ingredientCollectionView.delegate = self
        ingredientCollectionView.dataSource = self
    }
    
    //MARK: -SETUP UI
    private func setupUI() {
        loadingIndicator.startAnimating()
        
        swipeView.backgroundColor = .white
        navView.backgroundColor = .white
        
        image.layer.cornerRadius = 10
        instructionButton.layer.cornerRadius = 10
        
        shadows()
    }
    
    private func shadows() {
        let views : [UIView] = [swipeView, navView]
        views.forEach({
            $0.makeShadowAndRadius(shadow: true, opacity: 0.5, radius: 10)
        })
    }
    
    //MARK: -UPDATE UI
    @objc func openCard() {
        self.updateUI()
        self.showLoading(false)
    }
    
    @objc func updateUI() {
        guard let currentCocktail = cardCocktail else { return }
        
        self.categoryLbl.text = currentCocktail.category
        self.nameLbl.text = currentCocktail.name
        self.ingrCountLbl.text = "\(currentCocktail.ingrArray.count) Ingredients"
        
        self.image.image = currentCocktail.image
        ingredientCollectionView.reloadData()
    }
    
    
    func showLoading(_ show: Bool) {
        if show {
            loadingIndicator.isHidden = false
            
            self.image.image = nil
            self.image.backgroundColor = .systemGray6
        } else {
            loadingIndicator.isHidden = true
        }
        
        let viewArray : [UIView] = [ingredientCollectionView, image, nameLbl, categoryLbl, ingrCountLbl, instructionButton]
        viewArray.forEach({
            $0.animateHidding(hidding: show)
        })
    }
   
    //MARK: -ACTIONS
    @IBAction func panAction(_ sender: UIPanGestureRecognizer) {
        let card = sender.view!
        let point = sender.translation(in: card)
        
        card.center = CGPoint(x: bgView.center.x + point.x, y: bgView.center.y + point.y)
        
        if sender.state == .ended {
            swipeAction(card)
        }
    }
    
    @IBAction func instructionButtonTapped(_ sender: UIButton) {
        guard let currentCocktail = cardCocktail else { return }
        
        dataService.reviewCocktail = currentCocktail
        self.performSegue(withIdentifier: "mainToReview", sender: self)
    }
}

//MARK: -CV
extension SwipeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let currentCocktail = cardCocktail else { return 0 }
        return currentCocktail.ingrArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = ingredientCollectionView.dequeueReusableCell(withReuseIdentifier: "ingrCell", for: indexPath) as! IngrCollectionViewCell
        guard let currentCocktail = cardCocktail else { return cell }
        
        let ingr = currentCocktail.ingrArray[indexPath.row]
        cell.configureUI(ingr)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let currentCocktail = cardCocktail else { return }
        
        let ingrObject = currentCocktail.ingrArray[indexPath.row]
        dataService.alertIngredient = ingrObject
        
        SwiftEntryKit.display(entry: storyboard!.instantiateViewController(withIdentifier:"alertIngr"), using: setupAttributes())
    }
}
