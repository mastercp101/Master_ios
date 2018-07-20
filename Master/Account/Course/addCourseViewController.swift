//
//  addCourseViewController.swift
//  Master
//
//  Created by 黎峻亦 on 2018/7/15.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit

class addCourseViewController: UIViewController{

    @IBOutlet weak var addImageView: UIImageView!
    @IBOutlet weak var containView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var detailTextView: UITextView!
    
    @IBOutlet var courseTextField: [UITextField]!
    
    var courseName : String?
    var courseCategory : Int?
    var courseDetail : String?
    var courseDate : Date?
    var coursePrice : Int?
    var courseLocation : String?
    var courseNeed : String?
    var courseNumberOfPeople : Int?
    var courseQualification : String?
    var courseRegisterDeadline : Date?
    var courseNote : String?
    
    var whichIsEditing : dateIsEditing?
    let datePickerView = UIDatePicker()
    
    
    let picker = UIImagePickerController()
    let cropper = UIImageCropper(cropRatio: 16/9)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextView(textView: detailTextView)
        setTextView(textView: noteTextView)
        
        addImageView.isUserInteractionEnabled = true
        let imageGesture = UITapGestureRecognizer(target: self, action: #selector(addImageTapped))
        addImageView.addGestureRecognizer(imageGesture)
        
        let viewGesture = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        containView.addGestureRecognizer(viewGesture)
        
        cropper.delegate = self
        setDatePicker()
    }
    
    private func setDatePicker(){
        datePickerView.datePickerMode = .date
        courseTextField[2].inputView = datePickerView
        courseTextField[8].inputView = datePickerView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Common.shared.addObserves(scrollView: scrollView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Common.shared.removeObservers(viewController: self)
    }
    
    
    @IBAction func courseDateEditing(_ sender: UITextField) {
        whichIsEditing = dateIsEditing.courseDate
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: .valueChanged)
    }
    
    @IBAction func courseRegistedEditing(_ sender: UITextField) {
        whichIsEditing = dateIsEditing.courseDeadline
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: .valueChanged)
    }
    
    
    @objc
    private func datePickerValueChanged(sender : UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if whichIsEditing == dateIsEditing.courseDate{
            courseTextField[2].text = dateFormatter.string(from: sender.date)
        }else{
            courseTextField[8].text = dateFormatter.string(from: sender.date)
        }
    }
    
    @objc
    private func closeKeyboard(){
        view.endEditing(true)
    }
    
    @objc
    private func addImageTapped(){
        cropper.picker = picker
        cropper.cropButtonText = "Crop"
        cropper.cancelButtonText = "Retake"
        Alert.shared.buildPhotoAlert(viewController: self ,takePic: { (camera) in
            self.picker.sourceType = .camera
            self.present(self.picker, animated: true, completion: nil)
        }) { (photoLibrary) in
            self.picker.sourceType = .photoLibrary
            self.present(self.picker, animated: true, completion: nil)
        }
    }
    
    @IBAction func sendBtnTapped(_ sender: Any) {
        if checkIsTextFieldEmpty() == true && checkIsTextViewEmpty() == true{
            handleTextFieldValue()
        }
    }
    
    private func handleTextFieldValue(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        courseName = courseTextField[0].text!
        courseCategory  = Int(courseTextField[1].text!)
        courseDetail = detailTextView.text!
        courseDate = dateFormatter.date(from: courseTextField[2].text!)!
        coursePrice = Int(courseTextField[3].text!)
        courseLocation = courseTextField[4].text!
        courseNeed = courseTextField[5].text!
        courseNumberOfPeople = Int(courseTextField[6].text!)
        courseQualification = courseTextField[7].text!
        courseRegisterDeadline = dateFormatter.date(from: courseTextField[8].text!)!
        courseNote = noteTextView.text!
    }
    
    private func checkIsTextViewEmpty() -> Bool{
        if detailTextView.text == ""{
            Alert.shared.buildSingleAlert(viewConteoller: self, alertTitle: "課程內容不能為空白"){_ in }
            return false
        }else if noteTextView.text == ""{
            Alert.shared.buildSingleAlert(viewConteoller: self, alertTitle: "課程提醒不能為空白"){_ in }
            return false
        }
        return true
    }
    
    private func checkIsTextFieldEmpty() -> Bool{
        for textField in courseTextField{
            guard textField.text == "" else{
                return true
            }
            Alert.shared.buildSingleAlert(viewConteoller: self, alertTitle: "\(textFieldTitle(textField: textField))不能為空白") { (_) in}
            return false
        }
        return true
    }
    
    private func textFieldTitle(textField : UITextField) -> String{
        switch textField.tag{
        case 0:
            return "課程名稱"
        case 1:
            return "課程類別"
        case 2:
            return "課程日期"
        case 3:
            return "課程價格"
        case 4:
            return "課程地點"
        case 5:
            return "課程要求"
        case 6:
            return "課程人數"
        case 7:
            return "報名資格"
        case 8:
            return "報名期限"
        default:
            return ""
        }
    }
}

enum dateIsEditing{
    case courseDate
    case courseDeadline
}

extension addCourseViewController : UIImageCropperProtocol{
    private func setTextView(textView : UITextView){
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 5
        textView.backgroundColor = UIColor.white
    }
    
    func didCropImage(originalImage: UIImage?, croppedImage: UIImage?) {
        addImageView.image = croppedImage
        addImageView.contentMode = .scaleToFill
        addImageView.clipsToBounds = true
    }
}

