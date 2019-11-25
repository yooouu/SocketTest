//
//  TCPSocket.swift
//  SocketTest
//
//  Created by 유영문 on 2019/11/25.
//  Copyright © 2019 exs-mobile. All rights reserved.
//

import Foundation

protocol SocketDelegate: class {
    func socketDidConnected()
    func socketDidReceiveMessage(data: String)
    func socketDidReceiveFail()
    func socketDidDisconnected()
}

class TCPSocket: NSObject, StreamDelegate {
    weak var socketDelegate: SocketDelegate?
    var host: String?
    var port: Int?
    var inputStream: InputStream?
    var outputStream: OutputStream?
    let bufferSize: Int = 1024
    
    public static let shared: TCPSocket = {
        return TCPSocket()
    }()
    
    private override init() {
        super.init()
        
    }
    
    func connect(host: String, port: Int) {
        self.host = host
        self.port = port
        
        Stream.getStreamsToHost(withName: host, port: port, inputStream: &inputStream, outputStream: &outputStream)
        
        if inputStream != nil && outputStream != nil {
            inputStream?.delegate = self
            outputStream?.delegate = self
            
            inputStream?.schedule(in: .main, forMode: .default)
            outputStream?.schedule(in: .main, forMode: .default)
            
            print("Start open()!")
            inputStream?.open()
            outputStream?.open()
        }
    }
    
    func send(data: Data) {
        let _ = data.withUnsafeBytes { outputStream?.write($0, maxLength: data.count) }
//            return bytesWritten!
    }
    
//    func receive(buffersize: Int) -> Data {
//        var buffer = [UInt8](repeating :0, count : buffersize)
//
//        let bytesRead = inputStream?.read(&buffer, maxLength: buffersize)
//        var dropCount = buffersize - bytesRead!
//
//        if dropCount < 0 {
//            dropCount = 0
//        }
//
//        let chunk = buffer.dropLast(dropCount)
//
//        return Data(chunk)
//    }
    
    private func read(_ stream: Stream) {
        guard let iStream = stream as? InputStream else { return }
        
        var buffer: [UInt8] = [UInt8](repeating: 0, count: self.bufferSize)
        let bytesRead = iStream.read(&buffer, maxLength: (self.bufferSize - 1))
        
        guard bytesRead >= 0 else {
            socketDelegate?.socketDidReceiveFail()
            return
        }
        
        print("received data: \(String(cString: buffer))")
        socketDelegate?.socketDidReceiveMessage(data: String(cString: buffer))
    }
    
    func disconnect() {
        inputStream?.close()
        outputStream?.close()
    }
    
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        print("event: \(eventCode)")
        
        if aStream == inputStream {
            switch eventCode {
            case Stream.Event.errorOccurred:
                print("inputStream: ErrorOccurred!")
            case Stream.Event.openCompleted:
                print("inputStream: OpenCompleted!")
            case Stream.Event.hasBytesAvailable:
                print("inputStream: HasBytesAvailable!")
                read(aStream)
            default:
                break
            }
        } else if aStream == outputStream {
            switch eventCode {
            case Stream.Event.errorOccurred:
                print("outputStream: ErrorOccurred!")
            case Stream.Event.openCompleted:
                print("outputStream: OpenCompleted!")
            case Stream.Event.hasBytesAvailable:
                print("outputStream: HasBytesAvailable!")
                read(aStream)
            default:
                break
            }
        }
    }

    
//    func receiveMessage() {
//        socket.on("new message here") { (dataArray, ack) in
//            print("dataArray : \(dataArray)")
//            self.socketDelegate?.socketDidReceiveMessage(data: dataArray)
//        }
//    }
//
//    func disconnectSocket() {
//        socket.disconnect()
//        socketDelegate?.socketDidDisconnected()
//    }
//
//    func sendMessage(_ user_no: String, _ history_reg_no: String) {
//        socket.emit("startUse", "start \(user_no):\(history_reg_no)")
//    }
}
