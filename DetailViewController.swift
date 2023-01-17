//
//  DetailViewController.swift
//  LoanList
//
//  Created by t&a on 2023/01/12.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - 値受け取り用
    var item:MoneyRecord? = nil
    
    // MARK: - Outlet main
    @IBOutlet  private weak var amountLabel: UILabel!
    @IBOutlet  private weak var descLabel: UILabel!
    @IBOutlet  private weak var borrowLabel: UIButton!
    @IBOutlet  private weak var dateLabel: UILabel!
    @IBOutlet  private weak var baseView: UIView!
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpdateUIView()
    }
    
    override func prepare(for segue:UIStoryboardSegue,sender:Any?){
        if segue.identifier == "editRecordView" {
            guard let destination = segue.destination as? AddMoneyRecordViewController else {
                return
            }
            destination.item = item
        }
    }
    
    // MARK: - View
    private func setUpdateUIView() {
        guard item != nil else{
            return
        }
        
        amountLabel?.text = String(item!.amount)
        descLabel?.text = item!.desc
        if item!.borrow  {
            baseView.backgroundColor = UIColor(named: "ThemaColor2")
            borrowLabel.setTitle("貸", for: .normal)
            borrowLabel.backgroundColor = UIColor(named: "ThemaColor2")
        }else{
            baseView.backgroundColor = UIColor(named: "ThemaColor1")
            borrowLabel.setTitle("借", for: .normal)
            borrowLabel.backgroundColor = UIColor(named: "ThemaColor1")
            
        }
        
        baseView.layer.cornerRadius = 10
        baseView.clipsToBounds = true
        baseView.layer.opacity = 0.9
        
        let dvm = DateViewModel()
        dateLabel?.text = dvm.df.string(from: item!.date)
        
    }

    // MARK: - ButtonAction
    @IBAction func removeButtonAction(){
        let alert = UIAlertController(title: "確認", message: "このレコードを削除しますか？", preferredStyle: .alert)
        let destructive = UIAlertAction(title: "削除", style: .destructive,handler: { action in
            RealmCRUDViewModel().removeMoneyRecord(item: self.item!)
            self.navigationController?.popToRootViewController(animated: true)
        })
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: { (action) -> Void in
            
        })
        alert.addAction(destructive)
        alert.addAction(cancel)
        self.present(alert,animated: true)
    }
    
    
}
