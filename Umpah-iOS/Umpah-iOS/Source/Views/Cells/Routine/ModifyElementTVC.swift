//
//  ModifyElementTVC.swift
//  Umpah-iOS
//
//  Created by 장혜령 on 2021/09/07.
//

import UIKit

class ModifyElementTVC: UITableViewCell {

    static let identifier = "ModifyElementTVC"
    
    public var nameLabel = UILabel().then{
        $0.textColor = .upuhBlack
        $0.font = .systemFont(ofSize: 16)
    }
    
    public var checkImageView = UIImageView().then{
        $0.image = UIImage(named: "checkIcon")
        $0.isHidden = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        checkImageView.isHidden = selected ? false : true
        nameLabel.textColor = selected ? .upuhBlue : .upuhBlack
    }
    
    func setupLayout(){
        addSubviews([nameLabel, checkImageView])
        nameLabel.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(32)
        }
        
        checkImageView.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(32)
        }
    }
}

