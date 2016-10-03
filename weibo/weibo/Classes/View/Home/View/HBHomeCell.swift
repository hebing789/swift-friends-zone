//
//  HBHomeCell.swift
//  weibo
//
//  Created by hebing on 16/9/27.
//  Copyright © 2016年 hebing. All rights reserved.
//

import UIKit
//使用分类中的方法的时候不需要导包 但是使用主类中的方法或者属性的时候就需要导包

import SDWebImage
 let commonMargin: CGFloat = 8
//图片之间的间距
private let pictureCellMargin: CGFloat = 3
//计算图片的宽度
private let maxWidth = ScreenWidth - 2 * commonMargin
private let itemWidth = (maxWidth - 2 * pictureCellMargin) / 3


class HBHomeCell: UITableViewCell {
    
    @IBOutlet weak var toolBarView: UIView!
    @IBOutlet weak var retweetedLable: UILabel!
    @IBOutlet weak var ohYeahBtn: UIButton!
    @IBOutlet weak var resendBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var toolBarTopConst: NSLayoutConstraint!
    @IBOutlet weak var picViewFlowLayOut: UICollectionViewFlowLayout!
    @IBOutlet weak var picViewWidth: NSLayoutConstraint!
    @IBOutlet weak var picViewHight: NSLayoutConstraint!
    @IBOutlet weak var picView: HBPictViewCell!
    
    
    @IBOutlet weak var contentLable: UILabel!


    @IBOutlet weak var sourceLable: UILabel!
    @IBOutlet weak var memberView: UIImageView!
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var timeLable: UILabel!
        ///微博认证类型
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var iconView: UIImageView!
    
    
    func rowHeight(viewmodel: HBStatusViewModel) -> CGFloat {
        //给属性赋值
        self.viewmodel = viewmodel
        //提前刷新布局
//        self.contentView.layoutIfNeeded()
        //提前刷新布局 如果不加layoutIfNeeded 这个控件的frame只是在将要显示的时候才会被计算

        //layOutSubview只会在
        self.layoutIfNeeded()
        //可以光明正大的获取toolbar的frame

        return toolBarView.frame.maxY
    }

    
    //绑定数据
    var viewmodel: HBStatusViewModel? {
        didSet {
            //设置视图的数据
            //iconView.sd_setImage(with: <#T##URL!#>)
//            timeLable.text = viewmodel?.status?.created_at
            timeLable.text = viewmodel?.timeText

//            sourceLable.text = viewmodel?.status?.source
            sourceLable.text = viewmodel?.sourceText

            contentLable.text = viewmodel?.status?.text
            avatarView.image = viewmodel?.avatarImage
            memberView.image = viewmodel?.memberImage

            iconView.sd_setImage(with: viewmodel?.iconURL)

            nameLable.text = viewmodel?.status?.user?.name
            
            //一旦设置了数据 就应该立即更新配图视图的大小的约束
//            let pSize = changePictureViewSize(count: viewmodel?.status?.pic_urls?.count ?? 0)
            // 共用了配图视图  配图视图有且只有一份
            let count = viewmodel?.pictureInfos?.count ?? 0

//            let count = viewmodel?.status?.pic_urls?.count ?? 0
            let pSize = changePictureViewSize(count: count)
            

            //更新约束值
            picViewWidth.constant = pSize.width
            picViewHight.constant = pSize.height
            
            //根据是否有配图调整顶部间距
            toolBarTopConst.constant = (count == 0 ? 0 : commonMargin)

           
            //给配图视图设置数据源
//            picView.pictureInfos = viewmodel?.status?.pic_urls
            picView.pictureInfos = viewmodel?.pictureInfos

            
            //给底部工具条的按钮赋值
            commentBtn.setTitle(viewmodel?.comment_text, for: .normal)
            resendBtn.setTitle(viewmodel?.repost_text, for: .normal)
            ohYeahBtn.setTitle(viewmodel?.ohYeahText, for: .normal)

            //只能够对可选类型做可选/强制解包
            retweetedLable?.text = viewmodel?.status?.retweeted_status?.text
            
//            lable后面+?号,否则奔溃
//            retweetedLable.text=viewmodel?.status?.retweeted_status?.text

            
        }
    }
    
    //根据图片的张数来计算配图视图的大小
    private func changePictureViewSize(count: Int) -> CGSize {
        
        //0张图片
        if count == 0 {
            return CGSize.zero
        }
        if count == 1 {
            //返回原比例的大小
            //根据urlString 去沙盒中获取缓存的图片
            //能否在这个地方就一定确保图片已经被缓存到沙盒中
            let urlString = viewmodel?.pictureInfos?.first?.wap_pic ?? ""
            let image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: urlString)
            let imageSize = image?.size
//            return imageSize ?? CGSize(width: itemWidth, height: itemWidth)
//            return imageSize!//图片frame是返回的挺大,但是图片不大
            
        }

        //4 张图片
        if count == 4 {
            let width = itemWidth * 2 + pictureCellMargin
            return CGSize(width: width, height: width)
        }
        //其他 1,2,3,5,6,7,8,9  -> 3 * n
        //已知个数 和 列数 来计算 函数
        //3个为1,4个为2(行数)
        let rowCount = CGFloat((count - 1) / 3 + 1)
        let height = rowCount * itemWidth + (rowCount - 1) * pictureCellMargin
        return CGSize(width: maxWidth, height: height)
    }

    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //awakeFromNib获取的bounds 是根据xib中设置的大小 不是准确大小

        //设置cell的选中样式
        //让cell可以不被选中
        selectionStyle = .none

        contentLable.preferredMaxLayoutWidth = ScreenWidth - 2 * commonMargin

//        self.backgroundColor=randomColor()
        self.backgroundColor = UIColor.white
        
        picViewFlowLayOut.itemSize = CGSize(width: itemWidth, height: itemWidth)
        //设置间距
        //行间距 默认的间距: 10
        picViewFlowLayOut.minimumLineSpacing = pictureCellMargin
        picViewFlowLayOut.minimumInteritemSpacing = pictureCellMargin

    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
