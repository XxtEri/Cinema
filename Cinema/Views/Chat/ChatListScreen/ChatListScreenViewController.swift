//
//  DisscusionScreenViewController.swift
//  Cinema
//
//  Created by Елена on 05.04.2023.
//

import UIKit
import SnapKit

class ChatListScreenViewController: UIViewController {
    
    private var ui: ChatListScreenView
    var viewModel: ChatViewModel?
    
    init() {
        self.ui = ChatListScreenView()
        
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
        
        navigationController?.isNavigationBarHidden = true
        
        handler()
    }
    
    func handler() {
        self.ui.goBackButtonPressed = { [ weak self ] in
            guard let self = self else { return }
            
            self.viewModel?.goToProfileScreen()
        }
    }
}

extension ChatListScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        24
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatListScreenCollectionViewCell.reuseIdentifier, for: indexPath) as? ChatListScreenCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let chat = Chat(chatId: "1", chatName: "Игра престолов")
        let message = Message(messageId: "1", creationDateTime: "12:12:12", authorId: "1", authorName: "Иван", authorAvatar: nil, text: "Смотрели уже последнюю серию? Я просто поверить не могу в...")
        
        cell.configureCell(modelChat: chat, modelLastMessage: message)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath ) -> CGSize {
            
        return CGSize(width: collectionView.frame.width, height: 73)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
