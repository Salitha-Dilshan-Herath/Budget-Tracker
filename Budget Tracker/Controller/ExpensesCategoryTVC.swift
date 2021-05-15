//
//  ExpensesCategoryTVC.swift
//  Budget Tracker
//
//  Created by Spemai-Macbook on 2021-05-05.
//

import UIKit
import CoreData

protocol ExpensesCategoryTVCDelegate: class {
    
    func ExpenseDetail(categoryData:CategoryData, categoryManageObject: NSManagedObject)
}

class ExpensesCategoryTVC: UITableViewController {
    
    
    weak var delegate: ExpensesCategoryTVCDelegate?
    var dataManager = CoreDataManager()
    var categoryManageObjects = [NSManagedObject]()
    var categoryList = [CategoryData]()
    var selectedCategoryIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @IBAction func addCategoryBtnTap(_ sender: UIBarButtonItem) {
        
        let addNewCategory = self.storyboard!.instantiateViewController(withIdentifier: "AddNewCategoryVC") as! AddNewCategoryVC
        addNewCategory.modalPresentationStyle = .popover
        addNewCategory.preferredContentSize = CGSize(width: 350, height: 390)
        addNewCategory.delegate = self
        
        let popController  = addNewCategory.popoverPresentationController
        popController?.permittedArrowDirections = .up
        popController?.barButtonItem = sender

        present(addNewCategory, animated: true, completion: nil)
        print("tap")
    }
    
    @IBAction func sortBtnTap(_ sender: Any) {
        
        self.categoryList = self.categoryList.sorted { $0.name.lowercased() < $1.name.lowercased() }
        self.tableView.reloadWithAnimation()
    }
    
    //Mark: Custom methods
    func setupUI()  {
        self.tableView.register(UINib(nibName: "ExpenseTC", bundle: nil), forCellReuseIdentifier: "expense")
        self.categoryManageObjects = dataManager.getCategoryList()
        self.setupTable()
    }
    
    func setupTable()  {
                
        self.convertCategoryData()
        
        if self.categoryList.count > 0 {
            self.categoryList = self.categoryList.sorted { $0.tap > $1.tap }
            self.tableView.reloadWithAnimation()
            self.tableView.selectRow(at: IndexPath(row: 0, section: 0) as IndexPath, animated: true, scrollPosition:UITableView.ScrollPosition.none)

        }
    }
    
    func updateCategoryTapCount(category: CategoryData, catObj: NSManagedObject)  {
        
        var new_category = category
        new_category.tap += 1
        
        dataManager.updateCategory(categoryDetail: new_category, categoryObj: catObj) {
            result in

            if result {

                  self.categoryManageObjects = self.dataManager.getCategoryList()

            } else {

                print("update category tap count failed")

            }

        }
    }
    
    func convertCategoryData()  {
        
        self.categoryList.removeAll()

        self.categoryManageObjects.forEach { (nsObject) in
            
            self.categoryList.append(CategoryData(name: nsObject.value(forKey: "name") as! String, budget: nsObject.value(forKey: "budget") as! Decimal, colour: nsObject.value(forKey: "colour") as! Int, notes: nsObject.value(forKey: "notes") as? String ?? "", tap: nsObject.value(forKey: "tap") as! Int))
            
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
        controllerPopover?.categoryData = self.categoryList[index]
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
        self.categoryList.removeAll()
        self.categoryManageObjects = dataManager.getCategoryList()
        self.convertCategoryData()
        self.tableView.reloadData()
    }
}
