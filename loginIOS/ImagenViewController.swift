//
//  ImagenViewController.swift
//  loginIOS
//
//  Created by lucas on 27/05/24.
//

import UIKit
import FirebaseStorage

class ImagenViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    var imagePicker = UIImagePickerController()
    @IBAction func camaraTapped(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing  = false
        present(imagePicker, animated: true, completion: nil)
        
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        elegirContactoBoton.isEnabled = false

        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var descripcionTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func elegirContactoTapped(_ sender: Any) {
            self.elegirContactoBoton.isEnabled = false
            let imagenesFolder = Storage.storage().reference().child("imagenes")
            guard let imagenData = imageView.image?.jpegData(compressionQuality: 0.50) else {
                self.mostrarAlerta(titulo: "Error", mensaje: "No se pudo obtener la imagen.", accion: "Aceptar")
                self.elegirContactoBoton.isEnabled = true
                return
            }
            let cargarImagen = imagenesFolder.child("\(NSUUID().uuidString).jpg")
            
            
            let alertaCarga = UIAlertController(title: "Cargando Imagen...", message: "0%", preferredStyle: .alert)
            let progresoCarga = UIProgressView(progressViewStyle: .default)
            progresoCarga.frame = CGRect(x: 10, y: 70, width: 250, height: 0)
            alertaCarga.view.addSubview(progresoCarga)
            present(alertaCarga, animated: true, completion: nil)
            
            let uploadTask = cargarImagen.putData(imagenData, metadata: nil) { (metadata, error) in
                if let error = error {
                    self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al subir la imagen. Verifique su conexión a Internet y vuelva a intentarlo.", accion: "Aceptar")
                    self.elegirContactoBoton.isEnabled = true
                    print("Ocurrió un error al subir imagen: \(error)")
                    alertaCarga.dismiss(animated: true, completion: nil)
                    return
                } else {
                    cargarImagen.downloadURL { (url, error) in
                        guard let enlaceURL = url else {
                            self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al obtener la información de la imagen.", accion: "Aceptar")
                            self.elegirContactoBoton.isEnabled = true
                            print("Ocurrió un error al obtener la información de la imagen: \(error?.localizedDescription ?? "Error desconocido")")
                            alertaCarga.dismiss(animated: true, completion: nil)
                            return
                        }
                        self.performSegue(withIdentifier: "seleccionarContactoSegue", sender: enlaceURL.absoluteString)
                        alertaCarga.dismiss(animated: true, completion: nil)
                    }
                }
            }
            
            uploadTask.observe(.progress) { snapshot in
                guard let progress = snapshot.progress else { return }
                let porcentaje = Double(progress.completedUnitCount) / Double(progress.totalUnitCount)
                print(porcentaje)
                progresoCarga.setProgress(Float(porcentaje), animated: true)
                alertaCarga.message = String(format: "%.0f%%", porcentaje * 100)
                if porcentaje >= 1.0 {
                    alertaCarga.dismiss(animated: true, completion: nil)
                }
            }
        }

    @IBOutlet weak var elegirContactoBoton: UIButton!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageView.image = image
        imageView.backgroundColor = UIColor.clear
        elegirContactoBoton.isEnabled = true
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           let siguienteVC = segue.destination as! ElegirUsuarioViewController
           siguienteVC.imagenURL = sender as! String
           siguienteVC.descrip = descripcionTextField.text!
       }
    
    func mostrarAlerta(titulo: String, mensaje: String, accion: String){
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let btnCANELOK = UIAlertAction(title: accion, style: .default, handler: nil)
        alerta.addAction(btnCANELOK)
        present(alerta, animated: true, completion: nil)
    }
    

}
