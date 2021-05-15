//
//  ExpenseTC.swift
//  Budget Tracker
//
//  Created by Spemai-Macbook on 2021-05-08.
//

import UIKit

protocol ExpenseTCDelegate {
    
    func categoryEdit(index: Int, sender: UIButton, cell: UITableViewCell)
    
}

class ExpenseTC: UITableViewCell {

    @IBOutlet weak var viwBack: UIView!
    @IBOutlet weak var viwShadow: UIView!
    @IBOutlet weak var viwDetail: UIView!
    @IBOutlet weak var lblCategoryName: UILabel!
    @IBOutlet weak var lblbudget: UILabel!
    @IBOutlet weak var lblNote: UILabel!
    @IBOutlet weak var constaraintNoteLabel: NSLayoutConstraint!
    
    override var isSelected: Bool  {
        didSet{
            if self.isSelected {
                UIView.animate(withDuration: 0.3) { // for animation effect
                    self.viwBack.layer.borderColor = UIColor.link.cgColor
                    self.viwBack.layer.borderWidth = 2

                }
            }
            else {
                UIView.animate(withDuration: 0.3) { // for animation effect
                    
                    self.viwBack.layer.borderColor = UIColor.clear.cgColor
                    
                }
            }
        }
    }
    
    var index = 0
    var delegate: ExpenseTCDelegate!
    
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

    }
    
    func setupCell(category: CategoryData)  {
        
        self.viwBack.backgroundColor   = Constant.PRIMARY_COLOR_THEMES[category.colour]
        self.viwDetail.backgroundColor = Constant.SECONDARY_COLOR_THEMES[category.colour]
        self.selectionStyle = .none
        
        self.lblCategoryName.text = category.name.capitalized
        self.lblbudget.text       = String(format: "Budget £%.02f", NSDecimalNumber(decimal: category.budget).doubleValue)
        
        if category.notes == "" {
            self.constaraintNoteLabel.constant = 120
        } else{
            self.constaraintNoteLabel.constant = 71.5
            self.lblNote.text         = "Note: " + category.notes

        }
    }
    
    @IBAction func editBtnTap(_ sender: UIButton) {
        
        self.delegate.categoryEdit(index: self.index, sender: sender, cell: self)
    }
    
}
