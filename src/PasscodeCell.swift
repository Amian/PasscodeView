//
//  PasscodeCell.swift
//  PasscodeView
//
//  Created by Anum Mian on 18/08/2021.
//

import UIKit

class PasscodeCell: UICollectionViewCell {
    
    @IBOutlet private var button: UIButton!
    
    func configure(with number: Int) {
        button.setTitle(String(number), for: .normal)
        button.isHidden = false
    }
    
    func configureAsFaceID() {
        button.setTitle("", for: .normal)
        button.setImage(UIImage(systemName: "faceid"), for: .normal)
        let config = UIImage.SymbolConfiguration(pointSize: 25)
        button.setPreferredSymbolConfiguration(config, forImageIn: .normal)
        button.tintColor = .darkGray //TODO: add correct colour
    }
    
    func configureAsDeleteButton() {
        button.setTitle("", for: .normal)
        let image = UIImage(systemName: "delete.left.fill")
        button.setImage(image, for: .normal)
        let config = UIImage.SymbolConfiguration(pointSize: 35)
        button.setPreferredSymbolConfiguration(config, forImageIn: .normal)
        button.tintColor = .white
        button.backgroundColor = .clear
    }
    
    func hide() {
        button.isHidden = true
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        //TODO: Find a better place to put this code
        self.button.layer.cornerRadius = button.frame.size.height/2
    }
}
