//
//  ChatScreenViewController.swift
//  Cinema
//
//  Created by Елена on 09.04.2023.
//

import UIKit

class ChatScreenViewController: UIViewController {
    
    private let ui: ChatScreenView
    
    private var currentDate: DateMessage?
    
    private var chatModel: Chat
    
    var viewModel: ChatViewModel?
    
    var currentUserId: String?
    
    var messages = [MessageServer]()
    
    init(chatModel: Chat) {
        self.ui = ChatScreenView()
        self.chatModel = chatModel
        
        super.init(nibName: nil, bundle: nil)
        
        self.ui.configureCollection(delegate: self, dataSource: self)
        self.ui.configureTextView(delegate: self)
        self.ui.setTitleScreen(titleChat: chatModel.chatName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = ui
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel?.getUserId()
        self.viewModel?.connectToChat(chatId: chatModel.chatId)
        
        setupToHideKeyboardOnTapOnView()
        
        handler()
    }
    
    func reloadDataChat() {
        DispatchQueue.main.async {
            self.ui.chat.reloadData()
        }
    }
}

private extension ChatScreenViewController {
    func handler() {
        self.ui.goBackButtonPressed = { [ weak self ] in
            guard let self = self else { return }
            
            self.viewModel?.backGoToChatList()
            self.viewModel?.disconnectToChat()
        }
        
//        self.ui.addNewMessagePressed = { [ weak self ] message in
//            guard let self = self else { return }
//
//            self.reloadDataChat()
//
//            self.viewModel?.disconnectToChat()
//        }
        
        self.viewModel?.newMessages.subscribe(with: { [ weak self ] message in
            guard let self = self else { return }
            
            self.messages.append(message)
            self.reloadDataChat()
        })
        
        self.viewModel?.userId.subscribe(with: { [ weak self ] userId in
            guard let self = self else { return }
            
            self.currentUserId = userId
        })
    }
}

extension ChatScreenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let currentUserId = self.currentUserId else { return UITableViewCell() }
        
        let message = messages[indexPath.row]
        
        if currentUserId == message.authorId {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MyMessageTableViewCell.reuseIdentifier, for: indexPath) as? MyMessageTableViewCell else { return UITableViewCell() }
            
            cell.configureCell(message: message)
            
            return cell
            
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OtherMessageTableViewCell.reuseIdentifier, for: indexPath) as? OtherMessageTableViewCell else { return UITableViewCell() }
        
        cell.configureCell(message: message)
        
        return cell
    }
}

extension ChatScreenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension ChatScreenViewController {
    func isDatesEqual(firstDate: DateMessage, secondDate: DateMessage) -> Bool {
        if firstDate.day != secondDate.day ||
            firstDate.month != secondDate.month ||
            firstDate.year != secondDate.year {
            
            return false
        }
        
        return true
    }
    
    func getDateMessage(date: String) -> DateMessage? {
        let matchedYear = matches(for: "^\\d{4}", in: date)
        guard let year = Int(matchedYear[0]) else { return nil }
        
        var matchedMonth = matches(for: "-\\d{2}-", in: date)
        matchedMonth = matches(for: "\\d{2}", in: matchedMonth[0])
        guard let month = Int(matchedMonth[0]) else { return nil }
        
        var matchedDay = matches(for: "\\d{2}T", in: date)
        matchedDay = matches(for: "\\d{2}", in: matchedDay[0])
        guard let day = Int(matchedDay[0]) else { return nil }
        
        var matchedHour = matches(for: "T\\d{2}", in: date)
        matchedHour = matches(for: "\\d{2}", in: matchedHour[0])
        guard let hour = Int(matchedHour[0]) else { return nil }
        
        var matchedMinute = matches(for: ":\\d{2}:", in: date)
        matchedMinute = matches(for: "\\d{2}", in: matchedMinute[0])
        guard let minute = Int(matchedMinute[0]) else { return nil }
        
        var matchedSecond = matches(for: ":\\d+[.]*\\d*$", in: date)
        matchedSecond = matches(for: ":\\d{2}", in: matchedSecond[0])
        matchedSecond = matches(for: "\\d{2}", in: matchedSecond[0])
        guard let second = Int(matchedSecond[0]) else { return nil }
        
        return DateMessage(day: day, month: getNameMonth(numberMonth: String(month)), year: year, hour: hour, minute: minute, second: second)
    }
    
    func matches(for regex: String, in text: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }

    func getNameMonth(numberMonth: String) -> String {
        let month: String
        
        switch numberMonth {
        case "01":
            month = "Января"
        case "02":
            month = "Февраля"
        case "03":
            month = "Марта"
        case "04":
            month = "Апреля"
        case "05":
            month = "Мая"
        case "06":
            month = "Июня"
        case "07":
            month = "Июля"
        case "08":
            month = "Августа"
        case "09":
            month = "Сентября"
        case "10":
            month = "Октября"
        case "11":
            month = "Сентября"
        case "12":
            month = "Февраля"
        default:
            month = "Неизвестно"
        }
        
        return month
    }
}

extension ChatScreenViewController {
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

extension ChatScreenViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .placeholderChatInputMessage {
            textView.text = nil
            textView.textColor = .white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Напишите сообщение..."
            textView.textColor = .placeholderChatInputMessage
        }
    }
}
