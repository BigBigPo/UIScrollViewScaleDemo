//
//  ViewController.m
//  UIScrollViewTest
//
//  Created by Po on 2017/5/27.
//  Copyright © 2017年 Po. All rights reserved.
//

#import "ViewController.h"

#define SCWidth [UIScreen mainScreen].bounds.size.width

@interface ViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageTop;

@property (strong, nonatomic) NSArray * imageArray;                     //图片
@property (assign, nonatomic) NSInteger currentImageCount;              //当前图片编号
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _imageArray = @[[UIImage imageNamed:@"image"],
                    [UIImage imageNamed:@"image1"]];
    
    [_scrollView setDelegate:self];         //不要忘记添加代理
    [_scrollView setMinimumZoomScale:1];    //最小缩放系数
    [_scrollView setMaximumZoomScale:2];    //最大缩放系数
    
    _currentImageCount = 0;
    [self resetImage:_imageArray[_currentImageCount]];

}

- (void)resetImage:(UIImage *)image {
    //适配图片
    CGSize size = [self getImageVeiwSizeWithImage:image];
    
    //重置imageView的大小与位置
    _imageWidth.constant = size.width;
    _imageHeight.constant = size.height;
    
    //设置图片
    [_imageView setImage:image];
    [self setScrollViewCenterWithImageSize:size];
}

#pragma mark - event
- (IBAction)pressNextButton:(UIButton *)sender {
    
    if (_currentImageCount >= _imageArray.count - 1) {
        _currentImageCount = 0;
    } else {
        _currentImageCount += 1;
    }
    
    UIImage * image = _imageArray[_currentImageCount];
    [self resetImage:image];
}


#pragma mark - UIScrollViewDelegate
//该代理方法需要返回一个需要缩放的view，若返回nil，将没有任何效果。
//注：在TableView、UICollectionView中使用UIScrollView来完成缩放效果时，直接返回imageView可能不能达到效果，需要给imageView套一层View，在此代理中返回该view即可解决。
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
    
}


#pragma mark - tools

/**
 根据图片视图大小来确定图片位置
 */
- (void)setScrollViewCenterWithImageSize:(CGSize)size {
    //获取scrollView的尺寸（在Demo中，我们把scrollView的长宽都设置成了屏宽，是相等的）
    CGFloat scrollViewSize = SCWidth;
    
    //获取图片中心以此为依据计算scrollView的contentOffset
    CGPoint imageCenter = CGPointMake(size.width / 2, size.height / 2);
    CGPoint point = CGPointMake(imageCenter.x - scrollViewSize / 2, imageCenter.y - scrollViewSize / 2);
    [_scrollView setContentOffset:point];
}

/**
 根据图片的大小来获得合适的容器大小
 */
- (CGSize)getImageVeiwSizeWithImage:(UIImage *)image {
    //获取scrollView的尺寸（在Demo中，我们把scrollView的长宽都设置成了屏宽，是相等的）
    CGFloat scrollViewSize = SCWidth;
    
    //注：下方的 +1 只是为了方便实现ScrollView的边界弹簧效果，并无其他用处
    CGFloat width = scrollViewSize + 1;
    CGFloat height = width / image.size.width * image.size.height;
    if (height < scrollViewSize) {
        height = scrollViewSize + 1;
        width = height / image.size.height * image.size.width;
    }
    return CGSizeMake(width, height);
}
@end
