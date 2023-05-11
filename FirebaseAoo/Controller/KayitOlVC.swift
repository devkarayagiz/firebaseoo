//
//  KayitOlVC.swift
//  FirebaseAoo
//
//  Created by krygz on 11.05.2023.
//

import UIKit
import Firebase
import FirebaseStorage

class KayitOlVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet var userPhoto: UIImageView!
    @IBOutlet var adsoyadTF: UITextField!
    @IBOutlet var kullaniciadiTF: UITextField!
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var parolaTF: UITextField!
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        userPhoto.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(resimsec))
        userPhoto.addGestureRecognizer(gestureRecognizer)
    }
    
    // MARK: - Kayıt Ol
    @IBAction func kayitOl(_ sender: Any) {
        
        upload()
        
    }
    
    // MARK: - Giriş Yap
    @IBAction func girisyap(_ sender: Any) {
        
        performSegue(withIdentifier: "girisyapSegue", sender: nil)
        
    }
    
    // MARK: - Resim Seç
    @objc func resimsec()
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    //Galeriden seçtiğimiz resmi uploadView görselinin üzerine yapıştırdık.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        userPhoto.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
        
    }
    
    // MARK: - Upload İşlemleri
    
    func upload()
    {
        Auth.auth().createUser(withEmail: self.emailTF.text!, password: self.parolaTF.text!)
        let storage = Storage.storage()
                let referance = storage.reference()
                
                let uploads = referance.child("userphotos")
                
                if let data = userPhoto.image?.jpegData(compressionQuality: 0.5)
                {
                    
                    let uuid = UUID().uuidString
                    let imagereferance = uploads.child("\(uuid).jpg")
                    imagereferance.putData(data,metadata: nil) { metadata, error in
                        
                        if error != nil
                        {
                            print(error?.localizedDescription)
                        }
                        else
                        {
                            imagereferance.downloadURL { url, error in
                                if error == nil
                                {
                                    let imageURL = url?.absoluteString
                                    print(imageURL)
                                    
                                    //Veritabanı Bağlantısını başlatıyoruz.
                                    
                                    let firestoreveritabani = Firestore.firestore()
                                    var firestoreReferance : DocumentReference? = nil
                                    let firestorepost = ["imageURL" : imageURL!, "adsoyad" : self.adsoyadTF.text!, "user_email" : self.emailTF.text!,"username" : self.kullaniciadiTF.text!, "date" : FieldValue.serverTimestamp()] as [String:Any]
                                    
                                    firestoreReferance = firestoreveritabani.collection("Users").addDocument(data: firestorepost, completion: { error in
                                        if error != nil
                                        {
                                            self.alertVer(baslik: "HATA", icerik: error!.localizedDescription, buttonTitle: "Tamam")
                                        }
                                        
                                        
                                    })
                                }
                            }
                            //self.alertVer(baslik: "BAŞARILI", icerik: "Kaydınız başarıyla gerçekleştirildi!", buttonTitle: "Tamam")
                            self.performSegue(withIdentifier: "kayitOlTabbarSegue", sender: nil)
                        }
                    }
                }
    }
    
}
