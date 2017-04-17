//
//  Brain.swift
//  simple-calc
//
//  Created by William on 4/14/17.
//  Copyright © 2017 Yang Wang. All rights reserved.
//

import Foundation

class Brain {
	fileprivate var tempResult = 0.0
	fileprivate var counter = 0
	
	func storeOperand(_ number : Double) {
		tempResult = number
	}
	
	enum Operation {
		case unaryOperation((Double) -> Double)
		case binaryOperation((Double,Double) -> Double)
		case equals
	}
	
	var operations: Dictionary<String,Operation> = [
		"×" : Operation.binaryOperation({ $0 * $1 }),
		"÷" : Operation.binaryOperation({ $0 / $1 }),
		"+" : Operation.binaryOperation({ $0 + $1 }),
		"-" : Operation.binaryOperation({ $0 - $1 }),
		"%" : Operation.binaryOperation({ $0.truncatingRemainder(dividingBy: $1) }),
		"=" : Operation.equals
	]
	
	func performOperation(_ symbol: String) {
		if let operation = operations[symbol] {
			switch operation {
			case .unaryOperation(let foo):
				tempResult = foo(tempResult)
			case .binaryOperation(let function):
				executePendingBinaryOperation()
				pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: tempResult)
			case .equals:
				executePendingBinaryOperation()
			}
		}
	}
	
	fileprivate func executePendingBinaryOperation() {
		if pending != nil {
			print("Calculating \(pending!.firstOperand) and \(tempResult)")
			tempResult = pending!.binaryFunction(pending!.firstOperand, tempResult)
			pending = nil
		}
	}
	
	fileprivate var pending: PendingBinaryOperationInfo?
	
	fileprivate struct PendingBinaryOperationInfo {
		var binaryFunction: (Double, Double) -> Double
		var firstOperand: Double
	}
	
	var result: Double {
		get {
			return tempResult
		}
	}
	
}
