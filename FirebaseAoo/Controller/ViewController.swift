//
//  ViewController.swift
//  FirebaseAoo
//
//  Created by krygz on 4.05.2023.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    
    @IBOutlet var email: UITextField!
    @IBOutlet var parola: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    
    @IBAction func girisYap(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: email.text!, password: parola.text!)
        performSegue(withIdentifier: "girisSegue", sender: nil)
        
    }
    
    @IBAction func uyeOl(_ sender: Any) {
        
        Auth.auth().createUser(withEmail: email.text!, password: parola.text!)
        alertVer(baslik: "BAŞARILI", icerik: "Kaydınız başarıyla gerçekleştirildi!", buttonTitle: "Tamam")
    }
    
}

