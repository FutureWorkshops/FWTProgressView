//
//  ViewController.m
//  FWTProgressView_Test
//
//  Created by Marco Meschini on 06/09/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import "ViewController.h"
#import "FWTProgressView.h"
#import "UIImage+Sample.h"

@interface TableViewCell : UITableViewCell
@property (nonatomic, retain) FWTProgressView *progressView;
@end

@implementation TableViewCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!self.progressView.superview)
        [self.contentView addSubview:self.progressView];
    
    CGRect pvFrame = CGRectInset(self.bounds, 20.0f, .0f);
    pvFrame.origin.y += (CGRectGetHeight(self.bounds)-CGRectGetHeight(self.progressView.frame))*.5f;
    pvFrame.size.height = CGRectGetHeight(self.progressView.frame);
    self.progressView.frame = pvFrame;
}

@end

@interface ViewController ()
{
    FWTProgressView *test;
    NSArray *_array;
    CGFloat _progress;
    UISlider *_slider;
}
@property (nonatomic, retain) NSArray *array;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, retain) UISlider *slider;
@end

@implementation ViewController

- (void)dealloc
{
    self.array = nil;
    self.slider = nil;
    [super dealloc];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.title = @"Progress view";
    }
    
    return self;
}

NSString *const kDefault = @"kDefault";
NSString *const kPattern = @"kPattern";
NSString *const kSlider  = @"kSlider";
NSString *const kBorder  = @"kBorder";
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [[UIColor blackColor] colorWithAlphaComponent:.5f];
    self.tableView.tableFooterView = [[[UIView alloc] init] autorelease];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.slider)
    {
        self.slider = [[[UISlider alloc] initWithFrame:CGRectMake(0, 0, 300, 30)] autorelease];
        self.slider.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin;
        self.slider.center = CGPointMake(CGRectGetMidX(self.navigationController.toolbar.bounds), CGRectGetMidY(self.navigationController.toolbar.bounds));
        self.slider.minimumValue = .0f;
        self.slider.maximumValue = 1.0f;
        [self.slider addTarget:self action:@selector(sliderValueDidChange:) forControlEvents:UIControlEventValueChanged];
        [self.navigationController.toolbar addSubview:self.slider];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)sliderValueDidChange:(UISlider *)slider
{
    self.progress = slider.value;
    [self.tableView reloadData];
}

#pragma mark - Getters
- (NSArray *)array
{
    if (!self->_array)
    {
        self->_array =
        [@[
        @{},
        @{kPattern : [UIImage warning_patternImage]},
        @{kPattern : [UIImage barberShop_patternImage], kSlider : [UIImage barberShop_sliderImage], kBorder : [UIImage barberShop_borderImage]},
        @{kPattern : [UIImage blueGradient_patternImage]},
        @{kPattern : [UIImage iLikeTheWaves_patternImage]},
        ] retain];
    }
    
    return self->_array;
}

#pragma mark - Table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    TableViewCell *cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    
        NSDictionary *dictionary = [self.array objectAtIndex:indexPath.row];
        id pattern = [dictionary valueForKey:kPattern];
        id slider  = [dictionary valueForKey:kSlider];
        id border  = [dictionary valueForKey:kBorder];
        FWTProgressView *progressView = [[[FWTProgressView alloc] initWithPatternImage:pattern ? pattern : nil
                                                                           sliderImage:slider ? slider : nil
                                                                           borderImage:border ? border : nil] autorelease];
        cell.progressView = progressView;
    }
            
    cell.progressView.progress = self.slider.value;
    
    return cell;
}

@end
