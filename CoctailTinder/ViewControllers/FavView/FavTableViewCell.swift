//
//  FavTableViewCell.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 05/03/2021.
//

import UIKit 

class FavTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var instructionText: UITextView!
    
    @IBOutlet weak var ingrTableView: UITableView!
    var cellCoctail : Coctail!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func updateUI() {
        self.makeShadowAndRadius(shadow: true, opacity: 0.5, radius: 10)
        self.nameLbl.text = cellCoctail.name
        self.instructionText.text = cellCoctail.instruction
        self.img.makeShadowAndRadius(shadow: false, opacity: 0.5, radius: 10)
        self.instructionText.makeShadowAndRadius(shadow: false, opacity: 0.5, radius: 10)
        
        if let cocImg = cellCoctail.image {
            img.image = cocImg
        }
        
        ingrTableView.delegate = self
        ingrTableView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    //MARK:TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCoctail.ingrArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ingrTableView.dequeueReusableCell(withIdentifier: "ingrCell", for: indexPath) as! IngrTableViewCell
        let ingr = cellCoctail.ingrArray[indexPath.row]
        
        //Sometimes there's empty ingredient in array, because of API
        if ingr.name != "" {
            cell.nameLbl.text = "\(ingr.name) \(ingr.measure)"
        }
        
        
        return cell
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ingrTableView.deselectRow(at: indexPath, animated: true)
    }
}
