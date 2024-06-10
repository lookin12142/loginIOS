//
//  ViewController.swift
//  loginIOS
//
//  Created by lucas on 20/05/24.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import FirebaseDatabase
import FirebaseStorage

class iniciarSesionViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func GIDsingButton(_ sender: Any) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            guard error == nil else {
                print("Error de Google Sign-In: \(error!.localizedDescription)")
                return
            }

            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                print("Error: No se pudo obtener el ID Token del usuario")
                return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)

            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Error de autenticación con Google: \(error.localizedDescription)")
                    return
                                 }
                                 print("Inicio de sesión con Google exitoso")
                                 self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
                             }
                         }
                     }

                     @IBAction func iniciarSesionTapped(_ sender: Any) {
                         guard let email = emailTextField.text, !email.isEmpty,
                               let password = passwordTextField.text, !password.isEmpty else {
                             print("Email o contraseña están vacíos")
                             return
                         }

                         Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                             print("Intentando Iniciar Sesion")
                             if let error = error {
                                 print("Se presentó el siguiente error al iniciar sesión: \(error.localizedDescription)")
                                 self.mostrarAlertaCrearUsuario(email: email, password: password)
                             } else {
                                 print("Inicio de sesión exitoso")
                                 self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
                             }
                         }
                     }

                     func mostrarAlertaCrearUsuario(email: String, password: String) {
                         let alerta = UIAlertController(title: "Usuario no encontrado", message: "El usuario no existe. ¿Deseas crear un nuevo usuario?", preferredStyle: .alert)
                         let crearAction = UIAlertAction(title: "Crear", style: .default) { _ in
                             self.performSegue(withIdentifier: "showRegistro", sender: nil)
                         }
                         let cancelarAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)

                         alerta.addAction(crearAction)
                         alerta.addAction(cancelarAction)

                         self.present(alerta, animated: true, completion: nil)
                     }

                     @IBAction func registrarTapped(_ sender: Any) {
                         self.performSegue(withIdentifier: "showRegistro", sender: nil)
                     }
                  }
