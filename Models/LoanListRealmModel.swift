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
        if borrowSum > loanSum{
            return "+ \(borrowSum - loanSum)円"
        }else if borrowSum < loanSum{
            return "- \(loanSum - borrowSum)円"
        }else{
            return "± \(loanSum - borrowSum)円"
        }
    }
}

// MARK: - レコード
class MoneyRecord: Object,ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted  var amount:Int = 0      // 金額
    @Persisted  var desc:String = ""    // 内容
    @Persisted  var borrow:Bool = false // 借貸フラグ 真:貸付 偽：借入
    @Persisted  var date:Date = Date()  // 日付
    
}



