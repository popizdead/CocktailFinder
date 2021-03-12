//
//  CocktailViewController.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 12/03/2021.
//

import UIKit

class CocktailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK:OUTLETS
    @IBOutlet weak var cocktailImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var ingredientsCount: UILabel!
    @IBOutlet weak var ingrCV: UICollectionView!
    @IBOutlet weak var instructionText: UITextView!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    //MARK:VIEW LOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        delegates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupUI()
    }
    
    func delegates() {
        ingrCV.delegate = self
        ingrCV.dataSource = self
    }
    
    func setupUI() {
        cocktailImg.image = currentCoctail.image
        nameLbl.text = currentCoctail.name
        typeLbl.text = currentCoctail.category
        ingredientsCount.text = "\(currentCoctail.ingrArray.count) Ingredients"
        instructionText.text = currentCoctail.instruction
        
        let viewArray = [cocktailImg, dismissButton, saveButton]
        for view in viewArray {
            view?.makeShadowAndRadius(shadow: false, opacity: 0.5, radius: 10)
        }
    }
    
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:COLLECTION VIEW
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentCoctail.ingrArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = ingrCV.dequeueReusableCell(withReuseIdentifier: "ingrCell", for: indexPath) as! IngrCollectionViewCell
        let ingr = currentCoctail.ingrArray[indexPath.row]
        
        cell.nameLbl.text = ingr.name
        cell.img.image = ingr.ingrImage
        
        return cell
    }
    
}
