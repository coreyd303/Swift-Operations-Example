//
//  OperationViewController.swift
//  OperationExampleApp
//
//  Created by Corey Davis on 1/4/21.
//

import Foundation
import UIKit

class OperationViewController: UIViewController {

    @IBAction func didTapStart(_ sender: Any) {
        let opOne = OperationsManagerImplementation.shared.newAnOperation(apiService: APIServiceImp())
        opOne.name = "PostOp"

        let opTwo = OperationsManagerImplementation.shared.newAnotherOperation(apiService: APIServiceImp())

        opTwo.addDependency(opOne)  // this sets the second op as dependent on the completion of the first, so we have control of order of execution

        OperationsManagerImplementation.shared.add(operations: [opOne, opTwo])
    }

}
