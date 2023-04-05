//
//  InformationMovieCollectionViewCell.swift
//  Cinema
//
//  Created by Елена on 01.04.2023.
//

import UIKit
import SnapKit

class InformationMovieCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "InformationMovieCollectionViewCell"
    
    private lazy var title: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.attributedText = NSAttributedString(string: "Bla", attributes: [.kern: -0.41])
        view.font = UIFont(name: "SFProText-Regular", size: 14)
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .accentColorApplication
        self.addSubview(title)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String) {
        self.title.text = title
    }
    
    func getWidth() -> CGFloat {
        let titleWidth = self.title.intrinsicContentSize.width
        return titleWidth
    }
}

private extension InformationMovieCollectionViewCell {
    func setup() {
        configureConstraints()
        configureCell()
    }
    
    func configureCell() {
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
    }
    
    func configureConstraints() {
        title.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.verticalEdges.equalToSuperview().inset(1)
        }
    }
}
