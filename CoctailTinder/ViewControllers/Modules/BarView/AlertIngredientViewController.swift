//
//  AlertIngredientViewController.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 15/03/2021.
//

import UIKit
import SwiftEntryKit

class AlertIngredientViewController: UIViewController {
    
    //MARK:OUTLETS
    @IBOutlet weak var ingrImage: UIImageView!
    @IBOutlet weak var ingrNameLbl: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    private let dataService = DataService.shared
    
    //MARK:VIEW LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateUI()
    }
    
    //MARK:UI
    func setupUI(){
        addButton.layer.cornerRadius = 10
        cancelButton.layer.cornerRadius = 10
        view.layer.cornerRadius = 10
    }
    
    func updateUI(){
        ingrImage.image = dataService.alertIngredient.ingrImage
        ingrNameLbl.text = dataService.alertIngredient.name
    }
    
    //MARK:BUTTONS
    @IBAction func addButtonTapped(_ sender: UIButton) {
        let ingr = dataService.alertIngredient
        
        dataService.userBuyList.append(ingr)
        dataService.saveBuyListItem(ingr: ingr)
        
        SwiftEntryKit.dismiss()
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        SwiftEntryKit.dismiss()
    }
    
}
