//
//  FilterModel.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 16/03/2021.
//

import Foundation

enum ingrRequest {
    case all
    case myBar
}

enum alcRequest {
    case all
    case alc
    case none
}

struct requestType {
    var ingr = ingrRequest.all
    var alc = alcRequest.all
}

var currentRequest = requestType(ingr: .myBar, alc: .all)

func createShortCocktail(dict: [String:Any]) -> ShortCocktail? {
    if let name = dict["strDrink"] as? String {
        if let id = dict["idDrink"] as? String {
            let short = ShortCocktail(name: name, id: id)
            responseArray.append(short)
        }
    }
    return nil
}

func createIngrUrl() -> String {
    var urlString = "https://www.thecocktaildb.com/api/json/v2/9973533/filter.php?i="
    var counter = 1
    
    for ingr in ingrBarArray {
        if counter == ingrBarArray.count {
            urlString.append(ingr.name.makeUrlable())
        } else {
            urlString.append(ingr.name.makeUrlable() + ",")
        }
        counter += 1
    }
    
    return urlString
}


