//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Paul Davies on 18/03/2021.
//

import Foundation
import UIKit

class SentMemesTableViewController : UITableViewController, UIAdaptivePresentationControllerDelegate {
    
    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func presentationControllerDidDismiss(_ _: UIPresentationController) {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let meme = memes[(indexPath as NSIndexPath).row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeTableViewCell") as! MemeTableViewCell
        cell.topText?.text = meme.topText
        cell.bottomText?.text = meme.bottomText
        cell.memeImage?.image = meme.memedImage
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memeViewer = storyboard?.instantiateViewController(identifier: "MemeViewerViewController") as! MemeViewerViewController
        memeViewer.memeImage = memes[(indexPath as NSIndexPath).row].memedImage
        navigationController?.show(memeViewer, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        memes.count
    }
    
    @IBAction func add(_ sender: Any) {
        let viewController = storyboard?.instantiateViewController(identifier: "MemeEditorViewController") as! MemeEditorViewController
        viewController.presentationController?.delegate = self
        present(viewController, animated: true, completion: nil)
    }
}
