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
    
    //MARK: -VIEW LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        VCConfigure()
        request()
    }
    
    //MARK: -CONFIGURE VC
    private func VCConfigure() {
        delegates()
        observers()
        
        setupUI()
    }
    
    private func delegates() {
        ingredientCollectionView.delegate = self
        ingredientCollectionView.dataSource = self
    }
    
    private func observers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: NSNotification.Name("updateCard"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openCard), name: NSNotification.Name("openCard"), object: nil)
    }
    
    //MARK: -SETUP UI
    func setupUI() {
        loadingIndicator.startAnimating()
        
        swipeView.backgroundColor = .white
        navView.backgroundColor = .white
        
        shadows()
    }
    
    private func shadows() {
        let views : [UIView] = [swipeView, image, instructionButton, navView]
        views.forEach({
            $0.makeShadowAndRadius(shadow: true, opacity: 0.5, radius: 10)
        })
    }
    
    //MARK: -UPDATE UI
    @objc func openCard() {
        self.updateUI()
        self.showLoading(false)
    }
    
    @objc private func updateUI() {
        self.categoryLbl.text = currentCoctail.category
        self.nameLbl.text = currentCoctail.name
        self.ingrCountLbl.text = "\(currentCoctail.ingrArray.count) Ingredients"
        
        self.image.image = currentCoctail.image
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
        dataService.reviewCocktail = currentCoctail
        self.performSegue(withIdentifier: "mainToReview", sender: self)
    }
}

//MARK: -CV
extension SwipeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentCoctail.ingrArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = ingredientCollectionView.dequeueReusableCell(withReuseIdentifier: "ingrCell", for: indexPath) as! IngrCollectionViewCell
        let ingr = currentCoctail.ingrArray[indexPath.row]
        cell.configureUI(ingr)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ingrObject = currentCoctail.ingrArray[indexPath.row]
        dataService.alertIngredient = ingrObject
        
        SwiftEntryKit.display(entry: storyboard!.instantiateViewController(withIdentifier:"alertIngr"), using: setupAttributes())
    }
}
