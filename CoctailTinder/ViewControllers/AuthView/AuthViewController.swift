//
//  AuthViewController.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 10/03/2021.
//

import UIKit

class AuthViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var ingredientsCV: UICollectionView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "isLogin")
        setupUI()
        getAllIngredientsList()
        NotificationCenter.default.addObserver(self, selector: #selector(updateCV), name: NSNotification.Name("updateAuthCV"), object: nil)
    }
    
    @objc func updateCV() {
        self.ingredientsCV.reloadData()
    }
    
    func setupUI() {
        setDelegates()
        self.doneButton.layer.cornerRadius = 10
    }
    
    func setDelegates() {
        ingredientsCV.delegate = self
        ingredientsCV.dataSource = self
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ingrNameArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = ingredientsCV.dequeueReusableCell(withReuseIdentifier: "ingrCell", for: indexPath) as! ItemCollectionViewCell
        cell.cellIndex = indexPath.row
        cell.setupUI()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = ingredientsCV.dequeueReusableCell(withReuseIdentifier: "ingrCell", for: indexPath) as! ItemCollectionViewCell
        cell.cellIndex = indexPath.row
        cell.tappedCell()
        ingredientsCV.reloadData()
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        if ingrCalled == .auth {
            self.performSegue(withIdentifier: "toMain", sender: self)
        }
        else if ingrCalled == .bar {
            self.dismiss(animated: true, completion: nil)
        }
        imgDict.removeAll()
        ingrNameArray.removeAll()
    }
    
}
