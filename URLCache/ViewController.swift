//
//  ViewController.swift
//  URLCache
//
//  Created by Pratik on 11/09/20.
//  Copyright © 2020 Pratik Lad. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textViewResponse: UITextView!
    
    private lazy var serverCommunication: ServerCommunication = {
        return ServerCommunication.shared
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        sampleMethod1()
    }

    func sampleMethod1() {
        let request = RequestModel(url: "https://jsonplaceholder.typicode.com/posts")
        serverCommunication.dataTask(requestObject: request) { (response) in
            guard let data = response?.data else {
                dump(response?.error)
                return
            }
            if let jsonString = String(data: data, encoding: .utf8) {
                print(jsonString)
                self.textViewResponse.text = jsonString
            }
        }
    }

}

