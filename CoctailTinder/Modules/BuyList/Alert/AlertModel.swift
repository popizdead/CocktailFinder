//
//  AlertModel.swift
//  CoctailFinder
//
//  Created by Даниил Дорожкин on 01/12/2021.
//

import Foundation
import UIKit
import SwiftEntryKit

extension UIViewController {
    func showIngredient(_ ingredient: Ingredient) {
        guard let vc = storyboard!.instantiateViewController(withIdentifier: "alertIngr") as? AlertIngredientViewController else {
            return
        }
        
        vc.ingredient = ingredient
        SwiftEntryKit.display(entry: vc, using: alertAttributes())
    }
    
    private func alertAttributes() -> EKAttributes {
        var attributes = EKAttributes.centerFloat
        
        let widthConstraint = EKAttributes.PositionConstraints.Edge.ratio(value: 0.8)
        let heightConstraint = EKAttributes.PositionConstraints.Edge.ratio(value: 0.3)
        attributes.positionConstraints.size = .init(width: widthConstraint, height: heightConstraint)
        
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 10, offset: .zero))
        attributes.roundCorners = .all(radius: 15)
        
        attributes.entryBackground = .color(color: .clear)
        attributes.screenBackground = .color(color: EKColor(UIColor(white: 0, alpha: 0.5)))

        attributes.entranceAnimation = .translation
        attributes.exitAnimation = .translation
        
        attributes.displayDuration = .infinity
        attributes.entryInteraction = .forward
        
        attributes.screenInteraction = .dismiss
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
        
        return attributes
    }
}
