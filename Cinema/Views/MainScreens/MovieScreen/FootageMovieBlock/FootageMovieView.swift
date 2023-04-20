//
//  FootageMovieView.swift
//  Cinema
//
//  Created by Елена on 01.04.2023.
//

import UIKit
import SnapKit

class FootageMovieView: UIStackView {

    private lazy var titleFootageBlock: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.attributedText = NSAttributedString(string: "Кадры", attributes: [.kern: -0.17])
        view.font = UIFont(name: "SFProText-Bold", size: 24)
        
        return view
    }()

    private lazy var footagesMovieCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = CGFLOAT_MAX
                
        var view = UICollectionView(frame: .zero, collectionViewLayout: layout)
                
        view.register(FootageMovieCollectionViewCell.self, forCellWithReuseIdentifier: FootageMovieCollectionViewCell.reuseIdentifier)
        view.delegate = self
        view.dataSource = self
        
        view.backgroundColor = UIColor(named: "BackgroundApplication")
        view.contentInsetAdjustmentBehavior = .never
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.bounds.size.height = 117
        
        return view
    }()
    
    private lazy var footagesMovie = [String]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addArrangedSubview(titleFootageBlock)
        self.addArrangedSubview(footagesMovieCollection)
        
        self.setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setFootagesMovie(footages: [String]) {
        footagesMovie = footages
        
        footagesMovieCollection.reloadData()
    }
    
    func getHeightView() -> CGFloat {
        let titleHeight = titleFootageBlock.bounds.size.height
        let collectionHeight = footagesMovieCollection.bounds.size.height
        let spacing = self.spacing
        
        return titleHeight + collectionHeight + spacing
    }
}

private extension FootageMovieView {
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
        titleFootageBlock.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
        }
        
        footagesMovieCollection.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
        }
    }
}

extension FootageMovieView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        footagesMovie.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FootageMovieCollectionViewCell.reuseIdentifier, for: indexPath) as? FootageMovieCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.congifure(imageUrl: footagesMovie[indexPath.row])
        
        return cell
    }
}

extension FootageMovieView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 128, height: 72)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        16
    }
}
