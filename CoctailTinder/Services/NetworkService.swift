//
//  NetworkService.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 23/11/2021.
//

import Foundation
import Alamofire

class NetworkService {
    static let shared = NetworkService()
    private let factory = Factory.shared
    
    //MARK: -SESSION MANAGER
    private let requestSession : Session = Session()
    private let cacheSession : Session = Session()
    
    func stopAllRequests(_ compilation: @escaping () -> Void) {
        requestSession.cancelAllRequests(completingOnQueue: DispatchQueue.main, completion: {
            compilation()
        })
    }
    
    //MARK: -COCKTAILS REQUESTS
    func randomCoctailRequest(_ action: @escaping (Cocktail?) -> Void) {
        requestSession.request("https://www.thecocktaildb.com/api/json/v2/9973533/random.php").responseJSON { (data) in
            guard let dataDict = data.value as? [String : Any] else { return }
            if let arrayData = dataDict["drinks"] as? [[String:Any]] {
                if let cocktailData = arrayData.first {
                    if let cocktail = self.factory.createCoctail(from: cocktailData) {
                        action(cocktail)
                    } else {
                        self.stopAllRequests {
                            self.randomCoctailRequest(action)
                        }
                    }
                }
            }
        }
    }
    
    func getCocktailByID(_ id: String, _ action: @escaping (Cocktail?) -> Void) {
        self.requestSession.request("https://www.thecocktaildb.com/api/json/v2/9973533/lookup.php?i=\(id)").responseJSON { (data) in
            guard let dataDict = data.value as? [String : Any] else { return }
            if let arrayData = dataDict["drinks"] as? [[String:Any]] {
                if let cocktailData = arrayData.first {
                    if let cocktail = self.factory.createCoctail(from: cocktailData) {
                        action(cocktail)
                        return
                    }
                }
            }
            action(nil)
        }
    }
    
    func getCacheCocktailByID(_ id: String, _ action: @escaping (Cocktail?) -> Void) {
        cacheSession.request("https://www.thecocktaildb.com/api/json/v2/9973533/lookup.php?i=\(id)").responseJSON { (data) in
            guard let dataDict = data.value as? [String : Any] else { return }
            if let arrayData = dataDict["drinks"] as? [[String:Any]] {
                if let cocktailData = arrayData.first {
                    if let cocktail = self.factory.createCoctail(from: cocktailData) {
                        action(cocktail)
                        return
                    }
                }
            }
            action(nil)
        }
    }
    
    //MARK: -CATEGORY REQUEST
    public enum ResponseType {
        case id
        case fullInfo
        
    }
    /*
     Sometimes we're getting back couples of [Title:ID],
     and sometimes it's full data of cocktails
     
     So we have two ways of usage func categoryRequest() depends
     on response
     */
    
    func categoryRequest(_ url: String, _ type: ResponseType, _ action: @escaping (Cocktail?) -> Void) {
        switch type {
        case .id:
            idRequest(url) { cocktail in
                action(cocktail)
            }
        case .fullInfo:
            fullInfoRequest(url) { cocktail in
                action(cocktail)
            }
        }
    }
    
    private func fullInfoRequest(_ url: String, _ action: @escaping (Cocktail?) -> Void) {
        requestSession.request(url).responseJSON { (data) in
            guard let allDataDict = data.value as? [String : Any] else { return }
            if let cocktailsArray = allDataDict["drinks"] as? [[String:Any]] {
                for object in cocktailsArray {
                    if let cocktail = self.factory.createCoctail(from: object) {
                        action(cocktail)
                    }
                }
                
                return
            }
            
            action(nil)
        }
    }
    
    private func idRequest(_ url: String, _ action: @escaping (Cocktail?) -> Void) {
        requestSession.request(url).responseJSON { (data) in
            guard let allDataDict = data.value as? [String : Any] else { return }
            if let cocktailsArray = allDataDict["drinks"] as? [[String:Any]] {
                self.stopAllRequests {
                    for object in cocktailsArray {
                        if let id = object["idDrink"] as? String {
                            self.getCocktailByID(id) { cocktail in
                                action(cocktail)
                            }
                        }
                    }
                }
            }
        }
    }
    
    //MARK: -INGREDIENT SEARCH
    func byIngredientSearch(_ name: String, _ action: @escaping (Cocktail?) -> Void) {
        let url = "https://www.thecocktaildb.com/api/json/v2/9973533/filter.php?i=\(name.makeUrlable())"
        idRequest(url) { cocktail in
            action(cocktail)
        }
    }
    
    //MARK: -INGREDIENTS LIST
    func getAllIngredientsList(_ action: @escaping (Ingredient) -> Void) {
        requestSession.request("https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list").responseJSON { (response) in
            if let dataDict = response.value as? [String:Any] {
                if let ingrDict = dataDict["drinks"] as? [[String:Any]] {
                    for ingrElem in ingrDict {
                        if let name = ingrElem["strIngredient1"] as? String {
                            let ingredient = Ingredient(name: name)
                            action(ingredient)
                        }
                    }
                    NotificationCenter.default.post(name: NSNotification.Name("updateAuthCV"), object: nil)
                }
            }
        }
    }
    
    func getIngredientCategory(_ action: @escaping (CategoryIngredient) -> Void) {
        self.getAllIngredientsList { ingredient in
            self.getCountToIngredient(ingredient) { category in
                action(category)
            }
        }
    }
    
    private func getCountToIngredient(_ ingredient: Ingredient, _ action: @escaping (CategoryIngredient) -> Void) {
        requestSession.request("https://www.thecocktaildb.com/api/json/v2/9973533/filter.php?i=\(ingredient.name)").responseJSON { (response) in
            if let allData = response.value as? [String:Any] {
                if let cocktails = allData["drinks"] as? [[String:Any]] {
                    let model = CategoryIngredient(name: ingredient.name, count: cocktails.count)
                    action(model)
                }
            }
        }
    }
    
    
    //MARK: -NAME SEARCH
    func search(_ text: String, _ action: @escaping (Cocktail) -> Void) {
        requestSession.request("https://www.thecocktaildb.com/api/json/v1/1/search.php?s=\(text)").responseJSON { (response) in
            guard let data = response.value as? [String:Any] else { return }
            if let allDrinks = data["drinks"] as? [[String:Any]] {
                for object in allDrinks {
                    if let cocktail = self.factory.createCoctail(from: object) {
                        action(cocktail)
                    }
                }
            }
        }
    }
}
