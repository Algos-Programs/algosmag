//
//  MagCategoryViewController.h
//  Magazzino
//
//  Created by Marco Velluto on 29/09/12.
//  Copyright (c) 2012 algos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MagCategoryViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UIPickerViewAccessibilityDelegate>

@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;

@end
