//
//  MagCategoryViewController.m
//  Magazzino
//
//  Created by Marco Velluto on 29/09/12.
//  Copyright (c) 2012 algos. All rights reserved.
//

#import "MagCategoryViewController.h"

@interface MagCategoryViewController ()

@end

@implementation MagCategoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setPickerView:nil];
    [super viewDidUnload];
}


@end
