//
//  ViewController.m
//  FWTProgressView_Test
//
//  Created by Marco Meschini on 06/09/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import "TableViewController.h"
#import "FWTProgressView.h"
#import "UIImage+Sample.h"

#define INSET_HORIZONTAL            20.0f
#define VARIABLE_FRAME_ENABLED      1

@interface TableViewCell : UITableViewCell
@property (nonatomic, retain) FWTProgressView *progressView;
@end

@implementation TableViewCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!self.progressView.superview)
        [self.contentView addSubview:self.progressView];
        
#if VARIABLE_FRAME_ENABLED
    //  adjust progressView width to its superview
    CGRect pvFrame = CGRectInset(self.contentView.bounds, INSET_HORIZONTAL, .0f);
    pvFrame.origin.y += (CGRectGetHeight(self.contentView.bounds)-CGRectGetHeight(self.progressView.bounds))*.5f;
    pvFrame.size.height = CGRectGetHeight(self.progressView.bounds);
    self.progressView.frame = pvFrame;
#else
    //  center progressView inside its superview
    CGRect pvFrame = self.progressView.frame;
    pvFrame.origin.x = (CGRectGetWidth(self.contentView.bounds)-CGRectGetWidth(self.progressView.bounds))*.5f;
    pvFrame.origin.y = (CGRectGetHeight(self.contentView.bounds)-CGRectGetHeight(self.progressView.bounds))*.5f;
    self.progressView.frame = pvFrame;
#endif
}

@end

@interface TableViewController ()
{
    FWTProgressView *test;
    NSArray *_array;
    UISlider *_slider;
}
@property (nonatomic, retain) NSArray *array;
@property (nonatomic, retain) UISlider *slider;
@end

@implementation TableViewController
@synthesize slider = _slider;
@synthesize array = _array;

- (void)dealloc
{
    self.array = nil;
    self.slider = nil;
    [super dealloc];
}

NSString *const kDefault = @"kDefault";
NSString *const kPattern = @"kPattern";
NSString *const kSlider  = @"kSlider";
NSString *const kBorder  = @"kBorder";
NSString *const kAnim    = @"kAnim";
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Progress view";
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor colorWithWhite:.325f alpha:1.0f];
    self.tableView.tableFooterView = [[[UIView alloc] init] autorelease];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.slider.superview)
        [self.navigationController.toolbar addSubview:self.slider];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Private
+ (FWTProgressView *)_progressViewWithDictionary:(NSDictionary *)dictionary
{
    id pattern = [dictionary valueForKey:kPattern];
    id slider  = [dictionary valueForKey:kSlider];
    id border  = [dictionary valueForKey:kBorder];
    id anim    = [dictionary valueForKey:kAnim];
    FWTProgressView *toReturn = [[[FWTProgressView alloc] initWithProgressImage:pattern ? pattern : nil
                                                                     trackImage:slider ? slider : nil
                                                                    borderImage:border ? border : nil] autorelease];

    if (anim) toReturn.animationType = [anim integerValue];

#if !VARIABLE_FRAME_ENABLED
    toReturn.frame = CGRectMake(.0f, .0f, 100.0f, CGRectGetHeight(toReturn.frame));
#endif
    
    return toReturn;
}

#pragma mark - Action
- (void)sliderValueDidChange:(UISlider *)slider
{
    [self.tableView reloadData];
}

#pragma mark - Getters
- (NSArray *)array
{
    if (!self->_array)
    {
        self->_array =
        [@[
         
         // the default one
         //
         @{},
         
         // yellow-black stripes
         //
         @{kPattern : [UIImage warning_progressImage], kAnim : [NSNumber numberWithInt:FWTProgressViewAnimationTypeFromRightToLeft]},
         
         // barber
         //
         @{kPattern : [UIImage barberShop_progressImage], kSlider : [UIImage barberShop_trackImage], kBorder : [UIImage barberShop_borderImage]},
         
         // a static gradient
         //
         @{kPattern : [UIImage blueGradient_progressImage], kAnim : [NSNumber numberWithInt:FWTProgressViewAnimationTypeNone]},
         
         // a waste of time
         //
         @{kPattern : [UIImage iLikeTheWaves_progressImage], kAnim : [NSNumber numberWithInt:FWTProgressViewAnimationTypeFromRightToLeft]},
         
        ] retain];
    }
    
    return self->_array;
}

- (UISlider *)slider
{
    if (!self->_slider)
    {
        self->_slider = [[UISlider alloc] initWithFrame:CGRectInset(self.navigationController.toolbar.bounds, INSET_HORIZONTAL, .0f)];
        self->_slider.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth;
        self->_slider.minimumValue = .0f;
        self->_slider.maximumValue = 1.0f;
        [self->_slider addTarget:self action:@selector(sliderValueDidChange:) forControlEvents:UIControlEventValueChanged];
    }
    
    return self->_slider;
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
        cell.progressView = [[self class] _progressViewWithDictionary:[self.array objectAtIndex:indexPath.row]];
    }
            
    cell.progressView.progress = self.slider.value;
    
    return cell;
}

@end
