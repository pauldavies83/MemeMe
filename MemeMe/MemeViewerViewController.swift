//
//  MemeViewerViewController.swift
//  MemeMe
//
//  Created by Paul Davies on 19/03/2021.
//

import UIKit

class MemeViewerViewController: UIViewController {
    var memeImage: UIImage? = nil
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = memeImage
    }
}
