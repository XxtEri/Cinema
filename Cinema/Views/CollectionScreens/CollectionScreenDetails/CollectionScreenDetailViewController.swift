//
//  CollectionScreenDetailViewController.swift
//  Cinema
//
//  Created by Елена on 15.04.2023.
//

import UIKit

class CollectionScreenDetailViewController: UIViewController {
    
    private enum Metrics {
        static let itemsInRow = 1
        static let cellHeight: CGFloat = 80
        static let viewInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        static let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        static let lineSpace: CGFloat = 16
    }
    
    private let ui: CollectionScreenDetailView
    var viewModel: CollectionScreenViewModel?
    
    var collection: CollectionList
    var movies = [Movie]()
    
    init(collection: CollectionList) {
        self.ui = CollectionScreenDetailView()
        self.collection = collection
        
        super.init(nibName: nil, bundle: nil)
        
        self.ui.configureCollectionView(delegate: self, dataSource: self)
        self.ui.setCollection(collection: collection)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = ui
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        handler()
        bindListener()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewModel?.getMovieInCollection(collectionId: self.collection.collectionId)
    }
}

private extension CollectionScreenDetailViewController {
    func handler() {
        self.ui.backToGoCollectionsScreenButtonPressed = { [ weak self ] in
            guard let self = self else { return }
            
            self.viewModel?.goToCollectionsScreen()
        }
        
        self.ui.buttonEditCollectionPressed = { [ weak self ] collection in
            guard let self = self else { return }
            
            self.viewModel?.goToCreateEditingCollectionScreen(isCreatingCollection: false, collection: collection)
        }
    }
    
    func bindListener() {
        self.viewModel?.moviesCollection.subscribe(with: { movies in
            self.movies = movies
            self.ui.reloadData()
        })
    }
}

extension CollectionScreenDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionScreenDetailCollectionViewCell.reuseIdentifier, for: indexPath) as? CollectionScreenDetailCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(movie: movies[indexPath.row])
        
        return cell
    }
    
}

extension CollectionScreenDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel?.goToMovieScreen(movie: movies[indexPath.row])
    }
}

extension CollectionScreenDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath ) -> CGSize {
        
        let sideInsets = (Metrics.insets.left + Metrics.viewInsets.left) * 2
        let insetsSum = sideInsets
        let otherSpace = collectionView.frame.width - insetsSum
        let cellWidth = otherSpace / CGFloat(Metrics.itemsInRow)
        
        return CGSize(width: cellWidth, height: Metrics.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        Metrics.insets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        Metrics.lineSpace
    }
}
