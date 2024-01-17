//
//  HasAAcessoryViewController.swift
//  WTFDemo
//
//  Created by Nick Grabenstein on 1/16/24.
//

import UIKit

class HasAAcessoryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var canResignFirstResponder: Bool {
        return true
    }


    override var inputAccessoryView: UIView? {
        return UITextView()
    }
    

}
