//
//  RealmCRUDViewModel.swift
//  LoanList
//
//  Created by t&a on 2022/12/28.
//

import UIKit
import RealmSwift

class RealmCRUDViewModel {
    
    // MARK: - private property
    private let realm = try! Realm()
    
    // MARK: - ViewModels
    private let userDefaultsViewModels = UserDefaultsViewModels()
    
    // MARK: - public property
    var currentBorrower:Borrower? = nil
    var moneyRecords:Results<MoneyRecord>? = nil
    
    // MARK: - 入力バリデーション用
    private func isEmptyCheck(_ value:Any) -> Bool{
        if value as! String == ""{
            return true
        }else{
            return false
        }
    }
    
    // MARK: - Borrower
    func createBorrower(name:String){
        if isEmptyCheck(name) { return }
        
        try! realm.write {
            let borrower:Borrower = Borrower()
            borrower.name = name
            realm.add(borrower)
        }
    }
    
    func readBorrowerList() -> Results<Borrower> {
        try! realm.write {
            let borrowers = realm.objects(Borrower.self)
            return borrowers
        }
    }
    
    func deleteBorrower(_ borrower:Borrower){
        try! self.realm.write{
            self.realm.delete(borrower)
        }
    }
    // MARK: - Borrower
    
    
    // MARK: - MoneyRecord
    func createMoneyRecord(amount:String,desc:String,borrow:Bool,date:Date){
        try! realm.write {
            
            let name = userDefaultsViewModels.getCurrentBorrower()
            let borrowers = realm.objects(Borrower.self)
            
            if let result = borrowers.where({ $0.name == name }).first  {
                let moneyRecord:MoneyRecord = MoneyRecord()
                // Num Check
                if let num = Int(amount) {
                    moneyRecord.amount = num
                    moneyRecord.desc = desc
                    moneyRecord.borrow = borrow
                    moneyRecord.date = date
                    result.moneyRecords.append(moneyRecord)
                }
            }
        }
    }
    
    func updateMoneyRecord(item:MoneyRecord,amount:String,desc:String,borrow:Bool,date:Date){
        setAllMoneyRecords()
        
        try! realm.write {
            if let result = moneyRecords?.where({ $0.id == item.id }).first  {
                // Num Check
                if let num = Int(amount) {
                    result.amount = num
                    result.desc = desc
                    result.borrow = borrow
                    result.date = date
                }
            }
        }
    }
    
    func removeMoneyRecord(item:MoneyRecord){
        setAllMoneyRecords()
        try! realm.write {
            if let result = moneyRecords?.where({ $0.id == item.id }).first  {
                realm.delete(result)
            }
        }
    }
    
    // MARK: - プロパティにデータをセット
    func setAllMoneyRecords() {
        
        let name = userDefaultsViewModels.getCurrentBorrower()
        try! realm.write {
            let borrowers = realm.objects(Borrower.self)
            if let result = borrowers.where({ $0.name == name }).first  {
                currentBorrower = result
                // Results<MoneyRecord>型　そのまま返すとList<MoneyRecord>
                // 日付順にデフォルトでソートをかけておく
                moneyRecords =  result.moneyRecords.where({$0.amount != 0}).sorted(byKeyPath: "date", ascending: true)
            }else{
                moneyRecords = nil
            }
        }
    }
    
    // 以下ソートデータ返し用
    func setBorrowOnlyMoneyRecords(){
        setAllMoneyRecords()
        moneyRecords = moneyRecords?.where({$0.borrow == false})
    }
    
    func setLoanOnlyMoneyRecords(){
        setAllMoneyRecords()
        moneyRecords = moneyRecords?.where({$0.borrow == true})
    }
    
    func setSortMoneyRecords(key:String,asce:Bool) {
        setAllMoneyRecords()
        moneyRecords = moneyRecords?.sorted(byKeyPath: key, ascending: asce)
    }
    // MARK: - MoneyRecord
}
