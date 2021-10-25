//
//  ViewController.swift
//  ImageCaching
//
//  Created by Igor on 25.10.2021.
//

import UIKit

class ViewController: UITableViewController {
    
    private var contacts: [Contact] = []
    private let requestURL = "https://randomuser.me/api/?results=100"

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 100
        fetchContacts()
    }

    private func fetchContacts() {
        NetworkManager.shared.fetchContacts(stringWithUrl: requestURL) { result in
            switch result {
                
            case .success(let contacts):
                self.contacts = contacts
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        let contactForCell = contacts[indexPath.row]
        content.text = contactForCell.name.fullName
        
        DispatchQueue.global().async {
            if let url = URL(string: contactForCell.picture.large), let imageData = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    content.image = UIImage(data: imageData)
                    cell.contentConfiguration = content
                }
            }
        }
        
        cell.contentConfiguration = content
        
        return cell
    }

}
