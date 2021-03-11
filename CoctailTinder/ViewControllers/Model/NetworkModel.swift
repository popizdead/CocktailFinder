//
//  NetworkModel.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 05/03/2021.
//

import Foundation
import Alamofire

extension SwipeViewController {
    func randomCoctailRequest() {
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
    
    func downloadImg() {
        AF.request(currentCoctail.imageURL).response { (data) in
            if let dataImg = data.data {
                let coctailImage = UIImage(data: dataImg)
                self.image.image = coctailImage
                currentCoctail.image = coctailImage
                //self.image.animateHidding(hidding: false)
            }
        }
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
    
    func getIngrImages() {
        for ingr in currentCoctail.ingrArray {
            AF.request("https://www.thecocktaildb.com/images/ingredients/\(ingr.name.makeUrlable()).png").responseData { (response) in
                if let data = response.data {
                    if let img = UIImage(data: data) {
                        ingr.ingrImage = img
                        self.ingredientCollectionView.reloadData()
                    }
                }
            }
            
        }
    }

}

