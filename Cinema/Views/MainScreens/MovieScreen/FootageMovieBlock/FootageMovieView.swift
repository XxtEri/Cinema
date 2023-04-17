//
//  FootageMovieView.swift
//  Cinema
//
//  Created by Елена on 01.04.2023.
//

import UIKit

class FootageMovieView: UIView {

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
        
        return view
    }()
    
    private lazy var footagesMovie = [String]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(titleFootageBlock)
        self.addSubview(footagesMovieCollection)
        
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setFootagesMovie(footages: [String]) {
        footagesMovie = footages
        
        footagesMovieCollection.reloadData()
    }
}

private extension FootageMovieView {
    func setup() {
        configureConstraints()
    }
    
    func configureConstraints() {
        titleFootageBlock.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        footagesMovieCollection.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(titleFootageBlock.snp.horizontalEdges)
            make.top.equalTo(titleFootageBlock.snp.bottom).inset(-16)
            make.bottom.equalToSuperview()
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
