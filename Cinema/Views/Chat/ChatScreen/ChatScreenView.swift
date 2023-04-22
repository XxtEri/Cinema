//
//  ChatScreenView.swift
//  Cinema
//
//  Created by Елена on 09.04.2023.
//

import UIKit
import SnapKit

class ChatScreenView: UIView {
    
    //- MARK: Private properties
    
    private enum Metrics {
        static let textKern: CGFloat = -0.41
        static let textSize: CGFloat = 17
        
        static let messageInputTextSize: CGFloat = 14
        static let messageInputCornerRadius: CGFloat = 4
        static let messageInputBorderWidth: CGFloat = 1
        static let messageInputEdgeInset = UIEdgeInsets(top: 7, left: 16, bottom: 7, right: 16)
        
        static let titleScreenTrailingInset: CGFloat = 35
        static let titleScreenTopInset: CGFloat = 23
        static let titleScreenLeadingInset: CGFloat = -35
        
        static let imageGoBackScreenTopInset: CGFloat = 23
        static let imageGoBackScreenLeadingInset: CGFloat = 8.5
        
        static let chatTopInset: CGFloat = -41
        
        static let messageInputLeadingInset: CGFloat = 16
        static let messageInputTopInset: CGFloat = -24
        static let messageInputBottomInset: CGFloat = 42
        
        static let sendButtonLeadingInset: CGFloat = -16
        static let sendButtonTrailingInset: CGFloat = 16
    }
    
    private let titleScreen: UILabel = {
        let view = UILabel()
        view.attributedText = NSAttributedString(string: "", attributes: [.kern: Metrics.textKern])
        view.font = UIFont(name: "SFProText-Semibold", size: Metrics.textSize)
        view.textColor = .white
        view.textAlignment = .center
        view.numberOfLines = .max

        return view
    }()

    private let imageGoBackScreen: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "ArrowBack"), for: .normal)

        return view
    }()
    
    private var maxHeightMessageInput: CGFloat = 32
    
    
    //- MARK: Public properties
    
    let chat: UITableView = {
        let view = UITableView()
        view.separatorStyle = .none
        view.allowsSelection = false
        view.backgroundColor = .backgroundApplication
        view.showsVerticalScrollIndicator = false
        
        return view
    }()
    
    let messageInput: UITextView = {
        var view = UITextView()
        view.font = UIFont.systemFont(ofSize: Metrics.messageInputTextSize, weight: .regular)
        
        view.text = "Напишите сообщение..."
        view.textColor = .placeholderChatInputMessage
        
        view.layer.cornerRadius = Metrics.messageInputCornerRadius
        view.layer.borderWidth = Metrics.messageInputBorderWidth
        view.layer.borderColor = UIColor.borderColorInputMessage.cgColor
        
        
        view.textContainerInset = Metrics.messageInputEdgeInset
        view.textAlignment = .left
        
        view.backgroundColor = .clear
        
        view.isScrollEnabled = false
        
        return view
    }()
    
    let sendButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "SenderButton"), for: .normal)
        
        return button
    }()
    
    var goBackButtonPressed: (() -> Void)?
    var addNewMessagePressed: ((String) -> Void)?
    var needUpdateLayout: (() -> Void)?
    
    
    //- MARK: Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(titleScreen)
        self.addSubview(imageGoBackScreen)
        self.addSubview(chat)
        self.addSubview(messageInput)
        self.addSubview(sendButton)
        
        setup()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //- MARK: Private methods
    
    private func getWidthUITextView() -> CGFloat {
        let screenWidth = UIScreen.main.bounds.size.width
        let sendButtonWidth: CGFloat = 32
        
        return screenWidth - sendButtonWidth - 16 * 3
    }
    
    
    //- MARK: Public methods
    
    func configureCollection(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
        chat.delegate = delegate
        chat.dataSource = dataSource
        chat.register(MyMessageTableViewCell.self, forCellReuseIdentifier: MyMessageTableViewCell.reuseIdentifier)
        chat.register(OtherMessageTableViewCell.self, forCellReuseIdentifier: OtherMessageTableViewCell.reuseIdentifier)
        chat.register(DateTableViewCell.self, forCellReuseIdentifier: DateTableViewCell.reuseIdentifier)
    }
    
    func setTitleScreen(titleChat: String) {
        titleScreen.text = titleChat
    }
    
    func reloadData() {
        chat.reloadData()
    }
    
    
    //- MARK: Deinit
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
}


//- MARK: Private extensions

private extension ChatScreenView {
    
    //- MARK: Setup
    
    func setup() {
        configureConstraints()
        configureTextView()
        configureUI()
        configureActions()
    }
    
    func configureTextView() {
        messageInput.delegate = self
    }
    
    func configureUI() {
        self.backgroundColor = .backgroundApplication
    }
    
    func configureConstraints() {
        titleScreen.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(Metrics.titleScreenTrailingInset)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(Metrics.titleScreenTopInset)
            make.leading.equalTo(imageGoBackScreen.snp.trailing).inset(Metrics.titleScreenLeadingInset)
        }
        
        imageGoBackScreen.snp.makeConstraints { make in
            make.centerY.equalTo(titleScreen.snp.centerY)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(Metrics.imageGoBackScreenTopInset)
            make.leading.equalToSuperview().inset(Metrics.imageGoBackScreenLeadingInset)
        }
        
        chat.snp.makeConstraints { make in
            make.top.equalTo(titleScreen.snp.bottom).inset(Metrics.chatTopInset)
            make.horizontalEdges.equalToSuperview()
        }
        
        messageInput.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Metrics.messageInputLeadingInset)
            make.top.equalTo(chat.snp.bottom).inset(Metrics.messageInputTopInset)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(Metrics.messageInputBottomInset)
            make.width.equalTo(getWidthUITextView())
            make.height.equalTo(maxHeightMessageInput)
        }
        
        sendButton.snp.makeConstraints { make in
            make.leading.equalTo(messageInput.snp.trailing).inset(Metrics.sendButtonLeadingInset)
            make.bottom.equalTo(messageInput.snp.bottom)
            make.trailing.equalToSuperview().inset(Metrics.sendButtonTrailingInset)
        }
    }
    
    func configureActions() {
        imageGoBackScreen.addTarget(self, action: #selector(goBack(sender:)), for: .touchDown)
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
    }
    
    
    //- MARK: Actions
    
    @objc
    func goBack(sender: AnyObject) {
       goBackButtonPressed?()
    }
    
    @objc func sendButtonTapped() {
        if let message = messageInput.text, !message.isEmpty {
            addNewMessagePressed?((message == "Напишите сообщение...") ? String() : message)
            messageInput.text = "Напишите сообщение..."
            messageInput.textColor = .placeholderChatInputMessage
            
            messageInput.constraints.forEach { constraint in
                if constraint.firstAttribute == .height {
                    messageInput.isScrollEnabled = false
                    
                    maxHeightMessageInput = 32
                    constraint.constant = maxHeightMessageInput
                    messageInput.setNeedsUpdateConstraints()
                }
            }
        }
    }
    
    @objc
    func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let keyboardHeight = keyboardFrame.cgRectValue.height
        self.frame.origin.y -= keyboardHeight + 10
    }
    
    @objc
    func keyboardWillHide() {
        self.frame.origin.y = 0
    }
}


//- MARK: Public extensions

//- MARK: UITextViewDelegate

extension ChatScreenView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .placeholderChatInputMessage {
            textView.text = ""
            textView.textColor = .white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Напишите сообщение..."
            textView.textColor = .placeholderChatInputMessage
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        let textViewMinHeight: CGFloat = 32
        let textViewMaxHeight: CGFloat = textViewMinHeight * 2 + 2 * 7 + 10
        
        guard estimatedSize.height <= textViewMaxHeight else {
            textView.isScrollEnabled = true
            
            return
        }
        
        textView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                textView.isScrollEnabled = false
                
                if estimatedSize.height < textViewMinHeight {
                    constraint.constant = textViewMinHeight
                    needUpdateLayout?()
                    
                } else {
                    maxHeightMessageInput = estimatedSize.height
                    constraint.constant = estimatedSize.height
                    
                    messageInput.setNeedsUpdateConstraints()
                    needUpdateLayout?()
                }
            }
        }
    }
}
