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

func requestCocktail() {
    if currentRequest.ingr == .all && currentRequest.alc == .all {
        //Random
        
    }
    else if currentRequest.ingr == .myBar {
        //Ingredients
        
    }
}


