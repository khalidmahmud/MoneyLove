//
//  SelectCategoryViewController.m
//  MoneyLove
//
//  Created by Abu Khalid on 1/19/16.
//  Copyright © 2016 Abu Khalid. All rights reserved.
//

#import "SelectCategoryViewController.h"
#import "DataAccess.h"


@interface SelectCategoryViewController ()

@end

@implementation SelectCategoryViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  self.title = @"Select Category";
  
  
  self.expenseCategoryArray = [DataAccess getExpenseCategory];
  self.incomeCategoryArray = [DataAccess getIncomeCategory];
  
  //getting left bar button item....
  
  UIButton* customLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [customLeftButton setImage:[UIImage imageNamed:@"Back.png"] forState:UIControlStateNormal];
  [customLeftButton setTitle:@"" forState:UIControlStateNormal];
  [customLeftButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
  [customLeftButton sizeToFit];
  UIBarButtonItem* customLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customLeftButton];
  self.navigationItem.leftBarButtonItem = customLeftBarButtonItem;
}

- (void) back:(UIBarButtonItem *)sender {
  [self.navigationController popViewControllerAnimated:YES];
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
  static NSString *expenseTableIdentifier = @"transactionCategoryCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:expenseTableIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:expenseTableIdentifier];
  }
  
  if(self.segmentedControl.selectedSegmentIndex == 0) {
    cell.textLabel.text = [[self.expenseCategoryArray objectAtIndex:indexPath.row]  valueForKey:@"nameExpense"];
    NSString *imagePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[[self.expenseCategoryArray objectAtIndex:indexPath.row]  valueForKey:@"iconPath"]];
    cell.imageView.image = [UIImage imageWithContentsOfFile:imagePath];
  } else if(self.segmentedControl.selectedSegmentIndex == 1) {
    cell.textLabel.text = [[self.incomeCategoryArray objectAtIndex:indexPath.row]  valueForKey:@"nameIncome"];
    NSString *imagePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[[self.incomeCategoryArray objectAtIndex:indexPath.row]  valueForKey:@"iconPath"]];
    cell.imageView.image = [UIImage imageWithContentsOfFile:imagePath];
  }
  return cell;
}

- (IBAction)selectTransactionType:(id)sender {
  
  if(self.segmentedControl.selectedSegmentIndex == 0) {
    self.expenseCategoryArray = [DataAccess getExpenseCategory];
    [self.expenseTableView reloadData];
  } else if(self.segmentedControl.selectedSegmentIndex == 1) {
    self.incomeCategoryArray = [DataAccess getIncomeCategory];
    [self.expenseTableView reloadData];
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  CategoryObject *categoryObject = [[CategoryObject alloc] init];
  if(self.segmentedControl.selectedSegmentIndex == 0) {
    categoryObject.nameCategory = [[self.expenseCategoryArray objectAtIndex:indexPath.row]  valueForKey:@"nameExpense"];
    NSString *imagePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[[self.expenseCategoryArray objectAtIndex:indexPath.row]  valueForKey:@"iconPath"]];
    categoryObject.iconCategory = [UIImage imageWithContentsOfFile:imagePath];
    categoryObject.typeCategory = 1;//for expense type
    [self.delegate selectCategoryObject:categoryObject];
    [self.navigationController popViewControllerAnimated:YES];
  } else if(self.segmentedControl.selectedSegmentIndex == 1) {
    categoryObject.nameCategory = [[self.incomeCategoryArray objectAtIndex:indexPath.row]  valueForKey:@"nameIncome"];
    NSString *imagePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[[self.incomeCategoryArray objectAtIndex:indexPath.row]  valueForKey:@"iconPath"]];
    categoryObject.iconCategory = [UIImage imageWithContentsOfFile:imagePath];
    categoryObject.typeCategory = 2;//for income type
    [self.delegate selectCategoryObject:categoryObject];
    [self.navigationController popViewControllerAnimated:YES];
  }
}

@end
