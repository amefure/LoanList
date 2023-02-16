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
    
    func setCurrentBorrower(_ name:String){
        userDefaults.set(name, forKey: "CurrentBorrower")
    }
    
    func getCurrentBorrower() -> String {
        let borrower = userDefaults.string(forKey:"CurrentBorrower") ?? "unknown"
        return borrower
    }
    
    func setCurrentSort(_ sort:String){
        userDefaults.set(sort, forKey: "CurrentSort")
    }
    
    func getCurrentSort() -> SortItem? {
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
    
}
