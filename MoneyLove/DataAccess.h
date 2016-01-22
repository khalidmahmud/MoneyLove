//
//  DataAccess.h
//  MoneyLove
//
//  Created by Abu Khalid on 1/19/16.
//  Copyright © 2016 Abu Khalid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExpenseCategory.h"
#import "Expenses.h"
#import "IncomeCategory.h"
#import "Income.h"


@interface DataAccess : NSObject

- (NSArray *)getExpenseCategory;
- (NSArray *)getIncomeCategory;

@end
