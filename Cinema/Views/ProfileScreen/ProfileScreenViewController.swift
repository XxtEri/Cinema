//
//  ProfileScreenViewController.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

import UIKit
import SnapKit

final class ProfileScreenViewController: UIViewController {
    
    //- MARK: Private properties
    
    private enum Metrics {
        static let itemsInRow = 1
        static let cellHeight: CGFloat = 44
        static let viewInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        static let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        static let lineSpace: CGFloat = 23.5
        
        static let countCollectionCell = 3
    }
    
    private var titleCell: [String]
    
    private var titleImageCell: [String]
    
    private var ui: ProfileScreenView
    
    
    //- MARK: Public properties
    
    var viewModel: ProfileScreenViewModel?
    
    
    //- MARK: Inits
    
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
    
    
    //- MARK: Lifecycle
    
    override func loadView() {
        self.view = ui
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        bindListener()
        handler()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showActivityIndicator()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.viewModel?.getInformationProfile()
        }
    }
    
    
    //- MARK: Private methods
    
    private func showActivityIndicator() {
        ui.startAnumateIndicator()
    }
    
    private func hideActivityIndicator() {
        ui.stopAnimateIndicator()
    }
    
    private func showError(_ error: String) {
        let alertController = UIAlertController(title: "Внимание!", message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)
        
        alertController.addAction(action)
        
        alertController.view.tintColor = .accentColorApplication
        
        self.present(alertController, animated: true, completion: nil)
    }
}


//- MARK: Private extensions

private extension ProfileScreenViewController {
    func bindListener() {
        self.viewModel?.informationProfile.subscribe(with: { [ weak self ] user in
            guard let self = self else { return }
            
            self.ui.set(with: user)
            self.hideActivityIndicator()
        })
        
        self.viewModel?.errorOnLoading.subscribe(with: { [ weak self ] error in
            guard let self = self else { return }
            
            self.hideActivityIndicator()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.showError("Что-то пошло не так. Попробуйте повторить запрос")
            }
        })
    }
    
    func handler() {
        self.ui.signOutButtonPressed = { [ weak self ] in
            guard let self = self else { return }
            
            self.showActivityIndicator()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.viewModel?.signOut()
            }
        }
        
        self.ui.profileInformationBlock.avatarChangeButtonPressed = { [ weak self ] in
            guard let self = self else { return }
            
            self.showAlertChoosePhoto()
        }
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
    
    func chooseImage(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
}


//- MARK: Public extensions

//- MARK: UICollectionViewDataSource

extension ProfileScreenViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Metrics.countCollectionCell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileScreenCollectionViewCell.reuseIdentifier, for: indexPath) as? ProfileScreenCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(title: titleCell[indexPath.row], imageName: titleImageCell[indexPath.row])
        
        return cell
    }
}


//- MARK: UICollectionViewDelegate

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
            print("error")
        }
    }
}


//- MARK: UICollectionViewDelegateFlowLayout

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


//- MARK: UIImagePickerControllerDelegate, UINavigationControllerDelegate

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
