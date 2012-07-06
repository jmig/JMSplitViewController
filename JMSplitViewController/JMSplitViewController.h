//
//  JMSplitViewController.h
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


#import <UIKit/UIKit.h>

typedef enum _JMSplitViewDividerStyle {
	JMSplitViewDividerStyleNone			= 0, // No Divider between the 2 views.
	JMSplitViewDividerStyleThin         = 1  // Thin divider, like UISplitViewController (default).
} JMSplitViewDividerStyle;

@interface JMSplitViewController : UIViewController {
    UIViewController *_masterViewController;
    UIViewController *_detailViewController;
    
    CGFloat _masterViewWidthInPortrait;
    CGFloat _masterViewWidthInLandscape;
    
    BOOL _showMasterViewInPortrait;
    BOOL _showMasterViewInLandscape;
    
    UIView *_dividerView;
    JMSplitViewDividerStyle _dividerStyle;
}

@property (strong, nonatomic) UIViewController *masterViewController;
@property (strong, nonatomic) UIViewController *detailViewController;

@property (assign, nonatomic) BOOL showMasterViewInPortrait;
@property (assign, nonatomic) BOOL showMasterViewInLandscape;

@property (assign, nonatomic) JMSplitViewDividerStyle dividerStyle;

- (void)setMasterViewWidth:(CGFloat)width forOrientation:(UIInterfaceOrientation)theOrientation;

@end
