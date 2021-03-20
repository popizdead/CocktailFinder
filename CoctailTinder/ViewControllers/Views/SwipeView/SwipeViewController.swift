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
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    //MARK:VIEW LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        firstRequest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        requestedFrom = .swipe
    }
    
    func firstRequest() {
        self.hideView(hidding: true)
        requestedFrom = .swipe
        randomCoctailRequest()
    }
    
    //MARK:UI
    func setupUI() {
        loadingIndicator.startAnimating()
        observers()
        
        ingredientCollectionView.delegate = self
        ingredientCollectionView.dataSource = self
        
        swipeView.backgroundColor = .white
        navView.backgroundColor = .white
        
        swipeView.makeShadowAndRadius(shadow: true, opacity: 0.5, radius: 10)
        image.makeShadowAndRadius(shadow: false, opacity: 0.5, radius: 10)
        instructionButton.makeShadowAndRadius(shadow: false, opacity: 0.5, radius: 10)
        navView.makeShadowAndRadius(shadow: true, opacity: 0.5, radius: 10)
        
    }
    
    func observers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: NSNotification.Name("updateCard"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openCard), name: NSNotification.Name("openCard"), object: nil)
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
    
    //MARK:DESIGN
    func hideView(hidding: Bool) {
        if hidding {
            loadingIndicator.isHidden = false
            self.image.image = nil
            self.image.backgroundColor = .systemGray6
        } else {
            loadingIndicator.isHidden = true
        }
        let viewArray = [ingredientCollectionView, image, nameLbl, categoryLbl, ingrCountLbl, instructionButton]
        for view in viewArray {
            view?.animateHidding(hidding: hidding)
        }
    }
   
    func fillViewAnimate(toColor: UIColor) {
        hideView(hidding: true)
        self.swipeView.backgroundColor = toColor
        self.swipeView.alpha = 0.5
        UIView.animate(withDuration: 0.5) {
            self.swipeView.alpha = 1
            self.swipeView.backgroundColor = .white
        }
    }
    
    //MARK:BUTTON
    @IBAction func panAction(_ sender: UIPanGestureRecognizer) {
        let card = sender.view!
        let point = sender.translation(in: card)
        card.center = CGPoint(x: bgView.center.x + point.x, y: bgView.center.y + point.y)
        if sender.state == .ended {
            if card.center.x > bgView.center.x {
                //Green
                fillViewAnimate(toColor: .systemGreen)
                if !favArray.contains(where: {$0.name == currentCoctail.name}) {
                    var newCocktail = Coctail(name: currentCoctail.name, category: currentCoctail.category, id: currentCoctail.id, imgUrl: currentCoctail.imageURL, glass: currentCoctail.glass, ingrArray: currentCoctail.ingrArray, instr: currentCoctail.instruction)
                    newCocktail.image = currentCoctail.image
                    newCocktail = currentCoctail
                    saveCocktailCoreData(object: newCocktail)
                    favArray.insert(newCocktail, at: 0)
                    print("but in source \(currentCoctail.ingrArray.count) ingredients")
                    print("saving with \(newCocktail.ingrArray.count) ingredients")
                }
            } else {
                //Red
                fillViewAnimate(toColor: .systemRed)
            }
            UIView.animate(withDuration: 0.2) {
                card.center.x = self.bgView.center.x
                card.center.y = self.bgView.center.y / 1.25
            }
            self.swipeView.layoutIfNeeded()
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
