//
//  SettingsFavViewController.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 21/03/2021.
//

import UIKit
import SwiftEntryKit

class SettingsFavViewController: UIViewController {
    
    //MARK:OUTLETS
    
    //Short view
    @IBOutlet weak var shortBgView: UIView!
    @IBOutlet weak var shortImg: UIView!
    @IBOutlet weak var shortIngr1: UIView!
    @IBOutlet weak var shortIngr2: UIView!
    @IBOutlet weak var shortTitle: UIView!
    @IBOutlet weak var shortIngr3: UIView!
    
    //Card view
    @IBOutlet weak var cardBgView: UIView!
    @IBOutlet weak var cardImg: UIView!
    @IBOutlet weak var cardTitle: UIView!
    @IBOutlet weak var cardTitle1: UIView!
    @IBOutlet weak var cardTitle2: UIView!
    @IBOutlet weak var cardTitle3: UIView!
    @IBOutlet weak var cardIngr: UIView!
    @IBOutlet weak var cardIngr1: UIView!
    @IBOutlet weak var cardIngr2: UIView!
    @IBOutlet weak var cardIngr3: UIView!
    
    @IBOutlet var cardTapRecognizer: UITapGestureRecognizer!
    @IBOutlet var shortTapRecognizer: UITapGestureRecognizer!
    
    private let UIService = UIUserService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    //MARK:VIEW LOAD
    override func viewWillAppear(_ animated: Bool) {
        fillViews()
    }
    
    func setupUI() {
        view.layer.cornerRadius = 10
        let radiusArray = [shortBgView, shortImg, shortIngr1, shortIngr2, shortIngr3, cardImg, cardBgView, cardIngr, cardIngr1, cardIngr2, cardIngr3, shortTitle, cardTitle1, cardTitle2, cardTitle3, cardTitle]
        for element in radiusArray {
            element?.makeShadowAndRadius(shadow: false, opacity: 0.5, radius: 10)
        }
    }
    
    //MARK:UI
    func fillViews() {
        let shortArray = [shortImg, shortTitle, shortIngr1, shortIngr2, shortIngr3]
        let cardArray = [cardImg, cardTitle, cardTitle1, cardTitle2, cardTitle3, cardIngr, cardIngr1, cardIngr2, cardIngr3]
        
        if UIService.userFavoriteSetting == .card {
            cardBgView.backgroundColor = .systemPink
            for obj in cardArray {
                obj?.backgroundColor = .systemGray6
            }
            
            shortBgView.backgroundColor = .darkGray
            for obj in shortArray {
                obj?.backgroundColor = .systemGray6
            }
        } else {
            cardBgView.backgroundColor = .darkGray
            for obj in cardArray {
                obj?.backgroundColor = .systemGray6
            }
            
            shortBgView.backgroundColor = .systemPink
            for obj in shortArray {
                obj?.backgroundColor = .systemGray6
            }
        }
    }
    
    //MARK:BUTTONS
    @IBAction func cardTapped(_ sender: UITapGestureRecognizer) {
        UIService.userFavoriteSetting = .card
        fillViews()
        NotificationCenter.default.post(name: NSNotification.Name("updateFavCV"), object: nil)
        SwiftEntryKit.dismiss()
    }
    
    @IBAction func shortTapped(_ sender: UITapGestureRecognizer) {
        UIService.userFavoriteSetting = .short
        fillViews()
        NotificationCenter.default.post(name: NSNotification.Name("updateFavCV"), object: nil)
        SwiftEntryKit.dismiss()
    }
    
}
