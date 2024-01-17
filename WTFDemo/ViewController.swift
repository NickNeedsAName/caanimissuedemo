//
//  ViewController.swift
//  WTFDemo
//
//  Created by Nick Grabenstein on 1/16/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func didTapPresent(_ sender: Any) {
        let vc = CAAnimationController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @IBAction func didTapPush(_ sender: Any) {
        let vc = HasAAcessoryViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

