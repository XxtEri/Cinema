//
//  InformationMovieView.swift
//  Cinema
//
//  Created by Елена on 01.04.2023.
//

import UIKit
import SnapKit

class InformationMovieView: UIView {
    
    let tags1 = ["When you", "eliminate", "the impossible,", "whatever remains,", "however improbable,", "must be", "the truth."]

    private lazy var informationMovie: UICollectionView = {
        let alignedFlowLayout = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top)
        alignedFlowLayout.estimatedItemSize = .init(width: 100, height: 24)

        let view = UICollectionView(frame: .zero, collectionViewLayout: alignedFlowLayout)
        
        view.register(InformationMovieCollectionViewCell.self, forCellWithReuseIdentifier: InformationMovieCollectionViewCell.reuseIdentifier)
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
        
        self.addSubview(informationMovie)
        
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension InformationMovieView {
    func setup() {
        configureConstraints()
    }
    
    func configureConstraints() {
        informationMovie.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension InformationMovieView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tags1.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InformationMovieCollectionViewCell.reuseIdentifier, for: indexPath) as! InformationMovieCollectionViewCell
    
        
        cell.configure(title: tags1[indexPath.row])
        
        return cell
    }
}
