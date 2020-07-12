//
//  ViewController.swift
//  MemeApp
//
//  Created by Nawaf B Al sharqi on 14/11/1441 AH.
//  Copyright © 1441 Nawaf B Al sharqi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var pickedImageView: UIImageView!
    @IBOutlet weak var takePhotoButton: UIBarButtonItem!
    @IBOutlet weak var topField: UITextField!
    @IBOutlet weak var bottomField : UITextField!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    let pickerController = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setting the delegates
        pickerController.delegate = self
        
        // if the cam is not available we disable the button
        takePhotoButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        //setting up the textFields
        setupTextField( textField: topField, text: "TOP" )
        setupTextField( textField: bottomField, text: "BOTTOM" )
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    func setupTextField(textField: UITextField, text: String) {
        textField.defaultTextAttributes = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth:  -4.0]
        textField.textColor = UIColor.white
        textField.tintColor = UIColor.white
        textField.textAlignment = .center
        textField.text = text
        textField.delegate = self
    }
    
    
    @IBAction func addPhotoPressed(_ sender: Any) {
        //to tell it is from the album
        pickerController.sourceType = .photoLibrary
        self.present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func chooseFromCamPressed(_ sender: Any) {
        //to tell it is from the camera not from the album
        pickerController.sourceType = .camera
        self.present(pickerController, animated: true, completion: nil)
    }
    
    func chooseImageFromCameraOrPhoto(source: UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.sourceType = source
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func onClickShareButton(_ sender: Any) {
        if pickedImageView.image == nil {
            _ = UIAlertAction(title: "no image was chosen", style: .default) { (UIAlertAction) in
                return
            }
            return
        }
        
        let memedImage = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        activityController.completionWithItemsHandler = { activity, completed, items, error in
            if completed {
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        present(activityController, animated: true, completion: nil)}
    
    
    //MARK:- KeyBoard functions
    @objc func keyboardWillShow(notification:Notification) {
        
        var height : CGFloat!
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            height = keyboardHeight
        }
        
        if bottomField.isFirstResponder {
            view.frame.origin.y -= height
        }
    }
    @objc func keyboardWillHide(notification:Notification) {
        if bottomField.isFirstResponder {
            view.frame.origin.y = 0
        }
    }
    
}
//MARK:- UINavigationControllerDelegate && UIImagePickerControllerDelegate
extension ViewController :UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        pickedImageView.image = selectedImage
        pickedImageView.contentMode = .scaleAspectFit
        dismiss(animated: true, completion: nil)
    }
}


//MARK:- UITextFieldDelegate
extension ViewController : UITextFieldDelegate{
    //when the user finish editing we remove the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //when press return quit the keyboard and end editing
        textField.endEditing(true)
        return true
    }
    //when the user can return if the field is empty then we cannot make it empty
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text == "" {
            return false
            
        }else{
            
            return true
        }
    }
    
    //if the user starts editing we clear the text that inside the text field
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }}


//MARK:- Extension for further functionalities
extension ViewController {
    
    func save() {
        var memedImage = generateMemedImage()
        var meme = Meme(bottomString: bottomField.text!, topString: topField.text!, originalImage: pickedImageView.image!, memedImage: memedImage)
    }
    
    
    func hideTopAndBottomBars(_ hide: Bool) {
        toolbar.isHidden = hide
        navigationBar.isHidden = hide
    }
    func generateMemedImage() -> UIImage {
        
        // TODO: Hide toolbar and navbar
        hideTopAndBottomBars(true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        
        return memedImage
    }
    
    
}


