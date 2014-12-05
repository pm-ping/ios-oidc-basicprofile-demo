//
//  UserInfoAppView.m
//  Copyright (c) 2014 Ping Identity. All rights reserved.
//

#import "UserInfoAppView.h"

@implementation UserInfoAppView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Draw the custom background (ie the header bar)
    CGRect iPadHeaderRect = CGRectMake(0.0, 0.0, self.bounds.size.width, 55);
    CGRect iPhoneHeaderRect = CGRectMake(0.0, 0.0, self.bounds.size.width, 85);
    
    UIColor *headerColour = [UIColor colorWithRed:18.0/255.0 green:52.0/255.0 blue:66.0/255.0 alpha:1.0];
    UIColor *backgroundColourDark = [UIColor colorWithRed:50.0/255.0 green:118.0/255.0 blue:166.0/255.0 alpha:1.0];
    UIColor *backgroundColourLight = [UIColor colorWithRed:86.0/255.0 green:144.0/255.0 blue:182.0/255.0 alpha:1.0];
    
    // Paint the background gradient
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorSpaceRef colourSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGFloat gradientStartEndColourLocations[] = { 0.0, 1.0 };
    NSArray *gradientColours = @[(__bridge id)[backgroundColourDark CGColor], (__bridge id)[backgroundColourLight CGColor]];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colourSpaceRef, (__bridge CFArrayRef)gradientColours, gradientStartEndColourLocations);
    CGPoint topMiddle = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMinY(self.bounds));
    CGPoint bottomMiddle = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds));
    
    CGContextDrawLinearGradient(context, gradient, topMiddle, bottomMiddle, 0);
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        CGContextSetFillColorWithColor(context, headerColour.CGColor);
        CGContextFillRect(context, iPadHeaderRect);
        
    } else if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        CGContextSetFillColorWithColor(context, headerColour.CGColor);
        CGContextFillRect(context, iPhoneHeaderRect);
    }
    
    
}

@end
