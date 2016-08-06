//
//  UIImage+MMAdditions.m
//  Wind
//
//  Created by Hawk on 5/10/16.
//  Copyright © 2016 Yushen Han. All rights reserved.
//

#import "UIImage+MMAdditions.h"

@implementation UIImage (MMAdditions)

- (UIImage *)processedImage:(NSArray<NSValue *> *)points
{
    if (points.count == 4)
    {
        CGPoint pt1 = [points[0] CGPointValue];
        CGPoint pt2 = [points[1] CGPointValue];
        CGPoint pt3 = [points[2] CGPointValue];
        CGPoint pt4 = [points[3] CGPointValue];
        
        const CGFloat alpha = 0.1f;
        CGColorRef color = [UIColor whiteColor].CGColor;
        
        CGSize size = CGSizeMake(pt2.x - pt1.x, pt2.y - pt1.y);
        UIGraphicsBeginImageContextWithOptions(size, YES, 0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGRect rect1 = CGRectMake(pt1.x, pt1.y, size.width, size.height);
        UIImage *image1 = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([self CGImage], rect1)];
        [image1 drawAtPoint:CGPointZero blendMode:kCGBlendModeNormal alpha:1];
        
        CGContextSetFillColorWithColor(context, color);
        //CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 50.0, color);
        
        CGRect rect2 = CGRectMake(pt1.x, pt1.y, pt3.x - pt1.x, pt3.y - pt1.y);
        UIImage *image2 = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([self CGImage], rect2)];
        CGContextFillRect(context, CGRectMake(0, 0, rect2.size.width, rect2.size.height));
        [image2 drawAtPoint:CGPointZero blendMode:kCGBlendModeNormal alpha:alpha];
        
        CGRect rect3 = CGRectMake(pt4.x, pt4.y, pt2.x - pt4.x, pt2.y - pt4.y);
        UIImage *image3 = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([self CGImage], rect3)];
        CGContextFillRect(context, CGRectMake(rect3.origin.x - rect1.origin.x, rect3.origin.y - rect1.origin.y, rect3.size.width, rect3.size.height));
        [image3 drawAtPoint:CGPointMake(rect3.origin.x - rect1.origin.x, rect3.origin.y - rect1.origin.y) blendMode:kCGBlendModeNormal alpha:alpha];

        if (pt4.y < pt3.y){
            CGRect rect4 = CGRectMake(0, pt3.y, pt2.x, pt2.y - pt3.y);
            UIImage *image4 = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([self CGImage], rect4)];
            CGContextFillRect(context, CGRectMake(rect4.origin.x - rect1.origin.x, rect4.origin.y - rect1.origin.y, rect4.size.width, rect4.size.height));
            [image4 drawAtPoint:CGPointMake(rect4.origin.x - rect1.origin.x, rect4.origin.y - rect1.origin.y) blendMode:kCGBlendModeNormal alpha:alpha];
            
            CGRect rect5 = CGRectMake(0, 0, pt2.x, pt4.y);
            UIImage *image5 = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([self CGImage], rect5)];
            CGContextFillRect(context, CGRectMake(rect5.origin.x - rect1.origin.x, rect5.origin.y - rect1.origin.y, rect5.size.width, rect5.size.height));
            [image5 drawAtPoint:CGPointMake(rect5.origin.x - rect1.origin.x, rect5.origin.y - rect1.origin.y) blendMode:kCGBlendModeNormal alpha:alpha];
        }

        UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return result;
    }
    
    return nil;
}

@end