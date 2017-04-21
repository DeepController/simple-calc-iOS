//
//  ViewController.swift
//  SimpleCalc2
//
//  Created by William on 4/19/17.
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
		"×" : Operation.binaryOperation({ $0 * $1 }),
		"÷" : Operation.binaryOperation({ $0 / $1 }),
		"+" : Operation.binaryOperation({ $0 + $1 }),
		"−" : Operation.binaryOperation({ $0 - $1 }),
		"%" : Operation.binaryOperation({ $0.truncatingRemainder(dividingBy: $1) }),
		"Count" : Operation.arrayOperation("Count"),
		"Avg" : Operation.arrayOperation("Avg"),
		"=" : Operation.equals
	]
	
	var runningNumber = ""
	var leftValStr = ""
	var currentOperation: Operation = Operation.Empty
	var result = ""
	var arr : Array<Double> = []
	var RPN : Bool = false
	
	@IBAction func numberPressed(_ sender: UIButton!) {
		runningNumber += sender.currentTitle!
		display.text = runningNumber
	}
	
	@IBAction func commonOperationPressed(_ sender: UIButton) {
		if RPN {
			processRPN(sender.currentTitle!)
		} else {
			processOperation(operations[sender.currentTitle!]!)
		}
	}
	
	@IBAction func onRPNPressed(_ sender: UIButton) {
		if RPN {
			RPN = false
			sender.backgroundColor = UIColor.init(red: 0.327828, green: 0.327836, blue: 0.327832, alpha: 1.000)
		} else {
			RPN = true
			sender.backgroundColor = UIColor.init(red: 0.969, green: 0.573, blue: 0.192, alpha: 1.000)
		}
	}
	
	@IBAction func onEqualPressed(_ sender: UIButton) {
		if !RPN {
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
				arr = []
			}
		} else {
			arr.append(Double(runningNumber)!)
			runningNumber = ""
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
		if !RPN {
			let upper = Int(runningNumber)!
			var product = 1
			for num in 1...upper {
				product *= num
			}
			result = String(product)
			runningNumber = ""
			display.text = result
		}
	}
	
	
	@IBAction func onArrayOperationPressed(_ sender: UIButton) {
		if !RPN {
			arr.append(Double(runningNumber)!)
			runningNumber = ""
			currentOperation = Operation.arrayOperation(sender.currentTitle!)
		} else {
			processRPN(sender.currentTitle!)
		}
	}
	
	func processOperation(_ op: Operation) {
		//		print("Before: \n\trunning number : \(runningNumber)\n\tLeft : \(leftValStr)\n\tRight : \(runningNumber)\n\tcurrent op Empty? \(currentOperation == Operation.Empty)")
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
		//		print("After: \n\trunning number : \(runningNumber)\n\tLeft : \(leftValStr)\n\tRight : \(runningNumber)\n\tcurrent op Empty? \(currentOperation == Operation.Empty)")
	}
	
	fileprivate func processRPN(_ op : String) {
		switch op {
		case "+" :
			display.text = String(arr.reduce(0, +))
		case "−" :
			display.text = String(calculateArraySubtract())
		case "×" :
			display.text = String(arr.reduce(1, *))
		case "÷" :
			display.text = String(calculateArrayDivision())
		case "Count" :
			display.text = String(arr.count)
		case "Avg" :
			display.text = String(calculateAvg())
		default:
			break
		}
		runningNumber = ""
		arr = []
	}
	
	fileprivate func calculateArrayDivision() -> Double {
		var quo = arr[0]
		if arr.count > 1 {
			for i in (1...arr.count - 1) {
				quo /= arr[i]
			}
		}
		return quo
	}
	
	fileprivate func calculateArraySubtract() -> Double {
		var res = arr[0]
		if arr.count > 1 {
			for i in (1...arr.count - 1) {
				res -= arr[i]
			}
		}
		return res
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

