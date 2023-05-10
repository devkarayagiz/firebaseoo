//
//  UploadVC.swift
//  FirebaseAoo
//
//  Created by krygz on 4.05.2023.
//

import UIKit
import Firebase
import FirebaseStorage

class UploadVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet var uploadView: UIImageView!
    @IBOutlet var descriptions: UITextField!
    @IBOutlet var tags: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        uploadView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(resimsec))
        uploadView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func resimsec()
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        uploadView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
        
    }
    


    @IBAction func upload(_ sender: Any) {
        
       
        let storage = Storage.storage()
        let referance = storage.reference()
        
        let uploads = referance.child("uploads")
        
        if let data = uploadView.image?.jpegData(compressionQuality: 0.5)
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
                            let firestorepost = ["imageURL" : imageURL!, "postuYukleyenKisi" : Auth.auth().currentUser?.email!, "postYorumu" : self.descriptions.text!, "tags" : self.tags.text!, "date" : FieldValue.serverTimestamp(), "like" : 1] as [String:Any]
                            
                            firestoreReferance = firestoreveritabani.collection("Posts").addDocument(data: firestorepost, completion: { error in
                                if error != nil
                                {
                                    self.alertVer(baslik: "HATA", icerik: error!.localizedDescription, buttonTitle: "Tamam")
                                }
                                else
                                {
                                    self.uploadView.image = UIImage(named: "upload")
                                    self.descriptions.text = ""
                                    self.tags.text = ""
                                    self.tabBarController?.selectedIndex = 0
                                }
                            })
                        }
                    }
                }
            }
        }
        
    }
    
}
