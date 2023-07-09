//
//  UserDefaultsViewModels.swift
//  LoanList
//
//  Created by t&a on 2022/12/28.
//

import UIKit

// 現在のカレントユーザー引き継ぎ用
class UserDefaultsViewModels {
    
    private let userDefaults = UserDefaults.standard
    
    
    public func setCurrentBorrowerId(_ id:String){
        userDefaults.set(id, forKey: "CurrentBorrowerId")
    }
    
    public func getCurrentBorrowerId() -> String {
        let borrowerId = userDefaults.string(forKey:"CurrentBorrowerId") ?? "unknown"
        return borrowerId
    }
    
    public func setCurrentBorrowerName(_ name:String){
        userDefaults.set(name, forKey: "CurrentBorrower")
    }
    
    public func getCurrentBorrowerName() -> String {
        let borrower = userDefaults.string(forKey:"CurrentBorrower") ?? "unknown"
        return borrower
    }
    
    public func setCurrentSort(_ sort:String){
        userDefaults.set(sort, forKey: "CurrentSort")
    }
    
    public func getCurrentSort() -> SortItem? {
        let sort = userDefaults.string(forKey:"CurrentSort") ?? "none"
        
        switch sort {
        case SortItem.amountAsce.rawValue:
            return SortItem.amountAsce
        case SortItem.amountDesc.rawValue:
            return SortItem.amountDesc
        case SortItem.dateAsce.rawValue:
            return SortItem.dateAsce
        case SortItem.dateDesc.rawValue:
            return SortItem.dateDesc
        case SortItem.borrowOnly.rawValue:
            return SortItem.borrowOnly
        case SortItem.loanOnly.rawValue:
            return SortItem.loanOnly
        default:
            return .none
        }
    }
    
    
    public func setOperatorFlag(_ name:String){
        userDefaults.set(name, forKey: "OperatorFlag")
    }
    
    public func getOperatorFlag() -> String {
        let flag = userDefaults.string(forKey:"OperatorFlag") ?? "借"
        return flag
    }
    
}
