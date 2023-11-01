//
//  MenuViewController.swift
//  Gallery Core Data
//
//  Created by Artem Galiev on 31.10.2023.
//

import UIKit
import PhotosUI

class MenuViewController: UIViewController {
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var arrayPhoto: [Photo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
                
        configurateBarButtonItems()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadImageViewFromCoreData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func configurateBarButtonItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(onGalleryButtonClick))
        navigationItem.title = "Protected Gallery"
    }
    
    @objc func onGalleryButtonClick() {
        createPhotoLibrary()
    }
    
    private func createPhotoLibrary() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 50
        let pickerVC = PHPickerViewController(configuration: config)
        pickerVC.delegate = self
        self.present(pickerVC, animated: true)
    }
    
    private func loadImageViewFromCoreData() {
        let coreDataQueue = DispatchQueue.global(qos: .background)
        coreDataQueue.sync {
            arrayPhoto = CoreDataManager.shared.fetchPhotos()
        }
        coreDataQueue.sync {
            collectionView.reloadData()
        }
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension MenuViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayPhoto.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell {
            if let image = arrayPhoto[indexPath.row].imageData {
                cell.photoImageView.image = UIImage(data: image)
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.size.width / 3) - 3, height: (view.frame.size.width / 3) - 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    }
    
}

//MARK: - PHPickerViewControllerDelegate
extension MenuViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        for result in 0...results.count - 1 {
            results[result].itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                if let image = object as? UIImage {
                    //Добавление картинки в Core Data
                    if let imageData = image.jpegData(compressionQuality: 1) {
                        DispatchQueue.main.async { [weak self] in
                            CoreDataManager.shared.createPhoto(imageData)
                            if result / 3 == 0 {
                                self?.loadImageViewFromCoreData()
                            } else if result == results.count - 1 {
                                self?.loadImageViewFromCoreData()

                            }
                        }
                    }
                }
            }
        }
    }
}
