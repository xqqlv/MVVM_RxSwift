//
//  CalculatorViewController.swift
//  MVVMDemo
//
//  Created by 徐强强 on 2018/5/20.
//  Copyright © 2018年 徐强强. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class CalculatorViewController: UIViewController {
    
    lazy var viewModel: CalculatorViewModel = CalculatorViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(collectionView)
        view.addSubview(hudLabel)
        
        collectionView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalToSuperview()
            make.height.equalTo(self.view.frame.size.width + (self.view.frame.size.width - 75) / 4)
        }
        
        hudLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(collectionView.snp.top).offset(-15)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        bindViewModel()
    }
    
    func bindViewModel() {
        viewModel.output.calculatorData
            .drive(collectionView.rx.items(cellIdentifier: "ButtonCell", cellType: ButtonCell.self)) { _, viewModel, cell in
                cell.button.setTitle(viewModel, for: .normal)
            }.disposed(by: disposeBag)
        
        viewModel.output.calculateResult.drive(hudLabel.rx.text).disposed(by: disposeBag)
        
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        collectionView.register(ButtonCell.self, forCellWithReuseIdentifier: "ButtonCell")
        
        return collectionView
    }()
    
    lazy var hudLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .right
        
        return label
    }()

}

extension CalculatorViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 16 {
            return CGSize(width: (self.view.frame.size.width - 75) / 2 + 15, height: (self.view.frame.size.width - 75) / 4)
        }
        return CGSize(width: (self.view.frame.size.width - 75) / 4, height: (self.view.frame.size.width - 75) / 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ButtonCell
        viewModel.input.calculatorStr.onNext(cell.button.currentTitle ?? "")
    }
}
