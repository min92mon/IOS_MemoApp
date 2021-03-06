//
//  MemoWriteVC.swift
//  MemoWriteVC
//
//  Created by 정민영 on 2021/08/02.
//

import UIKit

class MemoWriteVC: UIViewController, UINavigationControllerDelegate {
    var subject: String!
    
    @IBOutlet weak var contents: UITextView!
    @IBOutlet weak var preview: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contents.delegate = self
        
        let bgImage = UIImage(named: "memoBackground.jpg")!
        self.view.backgroundColor = UIColor(patternImage: bgImage)
    
        self.contents.layer.borderWidth = 0
        self.contents.layer.borderColor = UIColor.clear.cgColor
        self.contents.backgroundColor = UIColor.clear
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 14
        self.contents.attributedText = NSAttributedString(string: " ", attributes: [.paragraphStyle: style])
        self.contents.text = ""
    }
    
    @IBAction func save(_ sender: Any) {
        guard self.contents.text?.isEmpty == false else {
            let alertVC = UIViewController()
            let alertImg = UIImageView(image: UIImage(named: "warning.png"))
            alertVC.view.frame = CGRect(x: 0, y: 0, width: 270, height: 80)
            alertImg.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            alertImg.center = CGPoint(x: alertVC.view.frame.width/2, y: alertVC.view.frame.height/2)
            alertVC.view.addSubview(alertImg)
            
            let alert = UIAlertController(title: nil, message: "내용을 입력해주세요", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            alert.setValue(alertVC, forKey: "contentViewController")
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let data = MemoData()
        
        data.title = self.subject
        data.contents = self.contents.text
        data.image = self.preview.image
        data.regdate = Date()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memoList.append(data)
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func pick(_ sender: Any) {
        let actionSheet = UIAlertController(title: "이미지를 가져올 곳을 선택해주세요", message: nil, preferredStyle: .actionSheet)
        /*
        let cameraActionItem = UIAlertAction(title: "카메라", style: .default) {_ in
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.cameraDevice = .rear
            picker.sourceType = .camera
            self.present(picker, animated: false)
        }
        */
        
        let albumActionItem = UIAlertAction(title: "저장앨범", style: .default) {_ in
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = .savedPhotosAlbum
            self.present(picker, animated: false)
        }
        let libraryActionItem = UIAlertAction(title: "사진 라이브러리", style: .default) {_ in
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = .photoLibrary
            self.present(picker, animated: false)
        }
        
//      actionSheet.addAction(cameraActionItem)
        actionSheet.addAction(albumActionItem)
        actionSheet.addAction(libraryActionItem)
    
        present(actionSheet, animated: false, completion: nil)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let bar = self.navigationController?.navigationBar
        
        let ts = TimeInterval(0.3)
        UIView.animate(withDuration: ts) {
            bar?.alpha = ( bar?.alpha == 0 ? 1 : 0 )
        }
    }
}

// MARK: - UIImagePickerController Delegate Implement
extension MemoWriteVC: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.preview.image = info[.editedImage] as? UIImage
        
        picker.dismiss(animated: false, completion: nil)
    }
}

// MARK: - UITextView Delegate Implement
extension MemoWriteVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let contents = textView.text as NSString
        let length = ( (contents.length > 15) ? 15 : contents.length )
        self.subject = contents.substring(with: NSRange(location: 0, length: length))
        
        self.navigationItem.title = self.subject
    }
}

