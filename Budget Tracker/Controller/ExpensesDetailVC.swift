//
//  ExpensesVC.swift
//  Budget Tracker
//
//  Created by Spemai-Macbook on 2021-05-05.
//

import UIKit
import CoreData

class ExpensesDetailVC: UIViewController {

    @IBOutlet weak var viwBack: UIView!
    @IBOutlet weak var viwHeader: UIView!
    @IBOutlet weak var viwShadow: UIView!
    @IBOutlet weak var viwPieChart: PieChartView!
    @IBOutlet weak var lblCategoryName: UILabel!
    @IBOutlet weak var lblBudget: UILabel!
    @IBOutlet weak var lblSpent: UILabel!
    @IBOutlet weak var lblRemaining: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viwBack.isHidden = true
        viwShadow.isHidden = true
        
        viwBack.layer.cornerRadius = 20
        viwBack.clipsToBounds = true
        viwShadow.addShadowView()
        
        viwPieChart.pieces = [
            Piece(color: .red, usage: 57),
            Piece(color: .blue, usage: 30),
            Piece(color: .green, usage: 25),
            Piece(color: .yellow, usage: 40)
        ]
    }

}

extension ExpensesDetailVC: ExpensesCategoryTVCDelegate {
    
    func ExpenseDetail(categoryData: Category, categoryManageObject: NSManagedObject) {
        
        viwBack.backgroundColor   = Constant.SECONDARY_COLOR_THEMES[Int(categoryData.colour)]
        viwHeader.backgroundColor = Constant.PRIMARY_COLOR_THEMES[Int(categoryData.colour)]
        
        viwBack.isHidden = false
        viwShadow.isHidden = false
        
        self.lblCategoryName.text = categoryData.name?.capitalized
        self.lblBudget.text       = String(format: "£%.02f", NSDecimalNumber(decimal: categoryData.budget! as Decimal).doubleValue)
        
        let expenses = (categoryData.expenses?.allObjects as! [Expense])
        
        print(expenses)

    }
}
