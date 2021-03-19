//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Paul Davies on 19/03/2021.
//

import Foundation
import UIKit

class SentMemesCollectionViewController : UICollectionViewController, UIAdaptivePresentationControllerDelegate {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
        
    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 2.0

        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    func presentationControllerDidDismiss(_ _: UIPresentationController) {
        collectionView.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let meme = memes[(indexPath as NSIndexPath).row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        cell.imageView?.image = meme.memedImage
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let memeViewer = storyboard?.instantiateViewController(identifier: "MemeViewerViewController") as! MemeViewerViewController
        memeViewer.memeImage = memes[(indexPath as NSIndexPath).row].memedImage
        navigationController?.show(memeViewer, sender: self)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        memes.count
    }
    
    @IBAction func add(_ sender: Any) {
        let viewController = storyboard?.instantiateViewController(identifier: "MemeEditorViewController") as! MemeEditorViewController
        viewController.presentationController?.delegate = self
        present(viewController, animated: true, completion: nil)
    }
}
