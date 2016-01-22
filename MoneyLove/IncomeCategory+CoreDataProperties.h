//
//  IncomeCategory+CoreDataProperties.h
//  MoneyLove
//
//  Created by Abu Khalid on 1/19/16.
//  Copyright © 2016 Abu Khalid. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "IncomeCategory.h"

NS_ASSUME_NONNULL_BEGIN

@interface IncomeCategory (CoreDataProperties)

@property (nullable, nonatomic, retain) NSData *icon;
@property (nullable, nonatomic, retain) NSString *nameIncome;
@property (nullable, nonatomic, retain) NSSet<Income *> *incomeOfType;

@end

@interface IncomeCategory (CoreDataGeneratedAccessors)

- (void)addIncomeOfTypeObject:(Income *)value;
- (void)removeIncomeOfTypeObject:(Income *)value;
- (void)addIncomeOfType:(NSSet<Income *> *)values;
- (void)removeIncomeOfType:(NSSet<Income *> *)values;

@end

NS_ASSUME_NONNULL_END
