//
//  IconSelectionScreenCollectionViewCell.swift
//  Cinema
//
//  Created by Елена on 14.04.2023.
//

import UIKit
import SnapKit

class IconSelectionScreenCollectionViewCell: UICollectionViewCell {
    
    //- MARK: Private properties
    
    private enum Metrics {
        static let imageIconHeightWidth: CGFloat = 74
    }
    
    private var imageIcon: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    
    //- MARK: Public static properties
    
    static let reuseIdentifier = "IconSelectionScreenCollectionViewCell"
    
    
    //- MARK: Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(imageIcon)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //- MARK: Public methods
    
    func configureCell(imageName: String) {
        imageIcon.image = UIImage(named: imageName)
    }
}


//- MARK: Public extensions

private extension IconSelectionScreenCollectionViewCell {
    
    //- MARK: Setup
    
    func setup() {
        configureConstraints()
    }
    
    func configureConstraints() {
        imageIcon.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.width.equalTo(Metrics.imageIconHeightWidth)
        }
    }
}
