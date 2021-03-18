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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let meme = memes[(indexPath as NSIndexPath).row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeCell")!
        cell.textLabel?.text = "\(meme.topText) \(meme.bottomText)"
        cell.detailTextLabel?.isHidden = true
        cell.imageView?.image = meme.memedImage
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        memes.count
    }
    
}
