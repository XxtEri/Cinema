//
//  TrendMoviesBlockView.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

import UIKit
import SnapKit

class TrendMoviesBlockView: UIStackView {
    
    //- MARK: Private properties
    
    private enum Metrics {
        static let titleTrendsBlockTextSize: CGFloat = 24
        static let titleTrendsBlockSizeHeight: CGFloat = 29

        static let collectionTrendFilmsSizeHeight: CGFloat = 144
        
        static let stackSpacing: CGFloat = 16
        
        static let collectionViewWidth: CGFloat = 100
        static let collectionViewHeight: CGFloat = 144
        
        static let collectionViewSpacinSection: CGFloat = 16
    }
    
    private lazy var titleTrendsBlock: UILabel = {
        let view = UILabel()
        view.text = "В тренде"
        view.font = UIFont(name: "SFProText-Bold", size: Metrics.titleTrendsBlockTextSize)
        view.textColor = .accentColorApplication
        view.textAlignment = .left
        view.bounds.size.height = Metrics.titleTrendsBlockSizeHeight
        
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
        
        view.bounds.size.height = Metrics.collectionTrendFilmsSizeHeight
        
        return view
    }()
    
    private var arrayTrendMovies = [Movie]()
    
    
    //- MARK: Public properties
    
    var trendMoviePressed: ((Movie) -> Void)?
    
    
    //- MARK: Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addArrangedSubview(titleTrendsBlock)
        self.addArrangedSubview(collectionTrendFilms)
        
        setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //- MARK: Public methods
    
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


//- MARK: Private extensions

private extension TrendMoviesBlockView {
    
    //- MARK: Setup
    
    func setup() {
        configureConstraints()
        configureStack()
    }
    
    func configureStack() {
        self.axis = .vertical
        self.alignment = .leading
        self.spacing = Metrics.stackSpacing
    }

    func configureConstraints() {
        titleTrendsBlock.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
        }
        
        collectionTrendFilms.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
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
        trendMoviePressed?(arrayTrendMovies[indexPath.row])
    }
}


//- MARK: UICollectionViewFlowLayout

extension TrendMoviesBlockView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: Metrics.collectionViewWidth, height: Metrics.collectionViewHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        Metrics.collectionViewSpacinSection
    }
}
