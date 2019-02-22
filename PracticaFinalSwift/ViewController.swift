//
//  ViewController.swift
//  PracticaFinalSwift
//
//  Created by Daniel Queraltó Parra on 01/02/2019.
//  Copyright © 2019 Daniel Queraltó Parra. All rights reserved.
//

import UIKit
import SQLite3
class ViewController: UIViewController {
    var db: OpaquePointer?
    var usuarios = [Usu]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        crearBDUsu()
        //insertarAdmin()

        for usu in usuarios.reversed()
        {
            print(usu.usuario)
            print(usu.contrasenia)
            print(usu.tipo)
            
        }
    }
    //MODIFICAMOS EL NOMBRE DEL BOTON DE RETROCESO
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Atras"
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
    }

    

    

    //BASE DE DATOS
    //---------------------------------------------------------------------------------------------------------
    func crearBDUsu()
    {
        //INDICAMOS DONDE SE GUARDARA LA BASE DE DATOS Y EL NOMBRE DE ESTAS
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("Usuarios.sqlite")
        //INDICAMOS SI DIERA ALGUN FALLO AL CONECTARSE
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error al abrir la base de datos")
        }
        else {//SI PODEMOS CONECTARNOS A LA BASE DE DATOS CREAREMOS LA ESTRUCTURA DE ESTA, SI NO EXISTIERA NO SE HARIA NADA
            print("base abierta")
            if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Usuarios (usuario TEXT PRIMARY KEY, contrasenia TEXT,tipo TEXT)", nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error creating table: \(errmsg)")
            }
        }
        leerValores()
        
        
    }

    func leerValores(){
        
        
        //GUARDAMOS NUESTRA CONSULTA
        let queryString = "SELECT * FROM Usuarios"
        
        //PUNTERO DE INSTRUCCIÓN
        var stmt:OpaquePointer?
        
        //PREPARACIÓN DE LA CONSULTA
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        //RECORREMOS LOS REGISTROS
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let usuario = String(cString: sqlite3_column_text(stmt, 0))
            let contrasenia = String(cString: sqlite3_column_text(stmt, 1))
            let tipo = String(cString: sqlite3_column_text(stmt, 2))

            
            //AÑADIMOS LOS VALORES A LA LISTA
            usuarios.append(Usu(usuario: String(describing: usuario), contrasenia: String(describing: contrasenia),tipo:String(describing: tipo)))
        }
    }
    

    

    //---------------------------------------------------------------------------------------------------------

}

class Usu
{
    
    var usuario: String
    var contrasenia: String
    var tipo: String
    
    init (usuario: String, contrasenia: String, tipo: String)
    {
        self.usuario = usuario
        self.contrasenia = contrasenia
        self.tipo = tipo
    }
    
}
