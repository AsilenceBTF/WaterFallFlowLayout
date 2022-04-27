//
//  WaterFlowLayout.h
//  Pro1.0
//
//  Created by asilencebtf on 2022/4/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WaterFallFlowLayoutDelegate;
@class WaterFallFlowLayout;

@interface WaterFallFlowLayout : UICollectionViewFlowLayout

@property (assign,nonatomic)CGFloat columnMargin;//每一列item之间的间距
@property (assign,nonatomic)CGFloat rowMargin;   //每一行item之间的间距
@property (assign,nonatomic)UIEdgeInsets sectionInset;//设置于collectionView边缘的间距
@property (assign,nonatomic)NSInteger columnCount;//设置每一行排列的个数

@property (weak,nonatomic)id<WaterFallFlowLayoutDelegate> delegate; //设置代理

@end

@protocol WaterFallFlowLayoutDelegate

@required
- (CGFloat)waterFlowLayout:(WaterFallFlowLayout *) WaterFlowLayout heightForWidth:(CGFloat)width andIndexPath:(NSIndexPath *)indexPath;

@end



NS_ASSUME_NONNULL_END
