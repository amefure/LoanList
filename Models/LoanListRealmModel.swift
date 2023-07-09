//
//  MoneyRecord.swift
//  LoanList
//
//  Created by t&a on 2022/12/28.
//

import UIKit
import RealmSwift

// MARK: - 借主
class Borrower: Object,ObjectKeyIdentifiable{
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name:String = ""
    @Persisted var returnFlag:Bool = false
    @Persisted var moneyRecords = RealmSwift.List<MoneyRecord>()
    
    // MARK: -　計算プロパティ
    var borrowSum:Int{
        let borrowRecords = self.moneyRecords.where({$0.borrow == false})
        var sum = 0
        for record in borrowRecords{
            sum += record.amount
        }
        return sum
    }
    
    var loanSum:Int{
        let loanRecords = self.moneyRecords.where({$0.borrow == true})
        var sum = 0
        for record in loanRecords{
            sum += record.amount
        }
        return sum
    }
    
    var calculationResult:String {
        if UserDefaultsViewModels().getOperatorFlag() == "借"{
            if borrowSum > loanSum{
                return "+ \(MoneyRecord.commaSeparateThreeDigits(borrowSum - loanSum))円"
            }else if borrowSum < loanSum{
                return "- \(MoneyRecord.commaSeparateThreeDigits(loanSum - borrowSum))円"
            }else{
                return "± \(MoneyRecord.commaSeparateThreeDigits(loanSum - borrowSum))円"
            }
        }else{
            if borrowSum > loanSum{
                return "- \(MoneyRecord.commaSeparateThreeDigits(borrowSum - loanSum))円"
            }else if borrowSum < loanSum{
                return "+ \(MoneyRecord.commaSeparateThreeDigits(loanSum - borrowSum))円"
            }else{
                return "± \(MoneyRecord.commaSeparateThreeDigits(loanSum - borrowSum))円"
            }
        }
    
    }
    
    func getDescList() -> [String]{
        var list:[String] = []
        for record in self.moneyRecords{
            if record.desc != ""{
                list.append(record.desc)
            }
        }
        let listSet = Set(list)
        list = Array(listSet).sorted()
        if list.count != 0 {
            list.append("-")
        }
        return list
    }
}

// MARK: - レコード
class MoneyRecord: Object,ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted  var amount:Int = 0      // 金額
    @Persisted  var desc:String = ""    // 内容
    @Persisted  var borrow:Bool = false // 借貸フラグ 真:貸付 偽：借入
    @Persisted  var date:Date = Date()  // 日付
    
    static func commaSeparateThreeDigits(_ amount:Int) -> String{
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.groupingSeparator = "," // 区切り文字を指定
        f.groupingSize = 3 // 何桁ごとに区切り文字を入れるか指定
        
        let result = f.string(from: NSNumber(integerLiteral: amount)) ?? "\(amount)"
        return result
    }
}
