//
//  ExpensesVC.swift
//  Budget Tracker
//
//  Created by Spemai-Macbook on 2021-05-05.
//

import UIKit

class ExpensesDetailVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}
