//
//  LibPlist.h
//  Magazzino
//
//  Created by Marco Velluto on 27/09/12.
//  Copyright (c) 2012 algos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LibPlist : NSObject

- (NSArray *)listaArticoli;
- (NSArray *)articoliFromDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictionaryWithString:(NSString *)name;
- (NSDictionary *)getDictionaryArticoli;
+ (void)writeDictionary:(NSDictionary *)dictionary fromPlistName:(NSString *)plistName;
+ (NSDictionary *)readPlistName:(NSString *)plistName;

@end
