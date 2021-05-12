//
//  ExpensesCategoryTVC.swift
//  Budget Tracker
//
//  Created by Spemai-Macbook on 2021-05-05.
//

import UIKit
import CoreData

protocol ExpensesCategoryTVCDelegate: class {
    
    func ExpenseDetail(id:Int)
}

class ExpensesCategoryTVC: UITableViewController {
    
    
    weak var delegate: ExpensesCategoryTVCDelegate?
    var dataManager = CoreDataManager()
    var categoryManageObjects = [NSManagedObject]() {
        didSet {
            self.setupTable()
        }
    }
    var categoryList = [CategoryData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI()  {
        self.tableView.register(UINib(nibName: "ExpenseTC", bundle: nil), forCellReuseIdentifier: "expense")
        self.tableView.reloadWithAnimation()
        
        self.categoryManageObjects = dataManager.getCategoryList()
    }
    
    func setupTable()  {
        
        
    }
    
    @IBAction func addCategoryBtnTap(_ sender: UIBarButtonItem) {

    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "expense", for: indexPath) as! ExpenseTC

        cell.viwBack.backgroundColor = Constant.PRIMARY_COLOR_THEMES[indexPath.row]
        cell.viwDetail.backgroundColor = Constant.SECONDARY_COLOR_THEMES[indexPath.row]

        cell.selectionStyle = .none
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.delegate?.ExpenseDetail(id: indexPath.row)
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
           // tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            
        }    
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 120
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

}
