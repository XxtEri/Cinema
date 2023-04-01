//
//  EpisodesMovieView.swift
//  Cinema
//
//  Created by Елена on 01.04.2023.
//

import UIKit

class EpisodesMovieView: UIView {

    private lazy var titleFootageBlock: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.attributedText = NSAttributedString(string: "Епизоды", attributes: [.kern: -0.17])
        view.font = UIFont(name: "SFProText-Bold", size: 14)
        
        return view
    }()

    private lazy var footageMovieList: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        var view = UICollectionView(frame: .zero, collectionViewLayout: layout)
                
        view.register(EpisodesMovieCollectionViewCell.self, forCellWithReuseIdentifier: EpisodesMovieCollectionViewCell.reuseIdentifier)
        view.delegate = self
        view.dataSource = self
        
        view.backgroundColor = UIColor(named: "BackgroundApplication")
        view.contentInsetAdjustmentBehavior = .never
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(titleFootageBlock)
        self.addSubview(footageMovieList)
        
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension EpisodesMovieView {
    func setup() {
        configureConstraints()
    }
    
    func configureConstraints() {
        titleFootageBlock.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        footageMovieList.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(titleFootageBlock.snp.bottom).inset(-16)
            make.bottom.equalToSuperview()
        }
    }
}

extension EpisodesMovieView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EpisodesMovieCollectionViewCell.reuseIdentifier, for: indexPath) as? EpisodesMovieCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.congifure(imageName: "Footage", titleEpisode: "Нелегальная магия", descriptionEpisode: "Квентин и Джулия приглашены на тест их волшебных навыков Квентин и Джулия приглашены на тест их волшебных навыков", yearEpisode: "2015")
        
        return cell
    }
}

extension EpisodesMovieView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 343, height: 72)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        16
    }
}

