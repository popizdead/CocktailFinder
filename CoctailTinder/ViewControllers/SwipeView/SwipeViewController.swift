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
    @IBOutlet weak var ingrCountLbl: UILabel!
    
    
    @IBAction func panAction(_ sender: UIPanGestureRecognizer) {
        let card = sender.view!
        let point = sender.translation(in: card)
        card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        if sender.state == .ended {
            if card.center.x > view.center.x {
                //Green
                self.swipeView.backgroundColor = .systemGreen
            } else {
                //Red
                self.swipeView.backgroundColor = .systemRed
            }
            UIView.animate(withDuration: 0.2) {
                card.center = self.view.center
            }
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
        self.ingrCountLbl.text = "\(currentCoctail.ingrArray.count) Ingredients"
        ingredientCollectionView.reloadData()
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
    
    
    @IBAction func instructionButtonTapped(_ sender: UIButton) {
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
    
}
