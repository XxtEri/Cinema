//
//  ViewControllerChat.swift
//  Cinema
//
//  Created by Елена on 09.04.2023.
//

import UIKit
import SnapKit
import InputBarAccessoryView
import MessageKit

class MessageListViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero)
        view.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.dataSource = self
        view.delegate = self
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(tableView)
        
        configureConstraints()
    }

    func configureConstraints() {
        tableView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.verticalEdges.equalToSuperview()
        }
    }
}

extension MessageListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = "Jony"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ChatViewController()
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
