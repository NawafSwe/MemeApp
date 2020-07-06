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
    
    
    let pickerController = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerController.delegate = self
        // if the cam is not available we disable the button 
        chooseFromCamButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
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


