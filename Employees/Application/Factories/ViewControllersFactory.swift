//
//  ViewControllersFactory.swift
//  Employees
//
//  Created by Olga Kliushkina on 27.05.2020.
//  Copyright © 2020 Olga Kliushkina. All rights reserved.
//

import Foundation
import UIKit

struct StoryboardRepresentation {
    let bundle: Bundle?
    let storyboardName: String
    let storyboardId: String
}

enum ViewControllerType {
    case employeesList, employeeDetails
}

private extension ViewControllerType {
    
    func storyboardRepresentation() -> StoryboardRepresentation {
        switch self {
        case .employeesList:
            return StoryboardRepresentation(bundle: nil, storyboardName: "EmployeesListViewController", storyboardId: "employeesList")
        case .employeeDetails:
            return StoryboardRepresentation(bundle: nil, storyboardName: "EmployeeDetailsViewController", storyboardId: "employeeDetails")
        }
    }
    
}

final class ViewControllerFactory {
    
    func viewController(for viewControllerType: ViewControllerType) -> UIViewController {
        let metadata = viewControllerType.storyboardRepresentation()
        let storyboard = UIStoryboard(name: metadata.storyboardName, bundle: metadata.bundle)
        let viewController = storyboard.instantiateViewController(withIdentifier: metadata.storyboardId)
        
        return viewController
    }
    
}
