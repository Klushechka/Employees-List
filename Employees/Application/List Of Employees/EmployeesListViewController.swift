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
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var employeesTableView: UITableView!
    
    private var viewModel: EmployeeListViewModelImpl?
    private var searchController: UISearchController?
    
    private var refreshControl: UIRefreshControl?
    private var activityIndicator: UIActivityIndicatorView?
    private var isSearchActive: Bool = false
    private var currentSearchQuery: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViewModelAndCallbacks()
        showDefaultPlaceholderIfNeeded()
        setUpActivityIndicator()
        
        setUpSearchBar()
        setUpTableViewInteractions()
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
            guard let self = self else { return }
            
            DispatchQueue.main.sync {
                self.stopSpinnersAnimation()
                
                self.showDefaultStyleAlert(title: AlertConstants.errorTitle, message: AlertConstants.generalErrorDescription, buttonLabel: Constants.closeButton)
            }
        }
    }
    
    func setUpEmployeesUpdateCallback() {
        guard let viewModel = self.viewModel else { return }
        
        viewModel.employeesListUpdated = { [weak self] in
            guard let self = self else { return }
            
            if self.isSearchActive, !viewModel.isSearchRefreshCompleted {
                return
            }
            
            let employeesList = self.isSearchActive ? viewModel.employeesMatchingQuery : viewModel.employees
            
            if let employees = employeesList, employees.count > 0 {
                self.reloadTable()
            }
            else {
                let placeholderText = self.isSearchActive ?  EmployeesConstants.noResultsPlaceholder : EmployeesConstants.defaultTableViewPlaceholder
                
                DispatchQueue.main.async {
                    self.employeesTableView.reloadData()
                    self.employeesTableView.showPlaceholder(message: placeholderText)
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
    
    func showDefaultPlaceholderIfNeeded() {
        guard let viewModel = self.viewModel, let employees = viewModel.employees, employees.count > 0 else {
            
            DispatchQueue.main.async {
                self.employeesTableView.showPlaceholder(message: EmployeesConstants.defaultTableViewPlaceholder)
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
        
        let completion: (() -> Void)? = { viewModel.filterEmployeesMatching(query: self.currentSearchQuery)
        }
        
        viewModel.downloadEmployees(completion: self.isSearchActive ? completion : nil)
    }
    
}

extension EmployeesListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let navigationController = self.navigationController else { return }
        
        guard let employeeDetailsVC = ViewControllerFactory().viewController(for: .employeeDetails) as? EmployeeDetailsViewController, let viewModel = self.viewModel else { return }
        
        guard let employeesInSection =  viewModel.employeesWithPosition(positionSection: indexPath.section, isSearchActive: self.isSearchActive) else { return }
        employeeDetailsVC.viewModel = EmployeeDetailsViewModelImpl(with: employeesInSection[indexPath.row])
        navigationController.pushViewController(employeeDetailsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: EmployeeCell.identifier) as? EmployeeCell
        
        if cell == nil {
            tableView.register(UINib(nibName: EmployeeCell.nibName, bundle: nil), forCellReuseIdentifier: EmployeeCell.identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: EmployeeCell.identifier) as? EmployeeCell
        }
        
        guard let viewModel = self.viewModel, let employeeCell = cell else {
                return UITableViewCell()
        }
        
        guard let fullEmployeesList = viewModel.employeesWithPosition(positionSection: indexPath.section, isSearchActive: self.isSearchActive) else { return UITableViewCell() }
        
        let employee = fullEmployeesList[indexPath.row]
        
        employeeCell.nameSurnameLabel.text = employee.name + " " + employee.surname
        employeeCell.openLocalContactsButton.isHidden = !viewModel.isEmployeeInLocalContacts(employee: employee)
        employeeCell.localContactButtonTapped = {
            self.openLocalContact(with: employee.name + " " + employee.surname)
        }
        
        return employeeCell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let viewModel = self.viewModel else {
            return 0
        }
        
        if self.isSearchActive, let positionsForSearchResults = viewModel.positionsForSearchResults {
            return positionsForSearchResults.count
        }
        else if let positions = viewModel.positions {
            return positions.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let viewModel = self.viewModel, let employees = viewModel.employeesWithPosition(positionSection: section, isSearchActive: self.isSearchActive) {
            return employees.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let viewModel = self.viewModel else { return  nil }
        
        if self.isSearchActive, let positionsForSearchResults = viewModel.positionsForSearchResults {
            return positionsForSearchResults[section]
        }
        else if let projects = viewModel.positions {
            return projects[section]
        }
        
        return nil
    }
    
}

private extension EmployeesListViewController {
    
    func reloadTable() {
        DispatchQueue.main.async {
            self.employeesTableView.hidePlaceholder()
            self.employeesTableView.reloadData()
        }
    }
    
    func setUpTableViewInteractions() {
        self.employeesTableView.delegate = self
        self.employeesTableView.dataSource = self
        self.employeesTableView.keyboardDismissMode = .onDrag
        
        setUpTableViewRefreshControl()
    }
    
}

private extension EmployeesListViewController {
    
    func openLocalContact(with fullName: String) {
        guard let viewModel = self.viewModel, let navigationController = self.navigationController, let contact = viewModel.localContact(fullName: fullName) else { return }
        
        let contactVC = CNContactViewController(for: contact)
        navigationController.pushViewController(contactVC, animated: true)
    }
    
}

extension EmployeesListViewController: UISearchBarDelegate, UISearchDisplayDelegate {
    
    func setUpSearchBar() {
        self.searchBar.placeholder = "Search"
        self.searchBar.delegate = self
        self.searchBar.showsCancelButton = false
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        guard let employeesTableView = self.employeesTableView else { return }
        
        self.isSearchActive = false
        self.searchBar.text = ""
        employeesTableView.reloadData()
        
        self.searchBar.resignFirstResponder()
        self.searchBar.showsCancelButton = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)  {
        self.searchBar.resignFirstResponder()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let viewModel = self.viewModel else { return }
        
        self.currentSearchQuery = searchBar.text
        
        if self.searchBar.text == "" {
            self.isSearchActive = false
            employeesTableView.reloadData()
        }
        else {
            self.isSearchActive = true
            self.searchBar.showsCancelButton = true
            
            viewModel.filterEmployeesMatching(query: searchBar.text)
        }
    }
    
    func employeeFilteredIfNeeded(for indexPath: IndexPath) -> Employee? {
        guard let viewModel = self.viewModel else { return nil }
        
        if self.isSearchActive, let employeesMatchingQuery = viewModel.employeesMatchingQuery {
            return employeesMatchingQuery[indexPath.row]
        }
        else if let employees = viewModel.employeesWithPosition(positionSection: indexPath.section) {
            return employees[indexPath.row]
        }
        
        return nil
    }
    
}
