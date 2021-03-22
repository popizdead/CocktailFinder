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
    @IBOutlet weak var beer: UIButton!
    @IBOutlet weak var cocoa: UIButton!
    @IBOutlet weak var soda: UIButton!
    @IBOutlet weak var others: UIButton!
    @IBOutlet weak var ordinary: UIButton!
    @IBOutlet weak var homemade: UIButton!
    
    
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var leftBgView: UIView!
    @IBOutlet weak var rightBgView: UIView!
    
    //MARK:VIEW LOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI(){
        let buttonsArray = [new, pop, nonAlc, cocktails, shake, coffee, shot, punch, soda, beer, others, homemade, ordinary, cocoa]
        for button in buttonsArray {
            button?.makeShadowAndRadius(shadow: false, opacity: 0.5, radius: 10)
        }
        leftBgView.backgroundColor = .white
        rightBgView.backgroundColor = .white
        navView.backgroundColor = .white
        navView.makeShadowAndRadius(shadow: true, opacity: 0.5, radius: 10)
    }
    
    //MARK:BUTTONS
    @IBAction func collectionButtonTapped(_ sender: UIButton) {
        switch sender {
        case new:
            showingRequest = .new
            collectionRequest(type: .new)
            screenName = "New drinks"
        case pop:
            showingRequest = .pop
            collectionRequest(type: .pop)
            screenName = "Popular drinks"
        case nonAlc:
            showingRequest = .nonAlc
            collectionRequest(type: .nonAlc)
            screenName = "Non-Alcoholic drinks"
        case cocktails:
            showingRequest = .cocktails
            collectionRequest(type: .cocktails)
            screenName = "Cocktails"
        case shake:
            showingRequest = .shake
            collectionRequest(type: .shake)
            screenName = "Milk/Shake drinks"
        case coffee:
            showingRequest = .coffee
            collectionRequest(type: .coffee)
            screenName = "Coffee/Tea drinks"
        case shot:
            showingRequest = .shot
            collectionRequest(type: .shot)
            screenName = "Shot drinks"
        case punch:
            showingRequest = .punch
            collectionRequest(type: .punch)
            screenName = "Punch drinks"
        case beer:
            showingRequest = .beer
            collectionRequest(type: .beer)
            screenName = "Beer drinks"
        default:
            print("default")
        }
        self.performSegue(withIdentifier: "toItemsList", sender: self)
        
    }
  
    
    
}
