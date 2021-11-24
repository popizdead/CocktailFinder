//
//  Category.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 24/11/2021.
//

import Foundation

enum Category {
    case new
    case pop
    case nonAlc
    case cocktails
    case shake
    case shot
    case coffee
    case beer
    case punch
    case random
    
    case soda
    case others
    case homemade
    case ordinary
    case cocoa
    
    func getUrl() -> String {
        switch self {
        case .new:
            return "https://www.thecocktaildb.com/api/json/v2/9973533/latest.php"
        case .pop:
            return "https://www.thecocktaildb.com/api/json/v2/9973533/popular.php"
        case .nonAlc:
            return "https://www.thecocktaildb.com/api/json/v2/9973533/filter.php?a=Non_Alcoholic"
        case .cocktails:
            return "https://www.thecocktaildb.com/api/json/v2/9973533/filter.php?c=Cocktail"
        case .shake:
            let url = "Milk / Float / Shake"
            return "https://www.thecocktaildb.com/api/json/v2/9973533/filter.php?c=\(url.makeUrlable())"
        case .shot:
            return "https://www.thecocktaildb.com/api/json/v2/9973533/filter.php?c=Shot"
        case .coffee:
            let url = "Coffee / Tea"
            return "https://www.thecocktaildb.com/api/json/v2/9973533/filter.php?c=\(url.makeUrlable())"
        case .beer:
            return "https://www.thecocktaildb.com/api/json/v2/9973533/filter.php?c=Beer"
        case .punch:
            let url = "Punch / Party Drink"
            return "https://www.thecocktaildb.com/api/json/v2/9973533/filter.php?c=\(url.makeUrlable())"
        case .random:
            return "https://www.thecocktaildb.com/api/json/v2/9973533/randomselection.php"
        case .soda:
            let url = "Soft Drink / Soda"
            return "https://www.thecocktaildb.com/api/json/v2/9973533/filter.php?c=\(url.makeUrlable())"
        case .others:
            let url = "Other/Unknown"
            return "https://www.thecocktaildb.com/api/json/v2/9973533/filter.php?c=\(url.makeUrlable())"
        case .homemade:
            let url = "Homemade Liqueur"
            return "https://www.thecocktaildb.com/api/json/v2/9973533/filter.php?c=\(url.makeUrlable())"
        case .ordinary:
            let url = "Ordinary Drink"
            return "https://www.thecocktaildb.com/api/json/v2/9973533/filter.php?c=\(url.makeUrlable())"
        case .cocoa:
            let url = "Cocoa"
            return "https://www.thecocktaildb.com/api/json/v2/9973533/filter.php?c=\(url.makeUrlable())"
        }
    }
    
    func getRequestType() -> NetworkService.ResponseType {
        switch self {
        case .new:
            return .fullInfo
        case .pop:
            return .fullInfo
        case .nonAlc:
            return .id
        case .cocktails:
            return .id
        case .shake:
            return .id
        case .shot:
            return .id
        case .coffee:
            return .id
        case .beer:
            return .id
        case .punch:
            return .id
        case .random:
            return .fullInfo
        case .soda:
            return .id
        case .others:
            return .id
        case .homemade:
            return .id
        case .ordinary:
            return .id
        case .cocoa:
            return .id
        }
    }
}
