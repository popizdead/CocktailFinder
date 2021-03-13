//
//  BarViewController.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 13/03/2021.
//

import UIKit

class BarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK:OUTLETS
    @IBOutlet weak var barButton: UIButton!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var ingrTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate()
        setupUI()
    }
    
    func delegate() {
        ingrTableView.dataSource = self
        ingrTableView.delegate = self
    }
    
    func setupUI() {
        navView.makeShadowAndRadius(shadow: true, opacity: 0.5, radius: 10)
        navView.backgroundColor = .white
        barButton.layer.cornerRadius = 10
        buyButton.layer.cornerRadius = 10
    }
    
    //MARK:TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentState == .bar {
            return ingrBarArray.count
        } else {
            return userBuyList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ingrTableView.dequeueReusableCell(withIdentifier: "ingrCell", for: indexPath) as! IngredientTableViewCell
        let ingr = ingrBarArray[indexPath.row]
        
        cell.setupUI()
        cell.ingrImage.image = ingr.ingrImage
        cell.ingrName.text = ingr.name
        
        return cell
    }

}
