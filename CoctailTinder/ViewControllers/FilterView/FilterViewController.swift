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
    
    
    //MARK:VIEW LOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
    }
    
    //MARK:UI
    func setupUI() {
        let buttonsArray = [ingrAll, ingrMyBar, alcAll, alcWith, alcWithout]
        for but in buttonsArray {
            but?.layer.cornerRadius = 10
        }
        view.layer.cornerRadius = 10
    }
    
    @IBAction func myBarTapped(_ sender: UIButton) {
        currentRequest.ingr = .myBar
        isFilterChanged = true
    }
}
