//
//  MagAggiungiArticoloViewController.m
//  Magazzino
//
//  Created by Marco Velluto on 27/09/12.
//  Copyright (c) 2012 algos. All rights reserved.
//

#import "MagAggiungiArticoloViewController.h"
#import "LibPlist.h"

@interface MagAggiungiArticoloViewController ()

@end

@implementation MagAggiungiArticoloViewController

static NSString * const KEY_CODE = @"code";
static NSString * const KEY_NAME = @"name";
static NSString * const KEY_PRICE = @"price";
static NSString * const KEY_DESCRIPTION = @"description";
static NSString * const KEY_CATEGORY = @"category";

static NSString * const PLIST_NAME = @"temp";


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
    [self setCodeTextField:nil];
    [self setNameTextField:nil];
    [self setPriceTextField:nil];
    [self setDescriptionTextField:nil];
    [self setIconImageView:nil];
    //[self setImageViewPressed:nil];
    [super viewDidUnload];
}
- (IBAction)categoryButtonPressed:(id)sender {
    
}

- (IBAction)saveButtonPressed:(id)sender {
    
    [self createDictionary];
}

- (NSDictionary *)createDictionary {
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:self.codeTextField.text forKey:KEY_CODE];
    [dictionary setObject:self.nameTextField.text forKey:KEY_NAME];
    [dictionary setObject:self.priceTextField.text forKey:KEY_PRICE];
    [dictionary setObject:self.descriptionTextField.text forKey:KEY_DESCRIPTION];
    
    [LibPlist writeDictionary:dictionary fromPlistName:PLIST_NAME];
    
#warning INSERISCO CATEGORA E IMMAGINE
    return dictionary;
}

@end
