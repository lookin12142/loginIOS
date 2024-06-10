//
//  SnapsViewController.swift
//  loginIOS
//
//  Created by lucas on 27/05/24.
//

import UIKit
import Firebase

class SnapsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tablaSnaps: UITableView!
    var snaps: [Snap] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snaps.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snap = snaps[indexPath.row]
        performSegue(withIdentifier: "versnapsegue", sender: snap)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let snap = snaps[indexPath.row]
        cell.textLabel?.text = snap.from
        return cell
    }
    
    @IBAction func cerrarSesionTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
        } catch {
            print("Error al cerrar sesión: \(error)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "versnapsegue" {
            let siguienteVC = segue.destination as! VerSnapViewController
            siguienteVC.snap = sender as! Snap
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tablaSnaps.delegate = self
        tablaSnaps.dataSource = self
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("usuarios").child(uid).child("snaps").observe(DataEventType.childAdded, with: { (snapshot) in
            if let snapDict = snapshot.value as? [String: AnyObject] {
                let snap = Snap()
                snap.imagenURL = snapDict["imagenURL"] as? String ?? ""
                snap.from = snapDict["from"] as? String ?? ""
                snap.descrip = snapDict["descripcion"] as? String ?? ""
                self.snaps.append(snap)
                self.tablaSnaps.reloadData()
            }
        }) { (error) in
            print("Error al recuperar los snaps: \(error.localizedDescription)")
        }
    }
}
