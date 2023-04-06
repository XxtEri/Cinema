//
//  TrendMoviesBlockView.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

import UIKit
import SnapKit

class TrendMoviesBlockView: UIStackView {
    private lazy var titleTrendsBlock: UILabel = {
        let view = UILabel()
        view.text = "В тренде"
        view.font = UIFont(name: "SFProText-Bold", size: 24)
        view.textColor = .accentColorApplication
        view.textAlignment = .left
        view.bounds.size.height = 29
        
        return view
    }()
    
    private lazy var collectionTrendFilms: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        var view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        view.register(TrendMovieCollectionViewCell.self, forCellWithReuseIdentifier: TrendMovieCollectionViewCell.reuseIdentifier)
        view.delegate = self
        view.dataSource = self
        
        view.backgroundColor = .backgroundApplication
        
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        
        view.bounds.size.height = 144
        
        return view
    }()
    
    private var arrayTrendMovies = [Movie]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addArrangedSubview(titleTrendsBlock)
        self.addArrangedSubview(collectionTrendFilms)
        
        setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getHeightView() -> CGFloat {
        let titleHeight = titleTrendsBlock.bounds.size.height
        let collectionHeight = collectionTrendFilms.bounds.size.height
        let spacing = self.spacing
        
        return titleHeight + collectionHeight + spacing
    }
    
    func addNewMovie(movie: Movie) {
        arrayTrendMovies.append(movie)
        
        DispatchQueue.main.async {
            self.reloadCollectionViewData()
        }
    }
    
    func reloadCollectionViewData() {
        self.collectionTrendFilms.reloadData()
    }
}

private extension TrendMoviesBlockView {
    func setup() {
        configureConstraints()
        configureStack()
    }
    
    func configureStack() {
        self.axis = .vertical
        self.alignment = .leading
        self.spacing = 16
    }

    func configureConstraints() {
        collectionTrendFilms.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
        }
    }
}

//- MARK: UICollectionViewDataSource

extension TrendMoviesBlockView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrayTrendMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendMovieCollectionViewCell.reuseIdentifier, for: indexPath) as? TrendMovieCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: arrayTrendMovies[indexPath.row])
        
        return cell
    }
}


//- MARK: UICollectionViewDelegate

extension TrendMoviesBlockView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

//- MARK: UICollectionViewFlowLayout

extension TrendMoviesBlockView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 100, height: 144)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        16
    }
}
