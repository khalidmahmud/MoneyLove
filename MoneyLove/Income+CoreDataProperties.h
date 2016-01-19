//
//  Income+CoreDataProperties.h
//  MoneyLove
//
//  Created by Abu Khalid on 1/19/16.
//  Copyright © 2016 Abu Khalid. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Income.h"

NS_ASSUME_NONNULL_BEGIN

@interface Income (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *amountIncome;
@property (nullable, nonatomic, retain) NSString *categoryIncome;
@property (nullable, nonatomic, retain) NSDate *dayOfIncome;
@property (nullable, nonatomic, retain) IncomeCategory *typeOfIncome;

@end

NS_ASSUME_NONNULL_END
