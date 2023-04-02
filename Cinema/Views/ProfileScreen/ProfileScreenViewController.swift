//
//  ProfileScreenViewController.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

import UIKit
import SnapKit

class ProfileScreenViewController: UIViewController {
    
    private enum Metrics {
        static let itemsInRow = 1
        static let cellHeight: CGFloat = 44
        static let viewInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        static let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        static let lineSpace: CGFloat = 23.5
    }
    
    private var titleCell: [String]
    
    private var titleImageCell: [String]
    
    private var ui: ProfileScreenView
    
    var viewModel: ProfileViewModel?
    
    init() {
        ui = ProfileScreenView()
        viewModel = ProfileViewModel(navigation: nil)
        
        titleCell = ["Обсуждения", "Истории", "Настройки"]
        titleImageCell = ["Discussions", "History", "Settings"]
        
        super.init(nibName: nil, bundle: nil)
        
        bind()
        handlers()
        ui.configureCollectionView(delegate: self, dataSource: self)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = ui
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.getInformationProfile()
    }
    
    func handlers() {
        self.viewModel?.changeData = { [ weak self ] user in
            self?.ui.set(with: user)
        }
    }
}

extension ProfileScreenViewController {
    func bind() {
        self.viewModel?.informationProfile.subscribe(with: { [ weak self ] user in
            self?.ui.set(with: user)
        })
        
        self.viewModel?.errorOnLoading.subscribe(with: { [ weak self ] error in
            self?.showError(error)
        })
    }
    
    func showError(_ error: Error) {
        print("error")
    }
}

extension ProfileScreenViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileScreenCollectionViewCell.reuseIdentifier, for: indexPath) as? ProfileScreenCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(title: titleCell[indexPath.row], imageName: titleImageCell[indexPath.row])
        
        return cell
    }
}

extension ProfileScreenViewController: UICollectionViewDelegateFlowLayout {
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

