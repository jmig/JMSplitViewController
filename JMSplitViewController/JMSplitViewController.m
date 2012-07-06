//
//  JMSplitViewController.m
//
//  Created by Jérôme Miglino on 7/3/12.
//
//  This code is based on the awesome MGSplitViewController of Matt Gemmell http://mattgemmell.com/
//
//  Copyright (c) 2012, Jerome Miglino
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.

#import "JMSplitViewController.h"

#define kDefaultMasterViewWidthPortrait             200.0
#define kDefaultMasterViewWidthLandscape            320.0
#define kDefaultDividerColor                        [UIColor blackColor]
#define kDividerStyleThinWidth                      1.0

@interface JMSplitViewController ()

@end

@implementation JMSplitViewController

@synthesize masterViewController = _masterViewController;
@synthesize detailViewController = _detailViewController;
@synthesize showMasterViewInLandscape = _showMasterViewInLandscape;
@synthesize showMasterViewInPortrait = _showMasterViewInPortrait;
@synthesize dividerStyle = _dividerStyle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    //Configure the default behavior
    _masterViewWidthInPortrait = kDefaultMasterViewWidthPortrait;
    _masterViewWidthInLandscape = kDefaultMasterViewWidthLandscape;
    _showMasterViewInPortrait = YES;
    _showMasterViewInLandscape = YES;
    _dividerStyle = JMSplitViewDividerStyleNone;
    _dividerView = [[UIView alloc] init];
    [_dividerView setBackgroundColor:kDefaultDividerColor];
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	if ([self isShowingMaster]) {
		[self.masterViewController viewWillAppear:animated];
	}
	[self.detailViewController viewWillAppear:animated];
	
	[self layoutSubviewsWithAnimation:NO];
}


- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	if ([self isShowingMaster]) {
		[self.masterViewController viewDidAppear:animated];
	}
	[self.detailViewController viewDidAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	if ([self isShowingMaster]) {
		[self.masterViewController viewWillDisappear:animated];
	}
	[self.detailViewController viewWillDisappear:animated];
}


- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	
	if ([self isShowingMaster]) {
		[self.masterViewController viewDidDisappear:animated];
	}
	[self.detailViewController viewDidDisappear:animated];
}


#pragma mark - Rotation Handling

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    [[self masterViewController] willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [[self detailViewController] willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    [self layoutSubviewsForInterfaceOrientation:toInterfaceOrientation withAnimation:NO];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [[self masterViewController] willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [[self detailViewController] willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [[self masterViewController] didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [[self detailViewController] didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}


#pragma mark - Orientation Methods

- (BOOL)isLandscape
{
    return UIInterfaceOrientationIsLandscape(self.interfaceOrientation);
}

- (BOOL)shouldShowMasterForInterfaceOrientation:(UIInterfaceOrientation)theOrientation
{
	return ((UIInterfaceOrientationIsLandscape(theOrientation)) ? _showMasterViewInLandscape : _showMasterViewInPortrait);
}

- (BOOL)shouldShowMaster
{
	return [self shouldShowMasterForInterfaceOrientation:self.interfaceOrientation];
}

- (BOOL)isShowingMaster
{
	return [self shouldShowMaster] && self.masterViewController && self.masterViewController.view && ([self.masterViewController.view superview] == self.view);
}

#pragma mark - Layout

- (void)layoutSubviewsWithAnimation:(BOOL)animated
{
	[self layoutSubviewsForInterfaceOrientation:self.interfaceOrientation withAnimation:animated];
}

- (void)layoutSubviews
{
    [self layoutSubviewsForInterfaceOrientation:self.interfaceOrientation withAnimation:YES];
}

- (void)layoutSubviewsForInterfaceOrientation:(UIInterfaceOrientation)theOrientation withAnimation:(BOOL)animated
{
	float width = self.view.bounds.size.width;
	float height = self.view.bounds.size.height;
    
    CGPoint origin = CGPointMake(0, 0);

    if (animated) {
        [UIView beginAnimations:@"layoutSubviewsAnimation" context:nil];
    }
    
    //Set the masterView frame if needed
    if ([self shouldShowMasterForInterfaceOrientation:theOrientation]) {

        CGFloat masterViewWidth = UIInterfaceOrientationIsLandscape(theOrientation) ? _masterViewWidthInLandscape : _masterViewWidthInPortrait;
        [_masterViewController.view setFrame:CGRectMake(origin.x, origin.y, masterViewWidth, height)];
        origin.x += masterViewWidth;
        
        if (!_masterViewController.view.superview) {
            [_masterViewController viewWillAppear:NO];
            [self.view insertSubview:_masterViewController.view atIndex:0];
            [_masterViewController viewDidAppear:NO];
        }
        
        //Set the Divider if needed
        CGFloat dividerWidth;
        switch (_dividerStyle) {
            case JMSplitViewDividerStyleThin:
                dividerWidth = kDividerStyleThinWidth;
                break;
            case JMSplitViewDividerStyleNone:
                dividerWidth = 0.0;
                break;
            default:
                dividerWidth = 0.0;
                break;
        }
        [_dividerView setFrame:CGRectMake(origin.x, origin.y, dividerWidth, height)];
        origin.x += dividerWidth;
        
        if (!_dividerView.superview) {
            [self.view addSubview:_dividerView];
        }
        
    }
    else {
        //Don't forget to remove the masterView and DividerView
        if (_masterViewController.view.superview) {            
            [_masterViewController.view removeFromSuperview];
        }
        if (_dividerView.superview) {            
            [_dividerView removeFromSuperview];
        }
    }

    //Set the remaining space for the DetailView
    [_detailViewController.view setFrame:CGRectMake(origin.x, origin.y, width-origin.x, height)];
    if (!_detailViewController.view.superview) {
        [_detailViewController viewWillAppear:NO];
        [self.view addSubview:_detailViewController.view];
        [_detailViewController viewDidAppear:NO];
    }
    
    if (animated) {
        [UIView commitAnimations];
    }
}

#pragma mark - Accessors

- (void)setMasterViewWidth:(CGFloat)width forOrientation:(UIInterfaceOrientation)theOrientation;
{
    if (UIInterfaceOrientationIsLandscape(theOrientation)) {
        _masterViewWidthInLandscape = width;
    }
    else {
        _masterViewWidthInPortrait = width;
    }
    //We change the width so we need to update the layout.
    [self layoutSubviews];
}

- (void)setShowMasterViewInLandscape:(BOOL)showMasterViewInLandscape
{
    _showMasterViewInLandscape = showMasterViewInLandscape;
    [self layoutSubviews];
}

- (void)setShowMasterViewInPortrait:(BOOL)showMasterViewInPortrait
{
    _showMasterViewInPortrait = showMasterViewInPortrait;
    [self layoutSubviews];
}

@end
