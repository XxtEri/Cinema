//
//  MovieScreenView.swift
//  Cinema
//
//  Created by Елена on 01.04.2023.
//

import UIKit
import SnapKit

class MovieScreenView: UIView {
    
    private lazy var scroll: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.alwaysBounceVertical = true
        view.frame = self.bounds
        view.contentInsetAdjustmentBehavior = .never
        
        return view
    }()
    
    private lazy var imageCurrentFilm: UIImageView = {
        let view = UIImageView()
        
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(scroll)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MovieScreenView {
    func setup() {
        configureUI()
        configureConstraints()
    }
    
    func configureUI() {
        
    }
    
    func configureConstraints() {
        scroll.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
