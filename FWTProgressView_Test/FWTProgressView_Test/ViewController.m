//
//  ViewController.m
//  FWTProgressView_Test
//
//  Created by Marco Meschini on 26/10/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import "ViewController.h"
#import "FWTProgressView.h"

@interface ViewController ()
@property (nonatomic, retain) FWTProgressView *progressView;
@end

@implementation ViewController

- (void)dealloc
{
    self.progressView = nil;
    [super dealloc];
}

- (void)loadView
{
    [super loadView];
    
    //
    self.progressView = [FWTProgressView defaultProgressView];
    self.progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.progressView];
    
    //
    CGRect frame = CGRectInset(self.view.bounds, 10.0f, 10.0f);
    frame.size.height = self.progressView.frame.size.height;
    self.progressView.frame = frame;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.navigationController setToolbarHidden:NO animated:YES];
    
    UISlider *s = [[[UISlider alloc] init] autorelease];
    s.tag = 0xbeef;
    s.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [s addTarget:self action:@selector(sliderValueDidChange:) forControlEvents:UIControlEventValueChanged];
    s.frame = CGRectInset(self.navigationController.toolbar.bounds, 10, 0);
    [self.navigationController.toolbar addSubview:s];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[self.navigationController.toolbar viewWithTag:0xbeef] removeFromSuperview];
    [self.navigationController setToolbarHidden:YES animated:YES];
}

#pragma mark - Action
- (void)sliderValueDidChange:(UISlider *)slider
{
    self.progressView.progress = slider.value;
}
@end
