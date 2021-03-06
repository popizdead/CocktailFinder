//
//  SwipeViewController.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 05/03/2021.
//

import UIKit

class SwipeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK:OUTLETS
    @IBOutlet weak var swipeView: UIView!
    @IBOutlet weak var colorView: UIView!
    
    @IBOutlet var rightSwipe: UISwipeGestureRecognizer!
    @IBOutlet var leftSwipe: UISwipeGestureRecognizer!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var instructionTextView: UITextView!
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var ingrTableView: UITableView!
   
    @IBAction func swipeAction(_ sender: UISwipeGestureRecognizer) {
        if sender == rightSwipe {
            hideView(hide: true, toColor: UIColor(red: 14/255, green: 150/255, blue: 65/255, alpha: 1))
            favArray.insert(currentCoctail, at: 0)
        }
        else if sender == leftSwipe {
            hideView(hide: true, toColor: UIColor(red: 240/255, green: 51/255, blue: 66/255, alpha: 1))
        }
        randomCoctailRequest()
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
        loadingIndicator.isHidden = true
        loadingIndicator.startAnimating()
        swipeView.backgroundColor = .white
        swipeView.makeShadowAndRadius(shadow: true, opacity: 0.5, radius: 10)
        image.makeShadowAndRadius(shadow: false, opacity: 0.5, radius: 10)
        
        ingrTableView.delegate = self
        ingrTableView.dataSource = self
    }
    
    func updateUI() {
        self.categoryLbl.text = currentCoctail.category
        self.nameLbl.text = currentCoctail.name
        self.instructionTextView.text = currentCoctail.instruction
        
        ingrTableView.reloadData()
    }
    
    func hideView(hide: Bool, toColor: UIColor?) {
        loadingIndicator.animateHidding(hidding: !hide)
        if hide {
            image.isHidden = true
            image.image = nil
            self.colorView.animateHidding(hidding: false)
            UIView.animate(withDuration: 1) {
                self.colorView.backgroundColor = toColor!
            }
            UIView.animate(withDuration: 0.5) {
                self.colorView.backgroundColor = .white
            }
            
        } else {
            image.backgroundColor = .systemGray6
            image.isHidden = false
            self.colorView.animateHidding(hidding: true)
            
        }
    }
    
    
    //MARK:COLLECTION VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentCoctail.ingrArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ingrTableView.dequeueReusableCell(withIdentifier: "ingrCell", for: indexPath) as! IngrTableViewCell
        let ingr = currentCoctail.ingrArray[indexPath.row]
        cell.nameLbl.text = "\(ingr.name) \(ingr.measure)"
        return cell
    }
    
}
