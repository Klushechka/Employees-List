//
//  EmployeeDetailsViewController.swift
//  Employees
//
//  Created by Olga Kliushkina on 30.05.2020.
//  Copyright © 2020 Olga Kliushkina. All rights reserved.
//

import Foundation
import UIKit
import ContactsUI

final class EmployeeDetailsViewController: UIViewController {
    @IBOutlet weak var nameAndSurnameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var projectsLabel: UILabel!
    @IBOutlet weak var openLocalContactsButton: UIButton!
    
    var viewModel: EmployeeDetailsViewModelImpl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLabels()
        showLocalContactButtonIfNeeded()
        setUpErrorCallback()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let viewModel = self.viewModel else { return }
        
        viewModel.fetchLocalContacts()
    }
    
    private func setUpLabels() {
        guard let viewModel = self.viewModel else { return }
        
        self.nameAndSurnameLabel.text = String("\(viewModel.employee.name) \(viewModel.employee.surname)").uppercased()
        self.positionLabel.text = viewModel.employee.position
        self.emailLabel.text = viewModel.employee.contactDetails.email
        
        setupOptionalLabels()
    }
    
    private func setupOptionalLabels() {
        setUpProjectsLabel()
        setUpPhoneLabel()
    }
    
    private func setUpProjectsLabel() {
        guard let viewModel = self.viewModel else { return }
        
        if let projects = viewModel.employee.projects {
            self.projectsLabel.text = "\(DetailsConstants.projects) \(projects.joined(separator: ", "))"
        }
        else {
            self.projectsLabel.text = DetailsConstants.noProjectsPlaceholder
            self.projectsLabel.textColor = .lightGray
        }
    }
    
    private func setUpPhoneLabel() {
        guard let viewModel = self.viewModel else { return }
        
        if let phoneNumber = viewModel.employee.contactDetails.phone {
            self.phoneLabel.text = phoneNumber
        }
        else {
            self.phoneLabel.text = DetailsConstants.phonePlaceholder
            
            self.phoneLabel.textColor = .lightGray
        }
    }
    
    @IBAction func localContactButtonTapped(_ sender: Any) {
        guard let viewModel = self.viewModel else { return }
        
        openLocalContact(fullName: viewModel.employee.name +  " " + viewModel.employee.surname)
    }
    
}

private extension EmployeeDetailsViewController {
    
    func showLocalContactButtonIfNeeded() {
        guard let viewModel = self.viewModel else { return }
        
        self.openLocalContactsButton.isHidden = !viewModel.showLocalContactButton
        
        viewModel.localContactsListUpdated = {
            DispatchQueue.main.async {
                self.openLocalContactsButton.isHidden = !viewModel.showLocalContactButton
            }
        }
    }
    
    func openLocalContact(fullName: String) {
        guard let viewModel = self.viewModel, let navigationController = self.navigationController, let contact = viewModel.localContact(fullName: fullName) else { return }
        
        let contactVC = CNContactViewController(for: contact)
        navigationController.pushViewController(contactVC, animated: true)
    }
    
}

private extension EmployeeDetailsViewController {
    
    func setUpErrorCallback() {
        guard let viewModel = self.viewModel else { return }
        
        viewModel.errorOccured = { [weak self] in
            guard let self = self else { return }
            
            DispatchQueue.main.sync {
                self.showDefaultStyleAlert(title: AlertConstants.errorTitle, message: AlertConstants.generalErrorDescription, buttonLabel: Constants.closeButton)
            }
        }
    }
    
}
