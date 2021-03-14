//
//  SwipeModel.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 05/03/2021.
//

import Foundation
import UIKit
import CoreData

var currentCoctail = Coctail(name: "", category: "", id: "", imgUrl: "", glass: "", ingrArray: [], instr: "")
var favArray : [Coctail] = []

func cocktailCoreData(object: Coctail) {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    
    guard let entity = NSEntityDescription.entity(forEntityName: "CocktailFav", in: context) else { return }
    let cocktailObject = CocktailFav(entity: entity, insertInto: context)
    
    cocktailObject.name = object.name
    cocktailObject.id = object.id
    
    do { try context.save() }
    catch {}
}

