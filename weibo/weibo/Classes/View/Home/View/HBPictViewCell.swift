//
//  HBPictViewCell.swift
//  weibo
//
//  Created by hebing on 16/9/27.
//  Copyright © 2016年 hebing. All rights reserved.
//

import UIKit
private let cellID = "HBPictViewCellId"

//继承自uicollectionView
class HBPictViewCell: UICollectionView {
    
    var pictureInfos: [HBPictureInfor]? {
        didSet {
            testLabel.text = "\(pictureInfos?.count ?? 0)张"
            print(testLabel.frame)
            
//            self.dataSource=self
            //刷新视图
            reloadData()
            

        }
    }
    

    
    override func awakeFromNib() {
        
             self.dataSource=self
//        self.backgroundColor=randomColor()
//        self.addSubview(testLabel)
        
//        testLabel.snp.makeConstraints { (make) in
//            make.center.equalTo(self)
//        }
        
        //注册cell
        self.register(HBpicCollctionCell.self, forCellWithReuseIdentifier: cellID)
        //获取layout对象
        //let layout = self.collectionViewLayout as! UICollectionViewFlowLayout

        
    }

    
   
//测试label
private lazy var testLabel: UILabel  = {
    let l = UILabel(title: "", textColor: UIColor.black, titleFont: 30)
    
    return l
}()


}

extension HBPictViewCell:UICollectionViewDataSource{
    

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictureInfos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! HBpicCollctionCell
        
//        cell.backgroundColor=randomColor()
        cell.pictureInfo = pictureInfos?[indexPath.item]
        
        return cell
        
    }
    
    
    
    
    
}

//一个文件中可以写多个类
class HBpicCollctionCell: UICollectionViewCell {
    
    var pictureInfo: HBPictureInfor? {
        didSet {
            var url = URL(string: pictureInfo?.wap_pic ?? "")
            
            if url!.absoluteString.hasSuffix(".gif")
            {
                url = URL(string: pictureInfo?.bmiddle_pic ?? "")
            }
            

//            let url = URL(string: pictureInfo?.thumbnail_pic ?? "")
            imageView.sd_setImage(with: url)
            //根据数据来设置是否显示gif的图片
            //cell的复用
            gificon.isHidden = !url!.absoluteString.hasSuffix(".gif")

        }
    }
    
    //添加一个 iv
    override init(frame: CGRect) {
        super.init(frame: frame)
        //添加子视图
        self.contentView.addSubview(imageView)
//        //设置约束

        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView.snp.edges)
        }
        //添加gif 图片
        self.contentView.addSubview(gificon)
        //设置约束
        gificon.snp.makeConstraints { (make) in
            //右下角
            make.bottom.right.equalTo(contentView)
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        
        
        //iv.contentMode = .scaleToFill   图片比例失真
        //iv.contentMode = .scaleAspectFit 造成图片视图显示不满
        iv.contentMode = .scaleAspectFill
        //手写代码设置的时候需要手动设置裁剪 xib/sb 自动设置裁剪
        iv.clipsToBounds = true

        return iv
    }()
    
    private lazy var gificon: UIImageView = UIImageView(image: #imageLiteral(resourceName: "timeline_image_gif"))

}

