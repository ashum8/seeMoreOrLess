//
//  PhotoManager.swift
//  mCAS
//
//  Created by iMac on 07/01/20.
//  Copyright © 2020 Nucleus. All rights reserved.
//

import UIKit

@objc protocol PhotoManagerDelegate {
    
    func didFinishPickingImage(image: UIImage)
   @objc optional func didFinishPickingMediaArray(mediaArray: [Any])
}


class PhotoManager: NSObject {

    var delegate: PhotoManagerDelegate?
    var isMultiUploading: Bool = false
    var fromCamera: Bool?
    var totalCount: Int?
    var baseVC: UIViewController?
    var imagePickerController: UIImagePickerController?
    var overlayView: CameraOverlayView?
    
    func showImageUploadDialogWithViewController(vc: UIViewController) {
       
        self.baseVC = vc
    
        if Constants.SHOW_GALLERY_WITH_CAMERA {
            
            self.baseVC?.view.endEditing(true)
            
        }
        else {
//             [self imageUsingCameraWithViewController:vc];
        }
    }
    
//    - (void)showImageUploadDialogWithViewController:(UIViewController *)vc {
//        self.baseVC  = vc;
//
//        if (Constants.SHOW_GALLERY_WITH_CAMERA) {
//            [self.baseVC.view endEditing:YES];
//
//            UIAlertController* alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"", nil)
//                                                                           message:NSLocalizedString(@"Capture Photo",@"")
//                                                                    preferredStyle:UIAlertControllerStyleAlert];
//
//            UIAlertAction* okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Gallery",@"") style:UIAlertActionStyleDefault
//                                                             handler:^(UIAlertAction *action) {
//                                                                 [self checkPhotoLibraryPermission];
//                                                             }];
//
//            UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Camera",@"") style:UIAlertActionStyleDefault
//                                                                 handler:^(UIAlertAction *action) {
//                                                                     [self imageUsingCameraWithViewController:self.baseVC];
//                                                                 }];
//
//            UIAlertAction* dismissAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel",@"") style:UIAlertActionStyleDefault
//                                                                  handler:^(UIAlertAction * _Nonnull action) {}];
//
//            [alert addAction:okAction];
//            [alert addAction:cancelAction];
//            [alert addAction:dismissAction];
//            [vc presentViewController:alert animated:YES completion:nil];
//        }
//        else {
//            [self imageUsingCameraWithViewController:vc];
//        }
//    }
    
    
//   MARK:- Taking Image Using Photo Library

    func imageUsingPhotoLibraryWithViewController(vc: UIViewController) {
        
        self.baseVC = vc
        
        let elcPicker = ELCImagePickerController.init(imagePicker: <#T##()#>)
        
        elcPicker?.maximumImagesCount = self.isMultiUploading ? 5 : 1  //Set the maximum number of images to select
        
        elcPicker?.returnsOriginalImage = true //Only return the fullScreenImage, not the fullResolutionImage
        elcPicker?.returnsImage = true //Return UIimage if YES. If NO, only return asset location information
        elcPicker?.onOrder = true //For multiple image selection, display and return order of selected images
        elcPicker?.mediaTypes = [kCIAttributeTypeImage as String]
//        elcPicker.mediaTypes = @[(NSString *)kUTTypeImage]; //Supports image
        elcPicker?.imagePickerDelegate = self
        self.baseVC?.present(elcPicker!, animated: true, completion: nil)
    }

    func openCameraAnimated(animated:Bool) {

    self.totalCount = 0

    self.imagePickerController = UIImagePickerController()
    self.imagePickerController?.delegate = self
    self.imagePickerController?.allowsEditing = true
        self.imagePickerController?.sourceType = .camera
    self.imagePickerController?.showsCameraControls = true

    if self.isMultiUploading {
        self.overlayView = CameraOverlayView(frame: self.baseVC!.view.frame)
        self.overlayView?.delegate = self
        self.imagePickerController?.cameraOverlayView = self.overlayView
        self.imagePickerController?.showsCameraControls = false

        let screenSize = UIScreen.main.bounds.size
        let cameraAspectRatio = 4.0 / 3.0
        let imageWidth = floorf(Float(screenSize.width) * Float(cameraAspectRatio));
        let scale = ceilf((Float(screenSize.height) / imageWidth) * 10.0) / 10.0;
        self.imagePickerController?.cameraViewTransform = CGAffineTransform(scaleX: CGFloat(scale), y: CGFloat(scale));
    }
        self.baseVC?.present(self.imagePickerController!, animated: animated, completion: nil)
        
    }
   
//    checkPhotoLibraryPermission
//    checkCameraPermission
//    imageUsingCameraWithViewController
}

extension PhotoManager: ELCImagePickerControllerDelegate {
    func elcImagePickerController(_ picker: ELCImagePickerController!, didFinishPickingMediaWithInfo info: [Any]!) {
        
        if (self.isMultiUploading) {
            self.delegate?.didFinishPickingMediaArray?(mediaArray: info)
        }
        else {
            for dict in info {
                if let data = dict as? NSDictionary {
                    if data[UIImagePickerController.InfoKey.mediaType] as? String == "public.image" {
                        self.delegate?.didFinishPickingImage(image: data[UIImagePickerController.InfoKey.originalImage] as! UIImage)
                        break
                    }
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func elcImagePickerControllerDidCancel(_ picker: ELCImagePickerController!) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}
extension PhotoManager: UIImagePickerControllerDelegate {
//    - (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info {

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension PhotoManager: CameraOverlayViewDelegate {
    func closeButtonAction() {
        self.totalCount = 0
        self.imagePickerControllerDidCancel(self.imagePickerController!)
    }
    
    func finishButtonAction() {
        self.imagePickerControllerDidCancel(self.imagePickerController!)
    }
    
    func takePictureButtonAction() {
        self.overlayView?.setTakePictureButtonEnabled(isEnabled: false)
        self.imagePickerController?.takePicture()
    }
}
