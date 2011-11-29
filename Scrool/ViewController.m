//
//  ViewController.m
//  Scrool
//
//  Created by quang on 29/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(UIView*)infiniteTableView:(InfiniteTableView*)scrollView andViewForIndex:(int)index widthRect:(CGRect)rect
{
    
    UILabel *view = [[UILabel alloc] init];
    view.frame = rect;
    
    view.text = [NSString stringWithFormat:@"Label %d", index];
    view.textAlignment = UITextAlignmentCenter;
    if (index %2 == 0) {
        view.backgroundColor = [UIColor yellowColor];
    }else
    {
        view.backgroundColor = [UIColor magentaColor];
    }
    
    return [view autorelease];
}


-(void)viewDidLoad
{
    [super viewDidLoad];

    scrollView = [[InfiniteTableView alloc] initWithFrame:CGRectMake(0, 0, 320, 100) andNumberOfColumns: 10 andColumnWidth: 100 andColumnHeight: 50 andGap: 5];
    [self.view addSubview: scrollView];
    scrollView.center = CGPointMake(320/2, 480/2 - 200);
    scrollView.dataDelegate = self;
    [scrollView release];
    scrollView.backgroundColor = [UIColor redColor];
    
    
    scrollView = [[InfiniteTableView alloc] initWithFrame:CGRectMake(0, 0, 320, 100) andNumberOfColumns: 10 andColumnWidth: 100 andColumnHeight: 50 andGap: 5];
    [self.view addSubview: scrollView];
    scrollView.center = CGPointMake(320/2 , 480/2 - 100);
    scrollView.dataDelegate = self;
    [scrollView release];
    scrollView.backgroundColor = [UIColor grayColor];
    
    
    scrollView = [[InfiniteTableView alloc] initWithFrame:CGRectMake(0, 0, 320, 100) andNumberOfColumns: 10 andColumnWidth: 100 andColumnHeight: 50 andGap: 5];
    [self.view addSubview: scrollView];
    scrollView.center = CGPointMake(320/2 , 480/2 );
    scrollView.dataDelegate = self;
    [scrollView release];
    scrollView.backgroundColor = [UIColor greenColor];
    
    scrollView = [[InfiniteTableView alloc] initWithFrame:CGRectMake(0, 0, 320, 100) andNumberOfColumns: 10 andColumnWidth: 100 andColumnHeight: 50 andGap: 5];
    [self.view addSubview: scrollView];
    scrollView.center = CGPointMake(320/2 , 480/2 + 100);
    scrollView.dataDelegate = self;
    [scrollView release];
    scrollView.backgroundColor = [UIColor blueColor];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
