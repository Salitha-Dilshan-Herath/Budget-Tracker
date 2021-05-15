//
//  Alert.swift
//  Budget Tracker
//
//  Created by Spemai-Macbook on 2021-05-11.
//

import Foundation
import UIKit

struct Alert {
    
    private static func showBasicAlert(on vc:UIViewController, with title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async { vc.present(alert, animated: true, completion: nil) }
    }
    
    private static func showBasicAlertWithSingleTask(on vc:UIViewController, with title: String, message: String,completion: @escaping () -> Void){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {( alert: UIAlertAction!) in
            completion()
        }))
        DispatchQueue.main.async { vc.present(alert, animated: true, completion: nil) }
    }
    
    private static func showAdvanceAlertForConfirmation(on vc:UIViewController, with title: String, message: String, completion: @escaping (Bool) -> Void){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: {(alert: UIAlertAction!) in
            completion(true)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: {(alert: UIAlertAction!) in 
            completion(false)
        }))
        DispatchQueue.main.async { vc.present(alert, animated: true, completion: nil) }
    }

    static func showMessage(msg: String,on vc:UIViewController){
        showBasicAlert(on: vc, with:Constant.ALERT_HEADER, message: msg)
    }
    
    static func showMessageWithTask(on vc:UIViewController, msg: String , completion: @escaping ()->Void){
        showBasicAlertWithSingleTask(on: vc, with: Constant.ALERT_HEADER , message: msg){
            completion()
        }
    }
    
    static func showDeleteConfirmationAlert(on vc:UIViewController, msg:String, completion: @escaping (Bool)->Void){
        showAdvanceAlertForConfirmation(on: vc, with: Constant.ALERT_HEADER , message: msg) { (action) in
            if action == true{
                completion(true)
            }else{
                completion(false)
            }
        }
    }
    
}
