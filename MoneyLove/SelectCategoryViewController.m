//
//  SelectCategoryViewController.m
//  MoneyLove
//
//  Created by Abu Khalid on 1/19/16.
//  Copyright © 2016 Abu Khalid. All rights reserved.
//

#import "SelectCategoryViewController.h"
#import "DataAccess.h"
#import "ExpenseCategory.h"
#import "IncomeCategory.h"

@interface SelectCategoryViewController ()

@end

@implementation SelectCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Select Category";
    DataAccess *accessData = [[DataAccess alloc] init];
    self.expenseCategoryArray = [accessData getExpenseCategory];
    self.incomeCategoryArray = [accessData getIncomeCategory];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.segmentedControl.selectedSegmentIndex == 0) {
        return [self.expenseCategoryArray count];
    } else {
        return [self.incomeCategoryArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *expenseTableIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:expenseTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:expenseTableIdentifier];
    }
    
    if(self.segmentedControl.selectedSegmentIndex == 0) {
        ExpenseCategory *expenseCategoryObject = [self.expenseCategoryArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",(expenseCategoryObject.nameExpense) ? expenseCategoryObject.nameExpense: @""];
        cell.imageView.image = [UIImage imageWithData:expenseCategoryObject.icon];
    } else if(self.segmentedControl.selectedSegmentIndex == 1) {
        IncomeCategory *incomeCategoryObject = [self.incomeCategoryArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",(incomeCategoryObject.nameIncome) ? incomeCategoryObject.nameIncome: @""];
        cell.imageView.image = [UIImage imageWithData:incomeCategoryObject.icon];
    }
    return cell;
}

- (IBAction)selectTransactionType:(id)sender {
    DataAccess *accessData = [[DataAccess alloc] init];
    if(self.segmentedControl.selectedSegmentIndex == 0) {
        self.expenseCategoryArray = [accessData getExpenseCategory];
        [self.expenseTableView reloadData];
    } else if(self.segmentedControl.selectedSegmentIndex == 1) {
        self.incomeCategoryArray = [accessData getIncomeCategory];
        [self.expenseTableView reloadData];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CategoryObject *categoryObject = [[CategoryObject alloc] init];
    if(self.segmentedControl.selectedSegmentIndex == 0) {
        ExpenseCategory *expenseCategoryObject = [self.expenseCategoryArray objectAtIndex:indexPath.row];
        categoryObject.nameCategory = [NSString stringWithFormat:@"%@",(expenseCategoryObject.nameExpense) ? expenseCategoryObject.nameExpense: @""];
        categoryObject.iconCategory = [UIImage imageWithData:expenseCategoryObject.icon];
        categoryObject.typeCategory = 0;
        [self.delegate selectCategoryObject:categoryObject];
        [self.navigationController popViewControllerAnimated:YES];
    } else if(self.segmentedControl.selectedSegmentIndex == 1) {
        IncomeCategory *incomeCategoryObject = [self.incomeCategoryArray objectAtIndex:indexPath.row];
        categoryObject.nameCategory = [NSString stringWithFormat:@"%@",(incomeCategoryObject.nameIncome) ? incomeCategoryObject.nameIncome: @""];
        categoryObject.iconCategory = [UIImage imageWithData:incomeCategoryObject.icon];
        categoryObject.typeCategory = 1;
        [self.delegate selectCategoryObject:categoryObject];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
