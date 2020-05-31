//
//  EmployeesListViewController.swift
//  Employees
//
//  Created by Olga Kliushkina on 27.05.2020.
//  Copyright © 2020 Olga Kliushkina. All rights reserved.
//

import Foundation
import UIKit

final class EmployeesListViewController: UIViewController {
    
    @IBOutlet weak var employeesTableView: UITableView!
    private var viewModel: EmployeesListViewModel?
    
    private var refreshControl: UIRefreshControl?
    private var activityIndicator: UIActivityIndicatorView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViewModelAndCallbacks()
        addRefreshControl()
        showPlaceholderOrEmployeesTable()
        setUpActivityIndicator()
        
        self.employeesTableView.delegate = self
        self.employeesTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let navigationController = self.navigationController else { return }
        
        navigationController.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let navigationController = self.navigationController else { return }
        
        navigationController.setNavigationBarHidden(false, animated: animated)
    }
    
}

extension EmployeesListViewController {
    
    func setUpViewModelAndCallbacks() {
        self.viewModel = EmployeeListViewModelImpl()
        self.viewModel?.errorOccured = { [weak self] in
            guard let sself = self else { return }
            
            sself.stopSpinnersAnimation()
            
            DispatchQueue.main.async {
                sself.showAlert(title: GeneralErrorConstants.title, message: GeneralErrorConstants.message, buttonLabel: GeneralErrorConstants.closeButton)
            }
        }
        
        self.viewModel?.dataUpdated = { [weak self] in
            guard let self = self, let employees = self.viewModel?.employees else { return }
            
            if employees.count > 0 {
                DispatchQueue.main.async {
                    self.employeesTableView.restore()
                    self.employeesTableView.reloadData()
                }
            }
            
            self.stopSpinnersAnimation()
        }
    }
    
    func showPlaceholderOrEmployeesTable() {
        guard let viewModel = self.viewModel, let employees = viewModel.employees, employees.count > 0 else {
            
            DispatchQueue.main.async {
                self.showPlaceholderProgramatically()
            }
            return
        }
    }
    
    func showPlaceholderProgramatically() {
        self.employeesTableView.showPlaceholder(message: EmployeesListConstants.tableViewPlaceholderText)
    }
    
    private func addRefreshControl() {
        self.refreshControl = UIRefreshControl()
        
        guard let refreshControl = self.refreshControl else { return }
        
        refreshControl.attributedTitle = NSAttributedString(string: EmployeesListConstants.refreshControlText)
        refreshControl.addTarget(self, action: #selector(self.refreshList(_:)), for: .valueChanged)
        self.employeesTableView.addSubview(refreshControl)
    }
    
    private func setUpActivityIndicator() {
        self.activityIndicator = UIActivityIndicatorView()
        self.activityIndicator?.style = .medium
        self.activityIndicator?.backgroundColor = .darkGray
        
        guard let activityIndicator = self.activityIndicator else { return }
        
        self.view.addSubview(activityIndicator)
        activityIndicator.center = self.view.center
        
        activityIndicator.startAnimating()
    }
    
    private func stopSpinnersAnimation() {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if let viewModel = self.viewModel, let employees = viewModel.employeesWithPosition(positionSection: indexPath.section) {
            cell.textLabel?.text = ("\(employees[indexPath.row].name) \(employees[indexPath.row].surname)")
        }
        
        return cell
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
