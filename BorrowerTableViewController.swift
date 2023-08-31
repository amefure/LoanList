//
//  BorrowerListViewController.swift
//  LoanList
//
//  Created by t&a on 2022/12/28.
//

import UIKit


class BorrowerTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - ViewModel
    private let realmCRUDViewModel = RealmCRUDViewModel()
    private let userDefaultsViewModels = UserDefaultsViewModels()
    private let interstitial = AdmobInterstitialView()
    
    // MARK: - Models
    private let borrowers = RealmCRUDViewModel().readBorrowerList()
    
    // MARK: - Outlet
    @IBOutlet var table:UITableView!
    @IBOutlet var textField:UITextField!
    
    // MARK: - ViewModel
    override func viewDidLoad() {
        super.viewDidLoad()
        interstitial.loadInterstitial()
        // MARK: - Admob
        AdMobViewModel().admobInit(vc: self)
    }
    
    @IBAction func addBorrower(sender : Any) {
        realmCRUDViewModel.createBorrower(name: textField!.text!)
        table.reloadData()
        textField.text = ""
        // インタースティシャル広告の表示
        interstitial.presentInterstitial()
        // 再読み込み
        interstitial.loadInterstitial()
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
        let borrower = self.borrowers[indexPath.row]
        cell.create(borrower: borrower)
        return cell
    }
    
    // MARK: - タップイベント
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // MARK: - アクティブにするborrower
        userDefaultsViewModels.setCurrentBorrowerId(self.borrowers[indexPath.row].id.stringValue)
        userDefaultsViewModels.setCurrentBorrowerName(self.borrowers[indexPath.row].name)
        table.reloadData()
    }
    
    
    // MARK: - 右側スワイプアクション
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // 削除ボタン
        let destructiveAction = UIContextualAction(style: .destructive, title: "削除") { (action, view, completionHandler) in
            // DB Delete処理
            let result = self.borrowers[indexPath.row]
            self.realmCRUDViewModel.deleteBorrower(result)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.userDefaultsViewModels.setCurrentBorrowerId("unknown")
            self.userDefaultsViewModels.setCurrentBorrowerName("unknown")
            completionHandler(true)
            
        }
        
        // 編集ボタン
        let editAction = UIContextualAction(style: .normal, title: "編集") { (action, view, completionHandler) in
            
            // 編集画面へ遷移
            let result = self.borrowers[indexPath.row]
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nextVC = storyboard.instantiateViewController(withIdentifier: "BorrowerEditTableViewController") as! BorrowerEditTableViewController
            nextVC.modalPresentationStyle = .formSheet
            nextVC.presentationController?.delegate = self
            nextVC.borrower = result
            self.present(nextVC, animated: true, completion: nil)
            completionHandler(true)
            
        }
        editAction.backgroundColor = UIColor(named: "ThemaColor4")
        
        let configuration = UISwipeActionsConfiguration(actions: [destructiveAction,editAction])
        return configuration
    }
    
    // MARK: - 左側スワイプアクション
     func tableView(_ tableView: UITableView,leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?{
         
         // 返済済みフラグ切り替え
         let borrower = self.borrowers[indexPath.row]
         var flag = borrower.returnFlag
         let completeAction = UIContextualAction(style: .normal, title: flag ? "未返済に戻す" : "返済済にする") { (action, view, completionHandler) in
             flag.toggle()
             self.realmCRUDViewModel.updateFlagBorrower(id: borrower.id, flag: flag)
             self.table.reloadData()
             completionHandler(true)
             
         }
         if flag {
             completeAction.backgroundColor = UIColor(named: "ThemaColor6")
         }else{
             completeAction.backgroundColor = UIColor(named: "ThemaColor1")
         }
         
         let configuration = UISwipeActionsConfiguration(actions: [completeAction])
         return configuration
     }
}

// 子Viewからメソッドを呼び出すため
extension BorrowerTableViewController :UIAdaptivePresentationControllerDelegate{
    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        table.reloadData()
    }
}
