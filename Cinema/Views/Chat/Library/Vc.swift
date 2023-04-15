//
//  Vc.swift
//  Cinema
//
//  Created by Елена on 10.04.2023.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class Vc: MessagesViewController {
    
    var currentUser = Sender(senderId: "First", displayName: "First Person")
    var anotherUser = Sender(senderId: "Second", displayName: "Second Person")

    var messages = [MessageChat]()
    
    override func viewDidLoad() {
        
        messagesCollectionView = MessagesCollectionView(frame: .zero, collectionViewLayout: CustomMessagesFlowLayout())
        
        // outgoing text nib register
        let outgoingTextNib = UINib(nibName: "OutgoingTextCell", bundle: nil)
        messagesCollectionView.register(outgoingTextNib, forCellWithReuseIdentifier: "outgoingTextCellID")
        
        // outgoing photo nib register
        let outgoingPhotoNib = UINib(nibName: "OutgoingPhotoCell", bundle: nil)
        messagesCollectionView.register(outgoingPhotoNib, forCellWithReuseIdentifier: "outgoingPhotoCellID")

        // incoming text nib register
        let incomingTextNib = UINib(nibName: "IncomingTextCell", bundle: nil)
        messagesCollectionView.register(incomingTextNib, forCellWithReuseIdentifier: "incomingTextCellID")
        
        // incoming photo nib register
        let incomingPhotoNib = UINib(nibName: "IncomingPhotoCell", bundle: nil)
        messagesCollectionView.register(incomingPhotoNib, forCellWithReuseIdentifier: "incomingPhotoCellID")

        super.viewDidLoad()
        
        self.configureMessageCollectionView()
        self.configureMessageInputBar()
        self.loadMessages()
    }
    
    func configureMessageCollectionView() {
        self.messagesCollectionView.messagesDataSource = self
      //  self.messagesCollectionView.messageCellDelegate = self
        self.messagesCollectionView.messagesLayoutDelegate = self
        self.messagesCollectionView.messagesDisplayDelegate = self
        
//        self.scrollsToBottomOnKeyboardBeginsEditing = true // default false
        self.maintainPositionOnInputBarHeightChanged = true // default false
    }
    
    func configureMessageInputBar() {

        messageInputBar.isTranslucent = true
     //   messageInputBar.separatorLine.isHidden = false
        messageInputBar.inputTextView.tintColor = UIColor(red: 48/255, green: 165/255, blue: 255/255, alpha: 1)
        messageInputBar.inputTextView.backgroundColor = .white //UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        messageInputBar.inputTextView.placeholderTextColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 36)
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 36)
        
        messageInputBar.inputTextView.layer.borderColor = UIColor(red: 56/255, green: 182/255, blue: 255/255, alpha: 1).cgColor
        messageInputBar.inputTextView.layer.borderWidth = 1.0
        messageInputBar.inputTextView.layer.cornerRadius = 19.0
        messageInputBar.inputTextView.layer.masksToBounds = true
        messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        configureInputBarItems()
    }
    
    private func configureInputBarItems() {
    
        messageInputBar.setRightStackViewWidthConstant(to: 36, animated: false)

        messageInputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        messageInputBar.sendButton.setSize(CGSize(width: 36, height: 36), animated: false)
        messageInputBar.sendButton.image = UIImage.init(named: "send")
        messageInputBar.sendButton.title = nil
        messageInputBar.textViewPadding.bottom = 8
        messageInputBar.setStackViewItems([], forStack: .bottom, animated: false)
        
    }
    
    func loadMessages() {
        messages.append(MessageChat(sender: currentUser,
                                    messageId: "1",
                                    sentDate: Date().addingTimeInterval(-86400),
                                    kind: .text("hello it's me, it's been a long time")))
        messages.append(MessageChat(sender: currentUser,
                                    messageId: "1",
                                    sentDate: Date().addingTimeInterval(-86400),
                                    kind: .text("how are you ?")))
        messages.append(MessageChat(sender: anotherUser,
                                    messageId: "3",
                                    sentDate: Date().addingTimeInterval(-86400),
                                    kind: .text("I'm fine thanks, I adopted a puppy a few weeks ago :)")))
        messages.append(MessageChat(sender: currentUser,
                                    messageId: "4",
                                    sentDate: Date().addingTimeInterval(-86400),
                                    kind: .text("Really? Send me photos when you can haha")))
        messages.append(MessageChat(sender: anotherUser  ,
                                    messageId: "5",
                                    sentDate: Date().addingTimeInterval(-86400),
                                    kind: .text("I'm at work now, but when I can, I'll go to a meeting now, we'll talk later bye! you have a good day!")))
        messages.append(MessageChat(sender: currentUser,
                                    messageId: "6",
                                    sentDate: Date().addingTimeInterval(-86400),
                                    kind: .text("OKAY! we'll talk later, you too have a good day! bye Bye!")))
    }
    
    // MARK: - UICollectionViewDataSource
    
    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let messagesDataSource = messagesCollectionView.messagesDataSource else {
            fatalError("Ouch. nil data source for messages")
        }
        
        //        guard !isSectionReservedForTypingBubble(indexPath.section) else {
        //            return super.collectionView(collectionView, cellForItemAt: indexPath)
        //        }
        
        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        
        if isFromCurrentSender(message: message) {
            switch message.kind {
            case .text(let text):
                let cell = messagesCollectionView.dequeueReusableCell(withReuseIdentifier: MyMessageCollectionViewCell.reuseIdentifier, for: indexPath) as! MyMessageCollectionViewCell
                cell.textMessage.text = text
                cell.infoMessage.text = message.sender.displayName
                return cell
            default:
                break
            }
            return super.collectionView(collectionView, cellForItemAt: indexPath)
        }else {
            switch message.kind {
            case .text(let text):
                let cell = messagesCollectionView.dequeueReusableCell(withReuseIdentifier: OtherMessageCollectionViewCell.reuseIdentifier, for: indexPath) as! OtherMessageCollectionViewCell
                cell.textMessage.text = text
                cell.infoMessage.text = message.sender.displayName
                return cell
            default:
                break
            }
            return super.collectionView(collectionView, cellForItemAt: indexPath)
        }
        
        
    }
}

// MARK: - MessagesDataSource
extension Vc: MessagesDataSource {
    var currentSender: MessageKit.SenderType {
        Sender.init(senderId: "nasrullah", displayName: "Nasrullah Khan")
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return self.messages.count
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return self.messages[indexPath.section] as! MessageType
    }
    
    func cellTopLabelAttributedText(for message: MessageType,
                                    at indexPath: IndexPath) -> NSAttributedString? {
        
        let name = message.sender.displayName
        return NSAttributedString(
            string: name,
            attributes: [
                .font: UIFont.preferredFont(forTextStyle: .caption1),
                .foregroundColor: UIColor(white: 0.3, alpha: 1)
            ]
        )
    }
    
}



// MARK: - MessagesLayoutDelegate
extension Vc: MessagesLayoutDelegate {
    
    func avatarSize(for message: MessageType, at indexPath: IndexPath,
                    in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return .zero
    }
    
    func footerViewSize(for message: MessageType, at indexPath: IndexPath,
                        in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: 0, height: 8)
    }
    
//    func heightForLocation(message: MessageType, at indexPath: IndexPath,
//                           with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
//        return 0
//    }
//
}

// MARK: - MessagesDisplayDelegate

extension Vc: MessagesDisplayDelegate {
    
    // MARK: - Text Messages
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : .darkText
    }
    
    func detectorAttributes(for detector: DetectorType, and message: MessageType, at indexPath: IndexPath) -> [NSAttributedString.Key: Any] {
        return MessageLabel.defaultAttributes
    }
    
    func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType] {
        return [.url, .address, .phoneNumber, .date, .transitInformation]
    }
    
    // MARK: - All Messages
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1) : UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    }
    
}
