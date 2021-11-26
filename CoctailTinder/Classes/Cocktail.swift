//
//  Cocktail.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 10/03/2021.
//

import Foundation
import UIKit
import Alamofire

class Cocktail {
    let name : String
    let category : String
    
    let id : String
    var imageURL : String
    var image: UIImage?
    
    let glass : String
    var ingrArray : [Ingredient]
    let instruction : String
    
    private let dataService = DataService.shared
    
    init(name: String, category: String, id: String, imgUrl: String, glass: String, ingrArray: [Ingredient], instr: String) {
        self.name = name
        self.category = category
        
        self.id = id
        self.imageURL = imgUrl
        
        self.glass = glass
        self.ingrArray = ingrArray
        self.instruction = instr
    }
    
    //MARK: -CORE DATA
    func saveCore() {
        dataService.saveCocktailCoreData(object: self)
        dataService.favArray.insert(self, at: 0)
    }
    
    //MARK: -SOURCE
    enum CocktailAction {
        case appendFavorite
        case deleteFavorite
    }
    
    func action(_ action: CocktailAction) {
        switch action {
        case .appendFavorite:
            dataService.favArray.insert(self, at: 0)
        case .deleteFavorite:
            dataService.favArray.removeAll(where: {
                $0.id == self.id
            })
        }
    }
    
    //MARK: -IMAGES
    func getImages(_ action: @escaping () -> Void) {
        self.getCocktailImage {
            self.getIngredientImage {
                action()
            }
        }
    }
    
    private func getCocktailImage(_ action: @escaping () -> Void) {
        AF.request(self.imageURL).response { (data) in
            if let dataImg = data.data {
                let cocktailImage = UIImage(data: dataImg)
                self.image = cocktailImage
                //self.updateController()
            }
            
            action()
        }
    }
    
    func getIngredientImage(_ action: @escaping () -> Void) {
        for ingr in self.ingrArray {
            AF.request("https://www.thecocktaildb.com/images/ingredients/\(ingr.name.makeUrlable()).png").responseData { (response) in
                if let data = response.data {
                    if let img = UIImage(data: data) {
                        ingr.ingrImage = img
                        action()
                        //self.updateController()
                    }
                }
            }
        }
        
        
        action()
    }
    
//    func updateController() {
//        if requestedFrom == .swipe {
//            NotificationCenter.default.post(name: NSNotification.Name("updateCard"), object: nil)
//        }
//        else if requestedFrom == .favorite {
//            NotificationCenter.default.post(name: Notification.Name("updateFavCV"), object: nil)
//        }
//        else if requestedFrom == .collection {
//            NotificationCenter.default.post(name: NSNotification.Name("updateItemsCV"), object: nil)
//        }
//        else if requestedFrom == .search {
//            NotificationCenter.default.post(name: NSNotification.Name("updateSearchResult"), object: nil)
//        }
//        else if requestedFrom == .review {
//            NotificationCenter.default.post(name: NSNotification.Name("updateReviewScreen"), object: nil)
//        }
//    }
}

struct ShortCocktail {
    var name : String
    var id: String
}

var currentCoctail = Cocktail(name: "", category: "", id: "", imgUrl: "", glass: "", ingrArray: [], instr: "")

