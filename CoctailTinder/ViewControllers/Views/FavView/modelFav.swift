//
//  modelFav.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 21/03/2021.
//

import Foundation
import UIKit

enum favoriteView {
    case card
    case short
}

enum favoriteState {
    case searching
    case hidden
}

var favArray : [Coctail] = []
var showingArray : [Coctail] = []
var favSearchArray : [Coctail] = []

var favoriteCurrentView : favoriteView = .short
var favoriteCurrentState : favoriteState = .hidden

func updateFavShowingArray() {
    if favoriteCurrentState == .searching {
        showingArray = favSearchArray
    } else {
        showingArray = favArray
    }
    NotificationCenter.default.post(name: NSNotification.Name("updateFavCV"), object: nil)
}

func searchInFavorite(text: String) {
    favSearchArray.removeAll()
    for object in favArray {
        if object.name.lowercased().contains(text.lowercased()) {
            favSearchArray.append(object)
        }
    }
    updateFavShowingArray()
}
