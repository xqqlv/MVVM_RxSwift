//
//  ButtonCellCollectionViewCell.swift
//  MVVMDemo
//
//  Created by 徐强强 on 2018/5/20.
//  Copyright © 2018年 徐强强. All rights reserved.
//

import UIKit
import SnapKit

class ButtonCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(button)
        
        button.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var button: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = self.frame.size.height / 2
        button.backgroundColor = UIColor.groupTableViewBackground
        button.setTitleColor(.black, for: .normal)
        button.isUserInteractionEnabled = false
        
        return button
    }()
}
