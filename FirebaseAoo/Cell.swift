//
//  Cell.swift
//  FirebaseAoo
//
//  Created by krygz on 9.05.2023.
//

import UIKit
import Firebase

class Cell: UITableViewCell {

    @IBOutlet var emailTF: UILabel!
    @IBOutlet var uploadView: UIImageView!
    @IBOutlet var begeniTF: UILabel!
    @IBOutlet var commentTF: UITextView!
    @IBOutlet var secenekler: UIImageView!
    @IBOutlet var ucnokta: UIImageView!
    @IBOutlet var documentIDLabel: UILabel!
    
    
    @IBAction func likebuttonclicked(_ sender: Any) {
        
        let db = Firestore.firestore()
        
        if let likesayisi = Int(begeniTF.text!)
        {
            let likeartir = ["like" : likesayisi + 1] as [String : Any]
            db.collection("Posts").document(documentIDLabel.text!).setData(likeartir, merge: true)
        }
        
    }
    
    
    
    
    
}
