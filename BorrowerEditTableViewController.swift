//
//  BorrowerEditTableViewController.swift
//  LoanList
//
//  Created by t&a on 2023/07/08.
//

import UIKit

class BorrowerEditTableViewController:UIViewController{
    
    // MARK: - ViewModel
    let realmCRUDViewModel = RealmCRUDViewModel()
    let userDefaultsViewModels = UserDefaultsViewModels()
    
    var borrower:Borrower? = nil
    @IBOutlet var textField:UITextField!
    
    // MARK: - ViewModel
    override func viewDidLoad() {
        super.viewDidLoad()
        if borrower != nil {
            textField.text = borrower!.name
        }
        
        if UIDevice.current.userInterfaceIdiom != .pad {
            // MARK: - Admob
            AdMobViewModel().admobInit(vc: self)
        }
    }
    
    @IBAction func updateBorrower(sender : Any) {
        if !textField!.text!.isEmpty  {
            if borrower != nil {
                realmCRUDViewModel.updateBorrower(id:borrower!.id, name: textField!.text!)
                userDefaultsViewModels.setCurrentBorrowerName(textField!.text!)
                // 親View テーブル更新
                if let presentationController = presentationController{
                    presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
                }
                successAlert()
            }
        }
    }
    
    
    // MARK: - Alert
    private func successAlert(){
        let message = "名前を変更しました。"
        let alert = UIAlertController(title: "Success!", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default,handler: { action in
            // ルート階層に戻る
            self.dismiss(animated: true,completion: nil)
        })
        alert.addAction(ok)
        self.present(alert,animated: true)
    }
}
