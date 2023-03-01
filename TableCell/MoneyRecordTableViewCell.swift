//
//  MoneyRecordTableViewCell.swift
//  LoanList
//
//  Created by t&a on 2022/12/29.
//

import UIKit

class MoneyRecordTableViewCell: UITableViewCell {
    
    @IBOutlet  private weak var amountLabel: UILabel!
    @IBOutlet  private weak var descLabel: UILabel!
    @IBOutlet  private weak var dateLabel: UILabel!
    @IBOutlet  private weak var borrowView: UIView!
    @IBOutlet  private weak var loanView: UIView!
    
    
    
    func create(amount: Int, desc: String,borrow:Bool,date:Date) {
        amountLabel.text = MoneyRecord.commaSeparateThreeDigits(amount)
        descLabel.text = desc
        if borrow {
            borrowView.isHidden = true
            loanView.isHidden = false
        }else{
    
            loanView.isHidden = true
            borrowView.isHidden = false
        }
        
        let dvm = DateViewModel()
        dateLabel.text = dvm.df.string(from: date)
       }

    override func awakeFromNib() {
        super.awakeFromNib()
        borrowView.layer.cornerRadius = 10
        borrowView.clipsToBounds = true
        borrowView.layer.opacity = 0.9
        loanView.layer.cornerRadius = 10
        loanView.clipsToBounds = true
        loanView.layer.opacity = 0.9
    }
    
 

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
