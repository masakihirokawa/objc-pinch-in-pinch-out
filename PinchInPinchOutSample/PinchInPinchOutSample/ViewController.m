//
//  ViewController.m
//  PinchInPinchOutSample
//
//  Created by Dolice on 2013/06/16.
//  Copyright (c) 2013年 Dolice. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

- (CGFloat)distanceWithPointA:(CGPoint)pointA pointB:(CGPoint)pointB;

@property UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //背景色を黒に設定
    self.view.backgroundColor = [UIColor blackColor];
    
    //マルチタッチの有効化
    self.view.multipleTouchEnabled = YES;
    
    //イメージの読み込み
    UIImage *image = [UIImage imageNamed:@"Pandora_640_1136.jpg"];
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 578)];
    _imageView.image = image;
    _imageView.center = self.view.center;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.autoresizingMask =
        UIViewAutoresizingFlexibleLeftMargin |
        UIViewAutoresizingFlexibleRightMargin |
        UIViewAutoresizingFlexibleTopMargin |
        UIViewAutoresizingFlexibleBottomMargin;
    
    //イメージを画面に追加
    [self.view addSubview:_imageView];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([touches count] == 2) {
        //2本指でタッチしている場合は、２点間の距離を計算
        NSArray *twoFingers = [touches allObjects];
        UITouch *touch1 = [twoFingers objectAtIndex:0];
        UITouch *touch2 = [twoFingers objectAtIndex:1];
        CGPoint previous1 = [touch1 previousLocationInView:self.view];
        CGPoint previous2 = [touch2 previousLocationInView:self.view];
        CGPoint now1 = [touch1 locationInView:self.view];
        CGPoint now2 = [touch2 locationInView:self.view];
        
        //現状の距離と、前回の距離を比較して距離が縮まったか離れたかを判別
        CGFloat previousDistance = [self distanceWithPointA:previous1 pointB:previous2];
        CGFloat distance = [self distanceWithPointA:now1 pointB:now2];
        
        CGFloat scale = 1.0;
        if (previousDistance > distance) {
            //距離が縮まったらならピンチイン
            scale -= ( previousDistance - distance ) / 300.0;
        } else if (distance > previousDistance) {
            // 距離が広がったならピンチアウト
            scale += ( distance - previousDistance ) / 300.0;
        }
        CGAffineTransform newTransform =
            CGAffineTransformScale(_imageView.transform, scale, scale);
        _imageView.transform = newTransform;
        _imageView.center = self.view.center;
    }
}

- (CGFloat)distanceWithPointA:(CGPoint)pointA pointB:(CGPoint)pointB
{
    CGFloat dx = fabs( pointB.x - pointA.x );
    CGFloat dy = fabs( pointB.y - pointA.y );
    return sqrt(dx * dx + dy * dy);
}

@end
