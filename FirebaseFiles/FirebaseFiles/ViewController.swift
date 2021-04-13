//
//  ViewController.swift
//  FirebaseFiles
//
//  Created by Antonio Lara Navarrete on 12/04/21.
//

import UIKit
import Firebase
import CoreServices
import FirebaseUI

class ViewController: UIViewController{
    
    @IBOutlet weak var cerrarSesion: UIButton!
    @IBOutlet var userImageView: UIImageView!
    
    @IBOutlet var coleccion: UICollectionView!
    
    @IBOutlet var button: UIButton!
    
    var images: [StorageReference] = []
    
    let placeholderImage = UIImage(named:"placeholder")
    
    var numeroElementos: Int=1
    
    let storage = Storage.storage()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coleccion.delegate=self
        coleccion.dataSource=self
        let nib = UINib.init(nibName: "ImageCollectionViewCell", bundle: nil)
        coleccion.register(nib, forCellWithReuseIdentifier: "imageCellXIB")
        // Do any additional setup after loading the view.
//        let isButtonEnabled = RemoteConfig.remoteConfig().configValue(forKey: "isButtonEnabled").boolValue
//
//        if !isButtonEnabled{
//            button.isEnabled = isButtonEnabled
//            button.backgroundColor = .red
//        }
        bajaDatos()
        downloadImage()
        coleccion.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("did")
    }
    func bajaDatos(){
        self.coleccion.reloadData()
        self.storage.reference().child("images/profile/").listAll { (result, erro) in
            self.images=result.items
            self.coleccion.reloadData()
        }
    }
    @IBAction func CerrarSesion(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            performSegue(withIdentifier: "InicioSesion", sender: self)
            print("Cerro Sesion")
        } catch{
            print("error")
        }
    }
    @IBAction func uploadImage(_ sender: UIButton){
        let userImagePicker = UIImagePickerController()
        userImagePicker.delegate = self
        userImagePicker.sourceType = .photoLibrary
        userImagePicker.mediaTypes = ["public.image"]
        present(userImagePicker, animated: true, completion: nil)

    }

//    func PhotosFb()->Int{
//        let storageRef = storage.reference()
//        let pruebaProfile =  storageRef.child("images/profile/")
//        var fotos = 0
//        pruebaProfile.list(maxResults: 10) { (results, error) in
//            if let error = error{
//                print(error)
//                fotos=0
//            }
////            Aqui encuentro el tamaño del archivo profile (¿Cuántas fotos hay en el archivo?)
////            print(results.items.count)
//            fotos = results.items.count
//            print("Fotos en Firebase:")
//            print(results.items.count)
//            self.idImage=results.items.count+1
//            print("xxxxxxxxx")
//            print(fotos)
//        }
//        print("------------")
//        print(fotos)
//        return fotos
//    }
    func uploadImage(imageData: Data){
        let activityIndicator = UIActivityIndicatorView.init(style: .large)
        activityIndicator.startAnimating()
        activityIndicator.center = self.userImageView.center
        self.view.addSubview(activityIndicator)
        
        let storageRef = storage.reference()
        
        let uploadMetaData = StorageMetadata()
        uploadMetaData.contentType = "image/jpeg"
        
        let pruebaProfile =  storageRef.child("images/profile/")
        
        pruebaProfile.listAll{ (results, error) in
            if let error = error{
                print(error)
                self.userImageView.image=self.placeholderImage
            }else{
//            Aqui encuentro el tamaño del archivo profile (¿Cuántas fotos hay en el archivo?)
//            print(results.items.count)
            let imageRef = storageRef.child("images").child("profile").child("\(results.items.count+1).jpg")
            imageRef.putData(imageData, metadata: uploadMetaData) { (metadata, error) in
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
                if let error = error{
                    print(error.localizedDescription)
                } else {
                    print("Exito al subir imagen")


                }
            }
            }
        }
        
    }

    func downloadImage(){
        let activityIndicator = UIActivityIndicatorView.init(style: .large)
        activityIndicator.startAnimating()
        activityIndicator.center = self.userImageView.center
        self.view.addSubview(activityIndicator)
        let storageRef = storage.reference()
        let pruebaProfile =  storageRef.child("images/profile/")
//        print("url de imageDownloadUrlRef: \(imageDownloadUrlRef)")
        
        pruebaProfile.listAll{ [self] (results, error) in
            if let error = error{
                print(error)
                self.userImageView.image=self.placeholderImage
            }else{
//            Aqui encuentro el tamaño del archivo profile (¿Cuántas fotos hay en el archivo?)
//            print(results.items.count)
//            print("Fotos en Firebase:")
//            print(results.items.count)
                let imageDownloadUrlRef = storageRef.child("images").child("profile").child("\(results.items.count).jpg")
                self.userImageView.sd_setImage(with: imageDownloadUrlRef)
            }
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
        let urlImagenes = storageRef.child("images/profile/\(numeroElementos).jpg")
                images.append(storageRef.child("images/profile/\(numeroElementos).jpg"))
            urlImagenes.downloadURL { (url, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                else{
                    self.numeroElementos=self.numeroElementos+1
                }
        }
    }

}

extension ViewController: UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage, let optimizedImageData = userImage.jpegData(compressionQuality: 0.6){
            uploadImage(imageData: optimizedImageData)
            userImageView.image=userImage

        }
        
        picker.dismiss(animated: true, completion: nil)
        
    }
}

extension ViewController: UINavigationControllerDelegate{
    
}


extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(images.count)
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCellXIB", for: indexPath) as! ImageCollectionViewCell
        
        
        let ref = images[indexPath.item]
        
        cell.imageViewCell.sd_setImage(with: ref, placeholderImage: placeholderImage)
        
        ref.downloadURL { (url, error) in
            if let error = error{
                print(error.localizedDescription)
            } else {
//                print("URL:  \(String(describing: url!))")
            }
        }
        
        
        
        return cell
    }
    
}

extension ViewController: UICollectionViewDelegate{
    func collectionView(_ colectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        colectionView.deselectItem(at: indexPath, animated:true)
        bajaDatos()
        coleccion.reloadData()
    }
    
}
extension ViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}
