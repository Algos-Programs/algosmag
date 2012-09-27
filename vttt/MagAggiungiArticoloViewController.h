//
//  MagAggiungiArticoloViewController.h
//  Magazzino
//
//  Created by Marco Velluto on 27/09/12.
//  Copyright (c) 2012 algos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MagAggiungiArticoloViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;


- (IBAction)categoryButtonPressed:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;
@end
