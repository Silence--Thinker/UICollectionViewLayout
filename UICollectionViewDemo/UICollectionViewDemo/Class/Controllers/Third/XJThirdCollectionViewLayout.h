//
//  XJThirdCollectionViewLayout.h
//  UICollectionViewDemo
//
//  Created by 曹秀锦 on 2018/7/16.
//  Copyright © 2018年 silence. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XJThirdCollectionViewLayout;
@protocol XJThirdCollectionViewLayoutDelegate <NSObject>

@optional
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(XJThirdCollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(XJThirdCollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(XJThirdCollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(XJThirdCollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section;

@end

@interface XJThirdCollectionViewLayout : UICollectionViewLayout

@property (nonatomic, weak) id<XJThirdCollectionViewLayoutDelegate> delegate;

@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) CGSize sectionHeaderSize;
@property (nonatomic, assign) CGSize sectionFooterSize;

@property (nonatomic, assign) UIEdgeInsets sectionInsets;

/** 行间距 */
@property (nonatomic, assign) CGFloat rowMargin;
/** 列间距 */
@property (nonatomic, assign) CGFloat columnMargin;
/** 列数目 */
@property (nonatomic, assign) CGFloat columnCount;
/** 瀑布组 */
@property (nonatomic, assign) NSInteger specialSection;

@end
