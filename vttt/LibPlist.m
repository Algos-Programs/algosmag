//
//  LibPlist.m
//  Magazzino
//
//  Created by Marco Velluto on 27/09/12.
//  Copyright (c) 2012 algos. All rights reserved.
//

#import "LibPlist.h"

@implementation LibPlist

//--- lista articoli in ordine alfabetico
//--- legge dictionary
//--- crea lista articoli

- (NSArray *)listaArticoli {
    static NSString *namePlist = @"articoli";
    
    //--- legge dictionary
    NSDictionary *dictionary = [self dictionaryWithString:namePlist];
    
    //NSArray *arrayKeys = [[self.categorieMerceologiche allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    //--- crea lista articoli
    NSArray *listaArticoli = [self articoliFromDictionary:dictionary];
    
    //--- ordina in modo alfabetico
    listaArticoli = [listaArticoli sortedArrayUsingSelector:@selector(compare:)];
    
    return listaArticoli;
    
}

- (NSArray *)articoliFromDictionary:(NSDictionary *)dictionary {
    
    NSMutableArray *listaTemp = [[NSMutableArray alloc] init];
    for (id key in dictionary) {
        
        id value = [dictionary objectForKey:key];
        
        for (id riga in value) {
            
            id stringa = (NSString *)riga;
            NSLog(@"Stringa = '%@'", stringa);
            [listaTemp addObject:stringa];
        }
    }
    return [[NSArray alloc] initWithArray:listaTemp];
}

- (NSDictionary *)dictionaryWithString:(NSString *)name {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"plist"];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    return dictionary;
}

- (NSDictionary *)getDictionaryArticoli {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"articoli" ofType:@"plist"];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    return dictionary;
    
}

@end
