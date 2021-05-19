//
//  ExpenseTC.swift
//  Budget Tracker
//
//  Created by Spemai-Macbook on 2021-05-17.
//

import UIKit

class ExpenseTC: UITableViewCell {

    @IBOutlet weak var viwBack: UIView!
    @IBOutlet weak var viwShadow: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblOccurance: UILabel!
    @IBOutlet weak var lblDueDate: UILabel!
    @IBOutlet weak var lblBudget: UILabel!
    @IBOutlet weak var imgEvent: UIImageView!
    @IBOutlet weak var viwProgress: CustomProgressBar!
    
    let dateFormatter = DateFormatter()
    var totalCategoryBudget: Decimal = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.viwShadow.layer.shadowOffset  = CGSize(width: 0, height: 1)
        self.viwShadow.layer.shadowColor   = UIColor.darkGray.cgColor
        self.viwShadow.layer.shadowOpacity = 1
        self.viwShadow.layer.shadowRadius  = 5

        self.viwBack.layer.cornerRadius    = 8
        self.viwBack.clipsToBounds         = true
        
        self.dateFormatter.dateStyle = .long
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            UIView.animate(withDuration: 0.3) { 
                self.viwBack.layer.borderColor = UIColor.link.cgColor
                self.viwBack.layer.borderWidth = 2

            }
        } else {
            
            UIView.animate(withDuration: 0.3) {
                
                self.viwBack.layer.borderColor = UIColor.clear.cgColor
                
            }
        }
    }
    
    func setupCell(expense: Expense, colorIndex: Int)  {
        
        viwBack.backgroundColor = Constant.PRIMARY_COLOR_THEMES[colorIndex]
        viwProgress.color = Constant.SECONDARY_COLOR_THEMES[colorIndex]
        viwProgress.layer.borderColor = Constant.PRIMARY_COLOR_THEMES[colorIndex].cgColor
        viwProgress.layer.borderWidth = 2
        
        
        let percentage =  (NSDecimalNumber( decimal:((expense.amount! as Decimal) / self.totalCategoryBudget)).doubleValue)
        
        viwProgress.progress = CGFloat(percentage)

        lblName.text      = expense.note?.capitalized
        lblOccurance.text = Constant.EXPENSES_OCCURRENCE[Int(expense.occurrence)].capitalized
        lblDueDate.text   = self.dateFormatter.string(from: expense.date!)
        lblBudget.text    = String(format: "Amount £%.02f", NSDecimalNumber(decimal: expense.amount! as Decimal).doubleValue)
        
        imgEvent.tintColor = Constant.PRIMARY_COLOR_THEMES[colorIndex]
        
        if expense.reminder {
            imgEvent.isHidden = false
        } else {
            imgEvent.isHidden = true
        }

    }
    
}
