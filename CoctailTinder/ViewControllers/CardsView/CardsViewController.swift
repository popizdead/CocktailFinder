//
//  CardsViewController.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 09/03/2021.
//

import UIKit
import Gemini

class CardsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cardsCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CardCollectionViewCell
        cell.text.text = favArray[indexPath.row].name
        cardsCollectionView.animateCell(cell)
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.cardsCollectionView.animateVisibleCells()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? CardCollectionViewCell {
            cardsCollectionView.animateCell(cell)
        }
    }
    
    @IBOutlet weak var cardsCollectionView: GeminiCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setDelegates()
        cardsCollectionView.gemini
            .rollRotationAnimation()
            .degree(45)
            .rollEffect(.rollUp)
    }
    
    var direction: UICollectionView.ScrollDirection = .horizontal
    
    func setDelegates() {
        cardsCollectionView.delegate = self
        cardsCollectionView.dataSource = self
        cardsCollectionView.isPagingEnabled = true
        if let layout = cardsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = direction
            cardsCollectionView.collectionViewLayout = layout
        }
    }
}
