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
    static NSString *categoryTableIdentifier = @"categoryCell";//cell for show categories in expense or income
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:categoryTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:categoryTableIdentifier];
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
        self.expenseCategoryArray = [accessData getExpenseCategory];//getting the categories for expenses
        [self.expenseTableView reloadData];
    } else if(self.segmentedControl.selectedSegmentIndex == 1) {
        self.incomeCategoryArray = [accessData getIncomeCategory];//getting the categories for income
        [self.expenseTableView reloadData];
    }
}

@end
