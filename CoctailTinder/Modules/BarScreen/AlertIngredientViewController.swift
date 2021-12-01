//
//  AlertIngredientViewController.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 15/03/2021.
//

import UIKit
import SwiftEntryKit

class AlertIngredientViewController: UIViewController {
    
    //MARK: -OUTLETS
    @IBOutlet weak var ingrImage: UIImageView!
    @IBOutlet weak var ingrNameLbl: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    var ingredient : Ingredient?
    private let dataService = DataService.shared
    
    //MARK: -VIEW LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateUI()
    }
    
    //MARK: -UI
    private func setupUI(){
        addButton.layer.cornerRadius = 10
        cancelButton.layer.cornerRadius = 10
        
        view.layer.cornerRadius = 10
    }
    
    private func updateUI(){
        guard let ingredient = ingredient else {
            return
        }
        
        ingrImage.image = ingredient.ingrImage
        ingrNameLbl.text = ingredient.name
    }
    
    //MARK: -BUTTONS
    @IBAction func addButtonTapped(_ sender: UIButton) {
        guard let ingredient = ingredient else {
            return
        }

        dataService.userBuyList.append(ingredient)
        dataService.saveBuyListItem(ingr: ingredient)
        
        SwiftEntryKit.dismiss()
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        SwiftEntryKit.dismiss()
    }
    
}
