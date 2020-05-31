//
//  EmployeeDetailsViewController.swift
//  Employees
//
//  Created by Olga Kliushkina on 30.05.2020.
//  Copyright © 2020 Olga Kliushkina. All rights reserved.
//

import Foundation
import UIKit

final class EmployeeDetailsViewController: UIViewController {
    @IBOutlet weak var nameAndSurnameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var projectsLabel: UILabel!
    
    var viewModel: EmployeeDetailsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLabels()
    }
    
    private func setUpLabels() {
        guard let viewModel = self.viewModel else { return }
        
        self.nameAndSurnameLabel.text = String("\(viewModel.employee.name) \(viewModel.employee.surname)").uppercased()
        self.positionLabel.text = viewModel.employee.position
        self.emailLabel.text = viewModel.employee.contactDetails.email
        
        setupOptionalLabels()
    }
    
    func setupOptionalLabels() {
        setUpProjectsLabel()
        setUpPhoneLabel()
    }
    
    private func setUpProjectsLabel() {
        guard let viewModel = self.viewModel else { return }
        
        if let projects = viewModel.employee.projects {
            self.projectsLabel.text = "\(DetailsConstants.projects) \(projects.joined(separator: ", "))"
        }
        else {
            self.projectsLabel.text = DetailsConstants.projectsPlaceholder
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
    
    
    
}
