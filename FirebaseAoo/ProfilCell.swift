//
//  ProfilCell.swift
//  FirebaseAoo
//
//  Created by krygz on 12.05.2023.
//

import UIKit

class ProfilCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Hücre yeniden kullanıldığında resmi sıfırla
        imageView.image = nil
    }
}
