//
//  NetworkConnection.swift
//  NewsApp
//
//  Created by SNEAHAAL on 10/04/23.
//

import Foundation
import UIKit
import Network

class NetworkConnection{
    static let shared = NetworkConnection()
    
    let monitor = NWPathMonitor()
    private var status : NWPath.Status = .requiresConnection
    var isReachable : Bool { status == .satisfied }
    var isReacheableOnCellular : Bool = true

    func startMonitoring(completionHandler: @escaping(Bool)->Void){
        monitor.pathUpdateHandler = { [unowned self] path in
            self.status = path.status
            if path.status == .satisfied{
                print("We are Connected")
                isReacheableOnCellular = true
                
            }else {
                print("No Connection")
                isReacheableOnCellular = false
            }
            completionHandler(isReacheableOnCellular)
        }
        let queue = DispatchQueue(label: "NetworkConnection")
        monitor.start(queue: queue)
    }
    
    func stopMonitoring(){
        monitor.cancel()
    }
    
    
}
