//
//  DateViewModel.swift
//  LoanList
//
//  Created by t&a on 2023/01/12.
//

import UIKit

class DateViewModel {
    
    private let df = DateFormatter()
    
    init(){
        df.calendar = Calendar(identifier: .gregorian)
        df.locale = Locale(identifier: "ja_JP")
        df.timeZone = TimeZone(identifier: "Asia/Tokyo")
        df.dateFormat = "yyyy/MM/dd"
    }

    public func getString(_ date:Date) -> String {
        df.string(from:date)
    }
}
