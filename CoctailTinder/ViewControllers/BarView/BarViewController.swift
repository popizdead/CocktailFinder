//
//  BarViewController.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 13/03/2021.
//

import UIKit

class BarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    //MARK:OUTLETS
    @IBOutlet weak var barButton: UIButton!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var ingrCV: UICollectionView!
    
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var addButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ingrCV.reloadData()
    }
    
    @objc func update() {
        ingrCV.reloadData()
    }
    
    func delegate() {
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: NSNotification.Name("updateBar"), object: nil)
        ingrCV.dataSource = self
        ingrCV.delegate = self
    }
    
    func setupUI() {
        navView.makeShadowAndRadius(shadow: true, opacity: 0.5, radius: 10)
        navView.backgroundColor = .white
        barButton.layer.cornerRadius = 10
        buyButton.layer.cornerRadius = 10
        buttonView.layer.cornerRadius = 10
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        ingrCalled = .bar
        self.performSegue(withIdentifier: "barToIngr", sender: self)
    }
    
    //MARK:COLLECTION VIEW
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if currentState == .bar {
            return ingrBarArray.count
        } else {
            return userBuyList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = ingrCV.dequeueReusableCell(withReuseIdentifier: "ingrCell", for: indexPath) as! BarCollectionViewCell
        let ingr = ingrBarArray[indexPath.row]
        
        cell.setupUI()
        cell.ingrImage.image = ingr.ingrImage
        cell.nameLbl.text = ingr.name
        
        return cell
    }

}
