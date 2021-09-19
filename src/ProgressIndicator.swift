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
    
    private var numberOfCircles: Int = 4
    private var circles: [CircleView] = []
    
    func configure(_ numberOfCircles: Int) {
        self.numberOfCircles = numberOfCircles
        removeExistingCircles()
        addCircles(with: self.frame.size.height)
    }
    
    private func removeExistingCircles() {
        self.arrangedSubviews.forEach { $0.removeFromSuperview() }
        circles = []
    }
    
    private func addCircles(with width: CGFloat) {
        for _ in 0..<numberOfCircles {
            let circle = CircleView.circle(with: width)
            circles.append(circle)
            self.addArrangedSubview(circle)
        }
    }
    
    func updateProgress(_ progress: Int) {
        if progress < 0 || progress > numberOfCircles { return }
        
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
    
    static func circle(with width: CGFloat) -> CircleView {
        let circle = CircleView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: width)))
        let constraint = NSLayoutConstraint(item: circle, attribute: .width, relatedBy: .equal, toItem: circle, attribute: .height, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: circle, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width)
        circle.addConstraints([constraint, widthConstraint])
        circle.isOn = false
        return circle
    }
    
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
