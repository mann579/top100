//
//  MAAlertView.swift
//  Top100
//
//  Created by Manpreet on 30/10/2020.
//

import Foundation
import UIKit
class MAAlertview {
    static func showAlertWrapper(alertTitle: String, alertMessage: String) {
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert);
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil);
        alertController.addAction(okAction);
        
        if var topController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            topController.present(alertController, animated: true, completion: nil);
        }
    }
    
}
