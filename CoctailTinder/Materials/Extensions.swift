//
//  Extensions.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 05/03/2021.
//

import Foundation
import UIKit

extension UIView {
    func makeShadowAndRadius(shadow: Bool, opacity: Float, radius: Float) {
        if shadow {
            self.layer.shadowColor = UIColor.darkGray.cgColor
            self.layer.shadowOpacity = opacity
            self.layer.shadowOffset = .zero
            self.layer.shadowRadius = CGFloat(radius)
            self.layer.masksToBounds = false
        }
        self.layer.cornerRadius = CGFloat(radius)
    }
    
    func animateHidding(hidding: Bool) {
        UIView.animate(withDuration: 0.1, delay: 0, options: [], animations: {
            if hidding {
                self.alpha = 0
            } else {
                self.alpha = 1
            }
        }, completion: { _ in
            self.isHidden = hidding
        })
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func uppercaseFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func makeUrlable() -> String {
        return self.replacingOccurrences(of: " ", with: "%20")
    }
}
