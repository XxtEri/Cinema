//
//  TagLabelsView.swift
//  Cinema
//
//  Created by Елена on 13.04.2023.
//

import UIKit

class TagLabelsView: UIView {
    
    var tagNames: [Tag] = [] {
        didSet {
            addTagLabels()
        }
    }
    
    let tagHeight:CGFloat = 30
    let tagPadding: CGFloat = 16
    let tagSpacingX: CGFloat = 8
    let tagSpacingY: CGFloat = 8
    
    var intrinsicHeight: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func addTagLabels() -> Void {
        while self.subviews.count > tagNames.count {
            self.subviews[0].removeFromSuperview()
        }
        
        while self.subviews.count < tagNames.count {
            let newLabel = UILabel()
            
            newLabel.textColor = .white
            newLabel.textAlignment = .center
            newLabel.backgroundColor = .accentColorApplication
            newLabel.layer.masksToBounds = true
            newLabel.layer.cornerRadius = 4
            
            self.addSubview(newLabel)
        }
        
        for (tag, v) in zip(tagNames, self.subviews) {
            guard let label = v as? UILabel else {
                fatalError("non-UILabel subview found!")
            }
            
            label.text = tag.tagName
            label.frame.size.width = label.intrinsicContentSize.width + tagPadding
            label.frame.size.height = tagHeight
        }
        
    }
    
    func displayTagLabels() {
        
        var currentOriginX: CGFloat = 0
        var currentOriginY: CGFloat = 0
        
        // for each label in the array
        self.subviews.forEach { v in
            
            guard let label = v as? UILabel else {
                fatalError("non-UILabel subview found!")
            }
            
            // if current X + label width will be greater than container view width
            //  "move to next row"
            if currentOriginX + label.frame.width > bounds.width {
                currentOriginX = 0
                currentOriginY += tagHeight + tagSpacingY
            }
            
            // set the btn frame origin
            label.frame.origin.x = currentOriginX
            label.frame.origin.y = currentOriginY
            
            // increment current X by btn width + spacing
            currentOriginX += label.frame.width + tagSpacingX
            
        }
        
        // update intrinsic height
        intrinsicHeight = currentOriginY + tagHeight
        invalidateIntrinsicContentSize()
        
    }
    
    override var intrinsicContentSize: CGSize {
        var view = super.intrinsicContentSize
        view.height = intrinsicHeight
        return view
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        displayTagLabels()
    }
    
}
