//
//  WaterFlowLayout.m
//  Pro1.0
//
//  Created by asilencebtf on 2022/4/26.
//

#import "WaterFallFlowLayout.h"


@interface WaterFallFlowLayout()

/** 这个字典用来存储每一列item的高度 */
@property (strong,nonatomic)NSMutableDictionary *maxYDic;
/** 存放每一个item的布局属性 */
@property (strong,nonatomic)NSMutableArray *attrsArray;

@end

@implementation WaterFallFlowLayout

@synthesize sectionInset;


#pragma mark-lazy initlazition
- (NSMutableDictionary *)maxYDic {
    if(!_maxYDic) {
        _maxYDic = [NSMutableDictionary dictionary];
    }
    return _maxYDic;
}

- (NSMutableArray *)attrsArray {
    if(!_attrsArray) {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

- (instancetype)init {
    if(self = [super init]) {
        self.columnMargin = 10;
        self.rowMargin = 10;
        self.columnCount = 2;
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    for(int i = 0; i < self.columnCount; ++i) {
        NSString *column = [NSString stringWithFormat:@"%d", i];
        self.maxYDic[column] = @(self.sectionInset.top);
    }
    
    [self.attrsArray removeAllObjects];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for(int i = 0; i < count; ++i) {
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [self.attrsArray addObject:attrs];
    }
}

- (CGSize)collectionViewContentSize {
    __block NSString *maxColumn = @"0";
    [self.maxYDic enumerateKeysAndObjectsUsingBlock:^(NSString *column, NSNumber *y, BOOL *stop){
        if([y floatValue] > [self.maxYDic[column] floatValue]) {
            maxColumn = column;
        }
    }];
    return CGSizeMake(0, [self.maxYDic[maxColumn] floatValue] + self.sectionInset.bottom);
}

// 是否item边界改变就重新布局 只要每一次重新布局内部就会调用下面的layoutAttributesForElementsInRect:获取所有cell(item)的属性
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    __block NSString *minColumn = @"0";
    [self.maxYDic enumerateKeysAndObjectsUsingBlock:^(NSString *column, NSNumber *y, BOOL *ok){
        if([y floatValue] < [self.maxYDic[minColumn] floatValue]) {
            minColumn = column;
        }
    }];
    CGFloat width = (self.collectionView.frame.size.width - self.columnMargin * (self.columnCount - 1) - self.sectionInset.left - self.sectionInset.right) / self.columnCount;
    CGFloat height = [self.delegate waterFlowLayout:self heightForWidth:width andIndexPath:indexPath];
    
    CGFloat x = self.sectionInset.left + (width + self.columnMargin) * [minColumn floatValue];
    CGFloat y = [self.maxYDic[minColumn] floatValue] + self.rowMargin;
    
    self.maxYDic[minColumn] = @(y + height);
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attrs.frame = CGRectMake(x, y, width, height);
    return attrs;
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return [self.attrsArray copy];
}





@end
