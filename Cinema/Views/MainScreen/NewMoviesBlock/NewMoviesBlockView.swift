//
//  NewMoviesBlockView.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

import UIKit
import SnapKit

class NewMoviesBlockView: UIStackView {
    
    private lazy var titleNewFilmBlock: UILabel = {
        let view = UILabel()
        view.text = "Новое"
        view.font = UIFont(name: "SFProText-Bold", size: 24)
        view.textColor = .accentColorApplication
        view.textAlignment = .left
        
        return view
    }()
    
    private lazy var listNewFilms: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = CGFLOAT_MAX
        
        var view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        view.register(NewMovieCollectionViewCell.self, forCellWithReuseIdentifier: NewMovieCollectionViewCell.reuseIdentifier)
        view.delegate = self
        view.dataSource = self
        
        view.backgroundColor = .backgroundApplication
        view.contentInsetAdjustmentBehavior = .never
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addArrangedSubview(titleNewFilmBlock)
        self.addArrangedSubview(listNewFilms)
        
        setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension NewMoviesBlockView {
    func setup() {
        configureConstraints()
    }

    func configureConstraints() {
        titleNewFilmBlock.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
        }
        
        listNewFilms.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.top.equalTo(titleNewFilmBlock.snp.bottom).inset(-16)
        }
    }
}

//- MARK: UICollectionViewDataSource

extension NewMoviesBlockView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewMovieCollectionViewCell.reuseIdentifier, for: indexPath) as? NewMovieCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        return cell
    }
    
}

//- MARK: UICollectionViewDelegate

extension NewMoviesBlockView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

//- MARK: UICollectionViewFlowLayout

extension NewMoviesBlockView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 60 * UIScreen.main.bounds.width / 100

        return CGSize(width: width, height: 144)
    }
}


