//
//  SearchModel.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 18/03/2021.
//

import Foundation
import SwiftEntryKit

extension SearchViewController {
    func search(_ text: String) {
        resultSearchArray.removeAll()
        network.stopAllRequests {
            self.network.search(text) { cocktail in
                
                self.resultSearchArray.append(cocktail)
                
                cocktail.getImages {
                    self.CVUpdate()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedCocktail = selectedCocktail else { return }
        if segue.identifier == "searchToReview" {
            if let vc = segue.destination as? CocktailViewController {
                vc.reviewCocktail = selectedCocktail
            }
        }
    }
}
