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

}
