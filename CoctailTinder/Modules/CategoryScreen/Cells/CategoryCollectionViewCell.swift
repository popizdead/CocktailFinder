//
//  CategoryCollectionViewCell.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 26/11/2021.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryNameLbl: UILabel!
    
    var category : CategoryType?
    
    func setup() {
        self.categoryNameLbl.text = category?.getTitle()
    }
    
}
