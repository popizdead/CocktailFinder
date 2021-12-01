//
//  BarCollectionViewCell.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 13/03/2021.
//

import UIKit

class BarCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var ingrImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    private let dataService = DataService.shared
    weak var delegate: BarProtocol?
    
    func setupUI() {
        self.makeShadowAndRadius(shadow: true, opacity: 0.5, radius: 10)
        self.contentView.layer.cornerRadius = 10
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        dataService.userBuyList = dataService.userBuyList.filter({$0.name != self.nameLbl.text})
        dataService.deleteBuyListItem(name: self.nameLbl.text!)
        
        delegate?.update()
    }
    
}
