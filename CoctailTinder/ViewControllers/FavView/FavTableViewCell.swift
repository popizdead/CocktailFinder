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
    
    @IBOutlet weak var ingrTableView: UITableView!
    var cellCoctail : Coctail!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func updateUI() {
        self.nameLbl.text = cellCoctail.name
        
        if let cocImg = cellCoctail.image {
            img.image = cocImg
        }
        
        ingrTableView.delegate = self
        ingrTableView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCoctail.ingrArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ingrTableView.dequeueReusableCell(withIdentifier: "ingrCell", for: indexPath) as! IngrTableViewCell
        let ingr = cellCoctail.ingrArray[indexPath.row]
        
        cell.nameLbl.text = "\(ingr.name) \(ingr.measure)"
        
        return cell
    }
    
}
