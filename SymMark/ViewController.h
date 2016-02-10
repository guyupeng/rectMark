//
//  ViewController.h
//  SymMark
//
//  Created by Yupeng Gu on 2/4/16.
//  Copyright © 2016 Yupeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController{
    CGPoint lastPoint;
    CGPoint startPoint;
    CGPoint endPoint;
    CGPoint midPoint;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat brush;
    CGFloat opacity;
    BOOL mouseSwiped;
}
@property (strong, nonatomic) IBOutlet UIImageView *mainImage;
@property (strong, nonatomic) IBOutlet UIImageView *tempDrawImage;
@property (strong, nonatomic) NSMutableArray* points;

@end

