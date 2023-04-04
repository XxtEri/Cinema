//
//  MainScreenView.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

import UIKit
import SnapKit

class MainScreenView: UIView {
    
    //- MARK: Private properties
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.alwaysBounceVertical = true
        view.frame = self.bounds
        view.contentInsetAdjustmentBehavior = .never

        return view
    }()
    
    private lazy var imageFilmCover: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "FilmCover")
        view.contentMode = .scaleToFill
        
        return view
    }()
    
    private lazy var watchButton: UIButton = {
        let view = UIButton()
        view.layer.cornerRadius = 4
        view.backgroundColor = .accentColorApplication
        view.setTitle("Смотреть", for: .normal)
        view.titleLabel?.font = UIFont(name: "SFProText-Bold", size: 14)
        view.setTitleColor(.white, for: .normal)
        view.contentEdgeInsets = UIEdgeInsets(top: 13, left: 32, bottom: 13, right: 32)
        
        return view
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private lazy var content: ContentMainScreenView = {
        let view = ContentMainScreenView()
        
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(imageFilmCover)
        imageFilmCover.addSubview(watchButton)
        contentView.addSubview(content)
        
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MainScreenView {
    func setup() {
        configureUI()
        configureConstraints()
    }
    
    func configureUI() {
        self.backgroundColor = .backgroundApplication
        print(UIScreen.main.bounds.height)
    }
    
    func configureConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(scrollView.frameLayoutGuide)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(100)
        }

        imageFilmCover.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(scrollView.contentLayoutGuide.snp.top)
            make.height.lessThanOrEqualTo(UIScreen.main.bounds.height * 60 / 100)
        }
        
        watchButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(120)
            make.bottom.equalToSuperview().inset(64)
        }

        content.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(imageFilmCover.snp.bottom).inset(-32)
            make.bottom.equalToSuperview()
        }
    }
}

extension MainScreenView {
    func setCoverImageMoview(with model: CoverMovie) {
        imageFilmCover.downloaded(from: model.backgroundImage, contentMode: imageFilmCover.contentMode)
    }
}
