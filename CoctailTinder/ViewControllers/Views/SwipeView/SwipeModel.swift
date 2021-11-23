//
//  SwipeModel.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 23/11/2021.
//

import Foundation
import UIKit
import SwiftEntryKit

extension SwipeViewController {
    //MARK: -NETWORK
    func request() {
        self.showLoading(true)
        
        network.stopAllRequests {
            self.network.currentRequestFrom = .swipe
            self.network.randomCoctailRequest()
        }
    }
    
    //MARK: -ANIMATION & SWIPE LOGIC
    func swipeAction(_ card: UIView) {
        if card.center.x > bgView.center.x {
            //Right
            fillView(.systemGreen)
            saveCurrentCocktail()
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
        
        self.swipeView.backgroundColor = toColor
        self.swipeView.alpha = 0.5
        
        UIView.animate(withDuration: 0.5) {
            self.swipeView.alpha = 1
            self.swipeView.backgroundColor = .white
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
