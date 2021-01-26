//
//  ViewController.swift
//  employee
//
//  Created by Petar Stoenchev on 26.01.21.
//

import UIKit


// MARK: - Class Definition

final class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        time()
        // Do any additional setup after loading the view.
    }


  private func time() {
        if let path = Bundle.main.path(forResource: "File", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let myString = data.components(separatedBy: ",")
                    .compactMap { $0 }
             
                let first = myString[2]
                let second = myString[3]
                print(first)
                print(second)
        
            } catch {
            
                print(error)
            }
        }

    }
}

