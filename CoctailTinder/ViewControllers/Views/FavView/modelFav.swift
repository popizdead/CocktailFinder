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

var favoriteCurrentView : favoriteView = .short
var favoriteCurrentState : favoriteState = .hidden
