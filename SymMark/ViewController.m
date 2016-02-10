//
//  ViewController.m
//  SymMark
//
//  Created by Yupeng Gu on 2/4/16.
//  Copyright © 2016 Yupeng. All rights reserved.
//

#import "ViewController.h"

#define bmpHeight 2555.0/2.0

@interface ViewController ()

@end

@implementation ViewController
@synthesize tempDrawImage;
@synthesize mainImage;
@synthesize points;

static NSValue* valueToStore;
static CGPoint readCGPoint;

- (void)viewDidLoad {
    red = 255.0/255.0;
    green = 0.0/255.0;
    blue = 0.0/255.0;
    brush = 2.0;
    opacity = 0.7;
    points = [NSMutableArray new];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshMarks{
    UIGraphicsBeginImageContext(self.mainImage.frame.size);
    CGContextClearRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height));
    
    for (int i = 0; i< points.count/2; i++){
        CGPoint a,b;
        readCGPoint = [[points objectAtIndex:i*2] CGPointValue];
        a = readCGPoint;
        readCGPoint = [[points objectAtIndex:(i*2+1)] CGPointValue];
        b = readCGPoint;
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), a.x, a.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), b.x, b.y);
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush );
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, opacity);
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
        
        CGContextStrokePath(UIGraphicsGetCurrentContext());
    }
    
    self.mainImage.image = UIGraphicsGetImageFromCurrentImageContext();
    self.tempDrawImage.image = nil;
    UIGraphicsEndImageContext();
}

- (IBAction)undo:(id)sender {
    [points removeLastObject];
    [points removeLastObject];
    [self refreshMarks];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    mouseSwiped = NO;
    UITouch *touch = [touches anyObject];
    lastPoint = [touch locationInView:self.view];
    startPoint = lastPoint;
    //NSLog(@"LPx = %f, LPy =  %f",lastPoint.x,lastPoint.y);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    mouseSwiped = YES;
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.view];
    //NSLog(@"CPx = %f, CPy =  %f",currentPoint.x,currentPoint.y);
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    CGContextClearRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height));
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), startPoint.x, startPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush );
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, opacity);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    [self.tempDrawImage setAlpha:opacity];
    UIGraphicsEndImageContext();
    
    lastPoint = currentPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(!mouseSwiped) {
        UIGraphicsBeginImageContext(self.view.frame.size);
        [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, opacity);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    valueToStore = [NSValue valueWithCGPoint:startPoint];
    [points addObject:valueToStore];
    valueToStore = [NSValue valueWithCGPoint:lastPoint];
    [points addObject:valueToStore];
    
    UIGraphicsBeginImageContext(self.mainImage.frame.size);
    CGContextClearRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height));
    
    for (int i = 0; i< points.count/2; i++){
        CGPoint a,b;
        readCGPoint = [[points objectAtIndex:i*2] CGPointValue];
        a = readCGPoint;
        readCGPoint = [[points objectAtIndex:(i*2+1)] CGPointValue];
        b = readCGPoint;
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), a.x, a.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), b.x, b.y);
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush );
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, opacity);
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
        
        CGContextStrokePath(UIGraphicsGetCurrentContext());
    }
    
    self.mainImage.image = UIGraphicsGetImageFromCurrentImageContext();
    self.tempDrawImage.image = nil;
    UIGraphicsEndImageContext();
}

- (IBAction)writePoints:(id)sender {
    float bmpRef = self.view.frame.size.height;
    NSString *applicationDocumentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //NSString *storePath = [applicationDocumentsDir stringByAppendingPathComponent:@"points.txt"];
    NSString *storePath = @"/Users/yupeng/Documents/points.txt";
    NSMutableString *pointsString;
    pointsString = [NSMutableString new];
//    for (int i = 0;i<points.count;i++){
//        readCGPoint = [[points objectAtIndex:i] CGPointValue];
//        [pointsString appendString:[NSString stringWithFormat:@"%f\t%f\n",readCGPoint.x/bmpRef,readCGPoint.y/bmpRef]];
//    }
    
    for (int i = 0; i< points.count/2; i++){
        CGPoint a,b;
        readCGPoint = [[points objectAtIndex:i*2] CGPointValue];
        a = readCGPoint;
        readCGPoint = [[points objectAtIndex:(i*2+1)] CGPointValue];
        b = readCGPoint;
        if (fabs(a.x-b.x)<fabs(a.y-b.y)){
            [pointsString appendString:@"stem\t"];
            if (a.y>b.y){
                [pointsString appendString:@"0\t"];
            }else{
                [pointsString appendString:@"1\t"];
            }
            [pointsString appendString:@"1\t"];
            [pointsString appendString:[NSString stringWithFormat:@"%d\t%d\n",(int)(a.x/bmpRef*bmpHeight+0.5),(int)(a.y/bmpRef*bmpHeight+0.5)]];
        }else{
            [pointsString appendString:@"beam\t"];
            if (a.x>b.x){
                [pointsString appendString:@"1\t2\t"];
                [pointsString appendString:[NSString stringWithFormat:@"%d\t%d\t%d\t%d\n",(int)(b.x/bmpRef*bmpHeight+0.5),(int)(b.y/bmpRef*bmpHeight+0.5),(int)(a.x/bmpRef*bmpHeight+0.5),(int)(a.y/bmpRef*bmpHeight+0.5)]];
            }else{
                [pointsString appendString:@"0\t2\t"];
                [pointsString appendString:[NSString stringWithFormat:@"%d\t%d\t%d\t%d\n",(int)(a.x/bmpRef*bmpHeight+0.5),(int)(a.y/bmpRef*bmpHeight+0.5),(int)(b.x/bmpRef*bmpHeight+0.5),(int)(b.y/bmpRef*bmpHeight+0.5)]];
            }
        }
    }

    BOOL success = [pointsString writeToFile:storePath atomically:YES encoding:NSUnicodeStringEncoding error:nil];
    NSLog(@"%d",success);
}


@end
