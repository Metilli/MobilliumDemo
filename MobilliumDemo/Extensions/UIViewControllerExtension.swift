//
//  UIViewControllerExtension.swift
//  MobilliumDemo
//
//  Created by Metilli on 30.03.2022.
//

import Foundation
import UIKit

extension UIViewController{
    
    func presentOkAlert(_ title: String, _ message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let uiAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: handler))
        present(uiAlert, animated: true)
        return
    }
    
}

class MovieViewController: UIViewController{
    
    var errorMessage:String? = ""{
        didSet{
            if let safeError = errorMessage,
               !safeError.isEmpty{
                presentOkAlert("Error", safeError, handler: nil)
            }
        }
    }
}
