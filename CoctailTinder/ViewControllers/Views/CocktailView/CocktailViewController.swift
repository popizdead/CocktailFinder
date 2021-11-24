//
//  CocktailViewController.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 12/03/2021.
//

import UIKit
import SwiftEntryKit

class CocktailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK: -OUTLETS
    @IBOutlet weak var cocktailImg: UIImageView!
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var ingredientsCount: UILabel!
    
    @IBOutlet weak var ingrCV: UICollectionView!
    @IBOutlet weak var instructionText: UITextView!
    
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var isFavoutite = false
    
    private let network = NetworkService.shared
    private let coreService = CoreDataService.shared
    private let dataService = DataService.shared
    
    //MARK: -VIEW LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: NSNotification.Name("updateReviewScreen"), object: nil)
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkForDownloaded()
        checkForFavourite()
        updateUI()
    }
    
    func delegates() {
        ingrCV.delegate = self
        ingrCV.dataSource = self
    }
    
    //MARK:UI
    func setupUI() {
        delegates()
        let viewArray = [cocktailImg, dismissButton, saveButton]
        for view in viewArray {
            view?.makeShadowAndRadius(shadow: false, opacity: 0.5, radius: 10)
        }
    }
    
    @objc func updateUI() {
        cocktailImg.image = reviewCocktail.image
        nameLbl.text = reviewCocktail.name
        typeLbl.text = reviewCocktail.category
        ingredientsCount.text = "\(reviewCocktail.ingrArray.count) Ingredients"
        instructionText.text = reviewCocktail.instruction
        ingrCV.reloadData()
    }
    
    func checkForFavourite() {
        isFavoutite = dataService.isFavorite(reviewCocktail)
        if isFavoutite {
            saveButton.setTitle("Unsave", for: .normal)
        } else {
            saveButton.setTitle("Save", for: .normal)
        }
    }
    
    func checkForDownloaded() {
        if reviewCocktail.image == nil {
            network.currentRequestFrom = .review
            
            reviewCocktail.getIngredientImage {
                self.updateUI()
            }
        }
    }
    
    
    //MARK:BUTTONS
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        if isFavoutite {
            coreService.deleteSavedCocktail(name: reviewCocktail.name)
            reviewCocktail.action(.deleteFavorite)
            dataService.favArray = dataService.favArray.filter({$0.name != reviewCocktail.name})
        } else {
            coreService.saveCocktailCoreData(object: reviewCocktail)
            reviewCocktail.action(.appendFavorite)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK:COLLECTION VIEW
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviewCocktail.ingrArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = ingrCV.dequeueReusableCell(withReuseIdentifier: "ingrCell", for: indexPath) as! IngrCollectionViewCell
        let ingr = reviewCocktail.ingrArray[indexPath.row]
        
        cell.nameLbl.text = ingr.name
        cell.img.image = ingr.ingrImage
        cell.mesureLbl.text = ingr.measure
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ingrObject = reviewCocktail.ingrArray[indexPath.row]
        dataService.alertIngredient = ingrObject
        
        SwiftEntryKit.display(entry: storyboard!.instantiateViewController(withIdentifier:"alertIngr"), using: setupAttributes())
    }
    
    //MARK:ATTRIBUTES
    func setupAttributes() -> EKAttributes {
        var attributes = EKAttributes.centerFloat
        
        let widthConstraint = EKAttributes.PositionConstraints.Edge.ratio(value: 0.8)
        let heightConstraint = EKAttributes.PositionConstraints.Edge.ratio(value: 0.3)
        
        attributes.positionConstraints.size = .init(width: widthConstraint, height: heightConstraint)
        
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
