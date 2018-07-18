//
//  manageStudentViewController.swift
//  Master
//
//  Created by 黎峻亦 on 2018/7/16.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit

class manageStudentViewController: UIViewController {

    @IBOutlet weak var manageStudentTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        manageStudentTableView.setCellAutoRowHeight()
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension manageStudentViewController : UITableViewDelegate ,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? manageStudentTableViewCell
        cell?.studentImageView.setRoundImage()
        return cell!
    }
}
