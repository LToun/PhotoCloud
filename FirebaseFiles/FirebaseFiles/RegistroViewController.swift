//
//  RegistroViewController.swift
//  FirebaseFiles
//
//  Created by Antonio Lara Navarrete on 12/04/21.
//

import UIKit
import Firebase

class RegistroViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var labelContra2: UILabel!
    @IBOutlet weak var labelContra1: UILabel!
    @IBOutlet weak var contra2: UITextField!
    @IBOutlet weak var contra1: UITextField!
    @IBOutlet weak var correo: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        contra2.delegate=self
        contra1.delegate=self
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func InicioSesion(_ sender: Any) {
        guard let email = correo.text else { return }
        guard let passwd = contra1.text else { return }
        if (email != nil) && (passwd != nil){
            createUser(email: email, password: passwd)
        }
        performSegue(withIdentifier: "RegistroInicio", sender: self)
    }
    func createUser(email: String, password: String){
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error{
                print("Error \(error)")

            } else {
                print("Usuario creado: \(String(describing: result?.user.uid)) ")
            }
        }
    }


}
//var usuarioCreado: Bool = false
//var inicio: Bool = false
//if (contra1.text==contra2.text)&&(correo.text != nil)&&(contra1.text != nil){
//    Auth.auth().createUser(withEmail: correo.text!, password: contra1.text!) { (result, error) in
//               if let error = error{
//                   print("Error \(error)")
//                    usuarioCreado=false
//               } else {
//                   print("Usuario creado: \(String(describing: result?.user.uid)) ")
//                    usuarioCreado=true
//                    inicio = self.signIn(email: self.correo.text!, password: self.contra1.text!)
//               }
//           }
//    if (usuarioCreado)&&(inicio){
//        performSegue(withIdentifier: "RegistroFotos", sender: self)
//        print("perform Segue")
//    }else{
//        print("No perform Segue")
//    }
//    print("USUARIO CREADO \(usuarioCreado)\nINICIO SESION \(inicio)")
//}
//else{
//    labelContra2.textColor=UIColor.red
//    labelContra1.textColor=UIColor.red
//}
