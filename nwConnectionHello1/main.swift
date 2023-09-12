//
//  main.swift
//  nwConnectionHello1
//
//  Created by itek on 2023/9/12.
//

import Foundation
import Network

let msg="Hello,world!"
let hostUDP: NWEndpoint.Host = "127.0.0.1"
let portUDP: NWEndpoint.Port = 20131
    
var connection=NWConnection(host: hostUDP, port: portUDP, using: .udp)
    
connection.stateUpdateHandler = { (newState) in
    print("This is stateUpdateHandler:")
    switch (newState) {
        case .ready:
            print("State: Ready\n")
            sendUDP(msg)
        case .setup:
            print("State: Setup\n")
        case .cancelled:
            print("State: Cancelled\n")
        case .preparing:
            print("State: Preparing\n")
        default:
            print("ERROR! State not defined!\n")
    }
}
    
connection.start(queue: .global())
    
func sendUDP(_ msg:String){
    let contentToSend=msg.data(using: String.Encoding.utf8)
    connection.send(content: contentToSend, completion: NWConnection.SendCompletion.contentProcessed({(NWError) in
        if NWError==nil{
            print("Data was sent to UDP")
        }else{
            print("ERROR! Error when data (Type: Data) sending. NWError: \n \(NWError!)")
        }
    }))
}
sendUDP(msg)

