//
//  CollectionsScreenCollectionViewCell.swift
//  Cinema
//
//  Created by Елена on 09.04.2023.
//

import UIKit
import SnapKit

class CollectionsScreenCollectionViewCell: UICollectionViewCell {
    
    //- MARK: Private properties
    
    private enum Metrics {
        static let imageIconCornerRadius: CGFloat = 40
        
        static let titleBlockTextSize: CGFloat = 14
        static let titleBlockTextKern: CGFloat = -0.17
        
        static let titleBlockLeadingInset: CGFloat = -18
    }
    
    private lazy var imageIcon: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = Metrics.imageIconCornerRadius
        view.clipsToBounds = true
        
        return view
    }()
    
    private lazy var titleBlock: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "SFProText-Bold", size: Metrics.titleBlockTextSize)
        view.attributedText = NSAttributedString(string: "", attributes: [.kern: Metrics.titleBlockTextKern])
        view.textColor = .white
        
        return view
    }()
    
    private lazy var imageArrowNext: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "ArrowNext")
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    
    //- MARK: Public static properties
    
    static let reuseIdentifier = "CollectionsScreenCollectionViewCell"
    
    
    //- MARK: Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(imageIcon)
        self.addSubview(titleBlock)
        self.addSubview(imageArrowNext)
        
       setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //- MARK: Public methods
    
    func configure(title: String, imageName: String) {
        titleBlock.text = title
        imageIcon.image = UIImage(named: imageName)
    }
}


//- MARK: Private extensions

private extension CollectionsScreenCollectionViewCell {
    
    //- MARK: Setup
    
    func setup() {
        configureConstraints()
    }
    
    func configureConstraints() {
        imageIcon.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        titleBlock.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalTo(imageIcon.snp.trailing).inset(Metrics.titleBlockLeadingInset)
            make.centerY.equalToSuperview()
        }
        
        imageArrowNext.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
}
