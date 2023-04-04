//
//  LastWatchMovieBlockView.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

import UIKit
import SnapKit

class LastWatchMovieBlockView: UIStackView {
    private lazy var titleBlock: UILabel = {
        let view = UILabel()
        view.text = "Вы смотрели"
        view.font = UIFont(name: "SFProText-Bold", size: 24)
        view.textColor = .accentColorApplication
        view.textAlignment = .left
        view.bounds.size.height = 29
        
        return view
    }()
    
    private lazy var filmImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "WatchFilm")
        view.contentMode = .scaleAspectFill
        view.bounds.size.height = 240
        
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
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addArrangedSubview(titleBlock)
        self.addArrangedSubview(filmImage)
        
        filmImage.addSubview(titleFilm)
        filmImage.addSubview(imagePlay)
        
        setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getHeightView() -> CGFloat {
        let titleHeight = titleBlock.bounds.size.height
        let filmImageHeight = filmImage.bounds.size.height
        let spacing = self.spacing
        
        return titleHeight + filmImageHeight + spacing
    }
}

private extension LastWatchMovieBlockView {
    func setup() {
        configureConstraints()
        configureStack()
    }
    
    func configureStack() {
        self.axis = .vertical
        self.spacing = 16
    }
    
    func configureConstraints() {
        imagePlay.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.verticalEdges.lessThanOrEqualToSuperview().inset(50)
        }
        
        titleFilm.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(16)
        }
        
        filmImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(0)
        }
    }
}

