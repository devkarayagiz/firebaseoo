//
//  Alerts.swift
//  FirebaseAoo
//
//  Created by krygz on 4.05.2023.
//

import UIKit

extension UIViewController
{
    func alertVer(baslik : String, icerik : String, buttonTitle : String)
    {
        let alert = UIAlertController(title: baslik, message: icerik, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: buttonTitle, style: UIAlertAction.Style.default)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
