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
    
    @IBOutlet weak var shadowView: UIView!
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
        shadowView.backgroundColor = .white
        shadowView.makeShadowAndRadius(shadow: true, opacity: 0.5, radius: 10)
        navView.makeShadowAndRadius(shadow: true, opacity: 0.5, radius: 10)
    }
    
    //MARK:BUTTONS
    @IBAction func newTapped(_ sender: UIButton) {
        collectionRequest(type: .new)
    }
    
}
