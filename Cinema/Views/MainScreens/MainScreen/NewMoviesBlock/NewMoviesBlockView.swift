//
//  NewMoviesBlockView.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

import UIKit
import SnapKit

class NewMoviesBlockView: UIStackView {
    
    //- MARK: Private properties
    
    private enum Metrics {
        static let titleNewFilmBlockTextSize: CGFloat = 24
        static let titleNewFilmBlockSizeHeight: CGFloat = 29
        
        static let collectionNewFilmsSizeHeight: CGFloat = 144
        
        static let stackSpacing: CGFloat = 16
        
        static let cellWidth: CGFloat = 60 * UIScreen.main.bounds.width / 100
        static let cellHeight: CGFloat = 144
    }
    
    private lazy var titleNewFilmBlock: UILabel = {
        let view = UILabel()
        view.text = "Новое"
        view.font = UIFont(name: "SFProText-Bold", size: Metrics.titleNewFilmBlockTextSize)
        view.textColor = .accentColorApplication
        view.textAlignment = .left
        view.bounds.size.height = Metrics.titleNewFilmBlockSizeHeight
        
        return view
    }()
    
    private lazy var collectionNewFilms: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        var view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        view.register(NewMovieCollectionViewCell.self, forCellWithReuseIdentifier: NewMovieCollectionViewCell.reuseIdentifier)
        view.delegate = self
        view.dataSource = self
        
        view.backgroundColor = .backgroundApplication

        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false

        view.bounds.size.height = Metrics.collectionNewFilmsSizeHeight
        
        return view
    }()
    
    private var arrayNewMovies = [Movie]()
    
    
    //- MARK: Public properties
    
    var newMoviePressed: ((Movie) -> Void)?
    
    
    //- MARK: Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addArrangedSubview(titleNewFilmBlock)
        self.addArrangedSubview(collectionNewFilms)
        
        setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //- MARK: Public methods
    
    func getHeightView() -> CGFloat {
        let titleHeight = titleNewFilmBlock.bounds.size.height
        let collectionHeight = collectionNewFilms.bounds.size.height
        let spacing = self.spacing
        
        return titleHeight + collectionHeight + spacing
    }
    
    func addNewMovie(movie: Movie) {
        arrayNewMovies.append(movie)
        
        DispatchQueue.main.async {
            self.reloadCollectionViewData()
        }
    }
    
    func reloadCollectionViewData() {
        self.collectionNewFilms.reloadData()
    }
    
}


//- MARK: Private extensions

private extension NewMoviesBlockView {
    
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
        collectionNewFilms.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
}


//- MARK: - UICollectionViewDataSource

extension NewMoviesBlockView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrayNewMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewMovieCollectionViewCell.reuseIdentifier, for: indexPath) as? NewMovieCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: arrayNewMovies[indexPath.row])
        
        return cell
    }
    
}


//- MARK: UICollectionViewDelegate

extension NewMoviesBlockView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        newMoviePressed?(arrayNewMovies[indexPath.row])
    }
    
}

//- MARK: UICollectionViewFlowLayout

extension NewMoviesBlockView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = Metrics.cellWidth

        return CGSize(width: width, height: Metrics.cellWidth)
    }
}


