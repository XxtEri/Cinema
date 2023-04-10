//
//  CustomMessagesFlowLayout.swift
//  Cinema
//
//  Created by Елена on 10.04.2023.
//

import Foundation
import MessageKit
import UIKit

open class CustomMessagesFlowLayout: MessagesCollectionViewFlowLayout {
    
    open lazy var customMessageSizeCalculator = CustomMessageSizeCalculator(layout: self)
    
    open override func cellSizeCalculatorForItem(at indexPath: IndexPath) -> CellSizeCalculator {

        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        if case .text = message.kind{
            return customMessageSizeCalculator
        }
        
        if case .photo = message.kind {
            return customMessageSizeCalculator
        }
    
        return super.cellSizeCalculatorForItem(at: indexPath)
    }
    
    open override func messageSizeCalculators() -> [MessageSizeCalculator] {
        var superCalculators = super.messageSizeCalculators()
       
        superCalculators.append(customMessageSizeCalculator)
        return superCalculators
    }
}

open class CustomMessageSizeCalculator: MessageSizeCalculator {
    
    public override init(layout: MessagesCollectionViewFlowLayout? = nil) {
        super.init()
        self.layout = layout
    }
    
    open override func sizeForItem(at indexPath: IndexPath) -> CGSize {
        guard let layout = layout else { return .zero }
        
        let message = self.messagesLayout.messagesDataSource.messageForItem(at: indexPath, in: self.messagesLayout.messagesCollectionView)
        
        let collectionViewWidth = layout.collectionView?.bounds.width ?? 0
        let contentInset = layout.collectionView?.contentInset ?? .zero
        let inset = layout.sectionInset.left + layout.sectionInset.right + contentInset.left + contentInset.right
        
        switch message.kind {
        case .text(let text):
            let textHeight = text.height(withConstrainedWidth: collectionViewWidth - 100 - inset, font: UIFont.systemFont(ofSize: 13)) + 16 + 26// 16 for top bottom padding, 26 for Name & time
            return CGSize.init(width: collectionViewWidth - inset, height: textHeight)
        case .photo:
            let halfCellWidth = (collectionViewWidth/2) - contentInset.left - 13
            return CGSize.init(width: collectionViewWidth - inset, height: halfCellWidth)
        default:
            break
        }

        return CGSize(width: collectionViewWidth - inset, height: 44)
    }
    
}

//import Foundation
//import MessageKit
//import UIKit
//
//open class CustomMessagesFlowLayout: MessagesCollectionViewFlowLayout {
//
//    open lazy var customMessageSizeCalculator = CustomMessageSizeCalculator(layout: self)
//
//    open override func cellSizeCalculatorForItem(at indexPath: IndexPath) -> CellSizeCalculator {
//        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
//
//        if case .text = message.kind{
//            return customMessageSizeCalculator
//        }
//
//        return super.cellSizeCalculatorForItem(at: indexPath)
//    }
//
//    open override func messageSizeCalculators() -> [MessageSizeCalculator] {
//        var superCalculators = super.messageSizeCalculators()
//
//        superCalculators.append(customMessageSizeCalculator)
//        return superCalculators
//    }
//}
//
//open class CustomMessageSizeCalculator: MessageSizeCalculator {
//
//    public override init(layout: MessagesCollectionViewFlowLayout? = nil) {
//        super.init()
//        self.layout = layout
//    }
//
//    open override func sizeForItem(at indexPath: IndexPath) -> CGSize {
//        guard let layout = layout else { return .zero }
//
//        let message = self.messagesLayout.messagesDataSource.messageForItem(at: indexPath, in: self.messagesLayout.messagesCollectionView)
//
//        let collectionViewWidth = layout.collectionView?.bounds.width ?? 0
//        let contentInset = layout.collectionView?.contentInset ?? .zero
//        let inset = layout.sectionInset.left + layout.sectionInset.right + contentInset.left + contentInset.right
//
//        switch message.kind {
//        case .text(let text):
//            let textHeight = text.height(withConstrainedWidth: collectionViewWidth - 100 - inset, font: UIFont.systemFont(ofSize: 13)) + 16 + 26// 16 for top bottom padding, 26 for Name & time
//            return CGSize.init(width: collectionViewWidth - inset, height: textHeight)
//        case .photo:
//            let halfCellWidth = (collectionViewWidth/2) - contentInset.left - 13
//            return CGSize.init(width: collectionViewWidth - inset, height: halfCellWidth)
//        default:
//            break
//        }
//
//        return CGSize(width: collectionViewWidth - inset, height: 44)
//    }
//}
