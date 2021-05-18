//
//  ExpensesVC.swift
//  Budget Tracker
//
//  Created by Spemai-Macbook on 2021-05-05.
//

import UIKit
import CoreData

class ExpensesDetailVC: UIViewController {
    
    //MARK: - @IBOutlets
    @IBOutlet weak var viwBack: UIView!
    @IBOutlet weak var viwHeader: UIView!
    @IBOutlet weak var viwShadow: UIView!
    @IBOutlet weak var viwPieChart: PieChartView!
    @IBOutlet weak var lblCategoryName: UILabel!
    @IBOutlet weak var lblBudget: UILabel!
    @IBOutlet weak var lblSpent: UILabel!
    @IBOutlet weak var lblRemaining: UILabel!
    @IBOutlet var viwPieArray: [UIView]!
    @IBOutlet var lblPieList: [UILabel]!
    @IBOutlet weak var tblExpense: UITableView!
    @IBOutlet weak var lblError: UILabel!
    
    var dataManager = CoreDataManager()
    var selectedCategory: Category!
    var totalAmount: Decimal = 0
    var remainingAmount:Decimal = 0
    var spentAmount:Decimal = 0
    var expensesList = [Expense]() {
        didSet {
            
            updateCalculation()
        }
    }
    var selectedExpenseIndex = -1
    
    //MARK: - Life cycle events
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
    }
    
    //MARK: - @IBAction
    @IBAction func addBtnTap(_ sender: UIBarButtonItem) {
        
        if selectedCategory == nil {
            Alert.showMessage(msg: "Please select a category to insert new expense", on: self)
            return
        }
        
        let addNewExpense = self.storyboard!.instantiateViewController(withIdentifier: "AddNewExpenseVC") as! AddNewExpenseVC
        addNewExpense.modalPresentationStyle = .popover
        addNewExpense.preferredContentSize = CGSize(width: 350, height: 450)
        addNewExpense.selectedCategory = self.selectedCategory
        addNewExpense.remainingAmount  = self.remainingAmount
        addNewExpense.delegate = self
        
        let popController  = addNewExpense.popoverPresentationController
        popController?.permittedArrowDirections = .up
        popController?.barButtonItem = sender
        
        present(addNewExpense, animated: true, completion: nil)
        
    }
    
    @IBAction func editBtnTap(_ sender: UIBarButtonItem) {
        
        if selectedCategory == nil {
            Alert.showMessage(msg: "Please select a category to insert new expense", on: self)
            return
        }
        
        if selectedExpenseIndex == -1 {
            Alert.showMessage(msg: "Please select expense in the expense table to modify", on: self)
            return
        }
        
        let expense = self.expensesList[selectedExpenseIndex]
        
        let editExpense = self.storyboard!.instantiateViewController(withIdentifier: "AddNewExpenseVC") as! AddNewExpenseVC
        editExpense.modalPresentationStyle = .popover
        editExpense.preferredContentSize = CGSize(width: 350, height: 450)
        editExpense.selectedCategory = self.selectedCategory
        editExpense.remainingAmount  = self.remainingAmount
        editExpense.selectedExpense = expense
        editExpense.isEdit = true
        editExpense.delegate = self
        
        let popController  = editExpense.popoverPresentationController
        popController?.permittedArrowDirections = .up
        popController?.barButtonItem = sender
        
        present(editExpense, animated: true, completion: nil)
    }
    
    
    func setupUI()  {
        
        viwBack.isHidden = true
        viwShadow.isHidden = true
        
        viwBack.layer.cornerRadius = 20
        viwBack.clipsToBounds = true
        viwShadow.addShadowView()
        
        viwPieArray.forEach { (viw) in
            viw.isHidden = true
        }
        
        self.tblExpense.tableFooterView = UIView()
        self.tblExpense.register(UINib(nibName: "ExpenseTC", bundle: nil), forCellReuseIdentifier: "expense")
    }
    
    
    func updateCalculation()  {
        
        self.spentAmount = 0
        self.remainingAmount = 0
        
        self.expensesList.forEach { (item) in
            
            self.spentAmount += item.amount?.decimalValue ?? 0
        }
        
        self.remainingAmount = self.totalAmount - self.spentAmount
        
        self.lblBudget.text    = String(format: "£%.02f", NSDecimalNumber(decimal: self.totalAmount).doubleValue)
        self.lblSpent.text     = String(format: "£%.02f", NSDecimalNumber(decimal: self.spentAmount).doubleValue)
        self.lblRemaining.text = String(format: "£%.02f", NSDecimalNumber(decimal: self.remainingAmount).doubleValue)
        
        let sortedList = self.expensesList
        
        viwPieChart.pieces.removeAll()
        
        if sortedList.count > 3{
            
            for index in 0..<4 {
                viwPieArray[index].isHidden = false
                lblPieList[index].text = ("\(sortedList[index].note!)").capitalized
                let amount = sortedList[index].amount
                let percentage =  NSDecimalNumber( decimal:((amount! as Decimal) / self.totalAmount) * 100).doubleValue
                viwPieChart.pieces.append(Piece(color: Constant.PIE_CHART_COLOR[index], usage: CGFloat(percentage)))
                
            }
            
            var other: Decimal = 0
            for index in 4..<sortedList.count {
                other += sortedList[index].amount!.decimalValue
                
            }
            viwPieArray[4].isHidden = false
            lblPieList[4].text = "Others"
            let percentage =  NSDecimalNumber( decimal:((other as Decimal) / self.totalAmount) * 100).doubleValue
            viwPieChart.pieces.append(Piece(color: Constant.PIE_CHART_COLOR[4], usage: CGFloat(percentage)))
            
        } else {
            
            for index in 0..<sortedList.count {
                
                let amount     = sortedList[index].amount
                let percentage =  NSDecimalNumber( decimal:((amount! as Decimal) / self.totalAmount) * 100).doubleValue
                viwPieArray[index].isHidden = false
                lblPieList[index].text = ("\(sortedList[index].note!)").capitalized
                viwPieChart.pieces.append(Piece(color: Constant.PIE_CHART_COLOR[index], usage: CGFloat(percentage)))
            }
        }
    }
    
    func setupBackground()  {
        
        viwBack.backgroundColor   = Constant.SECONDARY_COLOR_THEMES[Int(self.selectedCategory.colour)]
        viwHeader.backgroundColor = Constant.PRIMARY_COLOR_THEMES[Int(self.selectedCategory.colour)]
        
        viwBack.isHidden   = false
        viwShadow.isHidden = false
        
        self.lblCategoryName.text = self.selectedCategory.name?.capitalized
        self.tblExpense.reloadWithAnimation()
        
    }
}

extension ExpensesDetailVC: ExpensesCategoryTVCDelegate {
    
    func ExpenseDetail(categoryData: Category, categoryManageObject: NSManagedObject) {
        
        let sortedList  = (categoryData.expenses?.allObjects as! [Expense])
        self.totalAmount  = categoryData.budget!.decimalValue
        self.expensesList = sortedList.sorted { $0.amount!.doubleValue > $1.amount!.doubleValue}
        self.selectedCategory = categoryData
        
        if sortedList.isEmpty {
            
            lblError.text = "No expenses found for this category. Please insert your add new expenses by clicking the + icon"
            
        } else {
            
            setupBackground()
        }
        
    }
}

extension ExpensesDetailVC: AddNewExpenseVCDelegate {
    
    func updateTable() {
        
        if let updateCategory = dataManager.getCategory(name: self.selectedCategory.name!)?.first {
            self.selectedCategory     = updateCategory
            self.expensesList.removeAll()
            
            let sortedList = (updateCategory.expenses?.allObjects as! [Expense])
            self.expensesList = sortedList.sorted { $0.amount!.doubleValue > $1.amount!.doubleValue}
            
            if sortedList.isEmpty {
                
                lblError.text = "No expenses found for this category. Please insert your add new expenses by clicking the + icon"
                
            } else {
                
                setupBackground()
            }
            
        }
    }
}
