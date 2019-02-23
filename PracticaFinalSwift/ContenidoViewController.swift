//
//  ContenidoViewController.swift
//  PracticaFinalSwift
//
//  Created by Daniel Queraltó Parra on 04/02/2019.
//  Copyright © 2019 Daniel Queraltó Parra. All rights reserved.
//

import UIKit

class ContenidoViewController: UIViewController {
    var usuario: String?
    
    @IBOutlet weak var usu: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usu.text = self.usuario
        // Do any additional setup after loading the view.
    }

    //LE INDICAMOS QUE CUANDO TOQUEMOS EN ALGUNA PARTE DE LA VISTA CIERRE EL TECLADO
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }

}
