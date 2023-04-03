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
        
        return view
    }()
    
    private lazy var listTrendFilms: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
//        layout.minimumInteritemSpacing = CGFLOAT_MAX
        
        var view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        view.register(TrendMovieCollectionViewCell.self, forCellWithReuseIdentifier: TrendMovieCollectionViewCell.reuseIdentifier)
        view.delegate = self
        view.dataSource = self
        
        view.backgroundColor = .red
        
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addArrangedSubview(titleTrendsBlock)
        self.addArrangedSubview(listTrendFilms)
        
        setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TrendMoviesBlockView {
    func setup() {
        configureConstraints()
        self.axis = .vertical
        self.alignment = .leading
    }

    func configureConstraints() {
//        titleTrendsBlock.snp.makeConstraints { make in
//            make.horizontalEdges.equalToSuperview()
//            make.top.equalToSuperview()
//        }
//
        listTrendFilms.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
//            make.top.equalTo(titleTrendsBlock.snp.bottom).inset(-16)
//            make.bottom.equalToSuperview()
        }
    }
}

//- MARK: UICollectionViewDataSource

extension TrendMoviesBlockView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendMovieCollectionViewCell.reuseIdentifier, for: indexPath) as? TrendMovieCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("What!")
    }
}


////- MARK: UICollectionViewDelegate
//
//extension TrendMoviesBlockView: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("What!")
//    }
//}

//- MARK: UICollectionViewFlowLayout

extension TrendMoviesBlockView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 100, height: 144)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        16
    }
}
