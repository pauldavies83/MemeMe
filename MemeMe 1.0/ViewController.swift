//
//  ViewController.swift
//  MemeMe 1.0
//
//  Created by Paul Davies on 11/03/2021.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,
                      UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var pickedImage: UIImageView!
    @IBOutlet weak var openCameraButton: UIBarButtonItem!
    @IBOutlet var topText: UITextField!
    @IBOutlet var bottomText: UITextField!

    let defaultTopText = "TOP"
    let defaultBottomText = "BOTTOM"
    
    let memeTextAttributes: [NSAttributedString.Key : Any]  = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -5.0
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        topText.defaultTextAttributes = memeTextAttributes
        topText.textAlignment = .center
        topText.text = defaultTopText
        topText.delegate = self
        
        bottomText.defaultTextAttributes = memeTextAttributes
        bottomText.textAlignment = .center
        bottomText.text = defaultBottomText
        bottomText.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        openCameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    @IBAction func pickImage(_ sender: Any) {
        launchImagePicker(.photoLibrary)
    }
    
    @IBAction func openCamera(_ sender: Any) {
        launchImagePicker(.camera)
    }
    
    func launchImagePicker(_ sourceType: UIImagePickerController.SourceType) {
        let picker: UIImagePickerController = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker, animated: true, completion: nil)
    }
    
    
    // MARK: UIImagePickerControllerDelegate implementation
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            pickedImage.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: UITextFieldDelegate implementation
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField.text == defaultTopText || textField.text == defaultBottomText) {
            textField.text = ""
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

