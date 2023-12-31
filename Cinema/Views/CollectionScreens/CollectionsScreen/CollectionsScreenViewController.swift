//
//  CollectionsScreenViewController.swift
//  Cinema
//
//  Created by Елена on 09.04.2023.
//

import UIKit
import RealmSwift

final class CollectionsScreenViewController: UIViewController {
    
    //- MARK: Private properties
    
    private enum Metrics {
        static let itemsInRow = 1
        static let cellHeight: CGFloat = 44
        static let viewInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        static let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        static let lineSpace: CGFloat = 23.5
    }
    
    private let ui: CollectionsScreenView
    
    
    //- MARK: Public properties
    
    var viewModel: CollectionScreenViewModel?
    
    var collectionList: Results<CollectionList>?
    
    
    //- MARK: Inits
    
    init() {
        self.ui = CollectionsScreenView()
        
        super.init(nibName: nil, bundle: nil)
        
        ui.configureCollectionView(delegate: self, dataSource: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //- MARK: Lifecycle
    
    override func loadView() {
        self.view = ui
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        handler()
        bindListener()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewModel?.getCollection()
    }
}


//- MARK: Private extensions

private extension CollectionsScreenViewController {
    func handler() {
        self.ui.buttonAddingNewCollectionPressed = { [ weak self ] in
            guard let self = self else { return }
            
            self.viewModel?.goToCreateEditingCollectionScreen(isCreatingCollection: true, collection: nil)
        }
    }
    
    func bindListener() {
        self.viewModel?.collectionsDatabase.subscribe(with: { [ weak self ] collections in
            guard let self = self else { return }
            
            self.collectionList = collections
            self.ui.reloadData()
        })
    }
}


//- MARK: Public extensions

//- MARK: UICollectionViewDataSource

extension CollectionsScreenViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let collections = collectionList else { return 0 }
        
        if !collections.isEmpty {
            print(collections.count)
            return collections.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileScreenCollectionViewCell.reuseIdentifier, for: indexPath) as? ProfileScreenCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        guard let collections = collectionList else { return UICollectionViewCell()}
        
        let collection = collections[indexPath.row]
        
        cell.configure(title: collection.collectionName, imageName: collection.nameImageCollection)
        
        return cell
    }
}


//- MARK: UICollectionViewDelegate

extension CollectionsScreenViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let collections = collectionList else { return }
        
        self.viewModel?.goToCollectionScreenDetail(collection: collections[indexPath.row])
    }
}


//- MARK: UICollectionViewDelegateFlowLayout

extension CollectionsScreenViewController: UICollectionViewDelegateFlowLayout {
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
