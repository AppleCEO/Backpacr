//
//  DetailViewController.swift
//  Backpacr
//
//  Created by joon-ho kil on 2019/12/11.
//  Copyright © 2019 joon-ho kil. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class DetailViewController: UIViewController {
    var productDetailOb: Observable<ProductDetail>?
    var disposeBag = DisposeBag()
    var sections = [DetailSectionOfCustomData]()
    var currentPage = [Int]()
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = self
        flowLayoutSetting()
        load()
    }
    
    func flowLayoutSetting() {
        collectionView.showsHorizontalScrollIndicator = false
        let layout = UICollectionViewFlowLayout()
        self.collectionView.collectionViewLayout = layout
        layout.scrollDirection = .horizontal
    }
    
    func referToId (_ id: Int) {
        productDetailOb = JSONReceiver.getDetail(id: id)
    }
    
    func load() {
        let dataSource = RxCollectionViewSectionedReloadDataSource<DetailSectionOfCustomData>(
          configureCell: { dataSource, tableView, indexPath, item in
            let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCollectionViewCell", for: indexPath) as! DetailCollectionViewCell
            cell.putInfo(item)

            return cell
        })
        
        productDetailOb?
                .subscribe(onNext: { element in
                    var items = [String]()
                    for imageURL in (element.body.first?.thumbnailList320)!.split(separator: "#") {
                        items.append(String(imageURL))
                    }
                    
                    self.sections.append(DetailSectionOfCustomData(header: "imageURL", items: items))
                    
                       DispatchQueue.main.async {
                           Observable.just(self.sections)
                              .bind(to: self.collectionView.rx.items(dataSource: dataSource))
                              .disposed(by: self.disposeBag)
                       }
                   }).disposed(by: disposeBag)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size
        return CGSize(width: size.width, height: size.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        currentPage.append(indexPath.row)
        pageShow()
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        currentPage.removeAll { (number) -> Bool in
            number == indexPath.row
        }
        pageShow()
    }
    
    func pageShow() {
        print(currentPage)
        progressView.progress = Float(currentPage.first ?? 0)/(Float(sections.first?.items.count ?? 10)-1)
    }
}
