//
//  AddConsoleViewController.swift
//  MyGames
//
//  Created by Aluno on 26/12/21.
//

import UIKit
import Photos

class AddConsoleViewController: UIViewController {
    
    var console : Console?
    
    @IBOutlet weak var tvConsoleName: UITextField!
    
    @IBOutlet weak var btnConsoleImage: UIButton!
    
    @IBOutlet weak var ivConsoleImage: UIImageView!
    
    @IBOutlet weak var btnConsoleSave: UIButton!
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = .white
        return pickerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareDataLayout()
    }
    
    @IBAction func addConsoleImage(_ sender: Any) {
        print("obter uma imagem da galeria")
        
        let alert = UIAlertController(title: "Selecinar capa", message: "De onde você quer escolher a capa?", preferredStyle: .actionSheet)
        
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default, handler: {(action: UIAlertAction) in
            self.selectPicture(sourceType: .photoLibrary)
        })
        alert.addAction(libraryAction)
        
        let photosAction = UIAlertAction(title: "Album de fotos", style: .default, handler: {(action: UIAlertAction) in
            self.selectPicture(sourceType: .savedPhotosAlbum)
        })
        alert.addAction(photosAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func saveConsole(_ sender: Any) {
        addEditConsole()
    }
    
    
    func prepareDataLayout() {
        if console != nil {
            title = "Editar console"
            btnConsoleSave.setTitle("ALTERAR", for: .normal)
            tvConsoleName.text = console?.name
            
            ivConsoleImage.image = console?.image as? UIImage
            if ivConsoleImage?.image != nil {
                btnConsoleImage.setTitle("", for: .normal)
            }
        }
    }
    
    func selectPicture(sourceType: UIImagePickerController.SourceType) {
        
            //Photos
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                    
                    self.chooseImageFromLibrary(sourceType: sourceType)
                    
                } else {
                    
                    print("unauthorized -- TODO message")
                }
            })
        } else if photos == .authorized {
            
            self.chooseImageFromLibrary(sourceType: sourceType)
        } else if photos == .denied {
            print("notificar o usuario que nao temos permissao de acessar a galeria e sugerir para o usuario acessar a tela de configuracao para habiltiar novamente a sua app. Podemos colocar um link aqui para o usuario ir direto")
        }
    }
    
    func chooseImageFromLibrary(sourceType: UIImagePickerController.SourceType) {
        
        DispatchQueue.main.async {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = sourceType
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.navigationBar.tintColor = UIColor(named: "main")
            
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    func addEditConsole () {
        // acao salvar novo ou editar existente
    print("SALVAR")
    
    if console == nil {
        console = Console(context: context)
    }
    console?.name = tvConsoleName.text
    
    console?.image = ivConsoleImage.image
    
    do {
        try context.save()
    } catch {
        print(error.localizedDescription)
    }
        // Back na navigation
    navigationController?.popViewController(animated: true)
    }
}

// fim da classe


extension AddConsoleViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ConsolesManager.shared.consoles.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let console = ConsolesManager.shared.consoles[row]
        return console.name
    }
}


extension AddConsoleViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
                // ImageView won't update with new image
                // bug fixed: https://stackoverflow.com/questions/42703795/imageview-wont-update-with-new-image
            DispatchQueue.main.async {
                self.ivConsoleImage.image = pickedImage
                self.ivConsoleImage.setNeedsDisplay()
                self.btnConsoleImage.setTitle("", for: .normal)
                self.btnConsoleImage.setNeedsDisplay()
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}
