//
//  CalculatorViewModel.swift
//  MVVMDemo
//
//  Created by 徐强强 on 2018/5/20.
//  Copyright © 2018年 徐强强. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class CalculatorViewModel {
    
    let input: Input
    
    lazy var output: Output = {
        let calculateResult = input.calculatorStr.map {
            return self.calculateResult($0)
            }.asDriver(onErrorJustReturn: "")
        return Output(calculatorData: input.calculatorData.asDriver(onErrorJustReturn: []), calculateResult: calculateResult)
    }()
    
    var lastCalculatedResult: String = "0"
    
    var calculatedResult: String = "0"
    
    var currentOperators: String = ""
    
    init() {
        let calculatorData: [String] = ["C", "+/-", "%", "÷", "7", "8", "9", "x", "4", "5", "6", "-", "1", "2", "3", "+", "0", ".", "="]
        input = Input(calculatorData: ReplaySubject<[String]>.create(bufferSize: 1), calculatorStr: ReplaySubject<String>.create(bufferSize: 1))
        input.calculatorData.onNext(calculatorData)
    }
    
    func calculateResult(_ operators: String) -> String {
        switch operators {
        case "+", "-", "x", "÷", "=":
            switch currentOperators {
            case "+":
                calculatedResult = String((Int(lastCalculatedResult) ?? 0) + (Int(calculatedResult) ?? 0))
            case "-":
                calculatedResult = String((Int(lastCalculatedResult) ?? 0) - (Int(calculatedResult) ?? 0))
            case "x":
                calculatedResult = String((Int(lastCalculatedResult) ?? 0) * (Int(calculatedResult) ?? 0))
            case "÷":
                calculatedResult = String((Int(lastCalculatedResult) ?? 0) / (Int(calculatedResult) ?? 0))
            default:
                break
            }
            currentOperators = operators
            lastCalculatedResult = calculatedResult
            calculatedResult = ""
            return lastCalculatedResult
        case "C":
            calculatedResult = "0"
            currentOperators = ""
        case "+/-":
            break
        case "%":
            break
        case ".":
            break
        default:
            if calculatedResult == "0" {
                calculatedResult = ""
            }
            calculatedResult.append(operators)
        }
        return calculatedResult
    }

}

extension CalculatorViewModel {
    struct Input {
        let calculatorData: ReplaySubject<[String]>
        let calculatorStr: ReplaySubject<String>
    }
    
    struct Output {
        let calculatorData: Driver<[String]>
        let calculateResult: Driver<String>
    }
}
