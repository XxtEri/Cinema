//
//  DisscusionScreenViewController.swift
//  Cinema
//
//  Created by Елена on 05.04.2023.
//

import UIKit
import SnapKit

class ChatListScreenViewController: UIViewController {
    
    //- MARK: Private properties
    
    private enum Metrics {
        static let cellHeight: CGFloat = 73
        
        static let collectionLineSpacing: CGFloat = 8
    }
    
    private var ui: ChatListScreenView
    
    
    //- MARK: Public properties
    
    var viewModel: ChatViewModel?
    
    var chats = [Chat]()
    
    
    //- MARK: Inits
    
    init() {
        self.ui = ChatListScreenView()
        
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
        
        handler()
        bindListener()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel?.getChatList()
    }
}


//- MARK: Private extensions

private extension ChatListScreenViewController {
    func handler() {
        self.ui.goBackButtonPressed = { [ weak self ] in
            guard let self = self else { return }
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func bindListener() {
        self.viewModel?.chats.subscribe(with: { [ weak self ] chats in
            guard let self = self else { return }
            
            self.chats = chats
            self.ui.reloadData()
        })
    }
}


//- MARK: Public extensions

//- MARK: UICollectionViewDataSource

extension ChatListScreenViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        chats.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatListScreenCollectionViewCell.reuseIdentifier, for: indexPath) as? ChatListScreenCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configureCell(modelChat: chats[indexPath.row])
        
        return cell
    }
}


//- MARK: UICollectionViewDelegate

extension ChatListScreenViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel?.goToChatScreen(chatModel: chats[indexPath.row])
    }
}


//- MARK: UICollectionViewDelegateFlowLayout

extension ChatListScreenViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath ) -> CGSize {
            
        return CGSize(width: collectionView.frame.width, height: Metrics.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        Metrics.collectionLineSpacing
    }
}
