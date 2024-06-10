//
//  RegistroViewController.swift
//  loginIOS
//
//  Created by lucas on 3/06/24.
//
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class RegistroViewController: UIViewController {


    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
            super.viewDidLoad()
        }


    @IBAction func registrarTapped(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty,
                      let password = passwordTextField.text, !password.isEmpty else {
                    print("Email o contraseña están vacíos")
                    return
                }

                Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                    if let error = error {
                        print("Se presentó el siguiente error al crear el usuario: \(error.localizedDescription)")
                        return
                    }
                    print("El usuario fue creado exitosamente")
                    guard let user = authResult?.user else { return }
                    let ref = Database.database().reference()
                    ref.child("usuarios").child(user.uid).child("email").setValue(user.email) { (error, ref) in
                        if let error = error {
                            print("Error al guardar el email en la base de datos: \(error.localizedDescription)")
                            return
                        }
                        print("Email guardado en la base de datos exitosamente")
                        let alerta = UIAlertController(title: "Creación de Usuario", message: "Usuario: \(email) se creó correctamente.", preferredStyle: .alert)
                        let btnOK = UIAlertAction(title: "Aceptar", style: .default) { _ in
                            self.dismiss(animated: true, completion: nil)
                        }
                        alerta.addAction(btnOK)
                        self.present(alerta, animated: true, completion: nil)
                    }
                          }
                      }

              @IBAction func volverTapped(_ sender: Any) {
                  self.dismiss(animated: true, completion: nil)
              }
          }
