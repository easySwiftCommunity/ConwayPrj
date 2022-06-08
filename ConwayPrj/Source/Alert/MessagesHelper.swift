//
//  GameController.swift
//  ConwayPrj
//
//  Created by Danya on 08/06/2022.
//  Copyright © 2022 Danya. All rights reserved.
//
import UIKit

class MessagesHelper {
    
    static func showStandardMessage(reference: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        alert.view.setNeedsLayout()
        reference.present(alert, animated: true, completion: nil)
    }
    
    static func showStartCancel(reference: UIViewController, title: String, message: String, callback: @escaping (UIAlertAction)->()) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)

        alert.addAction(UIAlertAction(title: "Старт", style: UIAlertActionStyle.default, handler: callback))
        alert.addAction(UIAlertAction(title: "Отмена", style: UIAlertActionStyle.cancel, handler: nil))

        alert.view.setNeedsLayout()
        reference.present(alert, animated: true, completion: nil)
    }
    
    static func showYesNo(reference: UIViewController, title: String, message: String, callbackYes: @escaping (UIAlertAction)->(), callbackNo: @escaping (UIAlertAction)->(), buttonText: [String]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
   
        alert.addAction(UIAlertAction(title: buttonText[0], style: UIAlertActionStyle.default, handler: callbackYes))
        alert.addAction(UIAlertAction(title: buttonText[1], style: UIAlertActionStyle.cancel, handler: callbackNo))
  
        alert.view.setNeedsLayout()
        reference.present(alert, animated: true, completion: nil)
    }
    
}
