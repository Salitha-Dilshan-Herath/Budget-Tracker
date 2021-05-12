//
//  AddNewExpenseVC.swift
//  Budget Tracker
//
//  Created by Spemai-Macbook on 2021-05-11.
//

import UIKit

class AddNewExpenseVC: UIViewController {

    @IBOutlet weak var viwBudget: UIView!
    @IBOutlet weak var txtNote: UITextField!
    @IBOutlet weak var datePickerDueDate: UIDatePicker!
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var switchCalendar: UISwitch!
    @IBOutlet weak var pickerViwOccurence: UIPickerView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    
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
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
}
