//
//  AddMoneyRecordViewController.swift
//  LoanList
//
//  Created by t&a on 2022/12/29.
//

import UIKit

class AddMoneyRecordViewController: UIViewController {
    
    // MARK: - ViewModel
    private let admobViewModel = AdMobViewModel()
    private let realmCRUDViewModel = RealmCRUDViewModel()
    
    // MARK: - Update View
    var item:MoneyRecord? = nil
    
    var toggle:Bool = false
    
    @IBOutlet private weak var amountText:UITextField!
    @IBOutlet private weak var descText:UITextField!
    @IBOutlet private weak var borrowButton: UIButton!
    @IBOutlet private weak var loanButton: UIButton!
    @IBOutlet private weak var baseView: UIView!
    @IBOutlet private weak var picker:UIDatePicker!
    
    @IBOutlet private weak var executeButton: UIButton!
    
    // MARK: - Outlet PickerButton
    @IBOutlet private weak var pickerButton: UIButton!
    // MARK: - Outlet Picker
    @IBOutlet private weak var pickerView: UIPickerView!
    
    // MARK: - Update View
    func setUpdateUIView() {
        guard let record = self.item else{
            return
        }
        amountText.text = String(record.amount)
        descText.text = record.desc
        toggle = record.borrow
        picker.date = record.date
    }
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        admobViewModel.admobInit(vc: self)
        
        setUpdateUIView()
        
        
        borrowButton.addTarget(self, action: #selector(tapBorrowButton), for: .touchUpInside)
        loanButton.addTarget(self, action: #selector(tapLoanButton), for: .touchUpInside)
        executeButton.addTarget(self, action: #selector(tapExecuteButton), for: .touchUpInside)
        pickerButton.addTarget(self, action: #selector(tapPickerButton), for: .touchUpInside)
        
        baseView.layer.cornerRadius = 10
        baseView.clipsToBounds = true
        baseView.layer.opacity = 0.9
        
        borrowEnabled()
        
        picker.locale = Locale(identifier: "ja_JP")
        picker.timeZone = TimeZone(identifier: "Asia/Tokyo")
        picker.calendar = Calendar(identifier: .gregorian)
        
        // MARK: - 閉じるボタン
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        let closeButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action:#selector(closeButtonTapped))
        toolBar.items = [spacer, closeButton]
        amountText.inputAccessoryView = toolBar
        descText.inputAccessoryView = toolBar
        // MARK: - 閉じるボタン
        
        // Picker用に更新 currentBorrowes
        realmCRUDViewModel.setAllMoneyRecords()
        
        if !isEmptyDescList() {
            pickerButton.tintColor = UIColor(named: "ThemaColor6")
            pickerButton.isEnabled = true
            pickerView.selectRow(realmCRUDViewModel.currentBorrower!.getDescList().count - 1 ,inComponent: 0, animated:true)
        }else{
            pickerButton.tintColor = .gray
            pickerButton.isEnabled = false
        }
    }
    
    // MARK: - 閉じるボタン
    @objc func closeButtonTapped() {
        self.view.endEditing(true)
    }
    
    @objc func tapBorrowButton(){
        toggle = false
        borrowEnabled()
    }
    
    @objc func tapLoanButton(){
        toggle = true
        borrowEnabled()
    }
    
    @objc func tapPickerButton(){
        if !isEmptyDescList() {
            pickerView.isHidden.toggle()
        }
    }
    
    private func isEmptyDescList() -> Bool{
        if realmCRUDViewModel.currentBorrower != nil{
            if realmCRUDViewModel.currentBorrower!.getDescList().count != 0 {
                return false
            }
        }
        return true
    }
    
    private func borrowEnabled(){
        if toggle {
            baseView.backgroundColor = UIColor(named: "ThemaColor2")
            borrowButton.tintColor = .gray
            loanButton.tintColor = UIColor(named: "FoundationColor")
        }else{
            baseView.backgroundColor = UIColor(named: "ThemaColor1")
            borrowButton.tintColor = UIColor(named: "FoundationColor")
            loanButton.tintColor = .gray
            
        }
    }
    
    
    // MARK: - ボタンタップ時
    @objc func tapExecuteButton() {
        if amountText.hasText {
            guard Int(amountText.text!) != nil else {
                errorAlert()
                return
            }
                // Update?
                if item == nil{
                    createRecord()
                    confirmAlert()
                }else{
                    updateRecord()
                    confirmAlert()
                }
        }
    }
    
    // MARK: - 1. create method
    private func createRecord(){
        realmCRUDViewModel.createMoneyRecord(
            amount: amountText.text!,
            desc:descText.text!,
            borrow:toggle,
            date:picker.date)
    }
    // MARK: - 2. update method
    private func updateRecord(){
        realmCRUDViewModel.updateMoneyRecord(
            item: item!,
            amount: amountText.text!,
            desc:descText.text!,
            borrow:toggle,
            date:picker.date)
    }
    
    // MARK: - Alert
    private func confirmAlert(){
        var message = ""
        if item != nil{
            message = "データを更新しました。"
        }else{
            message = "新しいデータを追加しました。"
        }
        let alert = UIAlertController(title: "Success!", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default,handler: { action in
            // ルート階層に戻る
            self.navigationController?.popToRootViewController(animated: true)
        })
        alert.addAction(ok)
        self.present(alert,animated: true)
    }
    
    // MARK: - ErrorAlert
    private func errorAlert(){
        let message = "数値で正しく入力してください"
        let alert = UIAlertController(title: "登録できませんでした...", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default,handler: { action in
            self.amountText.text! = ""
        })
        alert.addAction(ok)
        self.present(alert,animated: true)
    }
}

// MARK: - Extension PickerView
extension AddMoneyRecordViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    // 列の数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // 行数
    func pickerView(_ pickerView: UIPickerView,numberOfRowsInComponent component: Int) -> Int {
        return realmCRUDViewModel.currentBorrower?.getDescList().count ?? 0
    }
    
    // 最初の表示
    func pickerView(_ pickerView: UIPickerView,titleForRow row: Int,forComponent component: Int) -> String? {
        return realmCRUDViewModel.currentBorrower?.getDescList()[row]
    }
    
    // 選択された時の挙動
    func pickerView(_ pickerView: UIPickerView,didSelectRow row: Int,inComponent component: Int) {
        if realmCRUDViewModel.currentBorrower?.getDescList()[row] != "-" {
            descText.text = realmCRUDViewModel.currentBorrower?.getDescList()[row]
        }else{
            descText.text = ""
        }
    }
}
