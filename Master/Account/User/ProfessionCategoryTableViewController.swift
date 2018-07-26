//
//  ProfessionCategoryTableViewController.swift
//  Master
//
//  Created by Diego on 2018/7/25.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit

private let pfsCategoryCell = "PfsCategoryCell"

private let categoryIcon = ["pfs_swim","pfs_skate","pfs_workout","pfs_ball",
                            "pfs_music","pfs_language","pfs_paint","pfs_code"]

class ProfessionCategoryTableViewController: UITableViewController {

    var professionCategory = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllProfessionCategory()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return professionCategory.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: pfsCategoryCell, for: indexPath) as? ProfessionTableViewCell else {
            return UITableViewCell()
        }
        cell.categoryImage.image = UIImage(named: categoryIcon[indexPath.row])
        cell.categoryLabel.text = professionCategory[indexPath.row]
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let controller = segue.destination as? ProfessionItemTableViewController
        if let row = tableView.indexPathForSelectedRow?.row {
            controller?.category = professionCategory[row]
        }
    }
    
    private func getAllProfessionCategory() {
        
        let request: [String: Any] = ["action": "getAllProfessionCategory"]
        
        Task.postRequestData(urlString: urlString + urlUserInfo, request: request) { (error, data) in
            
            guard error == nil, let data = data else { return }
            
            let results =  try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            
            guard let result = results , let profession = result as? [String] else { return }
            
            if profession.count > 0 {
                self.professionCategory = profession
            } else {
                self.professionCategory.append("No Data")
            }
            self.tableView.reloadData()
        }
    }
    

}
