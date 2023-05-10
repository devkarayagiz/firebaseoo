//
//  GirisIslemleri.swift
//  FirebaseAoo
//
//  Created by krygz on 4.05.2023.
//

import UIKit
import Firebase

struct girisIslemleri
{
    func girisYap(email : String, parola : String)
    {
            Auth.auth().signIn(withEmail: email, password: parola)
    }
    
    func uyeOl(email : String, parola : String)
    {
            Auth.auth().createUser(withEmail: email, password: parola)
    }
    
    func cikisYap()
    {
        do
        {
            try Auth.auth().signOut()
        }
        catch
        {
            print(error.localizedDescription)
        }
    }
}
