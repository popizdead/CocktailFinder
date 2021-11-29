//
//  SwipeModel.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 23/11/2021.
//

import Foundation
import UIKit
import FirebaseAnalytics
import SwiftEntryKit

extension SwipeViewController {
    //MARK: -NETWORK
    func request() {
        self.showLoading(true)
        
        network.stopAllRequests {
            self.network.randomCoctailRequest { cocktail in
                self.cardCocktail = cocktail
                self.cardCocktail?.getImages {
                    self.updateUI()
                }

                self.openCard()
            }
        }
    }
    
    //MARK: -ANIMATION & SWIPE LOGIC
    func swipeAction(_ card: UIView) {
        if card.center.x > bgView.center.x {
            //Right
            fillView(.systemGreen)
            cardCocktail?.saveCore()
        } else {
            //Left
            fillView(.systemRed)
        }
        
        animateCardBack(card)
        self.request()
    }
    
    private func animateCardBack(_ card: UIView) {
        UIView.animate(withDuration: 0.2) {
            card.center.x = self.bgView.center.x
            card.center.y = self.bgView.center.y / 1.25
            
            self.swipeView.layoutIfNeeded()
        }
    }
    
    private func fillView(_ toColor: UIColor) {
        showLoading(true)
        
        let items : [UIView] = [swipeView, navView]
        
        items.forEach({
            $0.backgroundColor = toColor
            self.swipeView.alpha = 0.5
        })
        
        self.tabBarController?.tabBar.backgroundColor = toColor
        self.navigationLbl.textColor = .white
        
        UIView.animate(withDuration: 0.5) {
            items.forEach({
                $0.alpha = 1
                $0.backgroundColor = .white
            })
            
            self.tabBarController?.tabBar.backgroundColor = .white
            self.navigationLbl.textColor = .black
        }
    }
    
    //MARK: -POPUP
    func setupAttributes() -> EKAttributes {
        var attributes = EKAttributes.centerFloat
        
        let widthConstraint = EKAttributes.PositionConstraints.Edge.ratio(value: 0.8)
        let heightConstraint = EKAttributes.PositionConstraints.Edge.ratio(value: 0.3)
        attributes.positionConstraints.size = .init(width: widthConstraint, height: heightConstraint)
        
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 10, offset: .zero))
        attributes.roundCorners = .all(radius: 15)
        
        // Set its background to white
        attributes.entryBackground = .color(color: .clear)
        attributes.screenBackground = .color(color: EKColor(UIColor(white: 0, alpha: 0.5)))

        // Animate in and out using default translation
        attributes.entranceAnimation = .translation
        attributes.exitAnimation = .translation
        
        attributes.displayDuration = .infinity
        attributes.entryInteraction = .forward
        
        attributes.screenInteraction = .dismiss
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
        
        return attributes
    }
}

