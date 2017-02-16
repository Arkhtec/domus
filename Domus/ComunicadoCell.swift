//
//  ComunicadoCell.swift
//  Condominus
//
//  Created by Thiago Vinhote on 16/01/17.
//  Copyright © 2017 Arkhtec. All rights reserved.
//

import UIKit

class ComunicadoCell: UICollectionViewCell {
    
    static let dateFormatter : DateFormatter = {
        let dt = DateFormatter()
        dt.dateStyle = .medium
        dt.timeStyle = .none
        return dt
    }()
    
    @IBOutlet weak var imagemStatus: UIImageView!
    @IBOutlet weak var imagemRemetente: UIImageView!
    @IBOutlet weak var labelData: UILabel!
    @IBOutlet weak var labelTitulo: UILabel!
    
    weak var comunicado: Comunicado? {
        didSet{
            if let titulo = comunicado?.titulo {
                self.labelTitulo.text = titulo
            }
            if let data = comunicado?.dataEnvio {
                self.labelData.text = ComunicadoCell.dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(data)))
            }
            if let imagemRemetente = comunicado?.remetenteImagemUrl {
                self.imagemRemetente.loadImageUsingCache(withUrlString: imagemRemetente)
            }
        }
    }
    
}
