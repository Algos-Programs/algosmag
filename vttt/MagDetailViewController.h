//
//  MagDetailViewController.h
//  vttt
//
//  Created by Grails on 24/08/12.
//  Copyright (c) 2012 algos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Articolo.h"

@interface MagDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@property (strong, nonatomic) IBOutlet UITextField *codeTextField;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *categoryTextField;
@property (strong, nonatomic) IBOutlet UITextField *priceTextField;
@property (strong, nonatomic) IBOutlet UITextField *descritpionTextField;
@property (strong, nonatomic) IBOutlet UIButton *buttonDescription;

@property (strong, nonatomic) Articolo *articolo;

+ (NSString *)descritpion;
+ (void)setDescription:(NSString *)str;

@end
