//
//  CoreDataService.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 24/11/2021.
//

import Foundation
import CoreData
import UIKit

extension DataService {
    func getSavedData() {
        getSavedCocktails()
        getSavedBuyList()
    }

//    func saveCurrentCocktail() {
//        if !dataService.isFavorite(currentCoctail) {
//            saveCocktailCoreData(object: currentCoctail)
//            dataService.favArray.insert(currentCoctail, at: 0)
//        }
//
////        if !favArray.contains(where: {$0.name == currentCoctail.name}) {
////            var newCocktail = Cocktail(name: currentCoctail.name, category: currentCoctail.category, id: currentCoctail.id, imgUrl: currentCoctail.imageURL, glass: currentCoctail.glass, ingrArray: currentCoctail.ingrArray, instr: currentCoctail.instruction)
////            newCocktail.image = currentCoctail.image
////            newCocktail = currentCoctail
////            saveCocktailCoreData(object: newCocktail)
////            favArray.insert(newCocktail, at: 0)
////        }
//    }

    //MARK: -COCKTAIL
    func getSavedCocktails() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        network.currentRequestFrom = .favorite
        
        let fetchRequest : NSFetchRequest<CocktailFav> = CocktailFav.fetchRequest()

        do {
            let cocktailsArray = try context.fetch(fetchRequest)
            for cocktailObject in cocktailsArray {
                if let id = cocktailObject.id {
                    network.getCocktailByID(id) { cocktail in
                        if let cocktail = cocktail {
                            cocktail.getImages {
                                NotificationCenter.default.post(name: NSNotification.Name("updateFavCV"), object: nil)
                            }
                            
                            self.favArray.append(cocktail)
                        }
                    }
                }
            }
        } catch {
            print("failed to get saved")
        }
    }

    func deleteSavedCocktail(name: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest : NSFetchRequest<CocktailFav> = CocktailFav.fetchRequest()
        
        if let cocktailsArray = try? context.fetch(fetchRequest) {
            for object in cocktailsArray {
                if object.name == name {
                    context.delete(object)
                }
            }
        }
        
        do { try context.save() }
        catch {}
    }

    func saveCocktailCoreData(object: Cocktail) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "CocktailFav", in: context) else { return }
        let cocktailObject = CocktailFav(entity: entity, insertInto: context)
        
        cocktailObject.name = object.name
        cocktailObject.id = object.id
        
        do { try context.save() }
        catch {print("failed save")}
    }

    //MARK: -BUY LIST
    func saveBuyListItem(ingr: Ingredient) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "IngredientBuy", in: context) else { return }
        let ingrObject = IngredientBuy(entity: entity, insertInto: context)
        
        ingrObject.name = ingr.name
        if let data = ingr.ingrImage?.pngData() {
            ingrObject.img = data
        }
        
        do { try context.save() }
        catch {}
    }

    func deleteBuyListItem(name: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest : NSFetchRequest<IngredientBuy> = IngredientBuy.fetchRequest()
        
        if let ingredientArray = try? context.fetch(fetchRequest) {
            for object in ingredientArray {
                if object.name == name {
                    context.delete(object)
                }
            }
        }
        
        do { try context.save() }
        catch {}
    }

    func getSavedBuyList() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let fetchRequest : NSFetchRequest<IngredientBuy> = IngredientBuy.fetchRequest()

        do {
            let ingredientArray = try context.fetch(fetchRequest)
            for object in ingredientArray {
                if let name = object.name {
                    let ingr = Ingredient(name: name)
                    if let imgData = object.img {
                        ingr.ingrImage = UIImage(data: imgData)!
                    }
                    self.userBuyList.append(ingr)
                }
            }
        } catch {}
    }
}
