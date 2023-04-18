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
    
    var containerHeightConstraint: NSLayoutConstraint = NSLayoutConstraint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(containerView)
        
        containerView.backgroundColor = .yellow
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: 10.0)
        
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
        
        addTagLabels()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        displayTagLabels()
        
    }
    
    func addTagLabels() -> Void {
        
        for j in 0..<self.tagNames.count {

            let newLabel = UILabel()
            
            newLabel.text = tagNames[j]
            newLabel.textAlignment = .center
            newLabel.backgroundColor = UIColor.cyan
            newLabel.layer.masksToBounds = true
            newLabel.layer.cornerRadius = 8
            newLabel.layer.borderColor = UIColor.red.cgColor
            newLabel.layer.borderWidth = 1

            newLabel.frame.size.width = newLabel.intrinsicContentSize.width + tagPadding
            newLabel.frame.size.height = tagHeight
            
            containerView.addSubview(newLabel)
            
            tagLabels.append(newLabel)
        }
    }
    
    func displayTagLabels() {
        
        let containerWidth = containerView.frame.size.width
        
        var currentOriginX: CGFloat = 0
        var currentOriginY: CGFloat = 0
        
        tagLabels.forEach { label in
            
            if currentOriginX + label.frame.width > containerWidth {
                currentOriginX = 0
                currentOriginY += tagHeight + tagSpacingY
            }
            
            label.frame.origin.x = currentOriginX
            label.frame.origin.y = currentOriginY
            
            currentOriginX += label.frame.width + tagSpacingX
            
        }
        
        containerHeightConstraint.constant = currentOriginY + tagHeight
        
    }
    
}
