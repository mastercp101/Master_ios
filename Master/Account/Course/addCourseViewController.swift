//
//  addCourseViewController.swift
//  Master
//
//  Created by 黎峻亦 on 2018/7/15.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit

class addCourseViewController: UIViewController {

    @IBOutlet weak var addImageView: UIImageView!
    @IBOutlet weak var noteTextViewOulet: UITextView!
    @IBOutlet weak var detailTextViewOulet: UITextView!
    
    let picker = UIImagePickerController()
    let cropper = UIImageCropper(cropRatio: 16/9)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextView(textView: detailTextViewOulet)
        setTextView(textView: noteTextViewOulet)
        addImageView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.addImageTapped))
        addImageView.addGestureRecognizer(gesture)
        cropper.delegate = self
    }
    @IBAction func BackBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func addImageTapped(){
        cropper.picker = picker
        cropper.cropButtonText = "Crop"
        cropper.cancelButtonText = "Retake"
        Common.shared.buildPhotoAlert(viewController: self ,takePic: { (_) in
            self.picker.sourceType = .camera
            self.present(self.picker, animated: true, completion: nil)
        }) { (_) in
            self.picker.sourceType = .photoLibrary
            self.present(self.picker, animated: true, completion: nil)
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
    }
}

