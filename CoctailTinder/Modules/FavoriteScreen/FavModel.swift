//
//  modelFav.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 21/03/2021.
//

import Foundation
import UIKit
import SwiftEntryKit

protocol FavoriteActionsProtocol: AnyObject {
    func updateAppearingArray()
    func UIUpdateState(_ state: UIFavoriteState)
}

enum UIFavoriteState {
   case card
   case short
}

//MARK: -PROTOCOL
extension FavViewController: FavoriteActionsProtocol {
    enum favoriteState {
        case searching
        case hidden
    }
    
    //MARK: -UI
    func UIUpdateState(_ state: UIFavoriteState) {
        self.UIState = state
        UIUpdate()
    }
    
    //MARK: -SOURCE
    func updateAppearingArray() {
        if favoriteCurrentState == .searching {
            showingArray = favSearchArray
        } else {
            showingArray = dataService.favArray
        }
        
        self.UIUpdate()
    }

    func searchInFavorite(text: String) {
        favSearchArray.removeAll()
        for object in dataService.favArray {
            if object.name.lowercased().contains(text.lowercased()) {
                favSearchArray.append(object)
            }
        }
        updateAppearingArray()
    }
}

//MARK: -SEARCH VIEW
extension FavViewController {
    func searchViewAnimate(_ to: favoriteState) {
        switch to {
        case .searching:
            UIView.animate(withDuration: 0.5) { [self] in
                self.labelFromBottomConstraint.constant = self.labelFromBottomConstraint.constant + 42
                self.settingButtonFromBottomConstraint.constant = self.settingButtonFromBottomConstraint.constant + 42
                self.searchButtonFromBottomConstraint.constant = self.searchButtonFromBottomConstraint.constant + 42
                self.cvFromTopConstraint.constant = self.cvFromTopConstraint.constant + 42
            }
            
            hideButton.animateHidding(hidding: false)
            searchField.animateHidding(hidding: false)
            
            favoriteCurrentState = .searching
        case .hidden:
            hideButton.isHidden = true
            searchField.isHidden = true
            
            UIView.animate(withDuration: 0.5) { [self] in
                self.labelFromBottomConstraint.constant = self.labelFromBottomConstraint.constant - 42
                self.settingButtonFromBottomConstraint.constant = self.settingButtonFromBottomConstraint.constant - 42
                self.searchButtonFromBottomConstraint.constant = self.searchButtonFromBottomConstraint.constant - 42
                self.cvFromTopConstraint.constant = self.cvFromTopConstraint.constant - 42
            }
            
            favoriteCurrentState = .hidden
            updateAppearingArray()
        }
    }
}

//MARK: -SEGUE
extension FavViewController {
    func setupAttributes() -> EKAttributes {
        var attributes = EKAttributes.centerFloat
        
        let widthConstraint = EKAttributes.PositionConstraints.Edge.ratio(value: 0.95)
        let heightConstraint = EKAttributes.PositionConstraints.Edge.ratio(value: 0.5)
        attributes.positionConstraints.size = .init(width: widthConstraint, height: heightConstraint)
        
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.8, radius: 10, offset: .zero))
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
    
    func displaySettings() {
        guard let vc = storyboard!.instantiateViewController(withIdentifier:"favSettings") as? SettingsFavViewController else {
            return
        }
        
        vc.currentState = UIState
        vc.delegate = self
        
        SwiftEntryKit.display(entry: vc, using: setupAttributes())
    }
}

extension FavViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedCocktail = selectedCocktail else { return }
        if segue.identifier == "favToReview" {
            if let vc = segue.destination as? CocktailViewController {
                vc.reviewCocktail = selectedCocktail
            }
        }
    }
}






