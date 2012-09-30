//
//  MagDetailViewController.m
//  vttt
//
//  Created by Grails on 24/08/12.
//  Copyright (c) 2012 algos. All rights reserved.
//

#import "MagDetailViewController.h"
#import "Articolo.h"

@interface MagDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation MagDetailViewController

#pragma mark - Managing the detail item
@synthesize codeTextField = _codeTextField;
@synthesize nameTextField = _nameTextField;
@synthesize categoryTextField = _categoryTextField;
@synthesize priceTextField = _priceTextField;
@synthesize descritpionTextField = _descritpionTextField;
@synthesize buttonDescription = _buttonDescription;

@synthesize articolo = _articolo;

static NSString * descrizione = @"";


+ (NSString *)descrizione {
    
    return descrizione;
}

+ (void)setDescrizione:(NSString *)str {
    
    descrizione = [[NSString alloc] initWithString:str];
}

- (void)setDetailItem:(id)newDetailItem
{
    _articolo = newDetailItem;
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {        
        _codeTextField.text = self.articolo.code;
        _nameTextField.text = self.articolo.name;
        _categoryTextField.text = self.articolo.category;
        if (self.articolo.price == nil)
            _priceTextField.text = @"0.00€";
        else
            _priceTextField.text = self.articolo.price;
        _descritpionTextField.text = self.articolo.description;
        
        descrizione = self.articolo.description;
        [self.buttonDescription setTitle:self.articolo.description forState:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    int c = 3;
}

- (void)viewDidLoad
{
    // Titolo della colonna di destra
    self.navigationItem.title = NSLocalizedString(@"Scheda", @"Scheda");

    // Colore dello sfondo
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *backgroundColor = [defaults objectForKey:@"backgroundColor"];

    //[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage
    //[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]]];
 
    if ([backgroundColor isEqual:@"green"]) {
        [self.view setBackgroundColor:[UIColor greenColor]];
    } else {
        if ([backgroundColor isEqual:@"yellow"]) {
            [self.view setBackgroundColor:[UIColor yellowColor]];
        } else {
            if ([backgroundColor isEqual:@"pink"]) {
                [self.view setBackgroundColor:[UIColor purpleColor]];
            } else {
                if ([backgroundColor isEqual:@"blue"]) {
                    [self.view setBackgroundColor:[UIColor blueColor]];
                } else {
                    [self.view setBackgroundColor:[UIColor brownColor]];
                }
            }
        }
    }

    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)viewDidUnload
{
    [self setCodeTextField:nil];
    [self setNameTextField:nil];
    [self setCategoryTextField:nil];
    [self setPriceTextField:nil];
    [self setDescritpionTextField:nil];
    [self setButtonDescription:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Lista", @"Lista");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
