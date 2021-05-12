//
//  ExpenseTC.swift
//  Budget Tracker
//
//  Created by Spemai-Macbook on 2021-05-08.
//

import UIKit

class ExpenseTC: UITableViewCell {

    @IBOutlet weak var viwBack: UIView!
    @IBOutlet weak var viwShadow: UIView!
    @IBOutlet weak var viwDetail: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.viwShadow.layer.shadowOffset  = CGSize(width: 0, height: 1)
        self.viwShadow.layer.shadowColor   = UIColor.darkGray.cgColor
        self.viwShadow.layer.shadowOpacity = 1
        self.viwShadow.layer.shadowRadius  = 5

        self.viwBack.layer.cornerRadius    = 8
        self.viwBack.clipsToBounds         = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
