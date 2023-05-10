//
//  AkisVC.swift
//  FirebaseAoo
//
//  Created by krygz on 4.05.2023.
//

import UIKit
import Firebase
import SDWebImage


class AkisVC: UIViewController{
    
    @IBOutlet var tableView: UITableView!
    
    var postuYukleyenKisiArray = [String]()
    var tagsArray = [String]()
    var postYorumuArray = [String]()
    var imageURLArray = [String]()
    var likeArray = [Int]()
    var dateArray = [String]()
    var documentArray = [String]()
    
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        dataGetir()    }
    
    
        
    
}

extension AkisVC :  UITableViewDelegate, UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postuYukleyenKisiArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell
        cell.emailTF.text = postuYukleyenKisiArray[indexPath.row]
        cell.begeniTF.text = String(likeArray[indexPath.row])
        cell.commentTF.text = postYorumuArray[indexPath.row]
        cell.uploadView.sd_setImage(with: URL(string: imageURLArray[indexPath.row]), placeholderImage: UIImage(named: "upload"))
        cell.documentIDLabel.text = documentArray[indexPath.row]
        return cell
        
    }
    
    func dataGetir()
    {
        let database = Firestore.firestore()
        
        database.collection("Posts").order(by: "date", descending: true).addSnapshotListener { snapshot, error in
            
            if error != nil
            {
                self.alertVer(baslik: "HATA", icerik: error!.localizedDescription, buttonTitle: "Ok")
            }
            else
            {
                if snapshot?.isEmpty != true
                {
                    
                    self.postuYukleyenKisiArray.removeAll(keepingCapacity: false)
                    self.imageURLArray.removeAll(keepingCapacity: false)
                    self.postYorumuArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.documentArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents
                    {
                        let documentID = document.documentID
                        self.documentArray.append(documentID)

                        if let postuYukleyenKisi = document.get("postuYukleyenKisi") as? String
                        {
                            self.postuYukleyenKisiArray.append(postuYukleyenKisi)
                        }
                        
                        if let tags = document.get("tags") as? String
                        {
                            self.tagsArray.append(tags)
                        }
                        
                        if let postYorumu = document.get("postYorumu") as? String
                        {
                            self.postYorumuArray.append(postYorumu)
                        }
                        
                        if let imageURL = document.get("imageURL") as? String
                        {
                            self.imageURLArray.append(imageURL)
                            
                        }
                        
                        if let like = document.get("like") as? Int
                        {
                            self.likeArray.append(like)
                        }
                        
                        if let date = document.get("date") as? String
                        {
                            self.dateArray.append(date)
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
}
