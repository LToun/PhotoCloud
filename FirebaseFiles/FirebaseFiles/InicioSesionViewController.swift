//
//  InicioSesionViewController.swift
//  FirebaseFiles
//
//  Created by Antonio Lara Navarrete on 12/04/21.
//

import UIKit
import Firebase
class InicioSesionViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var Contra: UITextField!
    @IBOutlet weak var Correo: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func InicioSesion(_ sender: Any) {
        guard let email = Correo.text else { return }
        guard let passwd = Contra.text else { return }
        Auth.auth().signIn(withEmail: email, password: passwd) { (result, error) in
            if let error = error{
                print(error.localizedDescription)
            } else {
                print("Inicio sesion")
                PerformSegue()
            }

    }
        func PerformSegue(){
            performSegue(withIdentifier: "InicioFotos", sender: self)
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
    
}
