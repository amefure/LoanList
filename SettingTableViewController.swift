//
//  SettingTableViewController.swift
//  LoanList
//
//  Created by t&a on 2023/07/09.
//

import UIKit

class SettingTableViewController: UITableViewController{
    
    // MARK: - ViewModel
    let realmCRUDViewModel = RealmCRUDViewModel()
    let userDefaultsViewModels = UserDefaultsViewModels()
    
    @IBOutlet var toggleSwitch:UISwitch!
    @IBOutlet var operatorFlagLabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setToggleSwitch()
        
        // MARK: - Admob
        AdMobViewModel().admobInit(vc: self)
        
    }
    
    @IBAction func tapToggleSwitch(_ sender:UISwitch){
        if sender.isOn {
            operatorFlagLabel.text = "借"
            userDefaultsViewModels.setOperatorFlag("借")
        } else {
            operatorFlagLabel.text = "貸"
            userDefaultsViewModels.setOperatorFlag("貸")
        }
    }
    
    private func setToggleSwitch(){
        let flag = userDefaultsViewModels.getOperatorFlag()
        operatorFlagLabel.text = flag
        
        if flag == "借"{
            toggleSwitch.isOn = true
        }else if flag == "貸"{
            toggleSwitch.isOn = false
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Static Cell Row 2番目クリック時
        if indexPath.row == 1{
            self.executeLink()
        }
    }
    
    // URLリンクの実行
    private func executeLink(){
        let application = UIApplication.shared
        application.open(URL(string: "https://apps.apple.com/jp/app/%E8%B2%B8%E3%81%97%E5%80%9F%E3%82%8A%E7%AE%A1%E7%90%86%E3%82%A2%E3%83%97%E3%83%AA/id1665658015?action=write-review")!,options: [.universalLinksOnly: false])
    }
}
