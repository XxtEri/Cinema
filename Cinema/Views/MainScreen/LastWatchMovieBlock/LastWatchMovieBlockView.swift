//
//  LastWatchMovieBlockView.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

import UIKit
import SnapKit

class LastWatchMovieBlockView: UIView {
    private lazy var titleBlock: UILabel = {
        let view = UILabel()
        view.text = "Вы смотрели"
        view.font = UIFont(name: "SFProText-Bold", size: 24)
        view.textColor = .accentColorApplication
        view.textAlignment = .left
        
        return view
    }()
    
    private lazy var filmImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "NewFilm")
        view.contentMode = .scaleAspectFill

        
        return view
    }()
    
    private lazy var titleFilm: UILabel = {
        let view = UILabel()
        view.text = "Altered Carbon"
        view.font = UIFont(name: "SFProText-Bold", size: 14)
        view.textColor = .white
        view.textAlignment = .left
        
        return view
    }()
    
    private lazy var imagePlay: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Play")
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(titleBlock)
        self.addSubview(filmImage)
        
        filmImage.addSubview(titleFilm)
        filmImage.addSubview(imagePlay)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension LastWatchMovieBlockView {
    func setup() {
        configureConstraints()
    }
    
    func configureConstraints() {
        titleBlock.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalToSuperview()
        }
        
        filmImage.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(titleBlock.snp.bottom).inset(-32)
            make.bottom.equalToSuperview()
        }
        
        imagePlay.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.verticalEdges.lessThanOrEqualToSuperview().inset(50)
        }
        
        titleFilm.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(16)
        }
        
    }
}

