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
    
    //MARK:VIEW LOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getIngredientsData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        AF.session.getAllTasks { (tasks) in
            tasks.forEach({$0.cancel()})
        }
    }
    
    func setupUI(){
        delegates()
        getIngredientsData()
        
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
        ingrTableView.delegate = self
        ingrTableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: NSNotification.Name("collectionSourceReady"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sortArray), name: NSNotification.Name("collectionSourcePreparing"), object: nil)
    }
    
    @objc func update() {
        ingrTableView.reloadData()
    }
    
    var sortCounter = 0
    
    @objc func sortArray() {
        tableSource.sort(by: {$0.count > $1.count })
        update()
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
        default:
            print("default")
        }
        self.performSegue(withIdentifier: "toItemsList", sender: self)
        
    }
  
    //MARK:TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableSource.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ingrTableView.dequeueReusableCell(withIdentifier: "ingrCell", for: indexPath) as! IngrTableViewCell
        let ingr = tableSource[indexPath.row]
        
        cell.ingrCell = ingr
        cell.setupUI()
        
        return cell
    }
    
    
}
