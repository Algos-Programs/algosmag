//
//  LibArticolo.m
//  Magazzino
//
//  Created by Marco Velluto on 27/09/12.
//  Copyright (c) 2012 algos. All rights reserved.
//

#import "LibArticolo.h"

@implementation LibArticolo

+ (NSDictionary *)creaVistaCategoryWithArray:(NSArray *)array {
    NSArray *categoryArray = [[NSArray alloc] init];
    NSMutableDictionary *articoliDictionary = [[NSMutableDictionary alloc] init];
    categoryArray = [LibArticolo categoryFromArray:array];
    
    for (int i = 0; i < categoryArray.count; i++) {
        
        NSString *categoryTemp = [[NSString alloc] init];
        NSMutableArray *arrayTemp = [[NSMutableArray alloc] init];
        categoryTemp = [categoryArray objectAtIndex:i];
        
        for (int y = 0; y < array.count; y++) {
            
            Articolo *art = [[Articolo alloc] init];
            art = [array objectAtIndex:y];
            
            if ([categoryTemp isEqualToString:art.category]) {
                
                [arrayTemp addObject:art];
            }//end if
        }//end for
        
        [articoliDictionary setObject:arrayTemp forKey:categoryTemp];
    }//end for
    
    return articoliDictionary;
}

+ (BOOL)categoryAlreadyExistWithString:(NSString *)categoria withArray:(NSArray *)array {
    
    for (NSString *tempString in array) {
        
        if ([categoria isEqualToString:tempString]) {
            return TRUE;
        }
    }
    return FALSE;
}

+ (NSArray *)categoryFromArray:(NSArray *)array {
    
    NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < array.count; i++) {
        
        Articolo *art = [[Articolo alloc] init];
        NSString *tempString = [[NSString alloc] init];
        
        art = [array objectAtIndex:i];
        tempString = [art category];
        
        if (![self categoryAlreadyExistWithString:tempString withArray:categoryArray]) {
            
            [categoryArray addObject:tempString];
        }
    }
    
    return categoryArray;
}

+ (NSArray *)categoryDuplicateFromArray:(NSArray *)array {
    
    NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < array.count; i++) {
        
        Articolo *art = [[Articolo alloc] init];
        NSString *tempString = [[NSString alloc] init];
        
        art = [array objectAtIndex:i];
        tempString = [art category];
        
        [categoryArray addObject:tempString];
    }
    
    return categoryArray;
}


@end
