//
//  ViewController.swift
//  PasscodeView
//
//  Created by Anum Mian on 12/08/2021.
//

import UIKit

class ViewController: UIViewController, PasscodeViewControllerDelegate {

    let passcode = "5492"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let controller = PasscodeViewController(nibName: "PasscodeViewController", bundle: nil)
        controller.configure(with: "Enter itt", numberOfDigits: passcode.count, backgroundColour: .yellow, delegate: self)
        self.navigationController?.pushViewController(controller, animated: true)
    }

    func passcodeController(_ controller: PasscodeViewController, didEnterPasscode passcode: String) {
        if passcode == self.passcode {
            self.navigationController?.popViewController(animated: true)
        } else {
            controller.showIncorrectPasscodeState()
        }
    }
}

