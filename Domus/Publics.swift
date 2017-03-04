//
//  Publics.swift
//  Condominus
//
//  Created by Thiago Vinhote on 04/03/17.
//  Copyright © 2017 Arkhtec. All rights reserved.
//

import Foundation

func verificarConexao() -> Bool {
    
    let networkStatus = Reachability().connectionStatus()
    
    switch networkStatus {
    case .Unknown, .Offline:
        print("Desconected")
        return false
    case .Online(.WWAN):
        print("Connected via WWAN")
        return true
    case .Online(.WiFi):
        print("Connected via WiFi")
        return true
    }
}
