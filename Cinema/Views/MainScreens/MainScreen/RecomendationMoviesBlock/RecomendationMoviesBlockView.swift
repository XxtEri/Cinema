//
//  RecomendationMoviesBlockView.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

import UIKit
import SnapKit

class RecomendationMoviesBlockView: UIStackView {
    
    //- MARK: Private properties
    
    private enum Metrics {
        static let titleNewFilmBlockTextSize: CGFloat = 24
        static let titleNewFilmBlockSizeHeight: CGFloat = 29
        
        static let collectionRecomenrationFilmsSizeHeight: CGFloat = 144
        
        static let stackSpacing: CGFloat = 16
        
        static let spacingSection: CGFloat = 16
    }
    
    private lazy var titleNewFilmBlock: UILabel = {
        let view = UILabel()
        view.text = "Для вас"
        view.font = UIFont(name: "SFProText-Bold", size: Metrics.titleNewFilmBlockTextSize)
        view.textColor = .accentColorApplication
        view.textAlignment = .left
        view.bounds.size.height = Metrics.titleNewFilmBlockSizeHeight
        
        return view
    }()
    
    private lazy var collectionRecomenrationFilms: UICollectionView = {
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

        view.bounds.size.height = Metrics.collectionRecomenrationFilmsSizeHeight
        
        return view
    }()
    
    private var arrayRecomendationMovies = [Movie]()
    
    
    //- MARK: Public properties
    
    var recomendationMoviePressed: ((Movie) -> Void)?
    
    
    //- MARK: Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        self.addArrangedSubview(titleNewFilmBlock)
        self.addArrangedSubview(collectionRecomenrationFilms)
        
        setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //- MARK: Public methods
    
    func getHeightView() -> CGFloat {
        let titleHeight = titleNewFilmBlock.bounds.size.height
        let collectionHeight = collectionRecomenrationFilms.bounds.size.height
        let spacing = self.spacing
        
        return titleHeight + collectionHeight + spacing
    }
    
    func addNewMovie(movie: Movie) {
        arrayRecomendationMovies.append(movie)
        
        DispatchQueue.main.async {
            self.reloadCollectionViewData()
        }
    }
    
    func reloadCollectionViewData() {
        self.collectionRecomenrationFilms.reloadData()
    }
}


//- MARK: Private extensions

private extension RecomendationMoviesBlockView {
    
    //- MARK: Setup
    
    func setup() {
        configureConstraints()
        configureStack()
    }
    
    func configureStack() {
        self.axis = .vertical
        self.spacing = Metrics.stackSpacing
    }

    func configureConstraints() {
        titleNewFilmBlock.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
        }
        
        collectionRecomenrationFilms.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}


//- MARK: UICollectionViewDataSource

extension RecomendationMoviesBlockView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrayRecomendationMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecomendationMovieCollectionViewCell.reuseIdentifier, for: indexPath) as? RecomendationMovieCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: arrayRecomendationMovies[indexPath.row])
        
        return cell
    }
    
}


//- MARK: UICollectionViewDelegate

extension RecomendationMoviesBlockView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        recomendationMoviePressed?(arrayRecomendationMovies[indexPath.row])
    }
    
}

//- MARK: UICollectionViewFlowLayout

extension RecomendationMoviesBlockView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 26.6 * UIScreen.main.bounds.width / 100

        return CGSize(width: width, height: 144)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        Metrics.spacingSection
    }
}

