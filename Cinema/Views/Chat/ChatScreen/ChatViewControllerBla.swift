//
//  ChatViewControllerBla.swift
//  Cinema
//
//  Created by Елена on 15.04.2023.
//

import UIKit

class ChatViewControllerBla: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Массив сообщений
    var messages: [String] = ["ksdnf;sdc", "skdnsdnvc", "s'dojcv;jsndc'"]

    // Таблица для отображения сообщений
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        return tableView
    }()

    // Поле ввода текста
    let textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Введите сообщение"
        textField.borderStyle = .roundedRect
        return textField
    }()

    // Кнопка отправки сообщения
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Отправить", for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupToHideKeyboardOnTapOnView()
        
        title = "Чат"
        view.backgroundColor = .white

        // Настройка таблицы
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MessageCell")

        // Добавление таблицы на экран
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // Добавление поля ввода текста на экран
        view.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80),
            textField.heightAnchor.constraint(equalToConstant: 40)
        ])

        // Добавление кнопки отправки сообщения на экран
        view.addSubview(sendButton)
        NSLayoutConstraint.activate([
            sendButton.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 8),
            sendButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            sendButton.heightAnchor.constraint(equalToConstant: 40)
        ])

        // Добавление обработчиков событий для кнопки отправки сообщения
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    // Метод обработки нажатия на кнопку отправки сообщения
    @objc func sendButtonTapped() {
        if let message = textField.text, !message.isEmpty {
            messages.append(message)
            tableView.reloadData()
            textField.text = nil
            textField.resignFirstResponder()
        }
    }

    // Методы UITableViewDelegate и UITableViewDataSource для работы с таблицей
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath)
        cell.textLabel?.text = messages[indexPath.row]
        return cell
    }
    
    @objc
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            // Высота клавиатуры
            let keyboardHeight = keyboardFrame.size.height
            
            // Настройка расположения вашего поля ввода (textField или textView)
            // Например, установка новых координат для вашего поля ввода
            // Может потребоваться рассчитать новые координаты, учитывая высоту клавиатуры и размеры вашего интерфейса
            textField.frame.origin.y = view.bounds.height - keyboardHeight - textField.bounds.height
        }
    }
    
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
