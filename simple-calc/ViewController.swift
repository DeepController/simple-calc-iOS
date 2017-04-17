//
//  ViewController.swift
//  simple-calc
//
//  Created by William on 4/14/17.
//  Copyright © 2017 Yang Wang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	@IBOutlet fileprivate weak var display: UILabel!
	
	enum Operation {
		case arrayOperation(String)
		case binaryOperation((Double,Double) -> Double)
		case equals
		case Empty
		
		static func ==(left : Operation, right : Operation) -> Bool {
			switch (left, right) {
			case (.arrayOperation(let a), .arrayOperation(let b)) where a == b:
				return true
			case (.Empty, .Empty):
				return true
			default:
				return false
			}
		}
	}
	
	var operations: Dictionary<String,Operation> = [
		//		"±" : Operation.unaryOperation({ -$0 }),
		"×" : Operation.binaryOperation({ $0 * $1 }),
		"÷" : Operation.binaryOperation({ $0 / $1 }),
		"+" : Operation.binaryOperation({ $0 + $1 }),
		"−" : Operation.binaryOperation({ $0 - $1 }),
		"%" : Operation.binaryOperation({ $0.truncatingRemainder(dividingBy: $1) }),
		"=" : Operation.equals
	]
	
	var runningNumber = ""
	var leftValStr = ""
	var currentOperation: Operation = Operation.Empty
	var result = ""
	var arrMode : Bool = false
	var arr : Array<Double> = []
	
	@IBAction func numberPressed(_ sender: UIButton!) {
		runningNumber += sender.currentTitle!
		display.text = runningNumber
	}
	
	@IBAction func commonOperationPressed(_ sender: UIButton) {
		processOperation(operations[sender.currentTitle!]!)
	}
	
	
	@IBAction func onEqualPressed(_ sender: UIButton) {
		if arr.count == 0 {
			processOperation(currentOperation)
			currentOperation = Operation.Empty
		} else {
			arr.append(Double(runningNumber)!)
			switch currentOperation {
			case .arrayOperation(let a) where a == "Count":
				result = String(Double(arr.count))
			default:
				result = String(calculateAvg())
			}
			display.text = result
			runningNumber = ""
			arrMode = false
			arr = []
		}
	}
	
	fileprivate func calculateAvg() -> Double {
		let count = arr.count
		return arr.reduce(0, +) / Double(count)
	}
	
	@IBAction func onClearPressed(_ sender: UIButton) {
		if sender.currentTitle == "C" {
			display.text = ""
			runningNumber = ""
			sender.setTitle("AC", for: .normal)
		} else if sender.currentTitle == "AC" {
			display.text = ""
			leftValStr = ""
			runningNumber = ""
			result = ""
			currentOperation = Operation.Empty
			sender.setTitle("C", for: .normal)
		}
	}
	
	@IBAction func onDotPressed(_ sender: AnyObject) {
		let searchCharachter: Character = "."
		if !(runningNumber.characters.contains(searchCharachter)) {
			if runningNumber == "" {
				runningNumber = runningNumber + "0."
				display.text = runningNumber
			} else {
				runningNumber = runningNumber + "."
				display.text = runningNumber
			}
		}
	}
	
	@IBAction func onFactPressed(_ sender: UIButton) {
		let upper = Int(runningNumber)!
		var product = 1
		for num in 1...upper {
			product *= num
		}
		result = String(product)
		runningNumber = ""
		display.text = result
	}
	
	
	@IBAction func onArrayOperationPressed(_ sender: UIButton) {
//		if !arrMode {
//			arr.append(Double(leftValStr)!)
//			arrMode = true
//		}
		arr.append(Double(runningNumber)!)
		runningNumber = ""
		currentOperation = Operation.arrayOperation(sender.currentTitle!)
		print(arr)
	}
	
	func processOperation(_ op: Operation) {
		print("Before: \n\trunning number : \(runningNumber)\n\tLeft : \(leftValStr)\n\tRight : \(runningNumber)\n\tcurrent op Empty? \(currentOperation == Operation.Empty)")
		if !(currentOperation == Operation.Empty) {
			if runningNumber != "" {
				switch op {
				case .binaryOperation(let f):
					if Double(leftValStr) == nil {
						leftValStr = result
					}
					result = "\(f(Double(leftValStr)!, Double(runningNumber)!))"
				default:
					break
				}
				
				runningNumber = ""
			}
			leftValStr = result
			runningNumber = ""
			display.text = result
			currentOperation = op
		} else {
			//First time operator is pressed
			leftValStr = runningNumber
			result = runningNumber
			runningNumber = ""
			currentOperation = op
		}
		print("After: \n\trunning number : \(runningNumber)\n\tLeft : \(leftValStr)\n\tRight : \(runningNumber)\n\tcurrent op Empty? \(currentOperation == Operation.Empty)")
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
}

