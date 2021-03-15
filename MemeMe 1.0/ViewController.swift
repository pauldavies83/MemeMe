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
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        openCameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if (bottomText.isEditing) {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    
    // MARK: IBActions
    @IBAction func pickImage(_ sender: Any) {
        launchImagePicker(.photoLibrary)
    }
    
    @IBAction func openCamera(_ sender: Any) {
        launchImagePicker(.camera)
    }
    
    @IBAction func cancel(_ sender: Any) {
        pickedImage.image = nil
        topText.text = defaultTopText
        bottomText.text = defaultBottomText
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

