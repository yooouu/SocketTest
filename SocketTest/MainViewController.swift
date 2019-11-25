//
//  ViewController.swift
//  SocketTest
//
//  Created by 유영문 on 2019/11/25.
//  Copyright © 2019 exs-mobile. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    public let SOCKET_HOST: String = "dart.exs-mobile.com"
    public let SOCKET_PORT: Int = 14089

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        startSocket()
    }

    @IBAction func onTouchStop(_ sender: UIButton) {
        endSocket()
    }
    
    // MARK: Start Socket connect
    func startSocket() {
        TCPSocket.shared.connect(host: "\(SOCKET_HOST)", port: SOCKET_PORT)
        TCPSocket.shared.socketDelegate = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            let dataStr = "start \(UserData.shared.userNo):\(UserData.shared.historyRegNo)"
//            guard let data = dataStr.data(using: .utf8, allowLossyConversion: true) else { return }
//            TCPSocket.shared.send(data: data)
        }
    }
    // MARK: End Socket connect
    func endSocket() {
//        let dataStr = "end \(UserData.shared.userNo):\(UserData.shared.historyRegNo)"
//        guard let data = dataStr.data(using: .utf8, allowLossyConversion: true) else { return }
//        TCPSocket.shared.send(data: data)
        
        TCPSocket.shared.disconnect()
    }
}

extension MainViewController: SocketDelegate {
    func socketDidConnected() {
        print("socketDidConnected!")
    }
    
    func socketDidReceiveMessage(data: String) {
        print("socketDidReceiveMessage: \(data)!")
    }
    
    func socketDidReceiveFail() {
        print("socketDidReceiveFail!")
    }
    
    func socketDidDisconnected() {
        print("socketDidDisconnected!")
    }
}
