//
//  DataAccess.m
//  MoneyLove
//
//  Created by Abu Khalid on 1/19/16.
//  Copyright © 2016 Abu Khalid. All rights reserved.
//

#import "DataAccess.h"
#import "AppDelegate.h"
#import "MainViewDataModel.h"

@implementation DataAccess

+ (NSArray *)getExpenseCategory {
    AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"ExpenseCategory"];
    [fetchRequest setResultType:NSDictionaryResultType];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSError *error;
    NSArray *expenseName = [context executeFetchRequest:fetchRequest error:&error];
    if (!expenseName) {
        NSLog(@"%@",[error localizedDescription]);
        NSMutableArray *emptyArray = [NSMutableArray array];
        return emptyArray;
    }
    NSLog(@"%@",expenseName);
    return expenseName;
}

+ (NSArray *)getIncomeCategory {
    AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"IncomeCategory"];
    [fetchRequest setResultType:NSDictionaryResultType];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSError *error;
    NSArray *incomeName = [context executeFetchRequest:fetchRequest error:&error];
    if (!incomeName) {
        NSLog(@"%@",[error localizedDescription]);
        NSMutableArray *emptyArray = [NSMutableArray array];
        return emptyArray;
    }
    NSLog(@"%@",incomeName);
    return incomeName;
}

- (void)saveTransactionExpenseWithAmount:(NSNumber *)amount category:(NSString *)category day:(NSDate *)dayTransaction typeCategory:(int)typeCategory {
    AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    if ((amount != nil) && (category != nil) && (dayTransaction != nil) && (typeCategory != 0)) {
        if (typeCategory == 1) {
            Expenses *expenseObject = [NSEntityDescription insertNewObjectForEntityForName:@"Expenses" inManagedObjectContext:context];
            expenseObject.amountExpense = amount;
            expenseObject.dayOfExpense = dayTransaction;
            expenseObject.categoryExpense = category;
        } else if(typeCategory == 2) {
            Income *incomeObject = [NSEntityDescription insertNewObjectForEntityForName:@"Income" inManagedObjectContext:context];
            incomeObject.amountIncome = amount;
            incomeObject.dayOfIncome = dayTransaction;
            incomeObject.categoryIncome = category;
        }
        NSError *error;
        if (![context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    }
}


- (NSArray *)getExpenseWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];

    if ((startDate != nil) && (endDate != nil)) {
        // fetch expenses data from  database
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Expenses"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(dayOfExpense >= %@) AND (dayOfExpense < %@)", startDate, endDate];
        [fetchRequest setPredicate:predicate];
        [fetchRequest setReturnsObjectsAsFaults:NO];
        NSError *error;
        NSArray *resultExpense = [context executeFetchRequest:fetchRequest error:&error];
        
        //creating expenses data model
        NSMutableArray *expenseArray = [[NSMutableArray alloc]init];
        for (int index = 0; index < resultExpense.count; index++) {
            MainViewDataModel *data = [[MainViewDataModel alloc] init];
            data.type = 1;
            data.category = [[resultExpense objectAtIndex:index] valueForKey:@"categoryExpense"];
            data.amount = [[[resultExpense objectAtIndex:index] valueForKey:@"amountExpense"] floatValue];
            data.date = [[resultExpense objectAtIndex:index] valueForKey:@"dayOfExpense"];
            [expenseArray addObject:data];
        }
        return  expenseArray;
    } else {
        return  @[];
    }
}

- (NSArray *)getIncomeWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    if ((startDate != nil) && (endDate != nil)) {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Income"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(dayOfIncome >= %@) AND (dayOfIncome < %@)", startDate, endDate];
        [fetchRequest setPredicate:predicate];
        [fetchRequest setReturnsObjectsAsFaults:NO];
        NSError *error;
        NSArray *resultIncome = [context executeFetchRequest:fetchRequest error:&error];        
        NSMutableArray *incomeArray = [[NSMutableArray alloc]init];
        for (int index = 0; index < resultIncome.count; index++) {
            MainViewDataModel *data = [[MainViewDataModel alloc] init];
            data.type = 2;
            data.category = [[resultIncome objectAtIndex:index] valueForKey:@"categoryIncome"];
            data.amount = [[[resultIncome objectAtIndex:index] valueForKey:@"amountIncome"] floatValue];
            data.date = [[resultIncome objectAtIndex:index] valueForKey:@"dayOfIncome"];
            [incomeArray addObject:data];
        }
        return  incomeArray;
    } else {
        return  @[];
    }
}

- (UIImage *)getIcon:(NSString *)categoryName typeTransaction:(int)typeInt {
    AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSFetchRequest *fetchRequest ;
    NSPredicate *iconPredicate ;
    if (typeInt == 2) {
        fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"IncomeCategory"];
        iconPredicate = [NSPredicate predicateWithFormat:@"nameIncome == %@",categoryName];
    } else {
        fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"ExpenseCategory"];
        iconPredicate = [NSPredicate predicateWithFormat:@"nameExpense == %@",categoryName];
    }
    [fetchRequest setReturnsObjectsAsFaults:NO];
    [fetchRequest setPredicate:iconPredicate];
    NSError *error;
    NSString *imagePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[[[context executeFetchRequest:fetchRequest error:&error] valueForKey:@"iconPath"] objectAtIndex:0]];
    
    UIImage *iconImage = [UIImage imageWithContentsOfFile:imagePath];
    if (!iconImage) {
      return nil;
    }
    return iconImage;
}

+ (float)getTotalExpense {
  AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
  NSManagedObjectContext *context = [appdelegate managedObjectContext];
  NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Expenses"];
  [fetchRequest setReturnsObjectsAsFaults:NO];
  [fetchRequest setReturnsDistinctResults:YES];
  [fetchRequest setPropertiesToFetch:@[@"amountExpense"]];
  [fetchRequest setResultType:NSDictionaryResultType];
  NSError *error;
  NSArray *expenseName = [context executeFetchRequest:fetchRequest error:&error];
  if (!expenseName) {
    NSLog(@"%@",[error localizedDescription]);
    return -1.0;//error occured
  }
  float resultTotalExpense = [[[expenseName valueForKey:@"amountExpense"]  valueForKeyPath:@"@sum.self"] floatValue];
  return resultTotalExpense;
}

+ (float)getTotalIncome {
  AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
  NSManagedObjectContext *context = [appdelegate managedObjectContext];
  NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Income"];
  [fetchRequest setReturnsObjectsAsFaults:NO];
  [fetchRequest setReturnsDistinctResults:YES];
  [fetchRequest setPropertiesToFetch:@[@"amountIncome"]];
  [fetchRequest setResultType:NSDictionaryResultType];
  NSError *error;
  NSArray *incomeName = [context executeFetchRequest:fetchRequest error:&error];
  if (!incomeName) {
    NSLog(@"%@",[error localizedDescription]);
    return -1.0;//error occured
  }
  float resultTotalIncome = [[[incomeName valueForKey:@"amountIncome"]  valueForKeyPath:@"@sum.self"] floatValue];
  return resultTotalIncome;
}


- (void)saveCategoryName:(NSString *)categoryName iconPath:(NSString *)iconPath typeCategory:(int)typeCategory {
  AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
  NSManagedObjectContext *context = [appdelegate managedObjectContext];
  if ((categoryName != nil) && (iconPath != nil) && (typeCategory != 0)) {
    if (typeCategory == 1) {
      ExpenseCategory *expenseCategoryObject = [NSEntityDescription insertNewObjectForEntityForName:@"ExpenseCategory" inManagedObjectContext:context];
      expenseCategoryObject.nameExpense = categoryName;
      expenseCategoryObject.iconPath = iconPath;
    } else if(typeCategory == 2) {
      IncomeCategory *incomeObject = [NSEntityDescription insertNewObjectForEntityForName:@"IncomeCategory" inManagedObjectContext:context];
      incomeObject.nameIncome = categoryName;
      incomeObject.iconPath = iconPath;
    }
    NSError *error;
    if (![context save:&error]) {
      NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
  }
}


@end
