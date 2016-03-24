//
//  CarouselCollectionViewController.m
//  zhuochenming
//
//  Created by zhuochenming on 16/1/29.
//  Copyright © 2016年 zhuochenming. All rights reserved.
//

#import "CarouselCollectionViewController.h"
#import "CarouselCollectionViewLayout.h"

@implementation CarouselCollectionViewController

- (id)init {
    self = [super init];
    if (self) {
        CarouselCollectionViewLayout *layout = [[CarouselCollectionViewLayout alloc] init];
        layout.itemSize = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) - 50, 400);
        layout.itemInterval = 10;
        layout.headerSize = CGSizeMake(50, 400);
        layout.footerSize = CGSizeMake(50, 400);
        self = [super initWithCollectionViewLayout:layout];
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];

    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer"];

    self.collectionView.backgroundColor = [UIColor whiteColor];
}

#pragma mark - 代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
//    个数不多的时候 不用折腾 只管用
    cell.layer.cornerRadius = 5;
    cell.backgroundColor = [UIColor orangeColor];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

    UICollectionReusableView *view;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Header" forIndexPath:indexPath];
        view.backgroundColor = [UIColor orangeColor];
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        lable.text = @"Header";
        lable.font = [UIFont systemFontOfSize:14];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.textColor = [UIColor whiteColor];
        [view addSubview:lable];
        
    } else {
        view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Footer" forIndexPath:indexPath];
        view.backgroundColor = [UIColor orangeColor];
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        lable.text = @"Footer";
        lable.font = [UIFont systemFontOfSize:14];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.textColor = [UIColor whiteColor];
        [view addSubview:lable];
    }

    return view;
}

@end
