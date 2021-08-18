//
//  ProgressIndicator.swift
//  Private Photos
//
//  Created by Anum Mian on 27/03/2021.
//

import UIKit

/*
 
 number of steps
 
 views in an array inside a stack
 stack spacing
 
 func updateprogress
 go through the whole array and colour accordingly
 
 */

class ProgressIndicatorStackView : UIStackView {
    @IBOutlet var circles: [CircleView]!
    
    func updateProgress(_ progress: Int) {
        if progress < 0 || progress > 5 { return }
        
        var index = 0
        arrangedSubviews.forEach { (view) in
            if let view = view as? CircleView {
                view.isOn = index < progress ? true : false
                index += 1
            }
        }
    }
}

@IBDesignable class CircleView: UIView {
    
    @IBInspectable
    var isOn: Bool = false {
        didSet {
            self.backgroundColor = isOn ? .white : .clear
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.height/2
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.white.cgColor
    }
}
