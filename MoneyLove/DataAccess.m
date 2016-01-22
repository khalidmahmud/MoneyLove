//
//  DataAccess.m
//  MoneyLove
//
//  Created by Abu Khalid on 1/19/16.
//  Copyright © 2016 Abu Khalid. All rights reserved.
//

#import "DataAccess.h"
#import "AppDelegate.h"

@implementation DataAccess

- (NSArray *)getExpenseCategory {
    AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"ExpenseCategory"];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    [fetchRequest setPropertiesToFetch:@[@"nameExpense"]];
    NSError *error;
    NSArray *expenseName = [context executeFetchRequest:fetchRequest error:&error];
    if (!expenseName) {
        NSLog(@"%@",[error localizedDescription]);
        NSMutableArray *emptyArray = [NSMutableArray array];
        return emptyArray;
    }
    return expenseName;
}

- (NSArray *)getIncomeCategory {
    AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"IncomeCategory"];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    [fetchRequest setPropertiesToFetch:@[@"nameIncome"]];
    NSError *error;
    NSArray *incomeName = [context executeFetchRequest:fetchRequest error:&error];
    if (!incomeName) {
        NSLog(@"%@",[error localizedDescription]);
        NSMutableArray *emptyArray = [NSMutableArray array];
        return emptyArray;
    }
    return incomeName;
}


@end
