//
//  ContenidoAdminViewController.swift
//  PracticaFinalSwift
//
//  Created by Daniel Queraltó Parra on 19/02/2019.
//  Copyright © 2019 Daniel Queraltó Parra. All rights reserved.
//

import UIKit

class ContenidoAdminViewController: UIViewController {
    var usuario: String?
    
    @IBOutlet weak var usu: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usu.text = self.usuario
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
