//
//  ViewController.swift
//  LoanList
//
//  Created by t&a on 2022/12/28.
//

import UIKit
import RealmSwift

class MoneyRecordTableViewController: UIViewController  {
    
    // MARK: - ViewModels
    private let realmCRUDViewModel = RealmCRUDViewModel()
    private let userDefaultsViewModels = UserDefaultsViewModels()
    private let admobViewModel = AdMobViewModel()
    
    // MARK: - Outlet main
    @IBOutlet private weak var nameLabelButton:UIButton!
    @IBOutlet private weak var table:UITableView!
    @IBOutlet private weak var borrowButton: UIButton!
    @IBOutlet private weak var loanButton: UIButton!
    @IBOutlet private weak var resultLabel:UILabel!
    
    // MARK: - Outlet Sort
    @IBOutlet private weak var sortViewButton: UIButton!
    @IBOutlet private weak var sortDetailButton: UIButton!
    
    // MARK: - Outlet layer
    @IBOutlet private weak var pickerView: UIPickerView!
    
    // MARK: - Sort
    private var sortItem:SortItem? {
        // none or SortItem
        return userDefaultsViewModels.getCurrentSort()
    }
    
    // MARK: - Override
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // MARK: - View
        nameLabelButton.setTitle(userDefaultsViewModels.getCurrentBorrowerName(), for: .normal)
        nameLabelButton.layer.cornerRadius = 5
        nameLabelButton.clipsToBounds = true
        
        setResultLabel()
        
        // MARK: - SortView
        pickerView.layer.cornerRadius = 5
        pickerView.clipsToBounds = true
        
        // MARK: - ButtonAction
        borrowButton.addTarget(self, action: #selector(tapBorrowButton), for: .touchUpInside)
        loanButton.addTarget(self, action: #selector(tapLoanButton), for: .touchUpInside)
        sortViewButton.addTarget(self, action: #selector(tapSortViewButton), for: .touchUpInside)
        sortDetailButton.addTarget(self, action: #selector(tapSortDetailButton), for: .touchUpInside)
        
        // MARK: - Admob
        admobViewModel.admobInit(vc: self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // 画面際描画時にViewを再構築
        // MARK: - View
        nameLabelButton.setTitle(userDefaultsViewModels.getCurrentBorrowerName(), for: .normal)
        refreshData()
        setSort()
        setResultLabel()
        
        // 遷移戻り後のタップを解除する
        if let indexPath = table.indexPathForSelectedRow{
            table.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
        if identifier == "showMoneyRecordView" {
            let name = userDefaultsViewModels.getCurrentBorrowerName()
            if name == "unknown"{
                noUserAlert()
                return false
            }else{
                return true
            }
        }else{
            return true
        }
    }
    
    // Segue遷移時にビューに値を渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailView" {
            if let indexPath = table.indexPathForSelectedRow {
                guard let destination = segue.destination as? DetailViewController else {
                    
                    return
                }
                let item = realmCRUDViewModel.moneyRecords?[indexPath.row]
                destination.item = item
            }
        }
    }
    
    // MARK: - Alert
    private func noUserAlert(){
        let message = "「unknown」をタップして\n貸し借りする相手を登録してください"
        let alert = UIAlertController(title: "登録できません..!", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default,handler: { action in
            // ルート階層に戻る
            self.navigationController?.popToRootViewController(animated: true)
        })
        alert.addAction(ok)
        self.present(alert,animated: true)
    }
    
    // MARK: - Reuse View
    private func setResultLabel(){
        let name = userDefaultsViewModels.getCurrentBorrowerName()
        if name != "unknown"{
            if let currentBorrower = realmCRUDViewModel.currentBorrower {
                let result = currentBorrower.calculationResult
                resultLabel.isHidden = false
                resultLabel.text = result
                // 正or負で文字色を変更
                if result.contains("+"){
                    // 緑色
                    resultLabel.textColor = UIColor(red: 48/255, green: 189/255, blue: 78/255, alpha: 1)
                }else if result.contains("-"){
                    resultLabel.textColor = .red
                }else{
                    resultLabel.textColor = .gray
                }
            }
        }else{
            resultLabel.isHidden = true
        }
    }
    
    private func refreshData(){
        // MARK: - Refresh
        realmCRUDViewModel.setAllMoneyRecords()
        table.reloadData()
    }
    
    // MARK: - ButtonAction
    @objc func tapSortDetailButton(){
        setResultLabel()
        pickerView.isHidden.toggle()
    }
    
    @objc func tapSortViewButton(){
        userDefaultsViewModels.setCurrentSort("none")
        sortViewButton.tintColor = UIColor(named: "FoundationColor")
        refreshData()
        setResultLabel()
    }
    
    @objc func tapBorrowButton(){
        realmCRUDViewModel.setBorrowOnlyMoneyRecords()
        table.reloadData()
        userDefaultsViewModels.setCurrentSort("借のみ")
        sortViewButton.tintColor = .orange
        self.pickerView.selectRow(4,inComponent: 0, animated:true)
        
        let name = userDefaultsViewModels.getCurrentBorrowerName()
        if name != "unknown"{
            if let currentBorrower = realmCRUDViewModel.currentBorrower {
                let result = currentBorrower.borrowSum
                resultLabel.isHidden = false
                resultLabel.text = "\(result)円"
                resultLabel.textColor = .gray
            }
        }
    }
    
    @objc func tapLoanButton(){
        realmCRUDViewModel.setLoanOnlyMoneyRecords()
        table.reloadData()
        userDefaultsViewModels.setCurrentSort("貸しのみ")
        sortViewButton.tintColor = .orange
        self.pickerView.selectRow(5,inComponent: 0, animated:true)
        
        let name = userDefaultsViewModels.getCurrentBorrowerName()
        if name != "unknown"{
            if let currentBorrower = realmCRUDViewModel.currentBorrower {
                let result = currentBorrower.loanSum
                resultLabel.isHidden = false
                resultLabel.text = "\(result)円"
                resultLabel.textColor = .gray
            }
        }
    }
}

// MARK: - ソート設定
enum SortItem :String,CaseIterable {
    case amountAsce = "金額(昇順)"
    case amountDesc = "金額(降順)"
    case dateAsce = "日付(昇順)"
    case dateDesc = "日付(降順)"
    case borrowOnly = "借のみ"
    case loanOnly = "貸しのみ"
}

// MARK: - Extension PickerView
extension MoneyRecordTableViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    // 列の数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // 行数
    func pickerView(_ pickerView: UIPickerView,numberOfRowsInComponent component: Int) -> Int {
        return SortItem.allCases.count
    }
    
    // 最初の表示
    func pickerView(_ pickerView: UIPickerView,titleForRow row: Int,forComponent component: Int) -> String? {
        return SortItem.allCases[row].rawValue
    }
    
    // 選択された時の挙動
    func pickerView(_ pickerView: UIPickerView,didSelectRow row: Int,inComponent component: Int) {
        userDefaultsViewModels.setCurrentSort(SortItem.allCases[row].rawValue)
        setSort()
    }
    
    // ソートを反映させたデータの読み込み
    func setSort(){
        switch sortItem {
            
        case .amountAsce:
            realmCRUDViewModel.setSortMoneyRecords(key: "amount", asce: true)
            table.reloadData()
            sortViewButton.tintColor = .orange
            self.pickerView.selectRow(0,inComponent: 0, animated:true)
            break
            
        case .amountDesc:
            realmCRUDViewModel.setSortMoneyRecords(key: "amount", asce: false)
            table.reloadData()
            sortViewButton.tintColor = .orange
            self.pickerView.selectRow(1,inComponent: 0, animated:true)
            break
            
        case .dateAsce:
            realmCRUDViewModel.setSortMoneyRecords(key: "date", asce: true)
            table.reloadData()
            sortViewButton.tintColor = .orange
            self.pickerView.selectRow(2,inComponent: 0, animated:true)
            break
            
        case .dateDesc:
            realmCRUDViewModel.setSortMoneyRecords(key: "date", asce: false)
            table.reloadData()
            sortViewButton.tintColor = .orange
            self.pickerView.selectRow(3,inComponent: 0, animated:true)
            break
            
        case .borrowOnly:
            realmCRUDViewModel.setBorrowOnlyMoneyRecords()
            table.reloadData()
            sortViewButton.tintColor = .orange
            self.pickerView.selectRow(4,inComponent: 0, animated:true)
            break
            
        case .loanOnly:
            realmCRUDViewModel.setLoanOnlyMoneyRecords()
            table.reloadData()
            sortViewButton.tintColor = .orange
            self.pickerView.selectRow(5,inComponent: 0, animated:true)
            break
            
        case .none:
            realmCRUDViewModel.setAllMoneyRecords()
            table.reloadData()
            self.pickerView.selectRow(0,inComponent: 0, animated:true)
            break
        }
    }
}



// MARK: - Extension TableView
extension MoneyRecordTableViewController: UITableViewDataSource, UITableViewDelegate{
    
    // セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if realmCRUDViewModel.moneyRecords != nil{
            return realmCRUDViewModel.moneyRecords!.count
        }else{
            return 0
        }
        
    }
    
    // セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    // セルの生成
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoneyRecordTableViewCell", for: indexPath) as! MoneyRecordTableViewCell
        let item = realmCRUDViewModel.moneyRecords![indexPath.row]
        cell.create(amount: item.amount, desc: item.desc, borrow: item.borrow, date: item.date)
        return cell
    }
}


