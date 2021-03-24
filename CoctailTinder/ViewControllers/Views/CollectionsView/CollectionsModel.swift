//
//  CollectionsModel.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 17/03/2021.
//

import Foundation
import UIKit
import Alamofire

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
                        countOfCocktailsTo(ingr: name)
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

//MARK:COLLECTIONS
var sourceItemsArray : [Coctail] = []
var responseArray : [ShortCocktail] = []

enum typeRequest {
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
}

var showingRequest : typeRequest = .cocktails

func createShort(dict: [String:Any]) -> ShortCocktail? {
    if let name = dict["strDrink"] as? String {
        if let id = dict["idDrink"] as? String {
            return ShortCocktail(name: name, id: id)
        }
    }
    return nil
}

//Creating request
func collectionRequest(type: typeRequest) {
    requestedFrom = .collection
    
    sourceItemsArray.removeAll()
    responseArray.removeAll()
    
    switch type {
    case .new:
        fullCocktailArrayRequest(url: "https://www.thecocktaildb.com/api/json/v2/9973533/latest.php")
    case .pop:
        fullCocktailArrayRequest(url: "https://www.thecocktaildb.com/api/json/v2/9973533/popular.php")
    case .nonAlc:
        idCocktailArrayRequest(url: "https://www.thecocktaildb.com/api/json/v2/9973533/filter.php?a=Non_Alcoholic")
    case .cocktails:
        idCocktailArrayRequest(url: "https://www.thecocktaildb.com/api/json/v2/9973533/filter.php?c=Cocktail")
    case .shake:
        let url = "Milk / Float / Shake"
        idCocktailArrayRequest(url: "https://www.thecocktaildb.com/api/json/v2/9973533/filter.php?c=\(url.makeUrlable())")
    case .shot:
        idCocktailArrayRequest(url: "https://www.thecocktaildb.com/api/json/v2/9973533/filter.php?c=Shot")
    case .coffee:
        let url = "Coffee / Tea"
        idCocktailArrayRequest(url: "https://www.thecocktaildb.com/api/json/v2/9973533/filter.php?c=\(url.makeUrlable())")
    case .beer:
        idCocktailArrayRequest(url: "https://www.thecocktaildb.com/api/json/v2/9973533/filter.php?c=Beer")
    case .punch:
        let url = "Punch / Party Drink"
        idCocktailArrayRequest(url: "https://www.thecocktaildb.com/api/json/v2/9973533/filter.php?c=\(url.makeUrlable())")
    case .random:
        fullCocktailArrayRequest(url: "https://www.thecocktaildb.com/api/json/v2/9973533/randomselection.php")
    }
    
}

//Request for full cocktail
func fullCocktailArrayRequest(url: String) {
    AF.request(url).responseJSON { (data) in
        guard let allDataDict = data.value as? [String : Any] else { return }
        if let cocktailsArray = allDataDict["drinks"] as? [[String:Any]] {
            for object in cocktailsArray {
                if let cocktail = createCoctail(from: object) {
                    cocktail.getCocktailImage()
                    cocktail.getIngredientImage()
                    sourceItemsArray.append(cocktail)
                }
            }
            NotificationCenter.default.post(name: NSNotification.Name("updateItemsCV"), object: nil)
        }
    }
}

//Request for id
func idCocktailArrayRequest(url: String) {
    AF.request(url).responseJSON { (data) in
        guard let allDataDict = data.value as? [String : Any] else { return }
        if let cocktailsArray = allDataDict["drinks"] as? [[String:Any]] {
            for object in cocktailsArray {
                if let short = createShort(dict: object) {
                    responseArray.append(short)
                }
            }
            showResponseFromArray()
        }
    }
}

//Cocktail from array
func showResponseFromArray() {
    var preparingArray : [ShortCocktail] = []
    var counter = 0
    
    while counter <= 10 {
        let object = responseArray.randomElement()!
        if !preparingArray.contains(where: {$0.id == object.id}) {
            getCocktailByID(id: object.id)
            preparingArray.append(object)
            counter += 1
        }
    }
    
    preparingArray.removeAll()
}
