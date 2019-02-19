//
//  LoginViewController.swift
//  PracticaFinalSwift
//
//  Created by Daniel Queraltó Parra on 01/02/2019.
//  Copyright © 2019 Daniel Queraltó Parra. All rights reserved.
//

import UIKit
import SQLite3

class LoginViewController: UIViewController {
    var db: OpaquePointer?
    var usuarios = [Usu]()
    
    @IBOutlet weak var usuario: UITextField!
    @IBOutlet weak var contrasenia: UITextField!
    @IBOutlet weak var alerta: UILabel!
    @IBOutlet weak var alerta2: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        conectarDBUsu()
        for usu in usuarios.reversed()
        {
            print(usu.usuario)
            print(usu.contrasenia)
        }
        
        
    }
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "data"
        {
            print("data")
            let contenido = segue.destination as! ContenidoViewController
            contenido.datos = self.usuario.text!
        }
    }*/
    
    @IBAction func conectar(_ sender: Any) {

        print("0")
        for usu in usuarios
        {
            alerta.isHidden = true
            alerta2.isHidden = true
            print("1")
            print(usu.usuario)
            print(usu.contrasenia)
            if (usuario.text!.elementsEqual(usu.usuario) )
            {
                print("2")
                if contrasenia.text!.elementsEqual(usu.contrasenia)
                {
                    print("3")
                    if usu.usuario == "admin"
                    {
                        print("3.1")
                        performSegue(withIdentifier: "contenidoAdmin", sender: nil)
                        return
                        
                    }else{
                        print("3.2")
                        performSegue(withIdentifier: "contenido", sender: nil)
                        return
                        
                    }
                    /*
                    let viewController = self.storyboard!.instantiateViewController(withIdentifier: "contenido") as! ContenidoViewController
                    
                    self.navigationController?.pushViewController(viewController, animated: true)
                    */
                    //performSegue(withIdentifier: "data", sender: self)
                    //return
                }
                else
                {
                    print("4")
                    alerta2.isHidden = false
                    //return
                }
            }
            else
            {
                print("5")
                alerta.isHidden = false
                //return
            }
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "contenido"
        {
            if let vistaContenido = segue.destination as? ContenidoViewController
            {
                vistaContenido.usuario =  usuario.text!
            }
        }
        
        if segue.identifier == "contenidoAdmin"
        {
            if let vistaContenido = segue.destination as? ContenidoAdminViewController
            {
                vistaContenido.usuario =  usuario.text!
            }
        }
    }


    //---------------------------------------------------------------------------------------------------------
    func conectarDBUsu()
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("Usuarios.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        else {
            print("base abierta")
            if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Usuarios (usuario TEXT PRIMARY KEY, contrasenia TEXT)", nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error creating table: \(errmsg)")
            }
        }
        leerValores()
    }
    
   /* func buscar(usu: String, pass: String)
    {
        //CREAMOS EL PUNTERO DE INSTRUCCIÓN
        var stmt: OpaquePointer?
        
        //CREAMOS NUESTRA SENTENCIA
        let queryString = "SELECT * FROM Usuarios WHERE  (usuario == '"+String(usuario.text!)+"' && contrasenia == '"+String(contrasenia.text!)+"')"
        //PREPARAMOS LA SENTENCIA
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print(queryString)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        
        //EJECUTAMOS LA SENTENCIA PARA INSERTAR LOS VALORES
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("fallo al insertar en usuarios: \(errmsg)")
            return
        }
        
        //FINALIZAMOS LA SENTENCIA
        sqlite3_finalize(stmt)
        print("Insertado")
        //displaying a success message
        print("Histo saved successfully")
    }*/
    
    func insertar()  {
        //CREAMOS EL PUNTERO DE INSTRUCCIÓN
        var stmt: OpaquePointer?
        
        //CREAMOS NUESTRA SENTENCIA
        let queryString = "INSERT INTO Usuarios (usuario,contrasenia) VALUES ("+"'"+String(usuario.text!)+"','"+String(contrasenia.text!)+" ')"
        //PREPARAMOS LA SENTENCIA
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print(queryString)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        
        //EJECUTAMOS LA SENTENCIA PARA INSERTAR LOS VALORES
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("fallo al insertar en usuarios: \(errmsg)")
            return
        }
        
        //FINALIZAMOS LA SENTENCIA
        sqlite3_finalize(stmt)
        print("Insertado")
        //displaying a success message
        print("Histo saved successfully")
        
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
            
            
            //AÑADIMOS LOS VALORES A LA LISTA
            usuarios.append(Usu(usuario: String(describing: usuario), contrasenia: String(describing: contrasenia)))
        }
        
    }
    //---------------------------------------------------------------------------------------------------------


}
