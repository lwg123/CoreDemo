//
//  pictureView.m
//  CoreDemo
//
//  Created by weiguang on 16/7/12.
//  Copyright © 2016年 weiguang. All rights reserved.
//

#import "pictureView.h"

#define TILE_SIZE 20
@implementation pictureView


- (void)drawRect:(CGRect)rect {
    CGContextRef context=UIGraphicsGetCurrentContext();
    //[self drawLinearGradient:context];
    //[self drawRadialGradient:context];
    [self drawRectWithLinearGradientFill:context];
   // [self drawBackgroundWithColoredPattern:context];
    //[self drawImage:context];
}

#pragma mark 图形上下文形变
-(void)drawImage:(CGContextRef)context{
    //保存初始状态
    CGContextSaveGState(context);
    //形变第一步，图形上下文向右平移40
    CGContextTranslateCTM(context, 100, 0);
    //缩放0.8
    CGContextScaleCTM(context, 0.8, 0.8);
    //旋转
    CGContextRotateCTM(context, M_PI_4/2);
    
    UIImage *image = [UIImage imageNamed:@"tu1.jpeg"];
    [image drawInRect:CGRectMake(100, 50, 240, 300)];
    
    //回复到初始状态
    CGContextRestoreGState(context);
}

//扩展--使用Core Graphics绘制图像
/*
 *在Core Graphics中坐标系的y轴正方向是向上的，坐标原点在屏幕左下角，y轴方向刚好和UIKit中y轴方向相反
 */
-(void)drawImage2:(CGContextRef)context{
    UIImage *image=[UIImage imageNamed:@"tu1.jpeg"];
    CGSize size=[UIScreen mainScreen].bounds.size;
    CGContextSaveGState(context);
    CGFloat height=300,y=50;
    //上下文形变
    CGContextScaleCTM(context, 1.0, -1.0);//在y轴缩放-1相当于沿着x张旋转180
    CGContextTranslateCTM(context, 0, -(size.height-(size.height-2*y-height)));//向上平移
    //图像绘制
    CGRect rect= CGRectMake(10, y, 240, height);
    CGContextDrawImage(context, rect, image.CGImage);
    CGContextRestoreGState(context);
}

#pragma mark 线性渐变颜色
-(void)drawLinearGradient:(CGContextRef)context{
    //使用RGB颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    /*指定渐变色
     space:颜色空间
     components:颜色数组,注意由于指定了RGB颜色空间，那么四个数组元素表示一个颜色（red、green、blue、alpha），
     如果有三个颜色则这个数组有4*3个元素
     locations:颜色所在位置（范围0~1），这个数组的个数不小于components中存放颜色的个数
     count:渐变个数，等于locations的个数
     */
    CGFloat compoents[12]={
        248.0/255.0,86.0/255.0,86.0/255.0,1,
        249.0/255.0,127.0/255.0,127.0/255.0,1,
        1.0,1.0,1.0,1.0
    };
     CGFloat locations[3]={0,0.3,1.0};
    
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, compoents, locations, 3);
    
    /*绘制线性渐变
     context:图形上下文
     gradient:渐变色
     startPoint:起始位置
     endPoint:终止位置
     options:绘制方式,kCGGradientDrawsBeforeStartLocation 开始位置之前就进行绘制，到结束位置之后不再绘制，
     kCGGradientDrawsAfterEndLocation开始位置之前不进行绘制，到结束点之后继续填充
     */
    CGContextDrawLinearGradient(context, gradient, CGPointZero, CGPointMake(320, 300), kCGGradientDrawsAfterEndLocation);
    //释放颜色空间
    CGColorSpaceRelease(colorSpace);
}

#pragma mark 径向渐变
-(void)drawRadialGradient:(CGContextRef)context{
    //使用rgb颜色空间
    CGColorSpaceRef colorSpace=CGColorSpaceCreateDeviceRGB();
    
    /*指定渐变色
     space:颜色空间
     components:颜色数组,注意由于指定了RGB颜色空间，那么四个数组元素表示一个颜色（red、green、blue、alpha），
     如果有三个颜色则这个数组有4*3个元素
     locations:颜色所在位置（范围0~1），这个数组的个数不小于components中存放颜色的个数
     count:渐变个数，等于locations的个数
     */
    CGFloat compoents[12]={
        248.0/255.0,86.0/255.0,86.0/255.0,1,
        249.0/255.0,127.0/255.0,127.0/255.0,1,
        1.0,1.0,1.0,1.0
    };
    CGFloat locations[3]={0,0.3,1.0};
    CGGradientRef gradient= CGGradientCreateWithColorComponents(colorSpace, compoents, locations, 3);
    
    /*绘制径向渐变
     context:图形上下文
     gradient:渐变色
     startCenter:起始点位置
     startRadius:起始半径（通常为0，否则在此半径范围内容无任何填充）
     endCenter:终点位置（通常和起始点相同，否则会有偏移）
     endRadius:终点半径（也就是渐变的扩散长度）
     options:绘制方式,kCGGradientDrawsBeforeStartLocation 开始位置之前就进行绘制，但是到结束位置之后不再绘制，
     kCGGradientDrawsAfterEndLocation开始位置之前不进行绘制，但到结束点之后继续填充
     */
    CGContextDrawRadialGradient(context, gradient, CGPointMake(160, 284),0, CGPointMake(165, 289), 150, kCGGradientDrawsAfterEndLocation);
    //释放颜色空间
    CGColorSpaceRelease(colorSpace);
}

/* 区域裁切并不仅仅适用于渐变填充，对于其他图形绘制仍然适用，并且注意裁切只能限于矩形裁切 */
-(void)drawRectWithLinearGradientFill:(CGContextRef)context{
    CGColorSpaceRef colorSpace=CGColorSpaceCreateDeviceRGB();
    
    //裁切处一块矩形用于显示，注意必须先裁切再调用渐变
    //CGContextClipToRect(context, CGRectMake(20, 50, 280, 300));
    //裁切还可以使用UIKit中对应的方法
    UIRectClip(CGRectMake(20, 100, 200, 200));
    
    CGFloat compoents[12]={
        248.0/255.0,86.0/255.0,86.0/255.0,1,
        249.0/255.0,127.0/255.0,127.0/255.0,1,
        1.0,1.0,1.0,1.0
    };
    CGFloat locations[3]={0,0.3,1.0};
    CGGradientRef gradient= CGGradientCreateWithColorComponents(colorSpace, compoents, locations, 3);
    
    CGContextDrawLinearGradient(context, gradient, CGPointMake(20, 50), CGPointMake(300, 300), kCGGradientDrawsAfterEndLocation);
    
    
    //释放颜色空间
    CGColorSpaceRelease(colorSpace);
}

#pragma mark - 有颜色填充模式
void drawColoredTile(void *info,CGContextRef context){
    //有颜色填充，这里设置填充色
    CGContextSetRGBFillColor(context, 254.0/255.0, 52.0/255.0, 90.0/255.0, 1);
    CGContextFillRect(context, CGRectMake(0, 0, TILE_SIZE, TILE_SIZE));
    CGContextFillRect(context, CGRectMake(TILE_SIZE, TILE_SIZE, TILE_SIZE, TILE_SIZE));
}
-(void)drawBackgroundWithColoredPattern:(CGContextRef)context{
    //设备无关的颜色空间
    //    CGColorSpaceRef rgbSpace= CGColorSpaceCreateDeviceRGB();
    //模式填充颜色空间,注意对于有颜色填充模式，这里传NULL
    CGColorSpaceRef colorSpace=CGColorSpaceCreatePattern(NULL);
    //将填充色颜色空间设置为模式填充的颜色空间
    CGContextSetFillColorSpace(context, colorSpace);
    
    //填充模式回调函数结构体
    CGPatternCallbacks callback={0,&drawColoredTile,NULL};
    /*填充模式
     info://传递给callback的参数
     bounds:瓷砖大小
     matrix:形变
     xStep:瓷砖横向间距
     yStep:瓷砖纵向间距
     tiling:贴砖的方法
     isClored:绘制的瓷砖是否已经指定了颜色(对于有颜色瓷砖此处指定位true)
     callbacks:回调函数
     */
    CGPatternRef pattern=CGPatternCreate(NULL, CGRectMake(0, 0, 2*TILE_SIZE, 2*TILE_SIZE), CGAffineTransformIdentity,2*TILE_SIZE+ 5,2*TILE_SIZE+ 5, kCGPatternTilingNoDistortion, true, &callback);
    
    CGFloat alpha=1;
    //注意最后一个参数对于有颜色瓷砖指定为透明度的参数地址，对于无颜色瓷砖则指定当前颜色空间对应的颜色数组
    CGContextSetFillPattern(context, pattern, &alpha);
    
    UIRectFill(CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
    
    //    CGColorSpaceRelease(rgbSpace);
    CGColorSpaceRelease(colorSpace);
    CGPatternRelease(pattern);
}


@end
