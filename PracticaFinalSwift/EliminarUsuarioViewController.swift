//
//  EliminarUsuarioViewController.swift
//  PracticaFinalSwift
//
//  Created by Daniel Queraltó Parra on 23/02/2019.
//  Copyright © 2019 Daniel Queraltó Parra. All rights reserved.
//

import UIKit
import SQLite3

class EliminarUsuarioViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var db: OpaquePointer?
    var usuarios = [Usu]()
    var usu: [String] = []
    var usuSelect: String = ""

    @IBOutlet weak var tabla: UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()
        conectarDB()
        leerValores()
        
        // Do any additional setup after loading the view.
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let celda = self.tabla.cellForRow(at: indexPath)
        let texto = (celda?.textLabel?.text)!
        usuSelect = texto
    }
    
    @IBAction func borrarUsu(_ sender: Any)
    {
        print(usuSelect)
        eliminarUsuario()
        leerValores()
        tabla.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //---------------------------------------------------------------------------------------------------------------
    //VISUALIZAR HISTORIAL EN TABLEVIEW
    //--------------------------------------------------------------------------------------------------------------
    //INDICAMOS EL NUMERO DE FILAS QUE TENDRA NUESTRA SECCIÓN A PARTIR DEL TOTAL DE OBJETOS QUE SE HABRAN CREADO GRACIAS A NUESTRA BASE DE DATOS
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return usuarios.count
    }
    
    //IPOR CADA REGISTRO CREAMOS UNA LINEA Y LA RELLENAMOS CON LOS OBJETOS EXTRAIDOS DE LA BASE DE DATOS
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //INDICAMOS EL ESTILO DE LA CELDA Y EL IDENTIFICADOR DE ESTA
        //let celda = UITableViewCell(style: UITableViewCell.CellStyle.default,  reuseIdentifier: "celdilla")
        let celda = tableView.dequeueReusableCell(withIdentifier: "celdilla", for: indexPath)
        
        //RECCOREMOS NUESTRA COLECCIÓN DE OBJETOS Y GUARDAMOS LA URL DE NUESTRO HISTORIAL EN UNA COLECCION DE STRINGS PARA PODER RELLENAR LAS CELDAS A CONTINUACION
        for us in usuarios
        {
            usu.append(us.usuario)//AÑADIMOS EL ESTRING "URL" A LA NUEVA COLECCION
        }
        //RELLENAMOS LAS CELDAS CON NUESTRA NUEVA COLECCION
        celda.textLabel?.text = usu[indexPath.row]//LE INDICAMOS QUE LOS INSERTE SEGUN EL INDICE DE FILAS QUE CREAMOS EN LA FUNCION ANTERIOR CON "historial.count"
        //CARGAMOS LAS CELDAS
        return celda
        
    }
    
    
    
    
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
        usu.removeAll()
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
    func eliminarUsuario()
    {
        //GUARDAMOS NUESTRA CONSULTA
        let queryString = "DELETE FROM Usuarios WHERE usuario = '"+usuSelect+"' "
        //CREAMOS EL PUNTERO DE INSTRUCCIÓN
        var deleteStatement: OpaquePointer? = nil
        
        //PREPARACIÓN DE LA CONSULTA
        if sqlite3_prepare(db, queryString, -1, &deleteStatement, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print(queryString)
            print("error preparing insert: \(errmsg)")
            return
        }
        //ELIMINAMOS LOS REGISTROS
        if sqlite3_prepare_v2(db, queryString, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        
        //FINALIZAMOS LA SENTENCIA
        sqlite3_finalize(deleteStatement)
        leerValores()
    }
    //LE INDICAMOS QUE CUANDO TOQUEMOS EN ALGUNA PARTE DE LA VISTA CIERRE EL TECLADO
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
    
}
