//
//  modelFav.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 21/03/2021.
//

import Foundation
import UIKit

protocol FavoriteActionsProtocol {
    func updateShowingArray()
}

extension FavViewController: FavoriteActionsProtocol {
    
    enum favoriteState {
        case searching
        case hidden
    }
    
    func updateShowingArray() {
        if favoriteCurrentState == .searching {
            showingArray = favSearchArray
        } else {
            showingArray = dataService.favArray
        }
        
        self.update()
    }

    func searchInFavorite(text: String) {
        favSearchArray.removeAll()
        for object in dataService.favArray {
            if object.name.lowercased().contains(text.lowercased()) {
                favSearchArray.append(object)
            }
        }
        updateShowingArray()
    }
}






