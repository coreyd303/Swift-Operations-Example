//
//  ViewController.swift
//  OperationExampleApp
//
//  Created by Corey Davis on 1/4/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var labelOne: UILabel!
    @IBOutlet weak var labelTwo: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()

        labelOne.text = ""
        labelTwo.text = ""

        NotificationCenter.default.addObserver(self, selector: #selector(postDone), name: Notification.Name("POST_DONE"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getDone), name: Notification.Name("GET_DONE"), object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        if OperationsManagerImplementation.shared.processQueue.operations.first(where: { $0.name == "PostOp"}) != nil {
            labelOne.text = "Operation Running"
        }
    }

    @objc func postDone() {
        labelOne.text = "AnOperation for POST is done!!"
    }


    @objc func getDone() {
        labelTwo.text = "AnotherOperation for GET is done!!"
    }
}

