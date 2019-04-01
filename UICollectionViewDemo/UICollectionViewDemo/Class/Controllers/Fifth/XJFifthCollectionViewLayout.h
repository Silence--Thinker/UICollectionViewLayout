//
//  XJFifthCollectionViewLayout.h
//  RETBCategoryList
//
//  Created by 曹秀锦 on 2019/3/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XJFifthCollectionViewLayout;
@protocol RETEditionRightListLayoutDelegate <NSObject>

@required
- (CGFloat)layout:(XJFifthCollectionViewLayout *)layout sectionHeaderHeight:(NSInteger)section;
- (CGFloat)layout:(XJFifthCollectionViewLayout *)layout sectionFooterHeight:(NSInteger)section;

@optional
- (void)layout:(XJFifthCollectionViewLayout *)layout section:(NSInteger)section;

@end

@interface XJFifthCollectionViewLayout : UICollectionViewFlowLayout

@property (nonatomic, strong, readonly) NSMutableDictionary<NSNumber *, NSNumber *> *sectionHeaderHeightDict;
@property (nonatomic, strong, readonly) NSMutableDictionary<NSNumber *, NSNumber *> *sectionFooterHeightDict;
@property (nonatomic, strong, readonly) NSMutableArray<NSNumber *> *alwaysTopHeaderArray;
@property (nonatomic, assign, readonly) NSInteger now_section;

@property (nonatomic, copy) BOOL(^alwaysHeaderTop)(NSInteger section);
@property (nonatomic, copy) CGFloat(^sectionHeaderHeight)(NSInteger section);
@property (nonatomic, copy) CGFloat(^sectionFooterHeight)(NSInteger section);

@property (nonatomic, weak) id<RETEditionRightListLayoutDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
