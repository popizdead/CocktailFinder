//
//  FilterViewController.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 16/03/2021.
//

import UIKit

class FilterViewController: UIViewController {
    
    //MARK:OUTLETS
    //Ingredients
    @IBOutlet weak var ingrAll: UIButton!
    @IBOutlet weak var ingrMyBar: UIButton!
    
    //Alcohol
    @IBOutlet weak var alcAll: UIButton!
    @IBOutlet weak var alcWith: UIButton!
    @IBOutlet weak var alcWithout: UIButton!
    
    //Category
    @IBOutlet weak var catAll: UIButton!
    @IBOutlet weak var catCocktail: UIButton!
    @IBOutlet weak var catBeer: UIButton!
    @IBOutlet weak var catShot: UIButton!
    @IBOutlet weak var catCoffee: UIButton!
    @IBOutlet weak var catMilk: UIButton!
    @IBOutlet weak var catPunch: UIButton!
    
    //MARK:VIEW LOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    //MARK:UI
    func setupUI() {
        let buttonsArray = [ingrAll, ingrMyBar, alcAll, alcWith, alcWithout, catAll, catCocktail, catBeer, catShot, catCoffee, catMilk, catPunch]
        for but in buttonsArray {
            but?.layer.cornerRadius = 10
        }
    }
}
