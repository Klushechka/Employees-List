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
        
        self.nameAndSurnameLabel.text = String("\(viewModel.employee.name) \(viewModel.employee.surname)")
        self.positionLabel.text = viewModel.employee.position
        
        if let contactDetails =  viewModel.employee.contactDetails {
            self.phoneLabel.text = contactDetails.phone
            self.emailLabel.text = contactDetails.email
        }
        
        if let projects = viewModel.employee.projects {
            self.projectsLabel.text = "Projects: \(projects.joined(separator: ", "))"
        }
    }
    
}
