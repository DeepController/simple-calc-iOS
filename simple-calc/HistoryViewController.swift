//
//  HistoryViewController.swift
//  simple-calc
//
//  Created by William on 4/21/17.
//  Copyright © 2017 Yang Wang. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
	
	private static var historyList: [String] = []
	private var lastLabel : UILabel = UILabel()
	
	@IBOutlet weak var stack: UIStackView!
	
	public static func addHistory(_ item : String) {
		HistoryViewController.historyList.append(item)
	}
	
	private func constructConstraints(_ currentLabel : UILabel, _ first : Bool) {
		let leadingConstraint = NSLayoutConstraint(item: currentLabel, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: stack, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
		let trailingConstraint = NSLayoutConstraint(item: currentLabel, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: stack, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
		let topConstraint = NSLayoutConstraint(item: currentLabel, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: first ? stack : lastLabel, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
		let heightConstraint = NSLayoutConstraint(item: currentLabel, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 40)
		
		stack.addConstraints([leadingConstraint, trailingConstraint, topConstraint, heightConstraint])
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		if HistoryViewController.historyList.count > 0 {
			let firstLabel = UILabel()
			firstLabel.text = HistoryViewController.historyList[0]
			firstLabel.translatesAutoresizingMaskIntoConstraints = false
			stack.addArrangedSubview(firstLabel)
			lastLabel = firstLabel
			constructConstraints(firstLabel, true)
			
			if HistoryViewController.historyList.count > 1 {
				for i in (1...HistoryViewController.historyList.count - 1) {
					let label = UILabel()
					label.text = HistoryViewController.historyList[i]
					label.translatesAutoresizingMaskIntoConstraints = false
					stack.addArrangedSubview(label)
					lastLabel = label
					constructConstraints(label, false)
				}
			}
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
