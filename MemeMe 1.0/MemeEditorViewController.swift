//
//  ViewController.swift
//  MemeMe 1.0
//
//  Created by Paul Davies on 11/03/2021.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate,
                      UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var openCameraButton: UIBarButtonItem!
    
    @IBOutlet weak var pickedImage: UIImageView!
        
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

        configure(topText, with: defaultTopText)
        configure(bottomText, with: defaultBottomText)

        shareButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        openCameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func configure(_ textField: UITextField, with defaultText: String) {
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.text = defaultText
        textField.delegate = self
    }
    
    func setToolbars(hidden flag: Bool) {
        topToolbar.isHidden = flag
        bottomToolbar.isHidden = flag
    }

    @objc func keyboardWillShow(_ notification:Notification) {
        if (bottomText.isEditing) {
            view.frame.origin.y = getKeyboardHeight(notification) * (-1)
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
        shareButton.isEnabled = false
    }
    
    @IBAction func share(_ sender: Any) {
        let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, originalImage: pickedImage.image!, memedImage: generateMemedImage())
        let sharer = UIActivityViewController.init(activityItems: [meme.memedImage], applicationActivities: nil)
        
        sharer.completionWithItemsHandler = { activity, success, items, error in
            if success {
                self.save(meme)
            }
            sharer.dismiss(animated: true, completion: nil)
        }
        
        present(sharer, animated: true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage {
        setToolbars(hidden: true)

        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        setToolbars(hidden: false)

        return memedImage
    }
    
    func save(_ meme: Meme) {
        UIImageWriteToSavedPhotosAlbum(meme.memedImage, nil, nil, nil)
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
            shareButton.isEnabled = true
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

