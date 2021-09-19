//
//  PasscodeViewController.swift
//  Private Photos
//
//  Created by Anum Mian on 25/03/2021.
//

import UIKit
import LocalAuthentication

protocol PasscodeViewControllerDelegate {
    func passcodeController(_ controller: PasscodeViewController, didEnterPasscode passcode: String)
}

private struct PasscodeViewConfig {
    var label: String
    var numberOfDigits: Int
    var backgroundColour: UIColor
    var backgroundImage: UIImage?
}

class PasscodeViewController: UIViewController {
        
    private let CELL_IDENTIFIER = "PasscodeCell"
    private var config: PasscodeViewConfig?
    private var delegate: PasscodeViewControllerDelegate?
    private var passcode: String = ""
    
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var progressStackView: ProgressIndicatorStackView!
    @IBOutlet private var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: CELL_IDENTIFIER, bundle: nil), forCellWithReuseIdentifier: CELL_IDENTIFIER)
        progressStackView.updateProgress(0)
//        configure()
    }
    
    // MARK: Public methods
    
    func configure(with label: String = "Enter Passcode", numberOfDigits: Int = 4, backgroundColour: UIColor = .white, backgroundImage: UIImage? = nil, delegate: PasscodeViewControllerDelegate? = nil) {
        self.config = PasscodeViewConfig(label: label, numberOfDigits: numberOfDigits, backgroundColour: backgroundColour, backgroundImage: backgroundImage)
        self.delegate = delegate
        updateView()
    }
    
    func showIncorrectPasscodeState() {
        shakePips()
        resetView()
    }
}

private extension PasscodeViewController {
    
    func updateView() {
        guard let config = self.config, let view = self.view else {
            return
        }
        label.text = config.label
        imageView.image = config.backgroundImage
        view.backgroundColor = config.backgroundColour
        progressStackView.configure(config.numberOfDigits)
    }
    
    func authenticateViaFaceOrTouchID() {
        let context = LAContext()
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            let reason = "Identify yourself"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] (success, authenticationError) in
                
                DispatchQueue.main.async {
                    if success {
                        self?.unlockApp()
                    } else {
                        //TODO: Show error
                    }
                }
            }
        }
    }
    
    func unlockApp() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func shakePips() {
        progressStackView.shake()
    }
    
    func resetView() {
        progressStackView.updateProgress(0)
        passcode = ""
    }
}

extension PasscodeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IDENTIFIER, for: indexPath) as! PasscodeCell
        
        let row = indexPath.row
        if row <= 8 {
            cell.configure(with: row + 1)
        } else if row == 10 {
            cell.configure(with: 0)
        } else if row == 9 {
            if LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
                cell.configureAsFaceID()
            } else {
                cell.hide()
            }
        } else if row == 11 {
            cell.configureAsDeleteButton()
        }
        return cell
    }
}

extension PasscodeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let config = config else { return }
        
        if indexPath.row == 11 {
            //delete button pressed
            if passcode.count > 0 {
                passcode.removeLast()
                progressStackView.updateProgress(passcode.count)
            }
            return
        }
        
        if indexPath.row == 9 {
            //touch/Face ID button pressed
            authenticateViaFaceOrTouchID()
            return
        }
        
        if passcode.count < config.numberOfDigits {
            passcode.append(String(indexPath.row + 1))
            progressStackView.updateProgress(passcode.count)
        }
        
        if passcode.count == config.numberOfDigits {
            delegate?.passcodeController(self, didEnterPasscode: passcode)
        }
    }
    
}

extension PasscodeViewController: UICollectionViewDelegateFlowLayout
{
    //MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: collectionView.frame.size.width/4,
                      height: collectionView.frame.size.height/4.5)
    }
}

extension UIView {
    
    func shake() {
        let shake = CABasicAnimation(keyPath: "position")
        let xDelta = CGFloat(5)
        shake.duration = 0.08
        shake.repeatCount = 3
        shake.autoreverses = true
        
        let from_point = CGPoint(x: self.center.x - xDelta, y: self.center.y)
        let from_value = NSValue(cgPoint: from_point)
        
        let to_point = CGPoint(x: self.center.x + xDelta, y: self.center.y)
        let to_value = NSValue(cgPoint: to_point)
        
        shake.fromValue = from_value
        shake.toValue = to_value
        shake.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        self.layer.add(shake, forKey: "position")
    }
}
