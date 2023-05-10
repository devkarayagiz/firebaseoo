//
//  AyarlarVC.swift
//  FirebaseAoo
//
//  Created by krygz on 4.05.2023.
//

import UIKit
import Firebase

class AyarlarVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


    @IBAction func cikisYap(_ sender: Any) {
        
        do
        {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "cikisSegue", sender: nil)
        }
        catch
        {
            print(error.localizedDescription)
        }
    }
    
}
