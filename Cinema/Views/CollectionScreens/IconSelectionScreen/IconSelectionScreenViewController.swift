//
//  IconSelectionScreenViewController.swift
//  Cinema
//
//  Created by Елена on 14.04.2023.
//

import UIKit

protocol SheetViewControllerDelegate: class {
    func didDismissSheetViewController(withData data: String)
}

class IconSelectionScreenViewController: UIViewController {
    
    private enum Metrics {
        static let itemsInRow = 4
        static let cellHeight: CGFloat = 74
        static let viewInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        static let insets = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
        static let lineSpace: CGFloat = 16
        static let itemSpace: CGFloat = 16
    }
    
    private var ui: IconSelectionScreenView
    var viewModel: CollectionScreenViewModel?
    
    weak var delegate: SheetViewControllerDelegate?
    
    var selectedIconName: String?
    
    var iconsImageName: [String] = {
        var array = [String]()
        
        for numberIcon in 1...36 {
            array.append("Group \(numberIcon)")
        }
        
        return array
    }()
    
    init() {
        self.ui = IconSelectionScreenView()
        
        super.init(nibName: nil, bundle: nil)
        
        self.ui.configureCollection(delegate: self, dataSource: self)
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
    }
    
    private func initArrayIcons() {
        for numberIcon in 1...36 {
            iconsImageName.append("Group \(numberIcon)")
        }
        
        self.ui.reloadData()
    }
    
    private func dismiss(imageName: String) {
        let data = imageName
        delegate?.didDismissSheetViewController(withData: data)
        dismiss(animated: true, completion: nil)
    }
}

extension IconSelectionScreenViewController {
    func handler() {
        self.ui.closeSheetScreenButtonPressed = {
            if let imageName = self.selectedIconName{
                self.dismiss(imageName: imageName)
                
            } else {
                self.viewModel?.backGoToCreateEditingCollectionScreen()
            }
        }
    }
}

extension IconSelectionScreenViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        iconsImageName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IconSelectionScreenCollectionViewCell.reuseIdentifier, for: indexPath) as? IconSelectionScreenCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configureCell(imageName: iconsImageName[indexPath.row])
        
        return cell
    }
}

extension IconSelectionScreenViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIconName = iconsImageName[indexPath.row]
        
        self.ui.closeSheetScreenButtonPressed?()
    }
}

extension IconSelectionScreenViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath ) -> CGSize {
        
        let sideInsets = (Metrics.insets.left + Metrics.viewInsets.left) * 2
        let insetsSum = Metrics.itemSpace * (CGFloat(Metrics.itemsInRow) - 1) + sideInsets
        let otherSpace = collectionView.frame.width - insetsSum
        let cellWidth = otherSpace / CGFloat(Metrics.itemsInRow)
        
        return CGSize(width: cellWidth, height: Metrics.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        Metrics.insets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        Metrics.itemSpace
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        Metrics.lineSpace
    }
}

