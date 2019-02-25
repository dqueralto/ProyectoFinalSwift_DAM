//
//  VisualizarContenidoViewController.swift
//  PracticaFinalSwift
//
//  Created by Daniel Queraltó Parra on 23/02/2019.
//  Copyright © 2019 Daniel Queraltó Parra. All rights reserved.
//

import UIKit
import SQLite3

class EliminararContenidoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var db: OpaquePointer?
    var contenido = [Contenido]()
    var cont: [String] = []
    var contSelect: String = ""
    
    @IBOutlet weak var tabla: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func borrarContenido(_ sender: Any)
    {
        print(contSelect)
        eliminarUsuario()
        insertarAdmin()
        leerValoresContenido()
        tabla.reloadData()
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let celda = self.tabla.cellForRow(at: indexPath)
        let texto = (celda?.textLabel?.text)!
        self.contSelect = texto
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
        return contenido.count
    }
    
    //IPOR CADA REGISTRO CREAMOS UNA LINEA Y LA RELLENAMOS CON LOS OBJETOS EXTRAIDOS DE LA BASE DE DATOS
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //INDICAMOS EL ESTILO DE LA CELDA Y EL IDENTIFICADOR DE ESTA
        //let celda = UITableViewCell(style: UITableViewCell.CellStyle.default,  reuseIdentifier: "celdilla")
        let celda = tableView.dequeueReusableCell(withIdentifier: "celdilla", for: indexPath)
        
        //RECCOREMOS NUESTRA COLECCIÓN DE OBJETOS Y GUARDAMOS LA URL DE NUESTRO HISTORIAL EN UNA COLECCION DE STRINGS PARA PODER RELLENAR LAS CELDAS A CONTINUACION
        for con in contenido
        {
            self.cont.append(con.titulo)//AÑADIMOS EL ESTRING "URL" A LA NUEVA COLECCION
        }
        //RELLENAMOS LAS CELDAS CON NUESTRA NUEVA COLECCION
        celda.textLabel?.text = self.cont[indexPath.row]//LE INDICAMOS QUE LOS INSERTE SEGUN EL INDICE DE FILAS QUE CREAMOS EN LA FUNCION ANTERIOR CON "historial.count"
        //CARGAMOS LAS CELDAS
        return celda
        
    }
    
    
    
    
    //---------------------------------------------------------------------------------------------------------------
    func conectarDB()
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
                self.contenido.append(Contenido(titulo: String(describing: titulo), descripcion: String(describing: descricion), autor: String(describing: autor)))
            }
        }
    
    func eliminarUsuario()
    {
        //GUARDAMOS NUESTRA CONSULTA
        let queryString = "DELETE FROM Contenido WHERE titulo = '"+self.contSelect+"' "
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
        leerValoresContenido()
    }
    func insertarAdmin()  {
        //CREAMOS EL PUNTERO DE INSTRUCCIÓN
        var stmt: OpaquePointer?
        
        //CREAMOS NUESTRA SENTENCIA
        let queryString = "INSERT INTO Usuarios (usuario,contrasenia,tipo) VALUES ('admin','admin','A')"
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
    //LE INDICAMOS QUE CUANDO TOQUEMOS EN ALGUNA PARTE DE LA VISTA CIERRE EL TECLADO
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
    
}
