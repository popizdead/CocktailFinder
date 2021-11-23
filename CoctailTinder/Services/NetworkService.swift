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
    
    var currentRequestFrom : DataRequestedFrom = .favorite
    
    //MARK: -SESSION MANAGER
    func stopAllRequests(_ compilation: @escaping () -> Void) {
        AF.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            dataTasks.forEach { $0.cancel() }
            uploadTasks.forEach { $0.cancel() }
            downloadTasks.forEach { $0.cancel() }
            
            compilation()
        }
    }
    
    //MARK: -COCKTAILS REQUESTS
    func randomCoctailRequest() {
        AF.request("https://www.thecocktaildb.com/api/json/v2/9973533/random.php").responseJSON { (data) in
            guard let dataDict = data.value as? [String : Any] else { return }
            if let arrayData = dataDict["drinks"] as? [[String:Any]] {
                if let cocktailData = arrayData.first {
                    if let coctail = createCoctail(from: cocktailData) {
                        currentCoctail = coctail
                        currentCoctail.getIngredientImage()
                        currentCoctail.getCocktailImage()
                        NotificationCenter.default.post(name: NSNotification.Name("openCard"), object: nil)
                    } else {
                        self.stopAllRequests {
                            self.randomCoctailRequest()
                        }
                    }
                }
            }
        }
    }
    
    func getCocktailByID(_ id: String) {
        AF.request("https://www.thecocktaildb.com/api/json/v2/9973533/lookup.php?i=\(id)").responseJSON { (data) in
            guard let dataDict = data.value as? [String : Any] else { return }
            if let arrayData = dataDict["drinks"] as? [[String:Any]] {
                if let cocktailData = arrayData.first {
                    if let cocktail = createCoctail(from: cocktailData) {
                        if self.currentRequestFrom == .collection {
                            cocktail.getIngredientImage()
                            cocktail.getCocktailImage()
                            sourceItemsArray.append(cocktail)
                            NotificationCenter.default.post(name: NSNotification.Name("updateItemsCV"), object: nil)
                        }
                    }
                }
            }
        }
    }
}

enum DataRequestedFrom {
    case swipe
    case favorite
    
    case collection
    case search
    
    case review
}
