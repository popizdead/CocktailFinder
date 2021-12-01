//
//  BarModel.swift
//  CoctailFinder
//
//  Created by Даниил Дорожкин on 01/12/2021.
//

import Foundation
import UIKit

protocol BarProtocol: AnyObject {
    func UIUpdate()
}

extension BarViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "barToIngr" {
            if let vc = segue.destination as? BuyListViewController {
                vc.delegate = self
            }
        }
    }
}
