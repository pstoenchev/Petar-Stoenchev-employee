//
//  ViewController.swift
//  employee
//
//  Created by Petar Stoenchev on 26.01.21.
//

import UIKit


// MARK: - Class Definition

final class ViewController: UIViewController {
    
    @IBOutlet private weak var workingTimeLabel: UILabel!
    
    
    var sortedDaysOfWorking:[Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        workingTimeLabel.text = "No result!"
        dateWorking(path: "File", extensionType: "txt")
    }
}

// MARK: - Definitions

extension ViewController {
    
    func stringFromDate(date: DateComponents) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        return dateFormatter.string(for: date)
    }
    
    
    /// Give result between two date
    /// - Parameters:
    ///   - name: name of File, in bundle
    ///   - extensionType: type of file. Example `txt`
   private func dateWorking(path name: String, extensionType: String) {
        
        print("(1)Id     Id(2)              Date        ")
        
        
    guard let path = Bundle.main.url(forResource: name, withExtension: extensionType) else { return }
            
    do {
        /// Encoding data from path
        let data = try String(contentsOf: path, encoding: .utf8)
        
        let myStrings = data.components(separatedBy: .newlines)
        
        let lines = myStrings.map { $0.components(separatedBy: ", ") }
        
        var k = myStrings.count - 1
        
        for line  in lines {
            if k > 0 {
                guard line.count - 1 > 0 else { return }
                /// Get id  first employee
                let idFirst  = line[0]
                
                /// Get id second employee
                let idSecond = line[1]
                
                k = k - 1
                ///Get start date from File.txt
                let first = line[2]
                
                ///Get end date from File.txt
                var second = line[3]
                
                let dateFormatterFrom = DateFormatter()
                dateFormatterFrom.locale = Locale(identifier: "en_US_POSIX")
                
                if first.contains("-" ) {
                    dateFormatterFrom.dateFormat = "yyyy-MM-dd"
                } else if first.contains("/") {
                    dateFormatterFrom.dateFormat = "yyyy/MM/dd HH:mm:ss Z"
                } else if first.contains(" ") {
                    dateFormatterFrom.dateFormat = "MMM dd,yyyy"
                }
                
                let date = Date()
                ///IF end data  NULL you can give date now.
                if second == "NULL" {
                    second = dateFormatterFrom.string(from: date)
                }
                
                ///Make start date  from String  to DateFormatter
                guard let firstDate = dateFormatterFrom.date(from: first) else { return }
                
                ///Make end date  from String  to DateFormatter
                guard let secondDate = dateFormatterFrom.date(from: second) else { return }
                
                let workingInterval = Calendar.current.dateComponents([.day], from: firstDate, to: secondDate)
                print("\(idFirst)        \(idSecond)        \(workingInterval)")
                let int = Array(arrayLiteral: workingInterval.day ?? 0)
                sortedDaysOfWorking.append(contentsOf: int)
                
                let writeInFile = paths().appendingPathComponent("results.txt")
                do {
                    try workingInterval.description.write(to: writeInFile, atomically: true, encoding: .utf8)
                }
                catch {
                    print(error.localizedDescription)
                }
            } else {
               // print(sortedDaysOfWorking.sorted { $0 < $1 })
                let days = sortedDaysOfWorking.sorted {  $0 < $1 }
                workingTimeLabel.text = String(days.last ?? 0)
            }
        }
    } catch {
        print(error.localizedDescription)
    }
   }
}

/// Get file path for write.
private func paths() -> URL {
    let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return path[0]
}
