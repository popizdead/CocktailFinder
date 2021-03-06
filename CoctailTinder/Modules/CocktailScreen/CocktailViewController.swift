//
//  CocktailViewController.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 12/03/2021.
//

import UIKit

class CocktailViewController: UIViewController {
    
    //MARK: -OUTLETS
    @IBOutlet weak var cocktailImg: UIImageView!
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var ingredientsCount: UILabel!
    
    @IBOutlet weak var ingrCV: UICollectionView!
    @IBOutlet weak var instructionText: UITextView!
    
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var reviewCocktail : Cocktail?
    
    //MARK: -VIEW LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UISetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIUpdate()
    }
    
    private func delegates() {
        ingrCV.delegate = self
        ingrCV.dataSource = self
    }
    
    //MARK: -UI
    private func UISetup() {
        delegates()
        
        let viewArray : [UIView] = [cocktailImg, dismissButton, saveButton]
        for view in viewArray {
            view.makeShadowAndRadius(shadow: false, opacity: 0.5, radius: 10)
        }
    }
    
    private func UIUpdate() {
        guard let cocktail = reviewCocktail else { return }
        
        UILabelsUpdate(cocktail)
        UIImageUpdate(cocktail)
        UIButtonsUpdate()
    }
    
    private func UILabelsUpdate(_ reviewCocktail: Cocktail) {
        cocktailImg.image = reviewCocktail.image
        nameLbl.text = reviewCocktail.name
        typeLbl.text = reviewCocktail.category
        ingredientsCount.text = "\(reviewCocktail.ingrArray.count) Ingredients"
        instructionText.text = reviewCocktail.instruction
        
        ingrCV.reloadData()
    }
    
    private func UIButtonsUpdate() {
        guard let reviewCocktail = reviewCocktail else {
            return
        }

        if reviewCocktail.isFavorite() {
            saveButton.setTitle("Unsave", for: .normal)
        } else {
            saveButton.setTitle("Save", for: .normal)
        }
    }
    
    private func UIImageUpdate(_ cocktail: Cocktail) {
        if cocktail.image == nil {
            cocktail.getIngredientImage {
                self.UIUpdate()
            }
        }
    }
    
    //MARK: BUTTONS
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        if let cocktail = reviewCocktail {
            if cocktail.isFavorite() {
                cocktail.action(.deleteFavorite)
            } else {
                cocktail.action(.appendFavorite)
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: -COLLECTION VIEW
extension CocktailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let cocktail = reviewCocktail else { return 0 }
        return cocktail.ingrArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = ingrCV.dequeueReusableCell(withReuseIdentifier: "ingrCell", for: indexPath) as! IngrCollectionViewCell
        guard let cocktail = reviewCocktail else { return cell }
        
        let ingr = cocktail.ingrArray[indexPath.row]
        
        cell.nameLbl.text = ingr.name
        cell.img.image = ingr.ingrImage
        cell.mesureLbl.text = ingr.measure
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cocktail = reviewCocktail else { return }
        let ingredient = cocktail.ingrArray[indexPath.row]
        
        showIngredient(ingredient)
    }
}
