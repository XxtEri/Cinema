//
//  FootageMovieView.swift
//  Cinema
//
//  Created by Елена on 01.04.2023.
//

import UIKit
import SnapKit

class FootageMovieView: UIStackView {
    
    //- MARK: Private properties
    
    private enum Metrics {
        static let titleFootageBlockKern: CGFloat = -0.17
        static let titleFootageBlockTextSize: CGFloat = 24
        
        static let footagesMovieCollectionSizeHeight: CGFloat = 117
        static let footagesMovieCollectionLeadingInset: CGFloat = 16
        
        static let stackSpacing: CGFloat = 16
        
        static let titleFootageBlockLeadingInset: CGFloat = 16
        
        static let collectionViewCellWidth: CGFloat = 128
        static let collectionViewCellHeight: CGFloat = 72
        
        static let collectionViewSpacingSection: CGFloat = 16
    }

    private lazy var titleFootageBlock: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.attributedText = NSAttributedString(string: "Кадры", attributes: [.kern: Metrics.titleFootageBlockKern])
        view.font = UIFont(name: "SFProText-Bold", size: Metrics.titleFootageBlockTextSize)
        
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
        
        view.bounds.size.height = Metrics.footagesMovieCollectionSizeHeight
        
        return view
    }()
    
    private lazy var footagesMovie = [String]()
    
    
    //- MARK: Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addArrangedSubview(titleFootageBlock)
        self.addArrangedSubview(footagesMovieCollection)
        
        self.setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //- MARK: Public methods
    
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


//- MARK: Private extensions

private extension FootageMovieView {
    
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
        titleFootageBlock.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Metrics.titleFootageBlockLeadingInset)
        }
        
        footagesMovieCollection.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview().inset(Metrics.footagesMovieCollectionLeadingInset)
        }
    }
}


//- MARK: UICollectionViewDataSource, UICollectionViewDelegate

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


//- MARK: UICollectionViewDelegateFlowLayout

extension FootageMovieView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: Metrics.collectionViewCellWidth, height: Metrics.collectionViewCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        Metrics.collectionViewSpacingSection
    }
}
