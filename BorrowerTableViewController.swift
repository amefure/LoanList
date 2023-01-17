//
//  BorrowerListViewController.swift
//  LoanList
//
//  Created by t&a on 2022/12/28.
//

import UIKit

class BorrowerTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - ViewModel
    let realmCRUDViewModel = RealmCRUDViewModel()
    let userDefaultsViewModels = UserDefaultsViewModels()
    
    let borrowers = RealmCRUDViewModel().readBorrowerList()
    
    // MARK: - Outlet
    @IBOutlet var table:UITableView!
    
    // MARK: - ViewModel
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet var textField:UITextField!
    
    @IBAction func addBorrower(sender : Any) {
        realmCRUDViewModel.createBorrower(name: textField!.text!)
        table.reloadData()
        textField.text = ""
    }
    // MARK: - セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.borrowers.count;
    }
    // セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    // MARK: - セルの生成
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "BorrowerTableViewCell", for: indexPath) as! BorrowerTableViewCell
        let name = self.borrowers[indexPath.row].name
        cell.create(name: name, result: self.borrowers[indexPath.row].calculationResult)
        return cell
    }
    
    // MARK: - タップイベント
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // MARK: - アクティブにするborrower
        userDefaultsViewModels.setCurrentBorrower(self.borrowers[indexPath.row].name)
        table.reloadData()
    }
    
    
    // MARK: - スワイプアクション
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
          let destructiveAction = UIContextualAction(style: .destructive, title: "削除") { (action, view, completionHandler) in
              let result = self.borrowers[indexPath.row]
              self.realmCRUDViewModel.deleteBorrower(result)
              tableView.deleteRows(at: [indexPath], with: .automatic)
              self.userDefaultsViewModels.setCurrentBorrower("unknown")
              completionHandler(true)
              
          }
          let configuration = UISwipeActionsConfiguration(actions: [destructiveAction])
          return configuration
      }
}
