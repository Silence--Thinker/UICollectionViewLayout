//
//  RETEditionRightListLayout.h
//  RETBCategoryList
//
//  Created by 曹秀锦 on 2019/3/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XJFifCollectionViewLayout;
@protocol RETEditionRightListLayoutDelegate <NSObject>

- (CGFloat)layout:(XJFifCollectionViewLayout *)layout sectionHeaderHeight:(NSInteger)section;

- (CGFloat)layout:(XJFifCollectionViewLayout *)layout sectionFooterHeight:(NSInteger)section;

- (void)layout:(XJFifCollectionViewLayout *)layout section:(NSInteger)section;

@end

@interface XJFifCollectionViewLayout : UICollectionViewFlowLayout

@property (nonatomic, strong) NSMutableDictionary *sectionHeaderHeightDict;
@property (nonatomic, strong) NSMutableDictionary *sectionFooterHeightDict;

@property (nonatomic, copy) NSMutableArray<NSNumber *> *alwaysTopHeaderArray;

@property (nonatomic, copy) BOOL(^alwaysHeaderTop)(NSInteger section);
@property (nonatomic, weak) id<RETEditionRightListLayoutDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
