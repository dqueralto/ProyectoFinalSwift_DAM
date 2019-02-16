//
//  ContenidoViewController.swift
//  PracticaFinalSwift
//
//  Created by Daniel Queraltó Parra on 04/02/2019.
//  Copyright © 2019 Daniel Queraltó Parra. All rights reserved.
//

import UIKit

class ContenidoViewController: UIViewController {
    var datos=""
    @IBOutlet weak var lUsuario: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lUsuario.text = datos
        // Do any additional setup after loading the view.
    }

    
  

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
