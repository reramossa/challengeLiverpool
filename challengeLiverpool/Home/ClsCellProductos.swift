//
//  ClsCellProductos.swift
//  challengeLiverpool
//
//  Created by Apsi on 12/09/18.
//  Copyright © 2018 rramossa. All rights reserved.
//

import Foundation

import UIKit

class ClsCellProductos: UITableViewCell {
    
    var imgNegocio = UIImageView()
    var lblTitulo = UILabel()
    var lblPrecio = UILabel()
    var lblMarca = UILabel()
    var loWidth:Double = Double(UIScreen.main.bounds.size.width)
    var loHeigth:Double = 150
    var loFont:UIFont = UIFont(name: "HelveticaNeue-Medium", size: 15)!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //imgNegocio.backgroundColor = UIColor.black
        imgNegocio.frame = CGRect(x: (0.1 * loWidth),
                                  y: (0.10 * loHeigth),
                                  width: (0.3 * loWidth),
                                  height: (0.60 * loHeigth))
        contentView.addSubview(imgNegocio)
        
        //promocion
        lblTitulo = UILabel(frame: CGRect(x: (0.45 * loWidth),
                                             y: (0.05 * loHeigth),
                                             width: (0.50 * loWidth),
                                             height: (0.40 * loHeigth)))
        lblTitulo.textAlignment = NSTextAlignment.center
        lblTitulo.textColor = UIColor.black
        lblTitulo.text = ""
        lblTitulo.adjustsFontSizeToFitWidth = true
        lblTitulo.font = loFont
        lblTitulo.numberOfLines = 3
        //lblPromocion.backgroundColor = UIColor(red: 244/255, green: 0/255, blue: 0/255, alpha: 1)
        contentView.addSubview(lblTitulo)
        
        //puntos
        lblPrecio = UILabel(frame: CGRect(x: (0.45 * loWidth),
                                          y: (0.5 * loHeigth),
                                          width: (0.50 * loWidth),
                                          height: (0.1 * loHeigth)))
        lblPrecio.textAlignment = NSTextAlignment.center
        lblPrecio.textColor = UIColor.black
        lblPrecio.text = ""
        lblPrecio.adjustsFontSizeToFitWidth = true
        lblPrecio.font = loFont
        //lblPuntos.backgroundColor = UIColor(red: 244/255, green: 0/255, blue: 0/255, alpha: 1)
        contentView.addSubview(lblPrecio)
        
        
        lblMarca = UILabel(frame: CGRect(x: (0.45 * loWidth),
                                         y: (0.7 * loHeigth),
                                         width: (0.50 * loWidth),
                                         height: (0.2 * loHeigth)))
        lblMarca.textAlignment = NSTextAlignment.center
        lblMarca.textColor = UIColor.black
        lblMarca.text = ""
        lblMarca.adjustsFontSizeToFitWidth = true
        lblMarca.font = loFont
        //lblPuntos.backgroundColor = UIColor(red: 244/255, green: 0/255, blue: 0/255, alpha: 1)
        contentView.addSubview(lblMarca)
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
