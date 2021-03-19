//
//  SwipeViewController.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 05/03/2021.
//

import UIKit
import SwiftEntryKit
import GoogleMobileAds

class SwipeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    //MARK:OUTLETS
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var swipeView: UIView!
    @IBOutlet var cardPenRecognizer: UIPanGestureRecognizer!
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var ingredientCollectionView: UICollectionView!
    @IBOutlet weak var instructionButton: UIButton!
    @IBOutlet weak var ingrCountLbl: UILabel!
    
    func createLoadingAnimation() {
        
    }
    
    
    //MARK:VIEW LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: NSNotification.Name("updateCard"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openCard), name: NSNotification.Name("openCard"), object: nil)
        
        updateUI()
        setupUI()
        requestedFrom = .swipe
        randomCoctailRequest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        requestedFrom = .swipe
    }
    
    //MARK:UI
    func setupUI() {
        swipeView.backgroundColor = .white
        swipeView.makeShadowAndRadius(shadow: true, opacity: 0.5, radius: 10)
        image.makeShadowAndRadius(shadow: false, opacity: 0.5, radius: 10)
        instructionButton.makeShadowAndRadius(shadow: false, opacity: 0.5, radius: 10)
        
        navView.backgroundColor = .white
        navView.makeShadowAndRadius(shadow: true, opacity: 0.5, radius: 10)
        
        ingredientCollectionView.delegate = self
        ingredientCollectionView.dataSource = self
    }
    
    @objc func updateUI() {
        self.categoryLbl.text = currentCoctail.category
        self.nameLbl.text = currentCoctail.name
        self.ingrCountLbl.text = "\(currentCoctail.ingrArray.count) Ingredients"
        self.image.image = currentCoctail.image
        ingredientCollectionView.reloadData()
    }
    
    @objc func openCard() {
        self.updateUI()
        self.hideView(hidding: false)
    }
    
    func hideView(hidding: Bool) {
        if hidding {
            self.image.image = nil
            self.image.backgroundColor = .systemGray6
            
            currentCoctail.ingrArray.removeAll()
        } else {
            swipeView.backgroundColor = .white
        }
        let viewArray = [ingredientCollectionView, image, nameLbl, categoryLbl, ingrCountLbl, instructionButton]
        for view in viewArray {
            view?.animateHidding(hidding: hidding)
        }
    }
   
    func fillView(toColor: UIColor) {
        UIView.animate(withDuration: 0.2) {
            
        }
    }
    
    //MARK:BUTTON
    @IBAction func panAction(_ sender: UIPanGestureRecognizer) {
        let card = sender.view!
        let point = sender.translation(in: card)
        card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        if sender.state == .ended {
            if card.center.x > view.center.x {
                //Green
                self.swipeView.backgroundColor = .systemGreen
                let newCocktail = Coctail(name: currentCoctail.name, category: currentCoctail.category, id: currentCoctail.id, imgUrl: currentCoctail.imageURL, glass: currentCoctail.glass, ingrArray: currentCoctail.ingrArray, instr: currentCoctail.instruction)
                newCocktail.image = currentCoctail.image
                saveCocktailCoreData(object: newCocktail)
                favArray.insert(newCocktail, at: 0)
            } else {
                //Red
                self.swipeView.backgroundColor = .systemRed
            }
            UIView.animate(withDuration: 0.2) {
                card.center = self.view.center
            }
            requestedFrom = .swipe
            self.hideView(hidding: true)
            randomCoctailRequest()
        }
    }
    
    @IBAction func instructionButtonTapped(_ sender: UIButton) {
        reviewCocktail = currentCoctail
        self.performSegue(withIdentifier: "mainToReview", sender: self)
    }
    
    
    //MARK:COLLECTION VIEW
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentCoctail.ingrArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = ingredientCollectionView.dequeueReusableCell(withReuseIdentifier: "ingrCell", for: indexPath) as! IngrCollectionViewCell
        let ingr = currentCoctail.ingrArray[indexPath.row]
        cell.img.layer.cornerRadius = 10
        cell.nameLbl.text = ingr.name
        if let img = ingr.ingrImage {
            cell.img.image = img
            cell.img.backgroundColor = .white
        } else {
            cell.img.image = nil
            cell.img.backgroundColor = .systemGray6
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        attributesView = .buyList
        let ingrObject = currentCoctail.ingrArray[indexPath.row]
        alertIngredient = ingrObject
        SwiftEntryKit.display(entry: storyboard!.instantiateViewController(withIdentifier:"alertIngr"), using: setupAttributes())
    }
    
    //MARK:ATTRIBUTES
    func setupAttributes() -> EKAttributes {
        var attributes = EKAttributes.centerFloat
        
        if attributesView == .buyList {
            let widthConstraint = EKAttributes.PositionConstraints.Edge.ratio(value: 0.8)
            let heightConstraint = EKAttributes.PositionConstraints.Edge.ratio(value: 0.3)
            attributes.positionConstraints.size = .init(width: widthConstraint, height: heightConstraint)
        } else {
            let widthConstraint = EKAttributes.PositionConstraints.Edge.ratio(value: 0.8)
            let heightConstraint = EKAttributes.PositionConstraints.Edge.ratio(value: 0.3)
            attributes.positionConstraints.size = .init(width: widthConstraint, height: heightConstraint)
        }
        
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 10, offset: .zero))
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
