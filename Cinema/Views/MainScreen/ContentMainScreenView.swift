//
//  ContentMainScreenView.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

import UIKit
import SnapKit

class ContentMainScreenView: UIView {
    private var contentStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 32
        
        return view
    }()
    
    private lazy var specifyInterests: UIButton = {
        let view = UIButton()
        view.layer.cornerRadius = 4
        view.backgroundColor = .accentColorApplication
        view.titleLabel?.font = UIFont(name: "SFProText-Bold", size: 14)
        view.setAttributedTitle(NSAttributedString(string: "Указать интересы", attributes: [.kern: -0.17]), for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.contentEdgeInsets = UIEdgeInsets(top: 13, left: 32, bottom: 13, right: 32)
        
        return view
    }()
    
    let trendBlock = TrendMoviesBlockView()
    let watchBlock = LastWatchMovieBlockView()
    let newBlock = NewMoviesBlockView()
    let recomendationBlock = RecomendationMoviesBlockView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(contentStack)
        contentStack.addArrangedSubview(trendBlock)
        contentStack.addArrangedSubview(watchBlock)
        contentStack.addArrangedSubview(newBlock)
        contentStack.addArrangedSubview(recomendationBlock)
        contentStack.addArrangedSubview(specifyInterests)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ContentMainScreenView {
    func setup() {
        configureConstraints()
    }
    
    func configureConstraints() {
        contentStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        trendBlock.snp.makeConstraints { make in
            make.height.equalTo(trendBlock.getHeightView())
        }
        
        watchBlock.snp.makeConstraints { make in
            make.height.equalTo(watchBlock.getHeightView())
        }
        
        newBlock.snp.makeConstraints { make in
            make.height.equalTo(newBlock.getHeightView())
        }
        
        recomendationBlock.snp.makeConstraints { make in
            make.height.equalTo(recomendationBlock.getHeightView())
        }
        
        specifyInterests.snp.makeConstraints { make in
            make.height.lessThanOrEqualTo(44)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}
