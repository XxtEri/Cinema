//
//  ProfileScreenViewController.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

import UIKit
import SnapKit

final class ProfileScreenViewController: UIViewController {
    
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
    
    var viewModel: ProfileScreenViewModel?
    
    init() {
        ui = ProfileScreenView()
        
        titleCell = ["Обсуждения", "Истории", "Настройки"]
        titleImageCell = ["Discussions", "History", "Settings"]
        
        super.init(nibName: nil, bundle: nil)
        
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
        
        self.navigationController?.isNavigationBarHidden = true
        
        bind()
        
        viewModel?.getInformationProfile()
    }
    
}

extension ProfileScreenViewController {
    func bind() {
        self.viewModel?.informationProfile.subscribe(with: { [ weak self ] user in
            guard let self = self else { return }
            
            self.ui.set(with: user)
        })
        
        self.viewModel?.errorOnLoading.subscribe(with: { [ weak self ] error in
            guard let self = self else { return }
            
            self.showError(error)
        })
        
        self.ui.signOutButtonPressed = { [ weak self ] in
            guard let self = self else { return }
            
            self.viewModel?.signOut()
        }
        
        self.ui.profileInformationBlock.avatarChangeButtonPressed = { [ weak self ] in
            guard let self = self else { return }
            
            self.showAlertChoosePhoto()
        }
    }
    
    func showError(_ error: Error) {
        print("error")
    }
    
    func showAlertChoosePhoto() {
        let alertController = UIAlertController(title: "Выберите источник фотографии", message: nil, preferredStyle: .alert)
        let actionChooseCamera = UIAlertAction(title: "Камера", style: .default) { _ in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            
            imagePicker.showsCameraControls = true
            
            self.present(imagePicker, animated: true, completion: nil)
        }
        let actionChooseGalery = UIAlertAction(title: "Галерея", style: .default) { _ in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            
            self.present(imagePicker, animated: true, completion: nil)
        }
        let actionCancel = UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)
        
        alertController.addAction(actionChooseGalery)
        alertController.addAction(actionChooseCamera)
        alertController.addAction(actionCancel)
        
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func chooseImage(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            
            self.present(imagePicker, animated: true, completion: nil)
        }
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

extension ProfileScreenViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch titleCell[indexPath.row] {
        case "Обсуждения":
            viewModel?.goToDisscusion()
        case "Истории":
            viewModel?.goToHistory()
        case "Настройки":
            viewModel?.goToSettings()
        default:
            print("")
        }
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

extension ProfileScreenViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("\(info)")
        picker.dismiss(animated: true, completion: nil)
        
        if let imageURl = info[.imageURL] as? URL {
            self.viewModel?.editAvatarProfile(imageUrl: imageURl)
        }
        
        if let pickedImage = info[.originalImage] as? UIImage {
            if let imageData = pickedImage.jpegData(compressionQuality: 0.8),
               let imageURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("image.jpg") {
                do  {
                    try? imageData.write(to: imageURL)
                    print("Фотография успешно сохранена: \(imageURL)")
                    
                    self.viewModel?.editAvatarProfile(imageUrl: imageURL)
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
