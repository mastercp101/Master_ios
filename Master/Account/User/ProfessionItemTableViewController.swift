//
//  ProfessionItemTableViewController.swift
//  Master
//
//  Created by Diego on 2018/7/25.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit

class ProfessionItemTableViewController: UITableViewController {

    var category: String?
    private var professionItem = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let category = category {
            getAllProfessionItem(category: category)
        }
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
        return professionItem.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PfsItemCell", for: indexPath)

        cell.textLabel?.text = professionItem[indexPath.row]
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let controller = segue.destination as? UserProfessionTableViewController
        if let row = tableView.indexPathForSelectedRow?.row {
            controller?.selectNewProfessionItem = professionItem[row]
        }
        
    }
 
    
    private func getAllProfessionItem(category: String) {
        
        let request: [String: Any] = ["action": "getAllProfessionItem", "category": category]
        
        Task.postRequestData(urlString: urlString + urlUserInfo, request: request) { (error, data) in
            
            guard error == nil, let data = data else { return }
            
            let results =  try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            
            guard let result = results , let profession = result as? [String] else { return }
            
            if profession.count > 0 {
                self.professionItem = profession
            } else {
                self.professionItem.append("No Data")
            }
            self.tableView.reloadData()
        }
    }

}
