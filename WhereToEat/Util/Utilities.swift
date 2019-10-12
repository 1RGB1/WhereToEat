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
}
