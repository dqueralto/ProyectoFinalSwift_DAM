//
//  NewContenidoViewController.swift
//  PracticaFinalSwift
//
//  Created by Daniel Queraltó Parra on 23/02/2019.
//  Copyright © 2019 Daniel Queraltó Parra. All rights reserved.
//

import UIKit
import SQLite3
class NewContenidoViewController: UIViewController {
    var db: OpaquePointer?
    var contenido = [Contenido]()
    
    @IBOutlet weak var alertContExistente: UILabel!
    @IBOutlet weak var alertContIngresado: UILabel!
    @IBOutlet weak var titulo: UITextField!
    @IBOutlet weak var autor: UITextField!
    @IBOutlet weak var descripcion: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        crearBDContenido()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func almacenar(_ sender: Any)
    {
        print("0")
        for con in contenido
        {
            alertContIngresado.isHidden = true
            alertContExistente.isHidden = true
            print("1")
            print(con.titulo)
            if !con.titulo.elementsEqual(titulo.text!)
            {
                print("3")
                //alerta.isHidden = true
                alertContIngresado.isHidden = false
                insertar()
                return
            }else
            {
                alertContIngresado.isHidden = true
                alertContExistente.isHidden = false
            }
            
        }
        leerValoresContenido()
    
        
    }
    
    //---------------------------------------------------------------------------------------------------------
    func crearBDContenido()
    {
        //INDICAMOS DONDE SE GUARDARA LA BASE DE DATOS Y EL NOMBRE DE ESTAS
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("Datos.sqlite")
        //INDICAMOS SI DIERA ALGUN FALLO AL CONECTARSE
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error al abrir la base de datos")
        }
        else {//SI PODEMOS CONECTARNOS A LA BASE DE DATOS CREAREMOS LA ESTRUCTURA DE ESTA, SI NO EXISTIERA NO SE HARIA NADA
            print("base abierta")
            if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Contenido (titulo TEXT PRIMARY KEY, descripcion TEXT,autor TEXT)", nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error creating table: \(errmsg)")
            }
        }
        leerValoresContenido()
        
        
    }
    
    func leerValoresContenido(){
        
        //GUARDAMOS NUESTRA CONSULTA
        let queryString = "SELECT * FROM Contenido"
        
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
            let titulo = String(cString: sqlite3_column_text(stmt, 0))
            let descricion = String(cString: sqlite3_column_text(stmt, 1))
            let autor = String(cString: sqlite3_column_text(stmt, 2))
            
            //AÑADIMOS LOS VALORES A LA LISTA
            contenido.append(Contenido(titulo: String(describing: titulo), descripcion: String(describing: descricion), autor: String(describing: autor)))
        }
    }
    
    func insertar()  {
        //CREAMOS EL PUNTERO DE INSTRUCCIÓN
        var stmt: OpaquePointer?
        
        //CREAMOS NUESTRA SENTENCIA
        let queryString = "INSERT INTO Contenido VALUES ('"+String(titulo.text!)+"','"+String(descripcion.text!)+"','"+String(autor.text!)+"')"
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
            alertContIngresado.isHidden = true
            alertContExistente.isHidden = false
            return
        }
        
        //FINALIZAMOS LA SENTENCIA
        sqlite3_finalize(stmt)
        print("Insertado")
        //displaying a success message
        print("Histo saved successfully")
        
    }
    
    //---------------------------------------------------------------------------------------------------------
    
    
    //LISTA----------------------------------------------------------------------------------------------------
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //---------------------------------------------------------------------------------------------------------
    
    //LE INDICAMOS QUE CUANDO TOQUEMOS EN ALGUNA PARTE DE LA VISTA CIERRE EL TECLADO
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
}
