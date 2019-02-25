//
//  VisualizarUsuariosTableViewController.swift
//  PracticaFinalSwift
//
//  Created by Daniel Queraltó Parra on 23/02/2019.
//  Copyright © 2019 Daniel Queraltó Parra. All rights reserved.
//

import UIKit
import SQLite3

//class VisualizarUsuariosTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
class VisualizarUsuariosTableViewController: UITableViewController
{
    var db: OpaquePointer?
    var usuarios = [Usu]()
    var usu: [String] = []
    var cabeceras: [[String]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        print("0")
        conectarDB()
        genUsu()
        print("0.0")

        // Do any additional setup after loading the view.
    }
    func genUsu()
    {
        for us in usuarios
        {
            
            usu.append("Usuario: "+us.usuario)
            cabeceras.append(["Pasword: "+us.contrasenia,"Tipo: "+us.tipo])
            print("-----------")
            print(us.usuario)
            print(us.contrasenia)
            print(us.tipo)
            print("-----------")

        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //---------------------------------------------------------------------------------------------------------------
    //VISUALIZAR HISTORIAL EN TABLEVIEW
    //---------------------------------------------------------------------------------------------------------------
    //INDICAMOS EL NUMERO DE FILAS QUE TENDRA NUESTRA SECCIÓN A PARTIR DEL TOTAL DE OBJETOS QUE SE HABRAN CREADO GRACIAS A NUESTRA BASE DE DATOS
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //rellenarUsuInfo()
        return cabeceras[section].count
    }
    
     override func numberOfSections(in tableView: UITableView) -> Int {
        //rellenarUsuInfo()
        return cabeceras.count
    }
    
     override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return usu[section]
    }
    
    //IPOR CADA REGISTRO CREAMOS UNA LINEA Y LA RELLENAMOS CON LOS OBJETOS EXTRAIDOS DE LA BASE DE DATOS
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let celda=tableView.dequeueReusableCell(withIdentifier: "celdilla", for: indexPath)
        celda.textLabel?.text=cabeceras[indexPath.section][indexPath.row]
        return celda
    }
    //---------------------------------------------------------------------------------------------------------------
    //Base de Datos
    //---------------------------------------------------------------------------------------------------------------
    func conectarDB()
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("Datos.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        else {
            print("base abierta")
            if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Usuarios (usuario TEXT PRIMARY KEY, contrasenia TEXT,tipo TEXT)", nil, nil, nil) != SQLITE_OK  {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error creating table: \(errmsg)")
            }
        }
        leerValores()
    }
    
    
    func leerValores(){
        
        //PRIMERO LIMPIAMOS LA LISTA "HISTORIAL"
        usuarios.removeAll()
        
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
    //---------------------------------------------------------------------------------------------------------------

    
    //LE INDICAMOS QUE CUANDO TOQUEMOS EN ALGUNA PARTE DE LA VISTA CIERRE EL TECLADO
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
}
