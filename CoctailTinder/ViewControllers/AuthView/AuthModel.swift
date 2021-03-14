//
//  AuthModel.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 10/03/2021.
//

import Foundation
import UIKit
import Alamofire
import CoreData

var ingrNameArray : [String] = []
var imgDict : [String:UIImage] = [:]

var ingrBarArray : [Ingredient] = []

enum ingrCalledFrom {
    case auth
    case bar
}

var ingrCalled = ingrCalledFrom.auth

extension AuthViewController {
    func getAllIngredientsList() {
        AF.request("https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list").responseJSON { (response) in
            if let dataDict = response.value as? [String:Any] {
                if let ingrDict = dataDict["drinks"] as? [[String:Any]] {
                    for ingrElem in ingrDict {
                        if let name = ingrElem["strIngredient1"] as? String {
                            ingrNameArray.append(name)
                            //self.getIngredientImage(toName: name)
                        }
                    }
                    self.ingredientsCV.reloadData()
                }
            }
        }
    }
    
    func getIngredientImage(toName: String) {
        AF.request("https://www.thecocktaildb.com/images/ingredients/\(toName.makeUrlable()).png").responseData { (response) in
            if let data = response.data {
                if let img = UIImage(data: data) {
                    imgDict[toName] = img
                    self.ingredientsCV.reloadData()
                }
            }
        }
    }
}

func saveIngredients() {
    for ingr in ingrBarArray {
        ingredientCoreData(ingr: ingr)
    }
}

func ingredientCoreData(ingr: Ingredient) {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    
    guard let entity = NSEntityDescription.entity(forEntityName: "IngredientBar", in: context) else { return }
    let ingrObject = IngredientBar(entity: entity, insertInto: context)
    
    ingrObject.name = ingr.name
    if let data = ingr.ingrImage?.pngData() {
        ingrObject.ingrImage = data
    }
    
    do { try context.save() }
    catch {}
}


