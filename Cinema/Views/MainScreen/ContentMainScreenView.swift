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
    }
}
