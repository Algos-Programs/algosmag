//
//  LibArticolo.h
//  Magazzino
//
//  Created by Marco Velluto on 27/09/12.
//  Copyright (c) 2012 algos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Articolo.h"

@interface LibArticolo : NSObject

+ (NSDictionary *)creaVistaCategoryWithArray:(NSArray *)array;
+ (BOOL)categoryAlreadyExistWithString:(NSString *)categoria withArray:(NSArray *)array;
+ (NSArray *)categoryFromArray:(NSArray *)array;
+ (NSArray *)categoryDuplicateFromArray:(NSArray *)array;

@end
