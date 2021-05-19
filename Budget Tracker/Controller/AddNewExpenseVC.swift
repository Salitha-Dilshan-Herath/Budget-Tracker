//
//  AddNewExpenseVC.swift
//  Budget Tracker
//
//  Created by Spemai-Macbook on 2021-05-11.
//

import UIKit

protocol AddNewExpenseVCDelegate {
    
    func updateTable()
    
}

class AddNewExpenseVC: UIViewController {
    
    //MARK: - @IBOutlets
    @IBOutlet weak var viwBudget: UIView!
    @IBOutlet weak var txtNote: UITextField!
    @IBOutlet weak var datePickerDueDate: UIDatePicker!
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var switchCalendar: UISwitch!
    @IBOutlet weak var pickerViwOccurence: UIPickerView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    
    //MARK: - Instance Variables
    var selectedCategory: Category!
    var selectedExpense: Expense!
    var isEdit = false
    var selectedOccur = 0
    var delegate: AddNewExpenseVCDelegate?
    var dataManager = CoreDataManager()
    var remainingAmount:Decimal = 0
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    //MARK: - Custom Method
    func setupUI()  {
        
        self.viwBudget.layer.cornerRadius = 6
        self.viwBudget.layer.borderWidth  = 0.2
        self.viwBudget.layer.backgroundColor = UIColor.white.cgColor
        
        
        self.txtNote.layer.cornerRadius = 6
        self.txtNote.layer.borderWidth  = 0.2
        
        btnCancel.addShadow()
        btnSave.addShadow()
        
        if isEdit {
            self.txtNote.text = self.selectedExpense.note?.capitalized
            self.txtAmount.text = String(format: "%.02f", NSDecimalNumber(decimal: self.selectedExpense.amount! as Decimal).doubleValue)
            
            self.datePickerDueDate.date = self.selectedExpense.date!
            self.switchCalendar.isOn = self.selectedExpense.reminder
            
            self.pickerViwOccurence.selectRow(Int(self.selectedExpense.occurrence), inComponent: 0, animated: false)
            self.pickerView(self.pickerViwOccurence, didSelectRow: Int(self.selectedExpense.occurrence), inComponent: 0)
        }
        
    }
    
    //MARK: - @IBActions
    @IBAction func saveBtnTap(_ sender: Any) {
        
        let amount = txtAmount.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let note   = txtNote.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let due_date = datePickerDueDate.date
        let addToCalendar = switchCalendar.isOn
        
        if note == "" {
            
            Alert.showMessage(msg: "Please enter category name", on: self)
            return
        }
        
        if amount == "" {
            
            Alert.showMessage(msg: "Please enter monthly budget amount", on: self)
            return
        }
        
        //TO-DO add validation numbers only in text field
        guard let budgetAmount = Decimal(string: amount) else {
            
            Alert.showMessage(msg: "Invalid budget amount", on: self)
            return
        }
        
        if budgetAmount < 1 {
            
            Alert.showMessage(msg: "The budget amount should be greater than zero", on: self)
            return
        }
        
        if isEdit {
            updateExpense()
            return
        }
        
        if budgetAmount > remainingAmount {
            
            Alert.showMessage(msg: "The budget amount should be lower than remaining amount ", on: self)
            return
        }
        
       
        
        if addToCalendar {
            
            Helper.createEvent(title: "Reminder on \(note)", endDate: due_date) {
                (status, result) in
                
                if status {
                    
                    self.dataManager.saveExpense(amount: budgetAmount, note: note, dueDate: due_date, addToCalendar: addToCalendar, calendarId: result, occur: self.selectedOccur, category: self.selectedCategory) {
                        result in
                        
                        if result {
                            
                            Alert.showMessageWithTask(on: self, msg: "Expense save successful"){
                                self.delegate?.updateTable()
                                self.dismiss(animated: true, completion: nil)
                                
                            }
                            
                        } else {
                            
                            Alert.showMessage(msg: "An error occurred while saving the expense", on: self)
                            
                        }
                    }
                    
                } else {
                    
                    Alert.showMessage(msg: result, on: self)
                }
                
            }
            
        } else {
            
            dataManager.saveExpense(amount: budgetAmount, note: note, dueDate: due_date, addToCalendar: addToCalendar, calendarId: "", occur: self.selectedOccur, category: self.selectedCategory) {
                result in
                
                if result {
                    
                    Alert.showMessageWithTask(on: self, msg: "Expense save successful"){
                        self.delegate?.updateTable()
                        self.dismiss(animated: true, completion: nil)
                        
                    }
                    
                } else {
                    
                    Alert.showMessage(msg: "An error occurred while saving the expense", on: self)
                    
                }
            }
            
        }
    }
    
    
    @IBAction func cancelBtnTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateExpense()  {
        
        let amount = txtAmount.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let note   = txtNote.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let due_date = datePickerDueDate.date
        let addToCalendar = switchCalendar.isOn
        
    
        guard let budgetAmount = Decimal(string: amount) else {return}
        
        if budgetAmount > self.selectedCategory.budget!.decimalValue {
            
            Alert.showMessage(msg: "The amount should be lower than total amount ", on: self)
            return
        }
        
        ///MARK: - check current expense have a reminder
        if self.selectedExpense.reminder {
            
            ///MARK: - if have reminder check new changes
            if addToCalendar {
                
                Helper.updateEvent(title: "Reminder on \(note)", endDate: due_date, eventIdentifier: self.selectedExpense.eventId!) {
                    
                    (status, result) in
                    
                    if status {
                        self.selectedExpense.eventId = result
                    } else {
                        print("Event update failed")
                    }
                }
                
            } else {
                
                if self.selectedExpense.eventId != nil && self.selectedExpense.eventId != "" {
                    Helper.deleteEvent(eventIdentifier: self.selectedExpense.eventId!)
                    self.selectedExpense.eventId = ""
                }
            }
            
            ///MARK: - update changes
            self.dataManager.updateExpense(amount: budgetAmount, note: note, dueDate: due_date, addToCalendar: addToCalendar, calendarId: self.selectedExpense.eventId, occur: self.selectedOccur, oldExpenseName: self.selectedExpense.note!, category: self.selectedCategory) {
                result in
                
                if result {
                    
                    Alert.showMessageWithTask(on: self, msg: "Expense update successful"){
                        self.delegate?.updateTable()
                        self.dismiss(animated: true, completion: nil)
                        
                    }
                    
                } else {
                    
                    Alert.showMessage(msg: "An error occurred while updating the expense", on: self)
                    
                }
            }
            
        } else {
            
            Helper.createEvent(title: "Reminder on \(note)", endDate: due_date) {
                (status, result) in
                
                if status {
                    
                    self.dataManager.updateExpense(amount: budgetAmount, note: note, dueDate: due_date, addToCalendar: addToCalendar, calendarId: result, occur: self.selectedOccur, oldExpenseName: self.selectedExpense.note!, category: self.selectedCategory){
                        
                        result in
                        
                        if result {
                            
                            Alert.showMessageWithTask(on: self, msg: "Expense update successful"){
                                self.delegate?.updateTable()
                                self.dismiss(animated: true, completion: nil)
                                
                            }
                            
                        } else {
                            
                            Alert.showMessage(msg: "An error occurred while updating the expense", on: self)
                            
                        }
                    }
                    
                } else {
                    
                    Alert.showMessage(msg: result, on: self)
                }
                
            }
        }
    }
}

extension AddNewExpenseVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constant.EXPENSES_OCCURRENCE.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Constant.EXPENSES_OCCURRENCE[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        print(Constant.EXPENSES_OCCURRENCE[row])
        self.selectedOccur = row
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
}
