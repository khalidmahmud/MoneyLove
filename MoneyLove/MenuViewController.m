//
//  MenuViewController.m
//  MoneyLove
//
//  Created by Abu Khalid on 1/19/16.
//  Copyright © 2016 Abu Khalid. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.menuOptions = [[NSArray alloc] initWithObjects:@"Transactions",@"Incomes",@"Expenses",nil];
    self.menuOptionsIcons = [[NSArray alloc] initWithObjects:@"Transactions.png",@"Incomes.png",@"Expenses.png",nil];
    [self.menuTableView registerNib:[UINib nibWithNibName:@"MenuHeader" bundle:nil] forHeaderFooterViewReuseIdentifier:@"MenuTableHeader"];
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
    return [self.menuOptions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *menuCellTableIdentifier = @"menuCell"; //cell for menuTableView
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:menuCellTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:menuCellTableIdentifier];
    }
    cell.textLabel.text = [self.menuOptions objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[self.menuOptionsIcons objectAtIndex:indexPath.row]];
    cell.backgroundColor = [UIColor grayColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"%ld",indexPath.row);
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"goToMain" sender:self.menuTableView];
    } else if (indexPath.row == 1) {
        [self performSegueWithIdentifier:@"goToIncome" sender:self.menuTableView];
    } else {
        [self performSegueWithIdentifier:@"goToExpense" sender:self.menuTableView];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MenuHeader *header=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MenuTableHeader"];
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = [UIImage imageNamed:@"wallet.png"];
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
    NSMutableAttributedString *myString = [[NSMutableAttributedString alloc] initWithAttributedString:attachmentString];
    [myString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Your Wallet"]];
    header.sectionHeaderLabel.attributedText = myString;;
    [header.sectionHeaderLabel setFont:[UIFont boldSystemFontOfSize:20]];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}


@end
