//
//  OperationManager.swift
//  OperationExampleApp
//
//  Created by Corey Davis on 1/4/21.
//

import Foundation

protocol OperationsManager: class {
    var inProcess: [String: Operation] { get set }
    var processQueue: OperationQueue { get }

    func newAnOperation(apiService: APIService) -> AnOperation
    func newAnotherOperation(apiService: APIService) -> AnotherOperation

    func add(operations: [EXOperation])
}

class OperationsManagerImplementation: OperationsManager {

    static let shared: OperationsManager = OperationsManagerImplementation(queueName: "MainOpQueue")

    private let queueName: String

    lazy var inProcess: [String: Operation] = [:] // this is one way to contain easy reference to our inprocess ops if we want
                                                  // or we can get them through the actual operation queue

    lazy var processQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = self.queueName
        queue.maxConcurrentOperationCount = .max
        return queue
    }()

    // we can have one operation queue or many, that is up to us, but the manager here maintains the reference in its singleton to any and all

    init(queueName: String) {
        self.queueName = queueName
    }

    func add(operations: [EXOperation]) {
        processQueue.addOperations(operations, waitUntilFinished: false)
    }
}

extension OperationsManagerImplementation {
    func newAnOperation(apiService: APIService) -> AnOperation {
        return AnOperation(apiService: apiService)
    }

    func newAnotherOperation(apiService: APIService) -> AnotherOperation {
        return AnotherOperation(apiService: apiService)
    }
}

// MARK: - A pretend API service

protocol APIService: class {
    func postSomething(_ completion: @escaping () -> Void)
    func getSomething(_ completion: @escaping () -> Void)
}

class APIServiceImp: APIService {

    func postSomething(_ completion: @escaping () -> Void) {
        Thread.sleep(forTimeInterval: 10)
        completion()
    }

    func getSomething(_ completion: @escaping () -> Void) {
        Thread.sleep(forTimeInterval: 10)
        completion()
    }
}

// MARK: - Some operations to do things

class AnOperation: EXOperation {

    private let apiService: APIService

    init(apiService: APIService) {
        self.apiService = apiService
    }

    override func main() {
        if isCancelled {
            finish(true)
            return
        }

        executing(true)
        apiService.postSomething {
            if self.isCancelled {
                self.finish(true)
                return
            }

            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Notification.Name("POST_DONE"), object: nil)
            }
            self.executing(false)
            self.finish(true)
        }
    }
}

class AnotherOperation: EXOperation {

    private let apiService: APIService

    init(apiService: APIService) {
        self.apiService = apiService
    }

    override func main() {
        if isCancelled {
            finish(true)
            return
        }

        executing(true)
        apiService.getSomething {
            if self.isCancelled {
                self.finish(true)
                return
            }

            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Notification.Name("GET_DONE"), object: nil)
            }
            self.executing(false)
            self.finish(true)
        }
    }
}
