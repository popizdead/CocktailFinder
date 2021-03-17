//
//  CollectionsModel.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 17/03/2021.
//

import Foundation
import UIKit
import Alamofire

var sourceItemsArray : [Coctail] = []

enum typeRequest {
    case new
    case pop
}

func collectionRequest(type: typeRequest) {
    switch type {
    case .new:
        newsCocktailRequest()
    case .pop:
        newsCocktailRequest()
    }
}

func newsCocktailRequest() {
    AF.request("https://www.thecocktaildb.com/api/json/v2/9973533/popular.php").responseJSON { (data) in
        guard let allDataDict = data.value as? [String : Any] else { return }
        print(data.value)
        if let cocktailsArray = allDataDict["drinks"] as? [[String:Any]] {
            for object in cocktailsArray {
                if let cocktail = createCoctail(from: object) {
                    sourceItemsArray.append(cocktail)
                }
            }
            print("Created \(sourceItemsArray.count) cocktails")
        }
    }
}
