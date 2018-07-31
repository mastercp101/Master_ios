//
//  MasterTableViewController.swift
//  Master
//
//  Created by Che-wei LIU on 2018/7/24.
//  Copyright © 2018 黎峻亦. All rights reserved.
//

import UIKit

class MasterTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    

    @IBOutlet weak var pickerTextField: UITextField!
    
    private let courseArticleServlet = "/CourseArticleServlet"
    private let courseCell = "courseCell"

    var pickerArray = [String]()
    var courseList = [Course]()
    var professionCategory: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setting pickerView.
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerTextField.inputView = pickerView
        pickerTextField.placeholder = professionCategory
        
        // Tap to hidePickerView.
        let tap = UITapGestureRecognizer(target: self, action: #selector(hidePickerView))
        self.view.addGestureRecognizer(tap)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return courseList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: courseCell, for: indexPath)
        cell.textLabel?.text = courseList[indexPath.row].courseName
        // Configure the cell...

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: PickerView Delegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerTextField.text = pickerArray[row]
        downloadCourse(professionItem: pickerArray[row])
    }
    
    @objc
    func hidePickerView() {
        self.view.endEditing(true)
    }
    
    func downloadCourse(professionItem: String) {
        
        let requestGetCourse = ["courseArticle":"getCourseByProfessionItem","professionItem":professionItem]
        Task.postRequestData(urlString: urlString + courseArticleServlet, request: requestGetCourse) { (error, data) in
            
            if let error = error {
                assertionFailure("Fail to get Course from servlet: \(error)." )
                return
            }
            
            guard let data = data, let courseList = try? decoder.decode([Course].self, from: data) else {
                print("Data is nil.")
                return
            }
            self.courseList = courseList
            self.tableView.reloadData()
        }
    }

}

