# UICollectionView
---
#### 什么是UICollectionView？
*UICollectionView*是一种新的数据展示方式，简单来说可以把他理解成多列的*UITableView*。它有许多与*UITableView*相同的地方，例如：数据源、代理等接口等。既然，*UITableView*有这么多的相似之处，为什么还要学习*CollectionView*呢？作为一个独立的控件，*CollectionView*有着自己独特的**布局**特性，这一点拉开了两个控件的差距，所以学习*UIcollectionView*还是非常有必要的。
## UICollectionView 组成
---
![image](https://github.com/Silence--Thinker/UICollectionViewLayout/blob/master/image.png?raw=true)

如图：你看到的就是一个最简单的*UICollectionView*，它包含：Cells、Supplementary Views、Decoration Views。

* **Cells** ：用于展示内容的主体，cell的尺寸和内容可以各不相同。这个下面会详细介绍。
* **Supplementary Views** ： 追加视图，类似于*UITableView*每个Seciton的Header View 或者Footer View，用来标记Section的View
* **Decoration Views** ：装饰视图，完全跟数据没有关系的视图，负责给cell 或者supplementary Views添加辅助视图用的，灵活性较强。

不管多么发杂的UIcollectionView都是由着三个部件组成的。
## 实现一个简单的UICollectionView 
---
相信如果你对UITableView有所了解的话，实现一个UICollectionView，其实和UITableView没有多大的区别，它们同样是由dataSource和delegate模式设计的：*dataSource*为View提供数据源，告诉View要显示什么样的数据，*delegate*提供一些样式的小细节以及用户交互的响应。但是值得一提的是要想初始化一个UICollectionView，一定要为它提供一个布局，即：*UICollectionViewLayout*对象，改对象定义了CollectionView的一些独特的布局，后面会详细的介绍。
### UICollectionViewDataSource
---
* section数量 ：`numberOfSectionsInCollectionView:`
* 某个section中多少个item：`collectionView:numberOfItemsInSection:`
* 对于某个位置的显示什么样的cell：`collectionView:cellForItemAtIndexPath:`
* 对于某个section显示什么样的supplementary View：`collectionView:viewForSupplementaryElementOfKind:atIndexPath:`
* 对于Decoration Views，提供的方法并不在UICollectionViewDataSource中，而是在UICollectionViewLayout中（因为它仅仅跟视图相关，而与数据无关）。

#### UICollectionView子视图重用
---
与UITableView一样，避免不断的生成和销毁对象，UICollectionView对于view的重用是必须的。但是我们发现在UIcollectionview中不仅仅是cell的重用，Supplementary View和Decoration View也是可以并且应当被重用的，细心的朋友可以发现，*UIcollectionViewCell*继承自*UICollectionReusableView*，而在`collectionView:viewForSupplementaryElementOfKind:atIndexPath:`这个方法的返回类型是：UICollectionReusableView，其实苹果给UIcollectionview中的所有视图都来自一个可重用的基类，就是UICollectionReusableView，所以自定义Supplementary View和Decoration View也是继承者个类为基础，来构建自己的视图。

* 注册自定义视图
* `registerClass:forCellWithReuseIdentifier`:
* `registerNib:forCellWithReuseIdentifier`:
* `registerClass:forSupplementaryViewOfKind:withReuseIdentifier`:
* `registerNib:forSupplementaryViewOfKind:withReuseIdentifier`:
* 得到对应的视图
* `dequeueReusableCellWithReuseIdentifier:forIndexPath`:
* `dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath`:

其中`SupplementaryViewOfKind:`参数的类型是一个字符串常量，**UICollectionElementKindSectionHeader** / **UICollectionElementKindSectionFooter**该常量的定义*UICollectionViewDelegateFlowLayout*类中。
### UICollectionViewDelegate
---
和数据无关的view的外形，用户的交互什么的，都是UICollectionViewDelegate来负责

* cell的高亮
* cell的选中状态
* 可以支持长安后的菜单

在用户交互上UIcollectionview做了很多细节的处理，每个cell有独立的高亮、选中事件的delegate，开发者可以监听到的事件变得多起来，当用户点击一个cell的时候，会按以下的流程delegate询问（这是UIcollectionViewDelegate API中给出的）：

* (when the touch begins)
* 1、`-collectionView:shouldHighlightItemAtIndexPath:`是否应该高亮？
* 2、`-collectionView:didHighlightItemAtIndexPath:`如果1返回YES,执行，否则不执行
* (when the touch lifts)
* 3、`-collectionView:shouldSelectItemAtIndexPath:` or `-collectionView:shouldDeselectItemAtIndexPath:`如果1返回NO这里不再询问询问是否选中，
* 4、`-collectionView:didSelectItemAtIndexPath:` or `-collectionView:didDeselectItemAtIndexPath:`如果3中返回选中，调用选中
* 5、`-collectionView:didUnhighlightItemAtIndexPath:`如果1返回YES，那么会调用取消高亮

在UIcollectionview中分别有selected和highlighted属性控制状态。
#### UICollectionViewCell
---
相对于UItableViewCell而言，UIcollectionViewCell没有那么多样式。UIcollectionViewCell不存在所谓的style，也没有titleLabel和内置的imageView属性，UIcollectionViewCell的结构上相对比较简单，由下至上：

* **cell** ：本身作为的View，这里应该就是*UICollectionReusableView*
* **backgroundView** ：用作cell背景的视图，设置背景图片等。
* **selectedBackgroundView** ：cell被选中的背景视图
* **contentView** ：内容视图，自定义的cell时应该将内容放在这个View上

UIcollectionView有一个小细节：被选中的cell的自动变化，所有的cell中的子View，也包括contentView中的子View，当cell被选中是，会自动去查找view是否有被选中状态下的改变，如果在contentView中有一个imageView的selected和normal状态下的图片是不同的，那么选中cell这张图片也会从normal变成selected，不需要添加代码。
## UICollectionView 布局 UICollectionViewLayout
---
UICollectionViewLayout是UICollectionView特有的，是UICollectionView的精髓所在，它负责将每个cell、supplementary view、decoration view进行组合，为它们设置各自的属性，包括：位置、大小、透明度、层级关系、形状等。UICollectionViewLayout决定了，UICollectionView是如何显示在界面上，从UICollectionView初始化必须要一个UICollectionViewLayout也可以看得出来，Layout对于UICollectionView的最要性。
### UICollectionViewFlowLayout 流水布局
---
苹果为我们设计了一套非常灵活、通用的Layout，就是UICollectionViewFlowLayout流水布局，也叫线性布局。UICollectionViewFlowLayout属性：

* `CGSize itemSize`：它定义了每一个item的大小，通过itemSize可以快捷给每一个cell设置一样的大小，如果你想到不同的尺寸，`-collectionView:layout:sizeForItemAtIndexPath:`来给每一个item指定不同的尺寸。
* `CGFloat minimumLineSpacing`：最小行间隔，同样你也可以通过`-collectionView:minimumLineSpacingForSectionAtIndex:`方法来个没一行设置不同的行间距
* `CGFloat minimumInteritemSpacing`：最小cell之间的距离，同上都是可以通过`-collectionView:minimumInteritemSpacingForSectionAtIndex:`特定的方法，顶底到具体的行和item之间的间距的，非常的灵活。
* `UIEdgeInsets sectionInset`：组内边距，设置UIcollectionView整体的组内边距，同上有特定方法`-collectionView:insetForSectionAtIndex:`设置具体的边距
* `CGSize headerReferenceSize`：设置supplementary header View的大小`-collectionView:referenceSizeForHeaderInSection:`
* `CGSize footerReferenceSize`：设置supplementary header View的大小`-collectionView:referenceSizeForFooterInSection:`
* `UICollectionViewScrollDirection scrollDirection`：设置UIcollectionView的滚动方向

UICollectionViewFlowLayout方法：

	// 1、准备布局，布局初始化一般在这里进行
	- (void)prepareLayout;
	
	// 每当collectionView边界改变时便调用这个方法询问 是否 重新初始化布局 是则调用prepareLayout准备布局
	- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds;
	
	// 2、初始化布局时调用，返回在一定区域内，每个cell和Supplementary和Decoration的布局属性
	- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:	(CGRect)rect;
	
	// 当滚动停止时，会调用该方法确定collectionView滚动到的位置
	- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset 	withScrollingVelocity:(CGPoint)velocity;
在使用UICollectionViewFlowLayout布局的时候，有时会有特别的需求，比如：当一个cell滑动到屏幕中点的时候放大，并且当我停止滑动时，能够将离屏幕最近的cell居中。这四个方法就能轻松的完成这样的事。
#### UICollectionViewLayoutAttributes 布局属性
---
在了解这个类之前，我们得先疏通一下，UIcollectionView的布局方式，首先我们之前一直提，UIcollectionView的初始化必须有一个UICollectionViewLayout，也就是我们说的，必须要有一个布局格式样式，那么一个UIcollectionView有那么多的cell、supplementary View、decoration View，*UIcollectionViewLayout*是如何进行布局显示的呢？原来从UIcollectionViewLayout开始加载内容的时候，便默默的做了很多事：首先是去调用 **1** 准备布局，然后根据当前屏幕所处位置的合适rect，得到每一个视图的*UICollectionViewLayoutAttributes*属性，然后在把视图按*UICollectionViewLayoutAttributes*中的属性描述设置视图具体的center、size等等，期间也会去调用其他方法去确定一些间距。所以UICollectionViewLayoutAttributes是每个视图决定性的布局的属性。

* **CGRect frame**   	布局视图的frame简单明了
* **CGPoint center**	视图中心点
* **CGSize size**		视图尺寸
* **CATransform3D transform3D**		这个属性可以用来做酷炫的3D动画
* **CGAffineTransform transform**		转场属性
* **CGFloat alpha**		透明度
* **NSInteger zIndex**	层级，数字越大，层级越高（最上面）。
* **NSIndexPath *indexPath**	如果是cell有对应的indexPath
* **UICollectionElementCategory representedElementCategory** 视图标记，是cell还是supplementary View或者decoration View
* registerClass:forDecorationViewOfKind: 注册decoration View
* registerNib:forDecorationViewOfKind:
* ** + (instancetype)layoutAttributesForDecorationViewOfKind:(NSString \*)decorationViewKind withIndexPath:(NSIndexPath *)indexPath** 这个类方法是decoration View布局的来源
* **- (nullable UICollectionViewLayoutAttributes \*)layoutAttributesForDecorationViewOfKind:(NSString \*)elementKind atIndexPath:(NSIndexPath *)indexPath** 与上一个方法结合得到decoration View布局

### UICollectionViewLayout 自定义布局
---
由于系统给我们设计的流水局在实现和细节处理上，帮我们做了很多事，所以完全的自定义布局是挺麻烦，并且要考虑到各种细节的。在UIcollectionViewLayout头文件中，苹果给我提供很多特定的方法，以供我们自己布局，有仅仅关于布局的、有关于删除插入item的布局、有关于移动item的布局。方法分的很细，我们只了解基本的布局、删除和插入布局等。

* `@interface UICollectionViewLayout (UISubclassingHooks)` 这个扩展类中，都是用来布局UIcollectionView子视图的
* `@interface UICollectionViewLayout (UIUpdateSupportHooks)` 用来布局删除插入动作
* `@interface UICollectionViewLayout (UIReorderingSupportHooks)` 移动动作布局

#### UISubclassingHooks 
---
这个扩展类里面的方法，上面流水布局的代码处已经给列举出来，就不多说了
#### UIUpdateSupportHooks 
---
在UIcollectionView中删除或者插入item时，建议使用下面的方式：

	[self.collectionView performBatchUpdates:^{
    	[self.collectionView deleteItemsAtIndexPaths:@[pinchIndexPath]];
    } completion:nil];
    [self.collectionView performBatchUpdates:^{
    	[self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
    } completion:nil];	

值得一说的是，在对UIcollectionView插入和删除操作是，不管使用的是上面的更新方式还是*reloadData*,collectionView都不会刷新全部的cell，具体原因本人也不是很清楚，多说无益，下面上删除、插入的代码：

<pre><code>
/*  在insert或者delete之前，prepareForCollectionViewUpdates:会调用，
	可以使用这个方法来完成 添加/ 删除的预处理，将要删除或者插入的indexPath保存
*/
- (void)prepareForCollectionViewUpdates:(NSArray<UICollectionViewUpdateItem *> *)updateItems {
    
    // Keep track of insert and delete index paths
    [super prepareForCollectionViewUpdates:updateItems];
    
    self.deleteIndexPaths = [NSMutableArray array];
    self.insertIndexPaths = [NSMutableArray array];
    
    for (UICollectionViewUpdateItem *update in updateItems) {
        if (update.updateAction == UICollectionUpdateActionDelete) {
            [self.deleteIndexPaths addObject:update.indexPathBeforeUpdate];
            
        }else if (update.updateAction == UICollectionUpdateActionInsert) {
            
            [self.insertIndexPaths addObject:update.indexPathAfterUpdate];
        }
    }
}

// 更新结束后调用 这个方法在 performBatchUpdates:completion: complete的Block之前调用
- (void)finalizeCollectionViewUpdates {
    [super finalizeCollectionViewUpdates];
    //  释放insert and delete index paths
    self.deleteIndexPaths = nil;
    self.insertIndexPaths = nil;
}

/**
    这两个方法是成对出现的，一个是在在屏幕上出现之前调用，一个是在屏幕上出现之后调用
    在[collecView reloadData]或者performBatchUpdates:completion:调用的时候
    只要是有刷新的效果，他们就会被调用多次，视图不断的消失（失效，被摧毁）出现（重组 被创建或者回收利用）
 */
// For each element on screen before the invalidation,
- (nullable UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    // Must call super
    UICollectionViewLayoutAttributes *attributes = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];

    if ([self.insertIndexPaths containsObject:itemIndexPath]) {
        // 只改变插入的 attributes
        attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
        
        // configure attributes...
        attributes.alpha = 0;
        attributes.center = _center;
        attributes.transform3D = CATransform3DMakeScale(0.1, 0.1, 1.0);
    }
    return attributes;
}

// For each element on screen after the invalidation,
- (nullable UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *attributes = [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
    
    if ([self.deleteIndexPaths containsObject:itemIndexPath]) {
        attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
        attributes.alpha = 0;
        attributes.center = _center;
        attributes.transform3D = CATransform3DMakeScale(0.1, 0.1, 1.0);
    }
    return attributes;
}
</code></pre>
##### UICollectionViewUpdateItem
这个类是UIcollectionView更新布局的时候，新旧布局信息交换的媒介，它存储了旧的布局，或者新布局。
