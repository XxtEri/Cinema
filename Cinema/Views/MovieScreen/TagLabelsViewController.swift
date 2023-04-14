//
//  TagLabelsViewController.swift
//  Cinema
//
//  Created by Елена on 13.04.2023.
//

import UIKit
import SnapKit

class TagLabelsViewController: UIViewController {
    
    let containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    let tagNames: [String] = [
        "First Tag",
        "Second",
        "Third Tag",
        "Fourth",
        "The Fifth Tag",
        "Sixth",
        "Seventh",
        "Tag Eight",
        "Here are some Letter Tags",
        "A", "B", "C", "D", "E", "F", "G", "H", "I", "J",
        "Nine",
        "Ten",
        "Eleven",
        "Tag Twelve",
        "Tag 13",
        "Fourteen",
        "Fifteen",
        "Sixteen",
        "Seventeen",
        "Eightteen",
        "Nineteen",
        "Last Tag",
    ]
    
    var tagLabels = [UILabel]()
    
    let tagHeight:CGFloat = 30
    let tagPadding: CGFloat = 16
    let tagSpacingX: CGFloat = 8
    let tagSpacingY: CGFloat = 8
    
    // container view height will be modified when laying out subviews
    var containerHeightConstraint: NSLayoutConstraint = NSLayoutConstraint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add the container view
        view.addSubview(containerView)
        
        // give it a background color so we can see it
        containerView.backgroundColor = .yellow
        
        // use autolayout
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // initialize height constraint - actual height will be set later
        containerHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: 10.0)
        
        // constrain container safe-area top / leading / trailing to view with 20-pts padding
        let g = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: g.topAnchor, constant: 20.0),
            containerView.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 20.0),
            containerView.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: -20.0),
            containerHeightConstraint,
        ])
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(20)
            make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide.snp.horizontalEdges).inset(20)
        }
        
        // add the buttons to the scroll view
        addTagLabels()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // call this here, after views have been laid-out
        // this will also be called when the size changes, such as device rotation,
        // so the buttons will "re-layout"
        displayTagLabels()
        
    }
    
    func addTagLabels() -> Void {
        
        for j in 0..<self.tagNames.count {
            
            // create a new label
            let newLabel = UILabel()
            
            // set its properties (title, colors, corners, etc)
            newLabel.text = tagNames[j]
            newLabel.textAlignment = .center
            newLabel.backgroundColor = UIColor.cyan
            newLabel.layer.masksToBounds = true
            newLabel.layer.cornerRadius = 8
            newLabel.layer.borderColor = UIColor.red.cgColor
            newLabel.layer.borderWidth = 1

            // set its frame width and height
            newLabel.frame.size.width = newLabel.intrinsicContentSize.width + tagPadding
            newLabel.frame.size.height = tagHeight
            
            // add it to the scroll view
            containerView.addSubview(newLabel)
            
            // append it to tagLabels array
            tagLabels.append(newLabel)
        }
    }
    
    func displayTagLabels() {
        
        let containerWidth = containerView.frame.size.width
        
        var currentOriginX: CGFloat = 0
        var currentOriginY: CGFloat = 0
        
        // for each label in the array
        tagLabels.forEach { label in
            
            // if current X + label width will be greater than container view width
            //  "move to next row"
            if currentOriginX + label.frame.width > containerWidth {
                currentOriginX = 0
                currentOriginY += tagHeight + tagSpacingY
            }
            
            // set the btn frame origin
            label.frame.origin.x = currentOriginX
            label.frame.origin.y = currentOriginY
            
            // increment current X by btn width + spacing
            currentOriginX += label.frame.width + tagSpacingX
            
        }
        
        // update container view height
        containerHeightConstraint.constant = currentOriginY + tagHeight
        
    }
    
}
