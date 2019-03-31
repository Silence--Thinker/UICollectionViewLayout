//
//  RETEditionRightListLayout.h
//  RETBCategoryList
//
//  Created by 曹秀锦 on 2019/3/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RETEditionRightListLayout;
@protocol RETEditionRightListLayoutDelegate <NSObject>

- (CGFloat)layout:(RETEditionRightListLayout *)layout sectionHeaderHeight:(NSInteger)section;

- (CGFloat)layout:(RETEditionRightListLayout *)layout sectionFooterHeight:(NSInteger)section;

- (void)layout:(RETEditionRightListLayout *)layout section:(NSInteger)section;

@end

@interface RETEditionRightListLayout : UICollectionViewFlowLayout

@property (nonatomic, strong) NSMutableDictionary *sectionHeaderHeightDict;
@property (nonatomic, strong) NSMutableDictionary *sectionFooterHeightDict;

@property (nonatomic, copy) NSMutableArray<NSNumber *> *alwaysTopHeaderArray;

@property (nonatomic, weak) id<RETEditionRightListLayoutDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
