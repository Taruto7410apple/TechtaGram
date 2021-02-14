//
//  ViewController.swift
//  TechtaGram
//
//  Created on 2021/02/03.
//

import UIKit

class ViewController: UIViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    @IBOutlet var cameraImageView: UIImageView!
    
    var originalImage:UIImage!//画像加工するための元となる画像
    
    var filter:CIFilter!//画像加工するフィルターの宣言

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func takePhoto(){
        //カメラが使えるかの確認
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            //カメラの起動
            let picker=UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate=self
            
            picker.allowsEditing=true
            
            present(picker, animated: true, completion: nil)
            
        }else{
            print("error")
        }
        
    }
    
    @IBAction func savePhoto(){
        UIImageWriteToSavedPhotosAlbum(cameraImageView.image!, nil, nil, nil)
        
    }
    
    @IBAction func colorFilter(){
        let filterImage:CIImage=CIImage(image:originalImage)!
        
        //フィルターの設定
        filter=CIFilter(name: "CIColorControls")!
        filter.setValue(filterImage, forKey: kCIInputImageKey)
        //彩度の調整
        filter.setValue(1.0, forKey: "inputSaturation")
        
        //明度の調整
        filter.setValue(0.5, forKey: "inputBrightness")
        
        //コントラストの調整
        filter.setValue(2.5, forKey: "inputContrast")
        
        let ctx=CIContext(options:nil)
        let cgImage=ctx.createCGImage(filter.outputImage!, from: filter.outputImage!.extent)
        cameraImageView.image=UIImage(cgImage: cgImage!)
        
    }
    
    @IBAction func openAlbum(){
        
        let picker=UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate=self
        
        picker.allowsEditing=true
        
        present(picker, animated: true, completion: nil)
        
    }
    
    @IBAction func snsPhoto(){
        
        //投稿する時に一緒に載せるコメント
        let shreText="写真加工した"
        
        //投稿する画像の選択
        let shareImage=cameraImageView.image!
        
        //投稿するコメントとがおずの準備
        let activityItems:[Any]=[shreText,shareImage]
        
        let activityViewController=UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        let excludeActivityTypes=[UIActivity.ActivityType.postToWeibo, .saveToCameraRoll, .print]
        
        activityViewController.excludedActivityTypes=excludeActivityTypes
        
        present(activityViewController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        cameraImageView.image=info[.editedImage]as? UIImage
        
        originalImage=cameraImageView.image//カメラで写真を撮った後に元画像を記憶する
        
        dismiss(animated: true,completion: nil)
    }



}

