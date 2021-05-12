//
//  ExpensesVC.swift
//  Budget Tracker
//
//  Created by Spemai-Macbook on 2021-05-05.
//

import UIKit

class ExpensesDetailVC: UIViewController {

    @IBOutlet weak var viwBack: UIView!
    @IBOutlet weak var viwHeader: UIView!
    @IBOutlet weak var viwShadow: UIView!
    @IBOutlet weak var viwPieChart: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    func ExpenseDetail(id: Int) {
        viwBack.backgroundColor = Constant.SECONDARY_COLOR_THEMES[id]
        viwHeader.backgroundColor = Constant.PRIMARY_COLOR_THEMES[id]

    }
}
