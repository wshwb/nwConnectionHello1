//
//  UDPClient.swift
//

import Network
import Foundation

class UDPListener {
    func handleResponse(_ client: UDPClient, data: Data){
        //print(data.count)
    }
}

class UDPClient {
    
    var connection: NWConnection
    var address: NWEndpoint.Host
    var port: NWEndpoint.Port
    var delegate: UDPListener?
    
    var resultHandler = NWConnection.SendCompletion.contentProcessed { NWError in
        guard NWError == nil else {
            print("ERROR! Error when data (Type: Data) sending. NWError: \n \(NWError!)")
            return
        }
    }

    init?(address newAddress: String, port newPort: Int32) {
        guard let codedAddress = IPv4Address(newAddress),
            let codedPort = NWEndpoint.Port(rawValue: NWEndpoint.Port.RawValue(newPort)) else {
                print("Failed to create connection address")
                return nil
        }
        address = .ipv4(codedAddress)
        port = codedPort
        
        connection = NWConnection(host: address, port: port, using: .udp)
        connection.stateUpdateHandler = { newState in
            switch (newState) {
            case .ready:
                print("State: Ready")
                return
            case .setup:
                print("State: Setup")
            case .cancelled:
                print("State: Cancelled")
            case .preparing:
                print("State: Preparing")
            default:
                print("ERROR! State not defined!\n")
            }
        }
        connection.start(queue: .global())
    }
    
    deinit {
        connection.cancel()
    }
    
    func send(_ data: Data) {
        self.connection.send(content: data, completion: self.resultHandler)
        self.connection.receiveMessage { data, context, isComplete, error in
            guard let data = data else {
                print("Error: Received nil Data")
                return
            }
            guard self.delegate != nil else {
                print("Error: UDPClient response handler is nil")
                return
            }
            self.delegate?.handleResponse(self, data: data)
        }
    }
    
    func recv(){
        self.connection.receiveMessage{ data, context, isComplete, error in
            guard let data = data else {
                print("Error: Received nil Data")
                return
            }
            guard self.delegate != nil else {
                print("Error: UDPClient response handler is nil")
                return
            }
            print(data.count)
            self.recv()
            //self.delegate?.handleResponse(self, data: data)
        }
    }
}
