//
//  FavModel.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 14/03/2021.
//

import Foundation
import UIKit
import CoreData
import Alamofire

func getSavedCocktails() {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    
    let fetchRequest : NSFetchRequest<CocktailFav> = CocktailFav.fetchRequest()
    
    do {
        let coreFavoriteStocks = try context.fetch(fetchRequest)
        for stockElement in coreFavoriteStocks {
            let cocktail = Stock(ticker: stockElement.ticker!, name: stockElement.name!)
            stock.getData()
            favoriteStocksArray.append(stock)
        }
    } catch {}
}

func getCocktailByID(id: String) -> Coctail {
    AF.request("https://www.thecocktaildb.com/api/json/v2/9973533/lookup.php?i=\(id)").responseJSON { (data) in
        guard let dataDict = data.value as? [String : Any] else { return }
        if let coctail = self.createCoctail(from: dataDict) {
            currentCoctail = coctail
        }
    }
}

func randomCoctailRequest() {
    self.hideView(hidding: true)
    AF.request("https://www.thecocktaildb.com/api/json/v1/1/random.php").responseJSON { (data) in
        guard let dataDict = data.value as? [String : Any] else { return }
        if let coctail = self.createCoctail(from: dataDict) {
            currentCoctail = coctail
        }
    }
}

func createCoctail(from dict: [String : Any]) -> Coctail? {
    if let arrayData = dict["drinks"] as? [[String:Any]] {
        if let coctailData = arrayData.first {
            if let name = coctailData["strDrink"] as? String {
                if let instrPrep = coctailData["strInstructions"] as? String {
                    let instr = instrPrep.capitalizingFirstLetter()
                    if let category = coctailData["strCategory"] as? String {
                        if let id = coctailData["idDrink"] as? String {
                            if let glass = coctailData["strGlass"] as? String {
                                if let imgUrl = coctailData["strDrinkThumb"] as? String {
                                    let ingredientArray = createIngredients(from: coctailData)
                                    let coctail = Coctail(name: name, category: category, id: id, imgUrl: imgUrl, glass: glass, ingrArray: ingredientArray, instr: instr)
                                    currentCoctail = coctail
                                    downloadImg()
                                    self.getIngrImages()
                                    self.updateUI()
                                    self.hideView(hidding: false)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    return nil
}

func createIngredients(from dict: [String:Any]) -> [Ingredient] {
    var ingrArray : [Ingredient] = []
    
    for index in Range(1...15) {
        if let name = dict["strIngredient\(index)"] as? String {
            if let measure = dict["strMeasure\(index)"] as? String {
                let ingr = Ingredient(name: name)
                //getIngredientImage(toName: ingr.name)
                ingrArray.append(ingr)
            }
        } else {
            break
        }
    }
    
    return ingrArray
}
