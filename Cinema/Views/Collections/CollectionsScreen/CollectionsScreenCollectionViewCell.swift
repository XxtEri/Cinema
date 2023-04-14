//
//  CollectionsScreenCollectionViewCell.swift
//  Cinema
//
//  Created by Елена on 09.04.2023.
//

import UIKit

class CollectionsScreenCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "CollectionsScreenCollectionViewCell"
    
    private lazy var imageIcon: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 40
        view.clipsToBounds = true
        
        return view
    }()
    
    private lazy var titleBlock: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "SFProText-Bold", size: 14)
        view.attributedText = NSAttributedString(string: "", attributes: [.kern: -0.17])
        view.textColor = .white
        
        return view
    }()
    
    private lazy var imageArrowNext: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "ArrowNext")
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(imageIcon)
        self.addSubview(titleBlock)
        self.addSubview(imageArrowNext)
        
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, imageName: String) {
        titleBlock.text = title
        imageIcon.image = UIImage(named: imageName)
    }
}

private extension CollectionsScreenCollectionViewCell {
    func configureConstraints() {
        imageIcon.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        titleBlock.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalTo(imageIcon.snp.trailing).inset(-18)
            make.centerY.equalToSuperview()
        }
        
        imageArrowNext.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
}
