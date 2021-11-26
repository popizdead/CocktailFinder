//
//  SearchModel.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 18/03/2021.
//

import Foundation
import Alamofire

extension SearchViewController {
    func search(_ text: String) {
        network.currentRequestFrom = .search
        resultSearchArray.removeAll()
        
        network.search(text) { cocktail in
            self.resultSearchArray.append(cocktail)
            
            cocktail.getImages {
                self.CVUpdate()
            }
        }
        
        AF.request("https://www.thecocktaildb.com/api/json/v1/1/search.php?s=\(text)").responseJSON { (response) in
            guard let data = response.value as? [String:Any] else { return }
            if let allDrinks = data["drinks"] as? [[String:Any]] {
                for object in allDrinks {
                    if let cocktail = Factory.shared.createCoctail(from: object) {
                        cocktail.getImages {
                            NotificationCenter.default.post(name: NSNotification.Name("updateSearchResult"), object: nil)
                        }
                        self.resultSearchArray.append(cocktail)
                    }
                    
                }
                
            }
        }
    }
}




