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
        view.bounds.size.height = 29
        
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

        view.bounds.size.height = 144
        
        return view
    }()
    
    private var arrayNewMovies = [Movie]()
    
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
    
    func addNewMovie(movie: Movie) {
        arrayNewMovies.append(movie)
        print(movie)
        
        DispatchQueue.main.async {
            self.reloadCollectionViewData()
        }
    }
    
    func reloadCollectionViewData() {
        self.collectionNewFilms.reloadData()
    }
    
}

private extension NewMoviesBlockView {
    func setup() {
        configureConstraints()
        configureStack()
    }
    
    func configureStack() {
        self.axis = .vertical
        self.spacing = 16
    }

    func configureConstraints() {
        collectionNewFilms.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
}

//- MARK: UICollectionViewDataSource

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
        
    }
    
}

//- MARK: UICollectionViewFlowLayout

extension NewMoviesBlockView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 60 * UIScreen.main.bounds.width / 100

        return CGSize(width: width, height: 144)
    }
}


