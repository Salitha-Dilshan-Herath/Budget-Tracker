//
//  AddNewCategoryVC.swift
//  Budget Tracker
//
//  Created by Spemai-Macbook on 2021-05-07.
//

import UIKit
import CoreData

class AddNewCategoryVC: UIViewController {

    //MARK: - @IBOutlates
    @IBOutlet weak var txtCategoryName: UITextField!
    @IBOutlet weak var txtBudget: UITextField!
    @IBOutlet weak var txtNote: UITextField!
    @IBOutlet weak var viwBudget: UIView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet var btnColorTheme: [UIButton]!
    
    var selected_color_index = 0
    var dataManager = CoreDataManager()
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    
    //MARK: - @IBAction
    @IBAction func cancelBtnTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBtnTap(_ sender: Any) {
        
        let category_name = txtCategoryName.text!.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let budget = txtBudget.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let note   = txtNote.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if category_name == "" {
            
            Alert.showMessage(msg: "Please enter category name", on: self)
            return
        }
        
        if budget == "" {
            
            Alert.showMessage(msg: "Please enter monthly budget amount", on: self)
            return
        }
        
        //TO-DO add validation numbers only in text field 
        guard let budgetAmount = Decimal(string: budget) else {
            
            Alert.showMessage(msg: "Invalid budget amount", on: self)
            return
        }
        
        if budgetAmount < 1 {
            
            Alert.showMessage(msg: "The budget amount should be greater than zero", on: self)
            return
        }
        
        let new_category = CategoryData(name: category_name, budget: budgetAmount, colour: selected_color_index, notes: note)
        
        print(new_category)
        
        dataManager.saveCategory(categoryDetail: new_category, vc: self)
    }
    
    @IBAction func colorThemeTap(_ sender: UIButton) {
        
        btnColorTheme.forEach { (button) in
            
            button.layer.borderWidth = 0
            button.layer.borderColor = UIColor.clear.cgColor
        }
        
        sender.layer.borderWidth = 2.5
        sender.layer.borderColor = UIColor.link.cgColor
        
    }
    
    
    //MARK: - Custom Method
    func setupUI()  {
        
        self.viwBudget.layer.cornerRadius = 6
        self.viwBudget.layer.borderWidth  = 0.2
        self.viwBudget.layer.backgroundColor = UIColor.white.cgColor
        
        self.txtCategoryName.layer.cornerRadius = 6
        self.txtCategoryName.layer.borderWidth  = 0.2

        self.txtNote.layer.cornerRadius = 6
        self.txtNote.layer.borderWidth  = 0.2
        
        btnCancel.addShadow()
        btnSave.addShadow()
        
        btnColorTheme.forEach { (button) in
            
            button.layer.cornerRadius = 6
        }
        
        btnColorTheme[0].layer.borderWidth = 2.5
        btnColorTheme[0].layer.borderColor = UIColor.link.cgColor
    }
}
