//
//  ContenidoTableViewController.swift
//  PracticaFinalSwift
//
//  Created by Daniel Queraltó Parra on 23/02/2019.
//  Copyright © 2019 Daniel Queraltó Parra. All rights reserved.
//

import UIKit
import SQLite3

class ContenidoTableViewController: UITableViewController {
    var db: OpaquePointer?
    var contenido = [Contenido]()
    var titulo: [String] = []
    var info: [[String]] = [[]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        crearBDContenido()
        genCont()
    }

    
    func genCont()
    {
        for co in contenido
        {
            
            titulo.append("Titulo: "+co.titulo)
            info.append(["Autor: "+co.autor,"Descripcion: "+co.descripcion])
            
        }
    }
    //---------------------------------------------------------------------------------------------------------------
    //VISUALIZAR HISTORIAL EN TABLEVIEW
    //---------------------------------------------------------------------------------------------------------------
    //INDICAMOS EL NUMERO DE FILAS QUE TENDRA NUESTRA SECCIÓN A PARTIR DEL TOTAL DE OBJETOS QUE SE HABRAN CREADO GRACIAS A NUESTRA BASE DE DATOS
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //rellenarUsuInfo()
        return info[section].count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        //rellenarUsuInfo()
        return info.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // rellenarUsuInfo()
        return titulo[section]
    }
    
    //IPOR CADA REGISTRO CREAMOS UNA LINEA Y LA RELLENAMOS CON LOS OBJETOS EXTRAIDOS DE LA BASE DE DATOS
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let celda=tableView.dequeueReusableCell(withIdentifier: "celdilla", for: indexPath)
        celda.textLabel?.text=info[indexPath.section][indexPath.row]
        return celda

        
    }
    
    //---------------------------------------------------------------------------------------------------------------


    
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

}
