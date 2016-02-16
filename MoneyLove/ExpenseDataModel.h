//
//  ExpenseDataModel.h
//  MoneyLove
//
//  Created by Abu Khalid on 2/5/16.
//  Copyright © 2016 Abu Khalid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExpenseDataModel : NSObject

@property (nonatomic, strong) NSString *category;
@property (nonatomic, assign) float amount;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) int type;


@end
