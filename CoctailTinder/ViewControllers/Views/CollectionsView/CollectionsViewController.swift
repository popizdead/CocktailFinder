//
//  CollectionsViewController.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 17/03/2021.
//

import UIKit
import Alamofire

class CollectionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    //MARK:OUTLETS
    @IBOutlet weak var new: UIButton!
    @IBOutlet weak var pop: UIButton!
    @IBOutlet weak var nonAlc: UIButton!
    @IBOutlet weak var cocktails: UIButton!
    @IBOutlet weak var shake: UIButton!
    @IBOutlet weak var coffee: UIButton!
    @IBOutlet weak var shot: UIButton!
    @IBOutlet weak var punch: UIButton!
    @IBOutlet weak var beer: UIButton!
    @IBOutlet weak var cocoa: UIButton!
    @IBOutlet weak var soda: UIButton!
    @IBOutlet weak var others: UIButton!
    @IBOutlet weak var ordinary: UIButton!
    @IBOutlet weak var homemade: UIButton!
    
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var leftBgView: UIView!
    @IBOutlet weak var rightBgView: UIView!
    
    @IBOutlet weak var ingrTableView: UITableView!
    
    @IBOutlet weak var tableBg: UIView!
    @IBOutlet weak var buttonsBg: UIStackView!
    
    @IBOutlet weak var catButtons: UIButton!
    @IBOutlet weak var ingrButton: UIButton!
    
    let network = NetworkService.shared
    let dataService = DataService.shared
    let factory = Factory.shared
    
    //MARK: -VIEW LOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    //MARK:UI
    func setupUI(){
        delegates()
        
        changeState()
        getListOfIngredients()
        
        let buttonsArray = [new, pop, nonAlc, cocktails, shake, coffee, shot, punch, soda, beer, others, homemade, ordinary, cocoa]
        for button in buttonsArray {
            button?.makeShadowAndRadius(shadow: false, opacity: 0.5, radius: 10)
        }
        
        leftBgView.backgroundColor = .white
        rightBgView.backgroundColor = .white
        navView.backgroundColor = .white
        
        navView.makeShadowAndRadius(shadow: true, opacity: 0.5, radius: 10)
        tableBg.makeShadowAndRadius(shadow: true, opacity: 0.5, radius: 10)
    }
    
    func delegates() {
        hiddingSetup()
        
        ingrTableView.delegate = self
        ingrTableView.dataSource = self
        ingrTableView.separatorStyle = .none
        
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: NSNotification.Name("collectionSourceReady"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sortArray), name: NSNotification.Name("collectionSourcePreparing"), object: nil)
    }
    
    func hiddingSetup() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    //MARK:OBSERVERS
    @objc func update() {
        ingrTableView.reloadData()
    }
    
    
    @objc func sortArray() {
        tableSource.sort(by: {$0.count > $1.count })
        updateCollectionShowingArray()
    }
    
    
    //MARK:BUTTONS
    @IBAction func collectionButtonTapped(_ sender: UIButton) {
        switch sender {
        case new:
            showingRequest = .new
            collectionRequest(type: .new)
            screenName = "New drinks"
        case pop:
            showingRequest = .pop
            collectionRequest(type: .pop)
            screenName = "Popular drinks"
        case nonAlc:
            showingRequest = .nonAlc
            collectionRequest(type: .nonAlc)
            screenName = "Non-Alcoholic drinks"
        case cocktails:
            showingRequest = .cocktails
            collectionRequest(type: .cocktails)
            screenName = "Cocktails"
        case shake:
            showingRequest = .shake
            collectionRequest(type: .shake)
            screenName = "Milk/Shake drinks"
        case coffee:
            showingRequest = .coffee
            collectionRequest(type: .coffee)
            screenName = "Coffee/Tea drinks"
        case shot:
            showingRequest = .shot
            collectionRequest(type: .shot)
            screenName = "Shot drinks"
        case punch:
            showingRequest = .punch
            collectionRequest(type: .punch)
            screenName = "Punch drinks"
        case beer:
            showingRequest = .beer
            collectionRequest(type: .beer)
            screenName = "Beer drinks"
        case soda:
            showingRequest = .soda
            collectionRequest(type: .soda)
            screenName = "Soft drink/Soda"
        case others:
            showingRequest = .others
            collectionRequest(type: .others)
            screenName = "Others"
        case homemade:
            showingRequest = .homemade
            collectionRequest(type: .homemade)
            screenName = "Homemade drinks"
        case ordinary:
            showingRequest = .ordinary
            collectionRequest(type: .ordinary)
            screenName = "Ordinary drinks"
        case cocoa:
            showingRequest = .cocoa
            collectionRequest(type: .cocoa)
            screenName = "Cocoa"
        default:
            print("default")
        }
        
        self.performSegue(withIdentifier: "toItemsList", sender: self)
    }
    
    //State buttons
    @IBAction func navButtonTapped(_ sender: UIButton) {
        if sender == catButtons {
            colCurrentState = .categories
        }
        else if sender == ingrButton {
            colCurrentState = .ingr
        }
        changeState()
    }
    
    //MARK:FIELD
    @IBAction func searchStart(_ sender: UITextField) {
        searchColCurrentState = .search
        updateCollectionShowingArray()
    }
    
    @IBAction func searchChanged(_ sender: UITextField) {
        if let text = sender.text {
            searchIngr(name: text)
        }
    }
    
    @IBAction func searchEnd(_ sender: UITextField) {
        if sender.text == "" {
            searchColCurrentState = .all
            updateCollectionShowingArray()
        }
    }
    
  
    //MARK:TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingrShowingArray.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ingrTableView.dequeueReusableCell(withIdentifier: "ingrCell", for: indexPath) as! IngrTableViewCell
        let ingr = ingrShowingArray[indexPath.row]
        
        cell.ingrCell = ingr
        cell.setupUI()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ingr = ingrShowingArray[indexPath.row]
        
        showingRequest = .nonAlc
        screenName = ingr.name
        
        network.byIngredientSearch(ingr.name) { cocktail in
            self.apply(cocktail)
        }
        
        self.performSegue(withIdentifier: "toItemsList", sender: self)
    }
    
    private func apply(_ cocktail: Cocktail?) {
        guard let cocktail = cocktail else { return }
        cocktail.getImages {
            NotificationCenter.default.post(name: NSNotification.Name("updateItemsCV"), object: nil)
        }
        
        dataService.collectionCocktailSource.append(cocktail)
        NotificationCenter.default.post(name: NSNotification.Name("updateItemsCV"), object: nil)
    }
    
    
}
