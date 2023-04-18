//
//  InformationMovieView.swift
//  Cinema
//
//  Created by Елена on 01.04.2023.
//

import UIKit
import SnapKit

class InformationMovieBlockView: UIView {
    
    private var tags = [Tag]()

    private lazy var informationMovie: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        view.register(InformationMovieBlockCollectionViewCell.self, forCellWithReuseIdentifier: InformationMovieBlockCollectionViewCell.reuseIdentifier)
        view.delegate = self
        view.dataSource = self
        
        view.backgroundColor = .backgroundApplication
        view.contentInsetAdjustmentBehavior = .never
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var widthAllCells: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(informationMovie)
        
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getHeightView(w: CGFloat) -> CGFloat {
        let widthScreen = UIScreen.main.bounds.width * 50.89 / 100
        let spacing: CGFloat = 8
        var heightView: CGFloat = 0
        
        calculateWidthAllCells()
        
        while widthAllCells > widthScreen {
            heightView += 24 + spacing
            widthAllCells -= widthScreen
        }

        if widthAllCells != 0 {
            heightView += 24 - spacing
        }
        
        return heightView
    }
    
    func setTagList(tags: [Tag]) {
        self.tags = tags
        
        informationMovie.reloadData()
    }
}

private extension InformationMovieBlockView {
    func setup() {
        configureConstraints()
    }
    
    func configureConstraints() {
        informationMovie.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func calculateWidthAllCells() {
        for element in tags {
            let label = UILabel()
            label.attributedText = NSAttributedString(string: element.tagName, attributes: [.kern: -0.41])
            label.font = UIFont(name: "SFProText-Regular", size: 14)
            
            widthAllCells += label.intrinsicContentSize.width
        }
    }
}

extension InformationMovieBlockView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InformationMovieBlockCollectionViewCell.reuseIdentifier, for: indexPath) as! InformationMovieBlockCollectionViewCell
    
        
        cell.configure(title: tags[indexPath.row].tagName)
        
        return cell
    }
}