//
//  BarViewController.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 13/03/2021.
//

import UIKit

class BarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, BarProtocol {

    //MARK: -OUTLETS
    @IBOutlet weak var navView: UIView!
    
    @IBOutlet weak var ingrCV: UICollectionView!
    
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var addButton: UIButton!
    
    private let dataService = DataService.shared
    
    //MARK: -VIEW LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIUpdate()
    }
    
    func UIUpdate() {
        ingrCV.reloadData()
    }
    
    private func delegate() {
        ingrCV.dataSource = self
        ingrCV.delegate = self
    }
    
    //MARK: -UI
    private func setupUI() {
        navView.makeShadowAndRadius(shadow: true, opacity: 0.5, radius: 10)
        
        buttonView.makeShadowAndRadius(shadow: false, opacity: 0.5, radius: 10)
        navView.backgroundColor = .white
    }
    
    //MARK: -BUTTONS
    @IBAction func addButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "barToIngr", sender: self)
    }
    
    //MARK: -COLLECTION VIEW
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataService.userBuyList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = ingrCV.dequeueReusableCell(withReuseIdentifier: "ingrCell", for: indexPath) as! BarCollectionViewCell
        let ingr = dataService.userBuyList[indexPath.row]
    
        cell.setupUI()
        cell.ingrImage.image = ingr.ingrImage
        cell.nameLbl.text = ingr.name
        
        cell.delegate = self
        return cell
    }

}
