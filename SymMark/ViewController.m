//
//  ViewController.m
//  SymMark
//
//  Created by Yupeng Gu on 2/4/16.
//  Copyright © 2016 Yupeng. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+MMAdditions.h"



@interface ViewController ()

@end

@implementation ViewController
@synthesize backgroundImage;
@synthesize tempDrawImage;
@synthesize mainImage;
@synthesize points;

static NSValue* valueToStore;
static CGPoint readCGPoint;
static int flag;
static int currentCheckPage;

- (void)viewDidLoad {
    red = 255.0/255.0;
    green = 0.0/255.0;
    blue = 0.0/255.0;
    brush = 2.0;
    opacity = 0.7;
    flag = 0;
    points = [NSMutableArray new];
    checkImageView = [UIImageView new];
    checkImageView.frame = CGRectMake(0, 600, 768, 204.5);
    imageName = @"LeetoniaAltoSax.jpg";
    
    [backgroundImage setImage:[UIImage imageNamed:imageName]];
    
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
    flag = 0;
    for (int i = 0; i< points.count/2; i++){
        CGPoint a,b;
        readCGPoint = [[points objectAtIndex:i*2] CGPointValue];
        a = readCGPoint;
        readCGPoint = [[points objectAtIndex:(i*2+1)] CGPointValue];
        b = readCGPoint;
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), a.x, a.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), b.x, b.y);
        
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), b.x, a.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), a.x, a.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), a.x, b.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), b.x, b.y);
        
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush );
        if (flag == 0){
            CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, opacity);
        }else{
            CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1-red, green, 1-blue, opacity);
        }
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
        
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        flag = 1-flag;
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

- (IBAction)checkImage:(id)sender {
//    NSArray<NSString*>* scoreIndexContent = [[scoreArray objectAtIndex:moduleIndex] componentsSeparatedByString:@"\t"];
//    NSString *imgName = [[MMArrangement sharedInstance].sampleKey stringByAppendingString:[NSString stringWithFormat:@"%d.jpg",scoreIndexContent[0].intValue]];
    NSMutableString *outputString = [NSMutableString new];
    NSString *storePath = @"/Users/yupeng/Documents/points.txt";

    NSArray<NSString*> *pointStringArray = [pointsString componentsSeparatedByString:@"\n"];
    for(int i =0; i< (int)(points.count/4);i++){
        checkImageString = [NSMutableString stringWithFormat:@"1\t"];
        [checkImageString appendString:pointStringArray[i*4]];
        [checkImageString appendString:@"\t"];
        [checkImageString appendString:pointStringArray[i*4+1]];
        [checkImageString appendString:@"\t"];
        [checkImageString appendString:pointStringArray[i*4+2]];
        [checkImageString appendString:@"\t"];
        [checkImageString appendString:pointStringArray[i*4+3]];
        [outputString appendString:checkImageString];
        [outputString appendString:@"\n"];
    }
    BOOL success = [outputString writeToFile:storePath atomically:YES encoding:NSUnicodeStringEncoding error:nil];
    NSLog(@"%d",success);

    
    NSArray<NSString*> *scoreIndexContent = [checkImageString componentsSeparatedByString:@"\t"];
    
    NSArray *axisArray = @[[NSValue valueWithCGPoint:CGPointMake(scoreIndexContent[1].intValue,scoreIndexContent[2].intValue)],
                           [NSValue valueWithCGPoint:CGPointMake(scoreIndexContent[3].intValue,scoreIndexContent[4].intValue)],
                           [NSValue valueWithCGPoint:CGPointMake(scoreIndexContent[5].intValue,scoreIndexContent[6].intValue)],
                           [NSValue valueWithCGPoint:CGPointMake(scoreIndexContent[7].intValue,scoreIndexContent[8].intValue)]];
    checkImageView.image =[[UIImage imageNamed:imageName] processedImage:axisArray];
    [self.view addSubview:checkImageView];
}

- (IBAction)checkImageInFile:(id)sender {
    //    NSArray<NSString*>* scoreIndexContent = [[scoreArray objectAtIndex:moduleIndex] componentsSeparatedByString:@"\t"];
    //    NSString *imgName = [[MMArrangement sharedInstance].sampleKey stringByAppendingString:[NSString stringWithFormat:@"%d.jpg",scoreIndexContent[0].intValue]];
    NSMutableString *outputString = [NSMutableString new];
    NSString *storePath = @"/Users/yupeng/Documents/points.txt";
    NSString *rPath = @"/Users/yupeng/Documents/rpoints.txt";
    
    NSArray<NSString*> *pointStringArray = [pointsString componentsSeparatedByString:@"\n"];
    for(int i =0; i< (int)(points.count/4);i++){
        checkImageString = [NSMutableString stringWithFormat:@"1\t"];
        [checkImageString appendString:pointStringArray[i*4]];
        [checkImageString appendString:@"\t"];
        [checkImageString appendString:pointStringArray[i*4+1]];
        [checkImageString appendString:@"\t"];
        [checkImageString appendString:pointStringArray[i*4+2]];
        [checkImageString appendString:@"\t"];
        [checkImageString appendString:pointStringArray[i*4+3]];
        [outputString appendString:checkImageString];
        [outputString appendString:@"\n"];
    }
    if ([outputString length]>1){
        [outputString deleteCharactersInRange:NSMakeRange([outputString length]-1, 1)];
    }
    BOOL success = [outputString writeToFile:storePath atomically:YES encoding:NSUnicodeStringEncoding error:nil];
    NSLog(@"%d",success);

    NSString *txtFile = [NSString stringWithContentsOfFile:rPath encoding:NSUTF8StringEncoding error:nil];
    NSArray *imgArray = [txtFile componentsSeparatedByString:@"\n"];
    
    NSArray<NSString*> *scoreIndexContent = [[imgArray objectAtIndex:(currentCheckPage++)%imgArray.count] componentsSeparatedByString:@"\t"];
    
    NSArray *axisArray = @[[NSValue valueWithCGPoint:CGPointMake(scoreIndexContent[1].intValue,scoreIndexContent[2].intValue)],
                           [NSValue valueWithCGPoint:CGPointMake(scoreIndexContent[3].intValue,scoreIndexContent[4].intValue)],
                           [NSValue valueWithCGPoint:CGPointMake(scoreIndexContent[5].intValue,scoreIndexContent[6].intValue)],
                           [NSValue valueWithCGPoint:CGPointMake(scoreIndexContent[7].intValue,scoreIndexContent[8].intValue)]];
    checkImageView.image =[[UIImage imageNamed:imageName] processedImage:axisArray];
    [self.view addSubview:checkImageView];
}

- (IBAction)removeCheck:(id)sender {
    [checkImageView removeFromSuperview];
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

    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, startPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), startPoint.x, startPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), startPoint.x, currentPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);

    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush );
    if (flag == 0){
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, opacity);
    }else{
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1-red, green, 1-blue, opacity);
    }
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

    [self refreshMarks];
}

- (IBAction)writePoints:(id)sender {
    UIImage *image = [UIImage imageNamed:imageName];
    NSLog(@"%f, %f",image.size.height,image.size.width);
    float bmpHeight = image.size.height/2.0;
    float bmpWidth = image.size.width/2.0;
    float frameWidth = self.view.frame.size.width;
    float frameHeight = self.view.frame.size.height;
    float scale = bmpWidth/self.view.frame.size.width;
    yOffset = (frameHeight - frameWidth*bmpHeight/bmpWidth)/2.0;
    xOffset = 0;
    if (bmpHeight/bmpWidth>4.0/3.0){
        scale = bmpHeight/self.view.frame.size.height;
        xOffset = (frameWidth - frameHeight*bmpWidth/bmpHeight)/2.0;
        yOffset = 0;
    }
    NSString *applicationDocumentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //NSString *storePath = [applicationDocumentsDir stringByAppendingPathComponent:@"points.txt"];
//    NSString *storePath = @"/Users/yupeng/Documents/points.txt";
    pointsString = [NSMutableString new];
    for (int i = 0;i<points.count;i++){
        readCGPoint = [[points objectAtIndex:i] CGPointValue];
        int x,y;
        y = (int)((readCGPoint.y-yOffset)*scale+0.5);
        x = (int)((readCGPoint.x-xOffset)*scale+0.5);
        [pointsString appendString:[NSString stringWithFormat:@"%d\t%d\n",x*2,y*2]];
    }
    
//    for (int i = 0; i< points.count/2; i++){
//        CGPoint a,b;
//        readCGPoint = [[points objectAtIndex:i*2] CGPointValue];
//        a = readCGPoint;
//        readCGPoint = [[points objectAtIndex:(i*2+1)] CGPointValue];
//        b = readCGPoint;
//        int by,bx,ay,ax;
//        by = (int)((b.y-yOffset)*scale+0.5);
//        bx = (int)((b.x-xOffset)*scale+0.5);
//        ay = (int)((a.y-yOffset)*scale+0.5);
//        ax = (int)((a.x-xOffset)*scale+0.5);
//        if (fabs(a.x-b.x)<fabs(a.y-b.y)){
//            [pointsString appendString:@"stem\t"];
//            if (a.y>b.y){
//                [pointsString appendString:@"1\t"];
//            }else{
//                [pointsString appendString:@"0\t"];
//            }
//            [pointsString appendString:@"1\t"];
//            [pointsString appendString:[NSString stringWithFormat:@"%d\t%d\n",ay,ax]];
//        }else{
//            [pointsString appendString:@"beam\t"];
//            if (a.x>b.x){
//                [pointsString appendString:@"1\t2\t"];
//                [pointsString appendString:[NSString stringWithFormat:@"%d\t%d\t%d\t%d\n",by,bx,ay,ax]];
//            }else{
//                [pointsString appendString:@"0\t2\t"];
//                [pointsString appendString:[NSString stringWithFormat:@"%d\t%d\t%d\t%d\n",ay,ax,by,bx]];
//            }
//        }
//    }

//    BOOL success = [pointsString writeToFile:storePath atomically:YES encoding:NSUnicodeStringEncoding error:nil];
//    NSLog(@"%d",success);
}


@end
