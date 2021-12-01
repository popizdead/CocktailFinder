//
//  SettingsFavViewController.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 21/03/2021.
//

import UIKit
import SwiftEntryKit

class SettingsFavViewController: UIViewController {
    
    //MARK: -OUTLETS
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
    
    var currentState = UIFavoriteState.short
    weak var delegate : FavoriteActionsProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    //MARK: -VIEW LOAD
    override func viewWillAppear(_ animated: Bool) {
        fillViews()
    }
    
    private func setupUI() {
        view.layer.cornerRadius = 10
        let radiusArray = [shortBgView, shortImg, shortIngr1, shortIngr2, shortIngr3, cardImg, cardBgView, cardIngr, cardIngr1, cardIngr2, cardIngr3, shortTitle, cardTitle1, cardTitle2, cardTitle3, cardTitle]
        for element in radiusArray {
            element?.makeShadowAndRadius(shadow: false, opacity: 0.5, radius: 10)
        }
    }
    
    //MARK:UI
    private func fillViews() {
        let shortArray = [shortImg, shortTitle, shortIngr1, shortIngr2, shortIngr3]
        let cardArray = [cardImg, cardTitle, cardTitle1, cardTitle2, cardTitle3, cardIngr, cardIngr1, cardIngr2, cardIngr3]
        
        if currentState == .card {
            cardBgView.backgroundColor = .black
            for obj in cardArray {
                obj?.backgroundColor = .systemGray6
            }
            
            shortBgView.backgroundColor = .lightGray
            for obj in shortArray {
                obj?.backgroundColor = .systemGray6
            }
        } else {
            cardBgView.backgroundColor = .lightGray
            for obj in cardArray {
                obj?.backgroundColor = .systemGray6
            }
            
            shortBgView.backgroundColor = .black
            for obj in shortArray {
                obj?.backgroundColor = .systemGray6
            }
        }
    }
    
    //MARK:BUTTONS
    @IBAction func cardTapped(_ sender: UITapGestureRecognizer) {
        delegate?.UIUpdateState(.card)
        self.currentState = .card
        
        self.close()
    }
    
    @IBAction func shortTapped(_ sender: UITapGestureRecognizer) {
        delegate?.UIUpdateState(.short)
        self.currentState = .short
        
        self.close()
    }
    
    private func close() {
        fillViews()
        NotificationCenter.default.post(name: NSNotification.Name("updateFavCV"), object: nil)
        SwiftEntryKit.dismiss()
    }
    
}
