//
//  EmployeesListViewController.swift
//  Employees
//
//  Created by Olga Kliushkina on 27.05.2020.
//  Copyright © 2020 Olga Kliushkina. All rights reserved.
//

import Foundation
import UIKit
import Contacts
import ContactsUI

final class EmployeesListViewController: UIViewController {
    
    @IBOutlet weak var employeesTableView: UITableView!
    
    private var viewModel: EmployeeListViewModelImpl?
    
    private var refreshControl: UIRefreshControl?
    private var activityIndicator: UIActivityIndicatorView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViewModelAndCallbacks()
        setUpTableViewRefreshControl()
        showPlaceholderOrEmployeesTable()
        setUpActivityIndicator()
        setUpLocalContactsCallback()
        
        self.employeesTableView.delegate = self
        self.employeesTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let navigationController = self.navigationController, let viewModel = self.viewModel else { return }
        
        navigationController.setNavigationBarHidden(true, animated: animated)
        
        viewModel.fetchLocalContacts()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let navigationController = self.navigationController else { return }
        
        navigationController.setNavigationBarHidden(false, animated: animated)
    }
    
}

private extension EmployeesListViewController {
    
    func setUpViewModelAndCallbacks() {
        self.viewModel = EmployeeListViewModelImpl()
        
        setUpErrorCallback()
        setUpEmployeesUpdateCallback()
        setUpLocalContactsUpdateCallback()
    }
    
    func setUpErrorCallback() {
        guard let viewModel = self.viewModel else { return }
        
        viewModel.errorOccured = { [weak self] in
            guard let sself = self else { return }
            
            sself.stopSpinnersAnimation()
            
            DispatchQueue.main.async {
                sself.showDefaultAlert(title: AlertConstants.title, message: AlertConstants.message, buttonLabel: Constants.closeButton)
            }
        }
    }
    
    func setUpEmployeesUpdateCallback() {
        guard let viewModel = self.viewModel else { return }
        
        viewModel.employeesListUpdated = { [weak self] in
            guard let self = self, let employees = viewModel.employees else { return }
            
            if employees.count > 0 {
                DispatchQueue.main.async {
                    self.employeesTableView.hidePlaceholder()
                    self.employeesTableView.reloadData()
                }
            }
            
            self.stopSpinnersAnimation()
        }
    }
    
    func setUpLocalContactsUpdateCallback() {
        guard let viewModel = self.viewModel else { return }
        
        viewModel.localContactsListUpdated = {
            guard let employees = viewModel.employees else { return }
            if employees.count > 0 {
                DispatchQueue.main.async {
                    self.employeesTableView.reloadData()
                }
            }
        }
    }
    
}

private extension EmployeesListViewController {
    
    func showPlaceholderOrEmployeesTable() {
        guard let viewModel = self.viewModel, let employees = viewModel.employees, employees.count > 0 else {
            
            DispatchQueue.main.async {
                self.employeesTableView.showPlaceholder(message: EmployeesConstants.tableViewPlaceholderText)
            }
            
            return
        }
    }
    
    func setUpTableViewRefreshControl() {
        self.refreshControl = UIRefreshControl()
        
        guard let refreshControl = self.refreshControl else { return }
        
        refreshControl.attributedTitle = NSAttributedString(string: EmployeesConstants.refreshControlText)
        refreshControl.addTarget(self, action: #selector(self.refreshList(_:)), for: .valueChanged)
        self.employeesTableView.addSubview(refreshControl)
    }
    
    func setUpActivityIndicator() {
        self.activityIndicator = UIActivityIndicatorView()
        guard let activityIndicator = self.activityIndicator else { return }
        
        activityIndicator.style = .medium
        activityIndicator.backgroundColor = .darkGray
        
        self.view.addSubview(activityIndicator)
        activityIndicator.center = self.view.center
        activityIndicator.startAnimating()
    }
    
    func stopSpinnersAnimation() {
        DispatchQueue.main.async {
            self.refreshControl?.endRefreshing()
            self.activityIndicator?.stopAnimating()
            
            self.activityIndicator?.hidesWhenStopped = true
        }
    }
    
    @objc func refreshList(_ sender: UIRefreshControl) {
        guard let viewModel = self.viewModel else { return }
        
        viewModel.downloadEmployees()
    }
    
}

extension EmployeesListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let navigationController = self.navigationController else { return }
        
        guard let employeeDetailsVC = ViewControllerFactory.viewController(for: .employeeDetails) as? EmployeeDetailsViewController, let viewModel = self.viewModel, let employeesInSection = viewModel.employeesWithPosition(positionSection: indexPath.section) else { return }
        
        employeeDetailsVC.viewModel = EmployeeDetailsViewModelImpl(with: employeesInSection[indexPath.row])
        navigationController.pushViewController(employeeDetailsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: EmployeeCell.identifier) as? EmployeeCell
        
        if cell == nil {
            tableView.register(UINib(nibName: EmployeeCell.nibName, bundle: nil), forCellReuseIdentifier: EmployeeCell.identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: EmployeeCell.identifier) as? EmployeeCell
        }
        
        guard let viewModel = self.viewModel, let employeeCell = cell,
            let employees = viewModel.employeesWithPosition(positionSection: indexPath.section) else {
                return UITableViewCell()
        }
        
        let employee = employees[indexPath.row]
        
        employeeCell.nameSurnameLabel.text = employee.name + " " + employee.surname
        employeeCell.openLocalContactsButton.isHidden = !viewModel.isEmployeeInLocalContacts(employee: employees[indexPath.row])
        employeeCell.localContactButtonTapped = {
            self.openLocalContact(with: employee.name + " " + employee.surname)
        }
        
        return employeeCell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let viewModel = self.viewModel, let projects = viewModel.positions else {
            return 0
        }
        
        return projects.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = self.viewModel, let employees = viewModel.employeesWithPosition(positionSection: section) else { return 0 }
        
        return employees.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let viewModel = self.viewModel, let projects = viewModel.positions else { return  nil }
        
        return projects[section]
    }
    
}

private extension EmployeesListViewController {
    
    func setUpLocalContactsCallback() {
        guard let viewModel = self.viewModel else { return }
        
        viewModel.showContactsAlert = {
            self.showContactsSettingsAlert()
        }
    }
    
    func openLocalContact(with fullName: String) {
        guard let viewModel = self.viewModel, let navigationController = self.navigationController, let contact = viewModel.localContact(fullName: fullName) else { return }
        
        let contactVC = CNContactViewController(for: contact)
        navigationController.pushViewController(contactVC, animated: true)
    }
    
}
