//
//  DataAccess.h
//  MoneyLove
//
//  Created by Abu Khalid on 1/19/16.
//  Copyright © 2016 Abu Khalid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ExpenseCategory.h"
#import "Expenses.h"
#import "IncomeCategory.h"
#import "Income.h"


@interface DataAccess : NSObject

+ (NSArray *)getExpenseCategory;
+ (NSArray *)getIncomeCategory;
+ (float)getTotalExpense;
+ (float)getTotalIncome;
- (void)saveTransactionExpenseWithAmount:(NSNumber *)amount category:(NSString *)category day:(NSDate *)dayTransaction typeCategory:(int)typeCategory;
- (NSArray *)getExpenseWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;
- (NSArray *)getIncomeWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;
- (UIImage *)getIcon:(NSString *)categoryName typeTransaction:(int)typeInt;
- (void)saveCategoryName:(NSString *)categoryName iconPath:(NSString *)iconPath typeCategory:(int)typeCategory;

@end
