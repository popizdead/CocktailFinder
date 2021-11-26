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

var currentRequest = requestType(ingr: .all, alc: .all)

func createShortCocktail(dict: [String:Any]) -> ShortCocktail? {
    if let name = dict["strDrink"] as? String {
        if let id = dict["idDrink"] as? String {
            let short = ShortCocktail(name: name, id: id)
            responseArray.append(short)
        }
    }
    return nil
}


