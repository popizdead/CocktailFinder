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

enum presentView {
    case filter
    case buyList
}

var attributesView = presentView.buyList

