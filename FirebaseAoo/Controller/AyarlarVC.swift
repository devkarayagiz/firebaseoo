//
//  AyarlarVC.swift
//  FirebaseAoo
//
//  Created by krygz on 4.05.2023.
//

import UIKit
import Firebase
import FirebaseFirestore
import SDWebImage

class AyarlarVC: UIViewController {
    
    var posts = [Post]()
    
    // MARK: - DIDSELECTEDITEMAT Değişkenleri
    
    var imageString = ""
    var aciklamaString = ""
    var likeString = 0
    var dateString = ""
    var postuYukleyenKisiString = ""
    
    // MARK: - Diziler
    
    var postuYukleyenKisiArray = [String]()
    var imageURLArray = [String]()
    var postYorumuArray = [String]()
    var likeArray = [Int]()
    var dateArray = [String]()

    let db = Firestore.firestore()
        
        // CollectionView için dizi
    var imageURLs = [String]()
    
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var adsoyadLabel: UILabel!
    @IBOutlet var userPhoto: UIImageView!
    
    var baslik = String()
    var imageURL = String()
    var profilreesmi = UIImage()
    var adsoyad = String()
    var documentID = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilPostlariniGetir()
        profilBilgileri()
        
    }
    
    // MARK: - Profil Bilgileri
    
    func profilBilgileri()
    {
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
                        
                        if user["user_email"] as! String == email! {
                            
                            self.baslik = user["username"] as! String
                            self.title = self.baslik
                            self.adsoyadLabel.text = user["adsoyad"] as! String
                            self.imageURL = user["imageURL"] as! String
                            self.userPhoto.sd_setImage(with: URL(string: self.imageURL))
                        } else {
                            print("Eşleşen kullanıcı bulunamadı")
                        }
                    }
                }
        }
    }
    
    // MARK: - ÇIKIŞ
    
    @IBAction func exitButton(_ sender: Any) {
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

// MARK: - CollectionView Extension

extension AyarlarVC : UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return posts.count
        }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProfilCell
        let post = posts[indexPath.item]
        
        cell.imageView.sd_setImage(with: URL(string: post.imageURL!))
        // Diğer hücre bileşenlerini de ayarlayabilirsiniz
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        imageString = posts[indexPath.item].imageURL!
        aciklamaString = posts[indexPath.item].aciklama!
        likeString = posts[indexPath.item].like!
        dateString = posts[indexPath.item].date!
        postuYukleyenKisiString = posts[indexPath.item].postuYukleyenKisi!
        performSegue(withIdentifier: "postDetaySegue", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "postDetaySegue"
        {
            let hedef = segue.destination as! PostDetayVC
            hedef.resmiGetir = imageString
            hedef.aciklamaGetir = aciklamaString
            hedef.begeniGetir = likeString
        }
    }
    
    func profilPostlariniGetir() {
        guard let currentUserEmail = Auth.auth().currentUser?.email else { return }

        let query = db.collection("Posts").whereField("postuYukleyenKisi", isEqualTo: currentUserEmail)

        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let imageURL = data["imageURL"] as? String ?? ""
                    let aciklama = data["postYorumu"] as? String ?? ""
                    let like = data["like"] as? Int ?? 0
                    let date = data["date"] as? String ?? ""
                    let postuYukleyenKisi = data["postuYukleyenKisi"] as? String ?? ""
                    
                    let post = Post(imageURL: imageURL, aciklama: aciklama, like: like, date: date, postuYukleyenKisi: postuYukleyenKisi)
                    self.posts.append(post) // Post modelini kullanarak verileri diziye ekle
                }

                self.collectionView.reloadData()
            }
        }
    }
}
