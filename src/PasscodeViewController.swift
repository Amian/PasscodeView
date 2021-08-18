//
//  PasscodeViewController.swift
//  Private Photos
//
//  Created by Anum Mian on 25/03/2021.
//

import UIKit
import LocalAuthentication

class PasscodeViewController: UIViewController {
    
    private let CELL_IDENTIFIER = "PasscodeCell"
    private let MAX_DIGITS_ALLOWED = 5
    
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var progressStackView: ProgressIndicatorStackView!
    
    private var progress = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: CELL_IDENTIFIER, bundle: nil), forCellWithReuseIdentifier: CELL_IDENTIFIER)
        setBackgroundGif()
        progressStackView.updateProgress(progress)
    }
}

private extension PasscodeViewController {
    
    func setBackgroundGif() {
//        imageView.image = UIImage.gif(name: "water")
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
        
        if indexPath.row == 11 {
            //delete button pressed
            if progress > 0 {
                progress -= 1
                progressStackView.updateProgress(progress)
            }
            return
        }
        
        if indexPath.row == 9 {
            //touch/Face ID button pressed
            authenticateViaFaceOrTouchID()
            return
        }
        
        if progress < MAX_DIGITS_ALLOWED {
            progress += 1
            progressStackView.updateProgress(progress)
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
