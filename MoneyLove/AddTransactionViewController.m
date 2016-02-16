//
//  AddTransactionViewController.m
//  MoneyLove
//
//  Created by Abu Khalid on 1/18/16.
//  Copyright © 2016 Abu Khalid. All rights reserved.
//

#import "AddTransactionViewController.h"
#import "DataAccess.h"

@interface AddTransactionViewController ()

@end

@implementation AddTransactionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Add Transaction";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(addTransaction:)];
    self.typeOfCategory = 0;
  
    //code for adding some expense and income categories....
//    DataAccess *accessData = [[DataAccess alloc] init];
//    [accessData saveCategoryName:@"Selling" iconPath:@"/Images/Selling.png" typeCategory:2];
//    [accessData saveCategoryName:@"Salary" iconPath:@"/Images/Salary.png" typeCategory:2];//2 for Income
//    [accessData saveCategoryName:@"Travel" iconPath:@"/Images/Travel.png" typeCategory:1];//1 for expense
//    [accessData saveCategoryName:@"Food And Drinks" iconPath:@"/Images/Food_And_Drinks.png" typeCategory:1];
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

- (IBAction)selectCategoryAction:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    SelectCategoryViewController *controller = (SelectCategoryViewController *)[mainStoryboard instantiateViewControllerWithIdentifier: @"SelectCategory"];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void) selectCategoryObject:(CategoryObject *)categoryObject {
    if (categoryObject != nil) {
        [self.buttonCategory setImage:categoryObject.iconCategory forState:UIControlStateNormal];
        self.categoryNameLabel.text = categoryObject.nameCategory;
        self.typeOfCategory = categoryObject.typeCategory;
    } else {
        NSLog(@"The Category Object returned nil value");
    }
}

- (IBAction)addTransaction:(id)sender {
    NSNumberFormatter *amountFormat = [[NSNumberFormatter alloc] init];
    amountFormat.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *amountExpense = [amountFormat numberFromString:self.amountTransaction.text];
    DataAccess *accessData = [[DataAccess alloc] init];
    if ((amountExpense != nil) && (self.categoryNameLabel.text != nil) && ([self.dateTransaction date] != nil) && (self.typeOfCategory != 0)) {
            [accessData saveTransactionExpenseWithAmount:amountExpense category:self.categoryNameLabel.text day:[self.dateTransaction date] typeCategory: self.typeOfCategory];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        NSLog(@"Some values are missing please check");
    }
}


@end
