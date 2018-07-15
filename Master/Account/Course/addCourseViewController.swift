//
//  addCourseViewController.swift
//  Master
//
//  Created by 黎峻亦 on 2018/7/15.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit

class addCourseViewController: UIViewController {

    @IBOutlet weak var noteTextViewOulet: UITextView!
    @IBOutlet weak var detailTextViewOulet: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextView(textView: detailTextViewOulet)
        setTextView(textView: noteTextViewOulet)
    }
    @IBAction func BackBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
extension addCourseViewController{
    private func setTextView(textView : UITextView){
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 5
        textView.backgroundColor = UIColor.white
    }
}

