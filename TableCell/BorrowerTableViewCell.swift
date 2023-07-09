//
//  BorrowerTableViewCell.swift
//  LoanList
//
//  Created by t&a on 2023/01/17.
//

import UIKit

class BorrowerTableViewCell: UITableViewCell {
    
    @IBOutlet  private weak var nameLabel: UILabel!
    @IBOutlet  private weak var resultLabel: UILabel!
    @IBOutlet  private weak var checkImageView: UIImageView!
    
    @IBOutlet  private weak var rowImage: UIImageView!
    
    public var flag:Bool = false
    
    func create(borrower:Borrower) {
        if borrower.returnFlag {
            rowImage.tintColor = UIColor(named: "ThemaColor1")
            rowImage.image = UIImage(systemName: "person.fill.checkmark")
            nameLabel.text = "済：" + borrower.name
        }else{
            rowImage.tintColor = UIColor(named: "ThemaColor6")
            rowImage.image = UIImage(systemName: "person.fill")
            nameLabel.text = borrower.name
        }
        
        resultLabel.text = borrower.calculationResult
        if borrower.id.stringValue == UserDefaultsViewModels().getCurrentBorrowerId(){
            checkImageView.isHidden = false
        }else{
            checkImageView.isHidden = true
        }
        
        // 正or負で文字色を変更
        if borrower.calculationResult.contains("+"){
            // 緑色
            resultLabel.textColor = UIColor(red: 48/255, green: 189/255, blue: 78/255, alpha: 1)
        }else if borrower.calculationResult.contains("-"){
            resultLabel.textColor = .red
        }else{
            resultLabel.textColor = .gray
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
