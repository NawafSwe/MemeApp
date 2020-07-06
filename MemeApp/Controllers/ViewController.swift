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
    @IBOutlet weak var chooseFromCamButton: UIBarButtonItem!
    @IBOutlet weak var topField: UITextField!
    @IBOutlet weak var bottomField : UITextField!
    let pickerController = UIImagePickerController()
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.black,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth:  2.5
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        //setting the delegates
        
        pickerController.delegate = self
        topField.delegate = self
        bottomField.delegate  = self
        // if the cam is not available we disable the button
        chooseFromCamButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        topField.defaultTextAttributes = memeTextAttributes
        bottomField.defaultTextAttributes = memeTextAttributes
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
    
}

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


