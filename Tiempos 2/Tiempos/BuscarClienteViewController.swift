//
//  BuscarClienteViewController.swift
//  Tiempos
//
//  Created by Gmo Ginppian on 28/06/18.
//  Copyright © 2018 Andres Fernandez. All rights reserved.
//

import Foundation
import UIKit

class BuscarClienteViewController: ViewController, ServiciosDelegate {
    
    @IBOutlet weak var txtCliente: UITextField!
    @IBOutlet weak var txtNombre: UILabel!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    var baseUrl = "http://erp.netsec.com.mx:8086/conttempo/cliente/"
    var url: URL!
    var service: BaseServices!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.service = BaseServices()
        service.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.txtNombre.text = ""
        activity.isHidden = true
    }
    
    @IBAction func buscarCliente(_ sender: UIButton) {
        // Limpiamos si ya hay una consulta anterior
        self.txtNombre.text = ""

        // Obtenemos el id del cliente
        let cliente = txtCliente.text
        
        if let _cliente = cliente{
            print("_cliente: \(_cliente)")
            
            // Construimos la cadena
            let strUrl = "\(baseUrl)\(_cliente)"
            print("strUrl: \(strUrl)")
            
            // Construimos la url
            url = URL(string: strUrl)
            
            // Enviamos el servicio y nos asignamos como delegados de la respuesta del servicio
            activity.isHidden = false
            service.submitRequest(url: url)
        }
    }

    
    func respuestaExistosa(objecto: Any) {
        print(objecto)
        let dicData = objecto as? [String: Any]
        
        if let _dicData = dicData {
            if let dic = _dicData["Data"] as? [[String:Any]],
                !dic.isEmpty {
                let nombre = dic[0]["Nombre"] as? String ?? ""
                print("nombre: \(nombre)")
                DispatchQueue.main.async {
                    self.activity.isHidden = true
                    self.txtNombre.text = nombre
                }
            }
        }
    }
    
    func respuestaFallida(error: Any) {
        print(error)
    }
    
}
