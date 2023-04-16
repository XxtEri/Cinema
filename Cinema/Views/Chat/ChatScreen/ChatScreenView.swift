//
//  ChatScreenView.swift
//  Cinema
//
//  Created by Елена on 09.04.2023.
//

import UIKit
import SnapKit

class ChatScreenView: UIView {
    
    private let titleScreen: UILabel = {
        let view = UILabel()
        view.attributedText = NSAttributedString(string: "", attributes: [.kern: -0.41])
        view.font = UIFont(name: "SFProText-Semibold", size: 17)
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
        view.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        view.text = "Напишите сообщение..."
        view.textColor = .placeholderChatInputMessage
        
        view.layer.cornerRadius = 4
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.borderColorInputMessage.cgColor
        
        
        view.textContainerInset = UIEdgeInsets(top: 7, left: 16, bottom: 7, right: 16)
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

    private var maxHeightMessageInput: CGFloat = 32
    
    var goBackButtonPressed: (() -> Void)?
    var addNewMessagePressed: ((String) -> Void)?
    
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
    
    private func getWidthUITextView() -> CGFloat {
        let screenWidth = UIScreen.main.bounds.size.width
        let sendButtonWidth: CGFloat = 32
        
        return screenWidth - sendButtonWidth - 16 * 3
    }
    
    @objc
    private func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let keyboardHeight = keyboardFrame.cgRectValue.height
        self.frame.origin.y -= keyboardHeight + 10
    }
    
    @objc
    private func keyboardWillHide() {
        self.frame.origin.y = 0
    }
    
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
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
}

private extension ChatScreenView {
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
            make.centerX.equalToSuperview()
            make.trailing.equalToSuperview().inset(60)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(23)
            make.leading.equalTo(titleScreen.snp.trailing).inset(-60)
        }
        
        imageGoBackScreen.snp.makeConstraints { make in
            make.centerY.equalTo(titleScreen.snp.centerY)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(23)
            make.leading.equalToSuperview().inset(8.5)
        }
        
        chat.snp.makeConstraints { make in
            make.top.equalTo(titleScreen.snp.bottom).inset(-41)
            make.horizontalEdges.equalToSuperview()
        }
        
        messageInput.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(chat.snp.bottom).inset(-24)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(42)
            make.width.equalTo(getWidthUITextView())
            make.height.equalTo(maxHeightMessageInput)
        }
        
        sendButton.snp.makeConstraints { make in
            make.leading.equalTo(messageInput.snp.trailing).inset(-16)
            make.bottom.equalTo(messageInput.snp.bottom)
            make.trailing.equalToSuperview().inset(16)
        }
    }
    
    func configureActions() {
        imageGoBackScreen.addTarget(self, action: #selector(goBack(sender:)), for: .touchDown)
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
    }
    
    @objc
    func goBack(sender: AnyObject) {
       goBackButtonPressed?()
    }
    
    @objc func sendButtonTapped() {
        if let message = messageInput.text, !message.isEmpty {
            addNewMessagePressed?(message)
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
}

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
                    
                } else {
                    maxHeightMessageInput = estimatedSize.height
                    constraint.constant = estimatedSize.height
                    
                    messageInput.setNeedsUpdateConstraints()
                }
            }
        }
    }
}
