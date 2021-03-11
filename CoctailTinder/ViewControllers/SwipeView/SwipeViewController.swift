//
//  SwipeViewController.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 05/03/2021.
//

import UIKit

class SwipeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    //MARK:OUTLETS
    @IBOutlet weak var swipeView: UIView!
    @IBOutlet var cardPenRecognizer: UIPanGestureRecognizer!
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var ingredientCollectionView: UICollectionView!
    @IBOutlet weak var instructionButton: UIButton!
    
    
    @IBAction func panAction(_ sender: UIPanGestureRecognizer) {
        let card = sender.view!
        let point = sender.translation(in: card)
        card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        if sender.state == .ended {
            card.animateHidding(hidding: true)
            card.center = self.view.center
            card.animateHidding(hidding: false)
            randomCoctailRequest()
        }
    }
    
    //MARK:VIEW LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        setupUI()
        randomCoctailRequest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    //MARK:UI
    func setupUI() {
        swipeView.backgroundColor = .white
        swipeView.makeShadowAndRadius(shadow: true, opacity: 0.5, radius: 10)
        image.makeShadowAndRadius(shadow: false, opacity: 0.5, radius: 10)
        instructionButton.makeShadowAndRadius(shadow: false, opacity: 0.5, radius: 10)
        
        ingredientCollectionView.delegate = self
        ingredientCollectionView.dataSource = self
    }
    
    func updateUI() {
        self.categoryLbl.text = currentCoctail.category
        self.nameLbl.text = currentCoctail.name
        
        ingredientCollectionView.reloadData()
    }
   
    
    
    //MARK:COLLECTION VIEW
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentCoctail.ingrArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = ingredientCollectionView.dequeueReusableCell(withReuseIdentifier: "ingrCell", for: indexPath) as! IngrCollectionViewCell
        let ingr = currentCoctail.ingrArray[indexPath.row]
        
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
    
}
