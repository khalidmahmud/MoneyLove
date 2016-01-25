//
//  CategoryObject.h
//  MoneyLove
//
//  Created by Abu Khalid on 1/22/16.
//  Copyright © 2016 Abu Khalid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CategoryObject : NSObject

@property (strong, nonatomic) NSString *nameCategory;
@property (strong, nonatomic) UIImage *iconCategory;
@property (nonatomic, assign) int typeCategory;


@end
