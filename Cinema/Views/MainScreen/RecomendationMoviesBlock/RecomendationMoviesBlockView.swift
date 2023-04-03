//
//  RecomendationMoviesBlockView.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

import UIKit
import SnapKit

class RecomendationMoviesBlockView: UIStackView {
    
    private lazy var titleNewFilmBlock: UILabel = {
        let view = UILabel()
        view.text = "Для вас"
        view.font = UIFont(name: "SFProText-Bold", size: 24)
        view.textColor = .accentColorApplication
        view.textAlignment = .left
        view.bounds.size.height = 29
        
        return view
    }()
    
    private lazy var collectionNewFilms: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = CGFLOAT_MAX
        
        var view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        view.register(RecomendationMovieCollectionViewCell.self, forCellWithReuseIdentifier: RecomendationMovieCollectionViewCell.reuseIdentifier)
        view.delegate = self
        view.dataSource = self
        
        view.backgroundColor = .backgroundApplication
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false

        view.bounds.size.height = 144
        
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        self.addArrangedSubview(titleNewFilmBlock)
        self.addArrangedSubview(collectionNewFilms)
        
        setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getHeightView() -> CGFloat {
        let titleHeight = titleNewFilmBlock.bounds.size.height
        let collectionHeight = collectionNewFilms.bounds.size.height
        let spacing = self.spacing
        
        return titleHeight + collectionHeight + spacing
    }
}

private extension RecomendationMoviesBlockView {
    func setup() {
        configureConstraints()
        configureStack()
    }
    
    func configureStack() {
        self.axis = .vertical
        self.spacing = 16
    }

    func configureConstraints() {
        titleNewFilmBlock.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
        }
        
        collectionNewFilms.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.top.equalTo(titleNewFilmBlock.snp.bottom).inset(-16)
        }
    }
}

//- MARK: UICollectionViewDataSource

extension RecomendationMoviesBlockView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecomendationMovieCollectionViewCell.reuseIdentifier, for: indexPath) as? RecomendationMovieCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        return cell
    }
    
}


//- MARK: UICollectionViewDelegate

extension RecomendationMoviesBlockView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

//- MARK: UICollectionViewFlowLayout

extension RecomendationMoviesBlockView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 26.6 * UIScreen.main.bounds.width / 100

        return CGSize(width: width, height: 144)
    }
}

