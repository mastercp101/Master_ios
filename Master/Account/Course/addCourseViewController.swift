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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Common.shared.addObserves(scrollView: scrollView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Common.shared.removeObservers(viewController: self)
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
//        var courseName : String?
//        var courseCategory : Int?
//        var courseDetail : String?
//        var courseDate : Date?
//        var coursePrice : Int?
//        var courseLocation : String?
//        var courseNeed : String?
//        var courseNumberOfPeople : Int?
//        var courseQualification : String?
//        var courseRegisterDeadline : Date?
//        var courseNote : String?
        courseName = courseTextField[0].text!
        courseCategory  = Int(courseTextField[1].text!)
        courseDetail = courseTextField[2].text!
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
            Alert.shared.buildSingleAlert(viewConteoller: self, alertTitle: "\(textFieldTitle(textField: textField))不能為空白") { (_) in
                return
            }
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

