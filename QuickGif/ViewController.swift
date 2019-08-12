//
//  ViewController.swift
//  QuickGif
//
//  Created by Malone Hedges on 8/12/19.
//  Copyright © 2019 Malone Hedges. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureDataSource()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }
    
    func configureDataSource() {
        let results = searchBar.rx.text.orEmpty
            .asDriver()
            .throttle(.milliseconds(500))
            .distinctUntilChanged()
            .flatMapLatest { query in
                GiphyAPI.shared.getSearchResults(query)
                    .startWith([])
                    .asDriver(onErrorJustReturn: [])
            }
        
        results
            .drive(collectionView.rx.items(cellIdentifier: "cell", cellType: GifCollectionViewCell.self)) { _, gif, cell in
                cell.imageView.kf.setImage(with: gif.gifURL)
            }
            .disposed(by: disposeBag)
    }
    
    func configureUI() {
        let collectionViewLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        collectionViewLayout.itemSize = CGSize(width: 150, height: 150)
    }
}
