//
//  Utilities.swift
//  WhereToEat
//
//  Created by Ahmad Ragab on 10/12/19.
//  Copyright © 2019 Ahmad Ragab. All rights reserved.
//

import UIKit

class Utilities {
    static func showAlertForView(_ view: UIViewController, title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in

            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: nil)
            }
        }
        
        alertController.addAction(settingsAction)
        
        view.present(alertController, animated: true, completion: nil)
    }
    
    static func showAlertForView(_ view: UIViewController, withError errorMsg: String) {
        let alertController = UIAlertController(title: "Error", message: errorMsg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alertController.addAction(okAction)
        
        view.present(alertController, animated: true, completion: nil)
    }
    
    static func isWithNotsh() -> Bool {
        switch UIScreen.main.nativeBounds.height {
            case 1136, 1334, 2208:
                return false
            default:
                return true
            }
    }
}
