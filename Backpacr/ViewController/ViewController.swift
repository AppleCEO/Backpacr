//
//  ViewController.swift
//  Backpacr
//
//  Created by joon-ho kil on 2019/12/09.
//  Copyright © 2019 joon-ho kil. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ViewController: UIViewController {
    @IBOutlet weak var tabbar: UITabBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    var productListOb: Observable<ProductList>?
    var disposeBag = DisposeBag()
    var sections = [SectionOfCustomData]()
    var oldOffset = CGPoint(x: 0, y: 0)
    var indexPath = IndexPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabbar.items?.first?.image = UIImage(named: "baseline_storefront_black_24pt")
        self.collectionView.delegate = self
        
        load(page: 1)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! DetailViewController
        if let cell = sender as? CollectionViewCell, let indexPath = self.collectionView.indexPath(for: cell){

            let id = sections[indexPath.section].items[indexPath.row].id
                 
             destination.referToId(id)
        }
    }

    func load(page: Int) {
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfCustomData>(
          configureCell: { dataSource, tableView, indexPath, item in
            let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
            
            cell.putInfo(item)

            return cell
        })
        
        productListOb = JSONReceiver.getList(page: page)
        productListOb?
            .subscribe(onNext: { element in
                self.sections.append(SectionOfCustomData(header: String(page), items: element.body))
                
                DispatchQueue.main.async {
                    Observable.just(self.sections)
                       .bind(to: self.collectionView.rx.items(dataSource: dataSource))
                       .disposed(by: self.disposeBag)
                    self.collectionView.setContentOffset(self.oldOffset, animated: false)
                        self.loadingIndicator.stopAnimating()
                }
            }).disposed(by: disposeBag)
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (collectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height: size+88)
    }
    
    //compute the scroll value and play witht the threshold to get desired effect
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let threshold   = 100.0 ;
        let contentOffset = scrollView.contentOffset.y;
        let contentHeight = scrollView.contentSize.height;
        let diffHeight = contentHeight - contentOffset;
        let frameHeight = scrollView.bounds.size.height;
        var triggerThreshold  = Float((diffHeight - frameHeight))/Float(threshold);
        triggerThreshold   =  min(triggerThreshold, 0.0)
        let pullRatio  = min(abs(triggerThreshold),1.0);
        if pullRatio >= 0.5 {
            self.loadingIndicator.startAnimating()
        }
    }
    
    //compute the offset and call the load method
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y;
        let contentHeight = scrollView.contentSize.height;
        let diffHeight = contentHeight - contentOffset;
        let frameHeight = scrollView.bounds.size.height;
        let pullHeight  = abs(diffHeight - frameHeight);
        
        if pullHeight == 0.0
        {
            if self.loadingIndicator.isAnimating {
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (timer:Timer) in
                    self.collectionView.dataSource = nil
                    self.oldOffset = CGPoint(x: self.collectionView.contentOffset.x, y: self.collectionView.contentOffset.y + 50)
                    self.load(page: self.sections.count+1)
                    self.loadingIndicator.stopAnimating()
                    })
                }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.indexPath = indexPath
        self.performSegue(withIdentifier: "moveToDetail", sender: self)
    }
}



