//
//  ExpensesCategoryTVC.swift
//  Budget Tracker
//
//  Created by Spemai-Macbook on 2021-05-05.
//

import UIKit
import CoreData

protocol ExpensesCategoryTVCDelegate: class {
    
    func ExpenseDetail(categoryData:Category)
}

class ExpensesCategoryTVC: UITableViewController {
    
    //MARK: - Instance Variables
    weak var delegate: ExpensesCategoryTVCDelegate?
    var dataManager = CoreDataManager()
    var categoryManageObjects = [NSManagedObject]()
    var selectedCategory: Category!
    var selectedCategoryIndex = -1
    var selectedOrderType: CategoryOrder = .tap
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK: - @IBActions
    @IBAction func addCategoryBtnTap(_ sender: UIBarButtonItem) {
        
        let addNewCategory = self.storyboard!.instantiateViewController(withIdentifier: "AddNewCategoryVC") as! AddNewCategoryVC
        addNewCategory.modalPresentationStyle = .popover
        addNewCategory.preferredContentSize = CGSize(width: 350, height: 390)
        addNewCategory.delegate = self
        
        let popController  = addNewCategory.popoverPresentationController
        popController?.permittedArrowDirections = .up
        popController?.barButtonItem = sender
        
        present(addNewCategory, animated: true, completion: nil)
    }
    
    @IBAction func sortBtnTap(_ sender: Any) {
        
        self.selectedOrderType = .alphabetically
        self.categoryManageObjects.removeAll()
        self.categoryManageObjects = dataManager.getCategoryList(order: self.selectedOrderType)
        self.tableView.reloadWithAnimation()
    }
    
    //MARK: Custom methods
    func setupUI()  {
        self.tableView.register(UINib(nibName: "CategoryTC", bundle: nil), forCellReuseIdentifier: "cateogry")
        self.categoryManageObjects = dataManager.getCategoryList(order: self.selectedOrderType)
        self.setupTable()
    }
    
    func setupTable()  {
                
        if self.categoryManageObjects.count > 0 {
            self.tableView.reloadWithAnimation()
        }
    }
    
    func updateCategoryTapCount()  {
    
        (categoryManageObjects[selectedCategoryIndex] as! Category).tap += 1
        
        let up_category = categoryManageObjects[selectedCategoryIndex] as! Category
        let new_category = CategoryData(name: up_category.name!, budget: up_category.budget! as Decimal, colour: Int(up_category.colour), notes: up_category.notes , tap: Int(up_category.tap))

        dataManager.updateCategory(categoryDetail: new_category, categoryObj: self.categoryManageObjects[selectedCategoryIndex]) {
            result in
            
            if result {
                
                //print("update category tap count success")
                
            } else {
                
                //print("update category tap count failed")
                
            }
        }
    }
}


extension ExpensesCategoryTVC: ExpenseTCDelegate {
    
    func categoryEdit(index: Int, sender: UIButton, cell: UITableViewCell) {
        
        let frame = sender.frame
        var showRect = cell.convert(frame, to: self.tableView)
        showRect = self.tableView.convert(showRect, to: view)
        
        let controllerPopover = self.storyboard?.instantiateViewController(withIdentifier: "AddNewCategoryVC") as? AddNewCategoryVC
        controllerPopover?.modalPresentationStyle = .popover
        controllerPopover?.preferredContentSize = CGSize(width: 350, height: 390)
        controllerPopover?.categoryData = self.selectedCategory
        controllerPopover?.categoryManageObj = self.categoryManageObjects[index]
        controllerPopover?.isEdit = true
        controllerPopover?.delegate = self
        
        if let popoverPC = controllerPopover?.popoverPresentationController {
            popoverPC.permittedArrowDirections = .left
            popoverPC.sourceView = self.view
            popoverPC.sourceRect = showRect
            
            if let popoverController = controllerPopover {
                present(popoverController, animated: true, completion: nil)
            }
        }
    }
}

extension ExpensesCategoryTVC: AddNewCategoryVCDelegate {
    
    func updateTable() {
        
        self.categoryManageObjects.removeAll()
        self.categoryManageObjects = dataManager.getCategoryList(order: self.selectedOrderType)
        self.tableView.reloadData()
    }
}
