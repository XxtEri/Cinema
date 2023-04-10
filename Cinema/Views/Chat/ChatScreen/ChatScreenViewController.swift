//
//  ChatScreenViewController.swift
//  Cinema
//
//  Created by Елена on 09.04.2023.
//

import UIKit

class ChatScreenViewController: UIViewController {
    
    private let ui: ChatScreenView
    
    private var blocks: [MessageServer]
    
    private var currentDate: DateMessage?
    
    var viewModel: ChatViewModel?
    
    var messages = [
        MessageServer(messageId: "3", creationDateTime: "2023-04-09T09:55:25.192531", authorId: "337a3473-b2e3-4736-ba8a-13e035b72d90", authorName: "Green Greenpix", authorAvatar: "https://ucarecdn.com/21b75d2f-14bf-4ecb-8a49-1883a00f4d3a/", text: "Ha\n-ha"),
        MessageServer(messageId: "2", creationDateTime: "2023-04-09T09:54:37.234769", authorId: "337a3473-b2e3-4736-ba8a-13e035b72d90", authorName: "Green Greenpix", authorAvatar: "https://ucarecdn.com/21b75d2f-14bf-4ecb-8a49-1883a00f4d3a/", text: "Ha\n-ha"),
        MessageServer(messageId: "1", creationDateTime: "2023-04-09T09:54:22.808868", authorId: "337a3473-b2e3-4736-ba8a-13e035b72d90", authorName: "Green Greenpix", authorAvatar: "https://ucarecdn.com/21b75d2f-14bf-4ecb-8a49-1883a00f4d3a/", text: "Ha\n-ha")
    ]
    
    init() {
        self.ui = ChatScreenView()
        blocks = messages
        
        super.init(nibName: nil, bundle: nil)
        
        self.ui.configureCollection(delegate: self, dataSource: self)
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
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func reloadDataChat() {
        self.ui.chat.reloadData()
    }
}

extension ChatScreenViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let element = blocks[blocks.endIndex - 1]
        var defaultCell = UICollectionViewCell()
        
        let date = getDateMessage(date: element.creationDateTime)

        if currentDate != nil && date != nil {
            if !isDatesEqual(firstDate: date!, secondDate: currentDate!) {
                currentDate = date
            }
            
        } else {
            currentDate = date
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DateCollectionViewCell.reuseIdentifier, for: indexPath) as? DateCollectionViewCell else { return defaultCell }
        
        
        
        return cell
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
