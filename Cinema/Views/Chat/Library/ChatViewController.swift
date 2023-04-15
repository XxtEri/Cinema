//
//  ChatViewController.swift
//  Cinema
//
//  Created by Елена on 10.04.2023.
//

import UIKit
import MessageKit
import SnapKit


struct Sender: SenderType {
    var senderId: String
    var displayName: String
}

struct MessageChat: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}


class ChatViewController: MessagesViewController {
    
    var currentUser = Sender(senderId: "First", displayName: "First Person")
    var anotherUser = Sender(senderId: "Second", displayName: "Second Person")
    var messages = [MessageType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesCollectionView.register(MyMessageCollectionViewCell.self, forCellWithReuseIdentifier: MyMessageCollectionViewCell.reuseIdentifier)
        
        messagesCollectionView.register(OtherMessageCollectionViewCell.self, forCellWithReuseIdentifier: OtherMessageCollectionViewCell.reuseIdentifier)
        
        self.configureCollectionView()
        self.configureMessageInputBar()
        self.setUpMessage()
        self.setupToHideKeyboardOnTapOnView()
        
        print(messagesCollectionView.alpha)
        
        messagesCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        messagesCollectionView.isHidden = false
    }
    
    func configureCollectionView() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate =  self
        
        messagesCollectionView.backgroundColor = .backgroundApplication
    }
    
    func configureMessageInputBar() {
        messageInputBar.inputTextView.placeholder = "Напишите сообщение..."
        
        messageInputBar.separatorLine.isHidden = true
        messageInputBar.inputTextView.tintColor = .accentColorApplication
        messageInputBar.backgroundView.backgroundColor = .backgroundApplication
        messageInputBar.inputTextView.placeholderTextColor = .placeholderChatInputMessage
        messageInputBar.inputTextView.textColor = .placeholderChatInputMessage
        messageInputBar.inputTextView.layer.borderColor = UIColor.borderColorInputMessage.cgColor
        
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 7, left: 12, bottom: 7, right: 36)
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 7, left: 16, bottom: 7, right: 36)
        messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 7, left: 0, bottom: 7, right: 0)
        
        messageInputBar.inputTextView.layer.borderWidth = 1
        messageInputBar.inputTextView.layer.cornerRadius = 4
        messageInputBar.inputTextView.layer.masksToBounds = true
        
        configureInputBarItems()
    }
    
    private func configureInputBarItems() {
        messageInputBar.setRightStackViewWidthConstant(to: 32, animated: false)
        
        messageInputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        messageInputBar.sendButton.setSize(CGSize(width: 36, height: 36), animated: false)
        messageInputBar.sendButton.image = UIImage.init(named: "SenderButton")
        messageInputBar.sendButton.title = nil
        messageInputBar.setStackViewItems([], forStack: .bottom, animated: false)
        
        messageInputBar.sendButton.addTarget(self, action: #selector(tup), for: .touchUpInside)
    }
     
    @objc
    func tup() {
        print("tup")
    }
    
    func setUpMessage() {
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
        
        self.messagesCollectionView.reloadData()
    }
    
    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let messagesDataSource = messagesCollectionView.messagesDataSource else {
            fatalError("Ouch. nil data source for messages")
        }

        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)

        if isFromCurrentSender(message: message) {
            switch message.kind {
            case .text(let text):
               guard let cell = messagesCollectionView.dequeueReusableCell(withReuseIdentifier: MyMessageCollectionViewCell.reuseIdentifier, for: indexPath) as? MyMessageCollectionViewCell else { return UICollectionViewCell() }

                cell.textMessage.text = text
                cell.infoMessage.text = message.sender.displayName
        

                return cell
            default:
                break
            }
            return super.collectionView(collectionView, cellForItemAt: indexPath)
            
        } else {
            switch message.kind {
            case .text(let text):
                guard let cell = messagesCollectionView.dequeueReusableCell(withReuseIdentifier: OtherMessageCollectionViewCell.reuseIdentifier, for: indexPath) as? OtherMessageCollectionViewCell else { return UICollectionViewCell() }

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

extension ChatViewController: MessagesDataSource {
    var currentSender: MessageKit.SenderType {
        currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        messages.count
    }
    
    func cellTopLabelAttributedText(for message: MessageType,
                                    at indexPath: IndexPath) -> NSAttributedString? {
        
        let name = message.sender.displayName
        return NSAttributedString(
            string: name,
            attributes: [
                .font: UIFont.preferredFont(forTextStyle: .caption1),
                .foregroundColor: UIColor.green
            ]
        )
    }
}

// MARK: - MessagesLayoutDelegate
extension ChatViewController: MessagesLayoutDelegate {
    
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize? {
        return CGSize(width: 32, height: 32)
    }
    
    func footerViewSize(for message: MessageType, at indexPath: IndexPath,
                        in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: 210, height: 74)
    }
}


extension ChatViewController: MessagesDisplayDelegate {
    // MARK: - Text Messages
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .green : .green
    }
    
    func detectorAttributes(for detector: DetectorType, and message: MessageType, at indexPath: IndexPath) -> [NSAttributedString.Key: Any] {
        return MessageLabel.defaultAttributes
    }
    
    func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType] {
        return [.url, .address, .phoneNumber, .date, .transitInformation]
    }
    
    // MARK: - All Messages
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .blue : .red
    }
}

extension ChatViewController {
    func setupToHideKeyboardOnTapOnView() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard(sender:)))

        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc
    func dismissKeyboard(sender: AnyObject) {
        view.endEditing(true)
    }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}
