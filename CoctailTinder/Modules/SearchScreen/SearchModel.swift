//
//  SearchModel.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 18/03/2021.
//

import Foundation
import SwiftEntryKit

extension SearchViewController {
    func search(_ text: String) {
        resultSearchArray.removeAll()
        network.stopAllRequests {
            self.network.search(text) { cocktail in
                
                self.resultSearchArray.append(cocktail)
                
                cocktail.getImages {
                    self.CVUpdate()
                }
            }
        }
    }
}

//MARK: -SEGUE
extension ItemSearchCollectionViewCell {
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


