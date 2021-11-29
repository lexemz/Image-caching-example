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
        tableView.register(ContactViewCell.nib(), forCellReuseIdentifier: ContactViewCell.cellID)
        fetchContacts()
    }

    private func fetchContacts() {
        NetworkManager.shared.fetch(stringWithUrl: requestURL, model: Results.self) { result in
            switch result {
            case .success(let result):
                self.contacts = result.results
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
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactViewCell.cellID, for: indexPath) as! ContactViewCell
        let contactForCell = contacts[indexPath.row]

        cell.configure(for: contactForCell)

        return cell
    }
}
