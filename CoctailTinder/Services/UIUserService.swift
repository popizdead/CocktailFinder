//
//  UIUserService.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 24/11/2021.
//

import Foundation

class UIUserService {
    static let shared = UIUserService()
    
    public enum favoriteView {
        case card
        case short
    }
    
    var userFavoriteSetting : favoriteView = .card
}
