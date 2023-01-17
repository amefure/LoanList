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
    
    func create(name:String,result:String) {
        nameLabel.text = name
        resultLabel.text = result
        if name == UserDefaultsViewModels().getCurrentBorrower(){
            checkImageView.isHidden = false
        }else{
            checkImageView.isHidden = true
        }
        
        // 正or負で文字色を変更
        if result.contains("+"){
            // 緑色
            resultLabel.textColor = UIColor(red: 48/255, green: 189/255, blue: 78/255, alpha: 1)
        }else if result.contains("-"){
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
