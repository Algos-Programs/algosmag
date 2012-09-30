//
//  MagDescrizioneViewController.m
//  Magazzino
//
//  Created by Marco Velluto on 30/09/12.
//  Copyright (c) 2012 algos. All rights reserved.
//

#import "MagDescrizioneViewController.h"
#import "MagMasterViewController.h"

@interface MagDescrizioneViewController ()

@end

@implementation MagDescrizioneViewController

@synthesize descrizioneTextField = _descrizioneTextField;
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
    
    _descrizioneTextField.text = [MagMasterViewController description];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setDescrizioneTextField:nil];
    [super viewDidUnload];
}
@end
