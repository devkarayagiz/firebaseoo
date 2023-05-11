//
//  AyarlarVC.swift
//  FirebaseAoo
//
//  Created by krygz on 4.05.2023.
//

import UIKit
import Firebase
import FirebaseFirestore

class AyarlarVC: UIViewController {
    
    @IBOutlet var documentIDLabel: UILabel!
    
    var baslik = String()
    
    var documentID = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let db = Firestore.firestore()
        let usersRef = db.collection("Users")
        let documentID = usersRef.document().documentID
        
        guard let user = Auth.auth().currentUser else { return }
        let email = user.email
        
        db.collection("Users").whereField("user_email", isEqualTo: email)
            .getDocuments() { (querySnapshot, error) in
                if let error = error {
                    print("Hata oluştu: \(error)")
                } else {
                    for document in querySnapshot!.documents {
                        let user = document.data()
                        // user_email alanı ile kullanıcının e-posta bilgisini karşılaştırın
                        if user["user_email"] as! String == email! {
                            //print(user["username"])
                            self.baslik = user["username"] as! String
                            self.title = self.baslik
                            
                        } else {
                            print("Eşleşen kullanıcı bulunamadı")
                        }
                    }
                }
        }
        
        
        
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
