//
//  CollectionsViewController.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 17/03/2021.
//

import UIKit

class CollectionsViewController: UIViewController {
    
    //MARK:OUTLETS
    @IBOutlet weak var new: UIButton!
    @IBOutlet weak var pop: UIButton!
    @IBOutlet weak var nonAlc: UIButton!
    @IBOutlet weak var cocktails: UIButton!
    @IBOutlet weak var shake: UIButton!
    @IBOutlet weak var coffee: UIButton!
    @IBOutlet weak var shot: UIButton!
    @IBOutlet weak var punch: UIButton!
    @IBOutlet weak var random: UIButton!
    @IBOutlet weak var beer: UIButton!
    
    @IBOutlet weak var navView: UIView!
    
    //MARK:VIEW LOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI(){
        let buttonsArray = [new, pop, nonAlc, cocktails, shake, coffee, shot, punch, random, beer]
        for button in buttonsArray {
            button?.makeShadowAndRadius(shadow: false, opacity: 0.5, radius: 10)
        }
        navView.backgroundColor = .white
        navView.makeShadowAndRadius(shadow: true, opacity: 0.5, radius: 10)
    }
    
    //MARK:BUTTONS
    @IBAction func collectionButtonTapped(_ sender: UIButton) {
        switch sender {
        case new:
            collectionRequest(type: .new)
            screenName = "New drinks"
        case pop:
            collectionRequest(type: .pop)
            screenName = "Popular drinks"
        case nonAlc:
            collectionRequest(type: .nonAlc)
            screenName = "Non-Alcoholic drinks"
        case cocktails:
            collectionRequest(type: .cocktails)
            screenName = "Cocktails"
        case shake:
            collectionRequest(type: .shake)
            screenName = "Milk/Shake drinks"
        case coffee:
            collectionRequest(type: .coffee)
            screenName = "Coffee/Tea drinks"
        case shot:
            collectionRequest(type: .shot)
            screenName = "Shot drinks"
        case punch:
            collectionRequest(type: .punch)
            screenName = "Punch drinks"
        case random:
            collectionRequest(type: .random)
            screenName = "Random drinks"
        case beer:
            collectionRequest(type: .beer)
            screenName = "Beer drinks"
        default:
            print("default")
        }
        self.performSegue(withIdentifier: "toItemsList", sender: self)
        
    }
  
    
    
}
