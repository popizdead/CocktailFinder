//
//  CollectionsModel.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 17/03/2021.
//

import Foundation
import UIKit
import Alamofire

/*
 Sometimes we're getting back couples of [Title:ID],
 and sometimes it's full data of cocktails
 
 So we have two ways of usage func categoryRequest() depends
 on response
 */


extension CollectionsViewController {
    func collectionRequest(type: Category) {
        network.currentRequestFrom = .collection
        
        dataService.collectionCocktailSource.removeAll()
        
        network.categoryRequest(type.getUrl(), type.getRequestType()) { cocktail in
            self.applyCocktail(cocktail)
        }
    }
    
    func applyCocktail(_ cocktail: Cocktail?) {
        guard let cocktail = cocktail else { return }
        cocktail.getImages {
            self.update()
            
            NotificationCenter.default.post(name: NSNotification.Name("updateItemsCV"), object: nil)
        }
        
        dataService.collectionCocktailSource.append(cocktail)
    }
}

//MARK:STATE
enum collectionState {
    case ingr
    case categories
}

enum showCollectionState {
    case search
    case all
}

var colCurrentState : collectionState = .categories
var searchColCurrentState : showCollectionState = .all

extension CollectionsViewController {
    func changeState() {
        fillButtons()
        
        if colCurrentState == .ingr {
            buttonsBg.animateHidding(hidding: true)
            tableBg.animateHidding(hidding: false)
        } else {
            buttonsBg.animateHidding(hidding: false)
            tableBg.animateHidding(hidding: true)
        }
    }
    
    func fillButtons() {
        if colCurrentState == .ingr {
            catButtons.setTitleColor(.black, for: .normal)
            ingrButton.setTitleColor(.systemPink, for: .normal)
        } else {
            catButtons.setTitleColor(.systemPink, for: .normal)
            ingrButton.setTitleColor(.black, for: .normal)
        }
    }
}

//MARK:INGREDIENTS
struct modelIngredient {
    var name : String
    var count : Int
}

var ingrShowingArray : [modelIngredient] = []

var ingrSearchArray : [modelIngredient] = []
var tableSource : [modelIngredient] = []

func updateCollectionShowingArray() {
    if searchColCurrentState == .all {
        ingrShowingArray = tableSource
    } else {
        ingrShowingArray = ingrSearchArray
    }
    NotificationCenter.default.post(name: NSNotification.Name("collectionSourceReady"), object: nil)
}

//Search ingredients
func searchIngr(name: String) {
    ingrSearchArray.removeAll()
    for object in tableSource {
        if object.name.lowercased().contains(name.lowercased()) {
            ingrSearchArray.append(object)
        }
    }
    updateCollectionShowingArray()
}

//Getting all ingredients
func getListOfIngredients() {
    AF.request("https://www.thecocktaildb.com/api/json/v2/9973533/list.php?i=list").responseJSON { (response) in
        if let dataDict = response.value as? [String:Any] {
            if let ingrDict = dataDict["drinks"] as? [[String:Any]] {
                for ingrElem in ingrDict {
                    if let name = ingrElem["strIngredient1"] as? String {
                        countOfCocktailsTo(ingr: name.capitalizingFirstLetter())
                    }
                }
            }
        }
    }
}

//Counting cocktails of ingredient
func countOfCocktailsTo(ingr: String) {
    AF.request("https://www.thecocktaildb.com/api/json/v2/9973533/filter.php?i=\(ingr)").responseJSON { (response) in
        if let allData = response.value as? [String:Any] {
            if let cocktails = allData["drinks"] as? [[String:Any]] {
                let model = modelIngredient(name: ingr, count: cocktails.count)
                tableSource.append(model)
                NotificationCenter.default.post(name: NSNotification.Name("collectionSourcePreparing"), object: nil)
            }
        }
    }
}

var showingRequest : Category = .cocktails

//Creating request


//func ingredientRequest(name: String) {
//    requestedFrom = .collection
//    
//    sourceItemsArray.removeAll()
//    responseArray.removeAll()
//    
//    let url = "https://www.thecocktaildb.com/api/json/v2/9973533/filter.php?i=\(name.makeUrlable())"
//    idCocktailArrayRequest(url: url)
//}
