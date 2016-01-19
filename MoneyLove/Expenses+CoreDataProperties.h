//
//  Expenses+CoreDataProperties.h
//  MoneyLove
//
//  Created by Abu Khalid on 1/19/16.
//  Copyright © 2016 Abu Khalid. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Expenses.h"

NS_ASSUME_NONNULL_BEGIN

@interface Expenses (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *amountExpense;
@property (nullable, nonatomic, retain) NSString *categoryExpense;
@property (nullable, nonatomic, retain) NSDate *dayOfExpense;
@property (nullable, nonatomic, retain) ExpenseCategory *expenseOfType;

@end

NS_ASSUME_NONNULL_END
