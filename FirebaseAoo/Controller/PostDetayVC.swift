//
//  PostDetayVC.swift
//  FirebaseAoo
//
//  Created by krygz on 12.05.2023.
//

import UIKit

class PostDetayVC: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var likeTextField: UILabel!
    @IBOutlet var aciklamaTV: UITextView!
    
    var resmiGetir = ""
    var aciklamaGetir = ""
    var begeniGetir = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        likeTextField.text = String(begeniGetir) + " kişi bunu beğendi"
        imageView.sd_setImage(with: URL(string: resmiGetir))
        aciklamaTV.text = aciklamaGetir
        
    }
    
}
