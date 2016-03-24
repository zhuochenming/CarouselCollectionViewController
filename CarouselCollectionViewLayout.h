//
//  CarouselCollectionViewLayout.h
//  zhuochenming
//
//  Created by zhuochenming on 16/1/29.
//  Copyright © 2016年 zhuochenming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarouselCollectionViewLayout : UICollectionViewLayout

@property(nonatomic, assign) CGSize itemSize;

@property(nonatomic, assign) CGFloat itemInterval;

@property(nonatomic, assign) CGSize headerSize;

@property(nonatomic, assign) CGSize footerSize;

@end
