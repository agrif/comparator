//
//  CMPSwapViewController.m
//  Comparator
//
//  Created by Aaron Griffith on 4/27/15.
//  Copyright (c) 2015 Aaron Griffith. All rights reserved.
//

#import "CMPSwapViewController.h"

@implementation CMPSwapViewController

#pragma mark setup and teardown

- (instancetype) initWithNibName: (NSString*) nibNameOrNil bundle: (NSBundle*) nibBundleOrNil
{
    if ((self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil]))
        [self setup];
    return self;
}

- (instancetype) initWithCoder: (NSCoder*) aDecoder
{
    if ((self = [super initWithCoder: aDecoder]))
        [self setup];
    return self;
}

- (void) setup
{
}

- (void) dealloc
{
    _primary = nil;
    _secondary = nil;
}

#pragma mark -
#pragma mark view controller properties

- (UIViewController*) primaryViewController
{
    return _primary;
}

- (void) setPrimaryViewController: (UIViewController*) primaryViewController
{
    if (_primary)
        [_primary.view removeFromSuperview];
    _primary = primaryViewController;
    [self layoutSubviews];
}

- (UIViewController*) secondaryViewController
{
    return _secondary;
}

- (void) setSecondaryViewController: (UIViewController*) secondaryViewController
{
    if (_secondary)
        [_secondary.view removeFromSuperview];
    _secondary = secondaryViewController;
    [self layoutSubviews];
}

- (BOOL) shouldShowSecondaryForSize: (CGSize) size
{
    if (size.width >= size.height)
        return YES;
    return NO;
}

- (BOOL) isShowingSecondary
{
    return [self shouldShowSecondaryForSize: self.view.frame.size];
}

#pragma mark -
#pragma mark rotation and animation calls

- (void) willRotateToInterfaceOrientation: (UIInterfaceOrientation) toInterfaceOrientation duration: (NSTimeInterval) duration
{
    [_primary willRotateToInterfaceOrientation: toInterfaceOrientation duration: duration];
    [_secondary willRotateToInterfaceOrientation: toInterfaceOrientation duration: duration];
}

- (void) didRotateFromInterfaceOrientation: (UIInterfaceOrientation) fromInterfaceOrientation
{
    [_primary didRotateFromInterfaceOrientation: fromInterfaceOrientation];
    [_secondary didRotateFromInterfaceOrientation: fromInterfaceOrientation];
}

- (void) willAnimateRotationToInterfaceOrientation: (UIInterfaceOrientation) toInterfaceOrientation duration: (NSTimeInterval) duration
{
    [_primary willAnimateRotationToInterfaceOrientation: toInterfaceOrientation duration: duration];
    [_secondary willAnimateRotationToInterfaceOrientation: toInterfaceOrientation duration: duration];
    
    [self layoutSubviewsAnimated: YES];
}

- (void) willAnimateFirstHalfOfRotationToInterfaceOrientation: (UIInterfaceOrientation) toInterfaceOrientation duration:(NSTimeInterval) duration
{
    [_primary willAnimateFirstHalfOfRotationToInterfaceOrientation: toInterfaceOrientation duration: duration];
    [_secondary willAnimateFirstHalfOfRotationToInterfaceOrientation: toInterfaceOrientation duration: duration];
}

- (void) didAnimateFirstHalfOfRotationToInterfaceOrientation: (UIInterfaceOrientation) toInterfaceOrientation
{
    [_primary didAnimateFirstHalfOfRotationToInterfaceOrientation: toInterfaceOrientation];
    [_secondary didAnimateFirstHalfOfRotationToInterfaceOrientation: toInterfaceOrientation];
}

- (void) willAnimateSecondHalfOfRotationFromInterfaceOrientation: (UIInterfaceOrientation) fromInterfaceOrientation duration: (NSTimeInterval) duration
{
    [_primary willAnimateFirstHalfOfRotationToInterfaceOrientation: fromInterfaceOrientation duration: duration];
    [_secondary willAnimateFirstHalfOfRotationToInterfaceOrientation: fromInterfaceOrientation duration: duration];
}

- (void) viewWillAppear: (BOOL) animated
{
    [super viewWillAppear: animated];
    [_primary viewWillAppear: animated];
    [_secondary viewWillAppear: animated];
    
    [self layoutSubviews];
}

- (void) viewDidAppear: (BOOL) animated
{
    [super viewDidAppear: animated];
    [_primary viewDidAppear: animated];
    [_secondary viewDidAppear: animated];
}

- (void) viewWillDisappear: (BOOL) animated
{
    [super viewWillDisappear: animated];
    [_primary viewWillDisappear: animated];
    [_secondary viewWillDisappear: animated];
}

- (void) viewDidDisappear: (BOOL) animated
{
    [super viewDidDisappear: animated];
    [_primary viewDidDisappear: animated];
    [_secondary viewDidDisappear: animated];
}

#pragma mark -
#pragma mark layout

- (void) layoutSubviews
{
    [self layoutSubviewsAnimated: NO];
}

- (void) layoutSubviewsAnimated: (BOOL) animated
{
    CGSize full = self.view.frame.size;
    
    CGRect primaryR, secondaryR;
    BOOL showSecondary = [self shouldShowSecondaryForSize: full];
    float secondaryStart = showSecondary ? (full.width / 2) : full.width;
    
    primaryR.origin.x = 0;
    primaryR.origin.y = 0;
    primaryR.size.width = secondaryStart;
    primaryR.size.height = full.height;
    
    secondaryR = primaryR;
    secondaryR.origin.x = secondaryStart;
    
    if (_primary)
    {
        _primary.view.frame = primaryR;
        if (!_primary.view.superview)
            [self.view addSubview: _primary.view];
    }
    
    if (_secondary)
    {
        _secondary.view.frame = secondaryR;
        if (_secondary.view.superview)
            [self.view bringSubviewToFront: _secondary.view];
        else
            [self.view addSubview: _secondary.view];
    }
}

#pragma mark -

@end
