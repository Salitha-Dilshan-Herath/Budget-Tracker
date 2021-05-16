//
//  UIExtenstions.swift
//  Budget Tracker
//
//  Created by Spemai-Macbook on 2021-05-08.
//

import Foundation
import UIKit

extension UIButton {
    
    func addShadow()  {
        
        self.layer.shadowOffset  = CGSize(width: 0, height: 1)
        self.layer.shadowColor   = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius  = 5
        self.layer.masksToBounds = false
        self.layer.cornerRadius  = 8
    }
}


extension UITableView {
    
    func reloadWithAnimation() {
        self.reloadData()
        let tblHeight = self.bounds.size.height
        let cells = self.visibleCells
        var delayCounter = 0
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tblHeight)
        }
        for cell in cells {
            UIView.animate(withDuration: 1.6, delay: 0.08 * Double(delayCounter),usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }
    
}


extension UIView {
    
    func addShadowView()  {
        
        self.layer.shadowOffset  = CGSize(width: 0, height: 1)
        self.layer.shadowColor   = UIColor.darkGray.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius  = 5
        self.layer.cornerRadius  = 8
    }
}



