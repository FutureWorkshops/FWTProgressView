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
#import "Factory.h"

#define RELATIVE_FRAME_ENABLED      0
#define INSET_HORIZONTAL            20.0f
#define SLIDER_HEIGHT               30.0f
#define PROGRESS_MINIMUM_WIDTH      30.0f

@interface TableViewCell : UITableViewCell
@property (nonatomic, retain) FWTProgressView *progressView;
@end

@implementation TableViewCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!self.progressView.superview)
        [self.contentView addSubview:self.progressView];
        
#if RELATIVE_FRAME_ENABLED
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

enum _SliderType
{
    SliderTypeProgress,
    SliderTypeWidth,
};
typedef NSUInteger SliderType;

@interface TableViewController ()
{
    NSArray *_dictionariesArray;
    
    NSInteger _numberOfSliders;
    NSArray *_slidersArray;
    UIView *_panelView;
    
    CGFloat _progressWidth;
    CGFloat _progressMinimumWidth, _progressMaximumWidth;
}
@property (nonatomic, retain) NSArray *dictionariesArray;
@property (nonatomic, retain) UIView *panelView;
@property (nonatomic, retain) NSArray *slidersArray;
@end

@implementation TableViewController
@synthesize slidersArray = _slidersArray;
@synthesize panelView = _panelView;

- (void)dealloc
{
    self.panelView = nil;
    self.slidersArray = nil;
    self.dictionariesArray = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Progress view";
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor colorWithWhite:.325f alpha:1.0f];
    
    //
    self.dictionariesArray = [Factory progressViewDictionariesArray];
    
    //
    _progressWidth = 113.0f;
    _progressMinimumWidth = PROGRESS_MINIMUM_WIDTH;
    
    
#if RELATIVE_FRAME_ENABLED
    _numberOfSliders = 1;
#else
    _numberOfSliders = 2;
#endif
    
    //
    CGFloat panelViewHeight = _numberOfSliders*SLIDER_HEIGHT;
    CGRect panelViewFrame = self.view.bounds;
    panelViewFrame.size.height = panelViewHeight;
    self.panelView.frame = panelViewFrame;
    self.tableView.tableFooterView = self.panelView;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    //
    _progressMaximumWidth = self.view.bounds.size.width-INSET_HORIZONTAL;
    
    //
#if !RELATIVE_FRAME_ENABLED
    [[self sliderWithType:SliderTypeWidth] setValue:(_progressWidth-_progressMinimumWidth)/(_progressMaximumWidth-_progressMinimumWidth)];
#endif
    
    //
    CGRect frame = CGRectInset(self.panelView.bounds, INSET_HORIZONTAL, .0f);
    frame.size.height = SLIDER_HEIGHT;
    [self.slidersArray enumerateObjectsUsingBlock:^(UIView *theView, NSUInteger idx, BOOL *stop) {
        if (!theView.superview)
            [self.panelView addSubview:theView];
        
        theView.frame = CGRectOffset(frame, .0f, CGRectGetHeight(frame)*idx);
    }];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Private
- (UISlider *)sliderWithType:(SliderType)type
{
    return [self.slidersArray objectAtIndex:type];
}

#pragma mark - Action
- (void)sliderValueDidChange:(UISlider *)slider
{
    if ([self.slidersArray indexOfObject:slider] == SliderTypeWidth)
        _progressWidth = slider.value*(_progressMaximumWidth-_progressMinimumWidth)+_progressMinimumWidth;
        
    [self.tableView reloadData];
}

#pragma mark - Getters
- (UIView *)panelView
{
    if (!self->_panelView)
    {
        self->_panelView = [[UIView alloc] init];
        self->_panelView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
        self->_panelView.backgroundColor = [UIColor colorWithWhite:.325f alpha:.35f];
        self->_panelView.layer.borderWidth = 1.0f;
        self->_panelView.layer.borderColor = [UIColor colorWithWhite:.325f alpha:1.0f].CGColor;
    }
    
    return self->_panelView;
}

- (NSArray *)slidersArray
{
    if (!self->_slidersArray)
    {
        NSMutableArray *_tmp = [NSMutableArray arrayWithCapacity:_numberOfSliders];
        for (unsigned i=0; i<_numberOfSliders; i++)
        {
            UISlider *s = [[[UISlider alloc] init] autorelease];
            s.layer.borderWidth = 1.0f;
            s.layer.borderColor = [UIColor colorWithWhite:.325f alpha:1.0f].CGColor;
            s.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            [s addTarget:self action:@selector(sliderValueDidChange:) forControlEvents:UIControlEventValueChanged];
            [_tmp addObject:s];
        }
        
        self->_slidersArray = [[NSArray alloc] initWithArray:_tmp];
    }
    
    return self->_slidersArray;
}

#pragma mark - Table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dictionariesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    TableViewCell *cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.progressView = [Factory progressViewWithDictionary:[self.dictionariesArray objectAtIndex:indexPath.row]];
    }
    
#if !RELATIVE_FRAME_ENABLED
    cell.progressView.frame = CGRectMake(.0f, .0f, _progressWidth, CGRectGetHeight(cell.progressView.frame));
#endif
    
    cell.progressView.progress = [[self sliderWithType:SliderTypeProgress] value];
    
    return cell;
}

@end
