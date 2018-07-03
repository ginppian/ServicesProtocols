//
//  BaseServices.swift
//  Tiempos
//
//  Created by Gmo Ginppian on 28/06/18.
//  Copyright © 2018 Andres Fernandez. All rights reserved.
//

import Foundation

protocol ServiciosDelegate {
    func respuestaExistosa(objecto: Any)
    func respuestaFallida(error: Any)
}

class BaseServices: NSObject {
    
    var session: URLSession?
    var dataTask: URLSessionDataTask?
    
    var delegate: ServiciosDelegate?
    
    override init() {
        super.init()
        session = URLSession(configuration: .default)

    }
    
    func submitRequest(url: URL) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        dataTask = session?.dataTask(with: request, completionHandler: completionHandler)
        dataTask?.resume()
    }
    
    fileprivate func completionHandler(data: Data?, response: URLResponse?, error: Error?) -> Void {
        guard error == nil else {
            print("error conexión: \(String(describing: error)) ")
            if let _delegate = delegate {
                _delegate.respuestaFallida(error: error ?? "")
            }
            return
        }
        guard response != nil else {
            print("no hay response")
            return
        }
        if let _data = data {
            do {
                let json = try JSONSerialization.jsonObject(with: _data, options: []) as? [String: Any]
                guard let _json = json else {
                    return
                }
                if let _delegate = delegate {
                    _delegate.respuestaExistosa(objecto: _json)
                }
            } catch {
                
            }
            
        }
    }
}
