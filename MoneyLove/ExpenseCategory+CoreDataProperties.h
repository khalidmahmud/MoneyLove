//
//  ExpenseCategory+CoreDataProperties.h
//  MoneyLove
//
//  Created by Abu Khalid on 2/4/16.
//  Copyright © 2016 Abu Khalid. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ExpenseCategory.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExpenseCategory (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *iconPath;
@property (nullable, nonatomic, retain) NSString *nameExpense;
@property (nullable, nonatomic, retain) NSSet<Expenses *> *typeOfExpense;

@end

@interface ExpenseCategory (CoreDataGeneratedAccessors)

- (void)addTypeOfExpenseObject:(Expenses *)value;
- (void)removeTypeOfExpenseObject:(Expenses *)value;
- (void)addTypeOfExpense:(NSSet<Expenses *> *)values;
- (void)removeTypeOfExpense:(NSSet<Expenses *> *)values;

@end

NS_ASSUME_NONNULL_END
