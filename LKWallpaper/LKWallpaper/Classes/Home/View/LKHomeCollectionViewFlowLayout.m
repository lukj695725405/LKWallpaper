//
//  LKHomeCollectionViewFlowLayout.m
//  LKWallpaper
//
//  Created by Lukj on 2017/5/21.
//  Copyright © 2017年 lukj. All rights reserved.
//

#import "LKHomeCollectionViewFlowLayout.h"

@implementation LKHomeCollectionViewFlowLayout

- (void)prepareLayout {

    [super prepareLayout];

    CGFloat W = self.collectionView.bounds.size.width;
    CGFloat H = self.collectionView.bounds.size.height;

    CGFloat itemH = H * 0.4;
    //  设置每个item的大小
    self.itemSize = CGSizeMake(W, itemH);
//    self.itemSize = CGSizeMake(self.collectionView.bounds.size.width, 44);
    //  竖着排列
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    //  内边距
    self.minimumLineSpacing = 10;
    self.minimumInteritemSpacing = 0;


}

//- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
//
//    NSArray<UICollectionViewLayoutAttributes *> *arr = [super layoutAttributesForElementsInRect:rect];
//
//    //    NSLog(@"%@",arr);
//
//    NSMutableArray *arryM = [[NSMutableArray alloc] initWithArray:arr copyItems:YES];
//
//    for (UICollectionViewLayoutAttributes *attr in arryM) {
//
//        CGFloat screenH = self.collectionView.bounds.size.height - 20;
//        CGFloat comonY = self.collectionView.contentOffset.y + screenH * 0.4;
////        NSLog(@"%f", self.collectionView.contentOffset.y );
//        CGFloat margin = attr.center.y - comonY;
////        NSLog(@"%f", margin);
//
//        CGFloat scale = 1 - ABS(margin) / screenH * 0.2;
////        attr.transform3D = CATransform3DMakeScale(scale, scale, 1);
//        attr.transform = CGAffineTransformMakeScale(scale, scale);
//    }
//
//    return arryM.copy;
//}

//- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
//    
//    NSArray *tempArray = [super layoutAttributesForElementsInRect:rect];
//    
//    NSArray *arrays = [[NSArray alloc]initWithArray:tempArray copyItems:YES];
//    
//    CGFloat topOffset = self.collectionView.contentOffset.y;
//    CGFloat bottonOffset = topOffset + self.collectionView.bounds.size.height - self.collectionView.contentSize.height;
//    //    NSLog(@"%f",topOffset);
//    NSLog(@"%f",bottonOffset);
//    for (int i = 0; i < arrays.count; i++) {
//        
//        UICollectionViewLayoutAttributes *array = arrays[i];
//        CGRect rect = array.frame;
//        if (topOffset <= 0) {
//            
//            //减去自身的offset 取消collectionview系统的offset
//            rect.origin.y += topOffset - topOffset * (array.indexPath.item + 1) * .2;
//            
//        }else if(bottonOffset > 0){
//            
//            rect.origin.y += bottonOffset - bottonOffset * (arrays.count - array.indexPath.item) * .2;
//            
//        }
//        
//        
//        array.frame = rect;
//    }
//    
//    return arrays;
//}

//  实时刷新
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    [super shouldInvalidateLayoutForBoundsChange:newBounds];

    return YES;
}

@end
