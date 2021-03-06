//
//  FavViewController.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 05/03/2021.
//

import UIKit

class FavViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var favTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        favTableView.delegate = self
        favTableView.dataSource = self
        self.favTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.favTableView.allowsSelection = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favTableView.dequeueReusableCell(withIdentifier: "favCell", for: indexPath) as! FavTableViewCell
        cell.cellCoctail = favArray[indexPath.row]
        cell.updateUI()
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        favArray.remove(at: indexPath.row)
        if favArray.count > 0 {
            favTableView.deleteRows(at: [indexPath], with: .fade)
        } else {
            favTableView.reloadData()
        }
    }
}
