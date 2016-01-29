//
//  IncomeViewController.m
//  MoneyLove
//
//  Created by Abu Khalid on 1/20/16.
//  Copyright © 2016 Abu Khalid. All rights reserved.
//

#import "IncomeViewController.h"
#import "DataAccess.h"
#import "IncomeDataModel.h"
#import "StatisticsIncomeHeader.h"

@interface IncomeViewController ()

@property (nonatomic, strong) UITableView *incomeTableView1;//initially previous table view
@property (nonatomic, strong) UITableView *incomeTableView2;//initially current tableview
@property (nonatomic, strong) UITableView *incomeTableView3;//initially next tableview

@property (nonatomic, strong) NSMutableArray *arrayTableView;//array for tableview
@property (nonatomic, strong) NSMutableArray *incomeDataArray1;//array for tableview 1
@property (nonatomic, strong) NSMutableArray *incomeDataArray2;//array for tableview 2
@property (nonatomic, strong) NSMutableArray *incomeDataArray3;//array for tableview 3

@property (nonatomic, assign) float walletIncome1;//initially income of previous week
@property (nonatomic, assign) float walletIncome2;//initially income of current week
@property (nonatomic, assign) float walletIncome3;//initially income of next week
@end

@implementation IncomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"Statistics Income";
    //getting wallet statistics...
    if ([DataAccess getTotalExpense] < 0.0) {
        NSLog(@"Error occured....");
    } else {
        self.totalExpense = [DataAccess getTotalExpense];
    }
    if ([DataAccess getTotalIncome] < 0.0) {
        NSLog(@"Error occured....");
    } else {
        self.totalIncome = [DataAccess getTotalIncome];
    }

    self.title = [[NSString alloc] initWithString:[NSString stringWithFormat:@"Your Wallet = %.2f",(self.totalIncome - self.totalExpense)]];
    //getting the start and end dates
    self.currentStartDate = [self setStartDateFromCurrentDate];
    self.currentEndDate = [self nextMonthCalculation:self.currentStartDate];//getting to next month
    //using data access data array 2......
    DataAccess *accessData = [[DataAccess alloc] init];
    NSMutableArray *resultOfIncome2 = [[accessData getIncomeWithStartDate:self.currentStartDate endDate:self.currentEndDate] mutableCopy];
    //using data access....
    //getting the income...current week initially
    self.walletIncome2 = [self totalSumFromArray:resultOfIncome2];
    //data array 1............
    NSMutableArray *resultOfIncome1 = [[accessData getIncomeWithStartDate:[self previousMonthCalculation:self.currentStartDate] endDate:[self previousMonthCalculation:self.currentEndDate]]mutableCopy];

    //getting the income...previous week
    self.walletIncome1 = [self totalSumFromArray:resultOfIncome1];
    
    //data array 3............
    NSMutableArray *resultOfIncome3 = [[accessData getIncomeWithStartDate:[self nextMonthCalculation:self.currentStartDate] endDate:[self nextMonthCalculation:self.currentEndDate]] mutableCopy];
    
    //getting the income...next week
    self.walletIncome3 = [self totalSumFromArray:resultOfIncome3];
    
    [self setScrollView];
    
    float x = 0.0;
    self.incomeTableView1 = [[UITableView alloc]initWithFrame:CGRectMake(x, 0.0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.incomeTableView1.dataSource = self;
    self.incomeTableView1.delegate = self;
    self.incomeTableView1.tag = 1;
    [self.incomeScrollView addSubview:self.incomeTableView1];
    
    x += self.view.bounds.size.width;
    self.incomeTableView2 = [[UITableView alloc]initWithFrame:CGRectMake(x, 0.0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.incomeTableView2.dataSource = self;
    self.incomeTableView2.delegate = self;
    self.incomeTableView2.tag = 2;
    [self.incomeScrollView addSubview:self.incomeTableView2];
    
    x += self.view.bounds.size.width;
    self.incomeTableView3 = [[UITableView alloc]initWithFrame:CGRectMake(x, 0.0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.incomeTableView3.dataSource = self;
    self.incomeTableView3.delegate = self;
    self.incomeTableView3.tag = 3;
    [self.incomeScrollView addSubview:self.incomeTableView3];
    
    self.arrayTableView = [NSMutableArray arrayWithObjects:self.incomeTableView1, self.incomeTableView2, self.incomeTableView3, nil];
    
    self.incomeDataArray1 = [NSMutableArray arrayWithArray:resultOfIncome1];
    self.incomeDataArray2 = [NSMutableArray arrayWithArray:resultOfIncome2];
    self.incomeDataArray3 = [NSMutableArray arrayWithArray:resultOfIncome3];
    
    //if initially any data array is empty......
    if (![self.incomeDataArray1 count]) {
        UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Question_mark_Icon_64.png"]];
        [tempImageView setFrame:self.incomeTableView1.frame];
        self.incomeTableView1.backgroundView = tempImageView;
    }
    if(![self.incomeDataArray2 count] ) {
        UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Question_mark_Icon_64.png"]];
        [tempImageView setFrame:self.incomeTableView2.frame];
        self.incomeTableView2.backgroundView = tempImageView;
    }
    if(![self.incomeDataArray3 count] ) {
        UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Question_mark_Icon_64.png"]];
        [tempImageView setFrame:self.incomeTableView3.frame];
        self.incomeTableView3.backgroundView = tempImageView;
    }

    [self.incomeTableView1 registerNib:[UINib nibWithNibName:@"StatisticsIncomeHeader" bundle:nil] forHeaderFooterViewReuseIdentifier:@"StatisticsIncomeHeader"];
    [self.incomeTableView2 registerNib:[UINib nibWithNibName:@"StatisticsIncomeHeader" bundle:nil] forHeaderFooterViewReuseIdentifier:@"StatisticsIncomeHeader"];
    [self.incomeTableView3 registerNib:[UINib nibWithNibName:@"StatisticsIncomeHeader" bundle:nil] forHeaderFooterViewReuseIdentifier:@"StatisticsIncomeHeader"];
}

-(void)setScrollView {
    CGSize size = CGSizeMake(self.view.bounds.size.width * 3, self.view.bounds.size.height);
    [self.incomeScrollView setContentSize:size];
    
    CGPoint point = CGPointMake(self.view.bounds.size.width, 0.0);
    [self.incomeScrollView setContentOffset:point];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.incomeTableView1]) {
        return [self.incomeDataArray1 count];
    } else if ([tableView isEqual:self.incomeTableView2]) {
        return [self.incomeDataArray2 count];
    } else {
        return [self.incomeDataArray3 count];
    }
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

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *incomeTableIdentifier = @"IncomeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:incomeTableIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:incomeTableIdentifier];
    }
    [cell setBackgroundColor:[UIColor clearColor]];
    NSMutableArray *arrayTemp1 = [[NSMutableArray alloc] init];
    DataAccess *accessData = [[DataAccess alloc] init];
    
    if ([tableView isEqual:self.incomeTableView1]) {
        arrayTemp1 = self.incomeDataArray1;
    } else if ([tableView isEqual:self.incomeTableView2]) {
        arrayTemp1 = self.incomeDataArray2;
    } else {
        arrayTemp1 = self.incomeDataArray3;
    }
    if (arrayTemp1.count) {
        IncomeDataModel *data = [arrayTemp1 objectAtIndex:indexPath.row];
        if (data.type == 1) {  // If type is expense
            cell.textLabel.text = data.category;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f",data.amount];
            cell.detailTextLabel.textColor = [UIColor redColor];
            cell.imageView.image = [accessData getIcon:data.category typeTransaction:data.type];
        } else if (data.type == 2) { // If type is income
            cell.textLabel.text = data.category;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f",data.amount];
            cell.detailTextLabel.textColor = [UIColor blueColor];
            cell.imageView.image = [accessData getIcon:data.category typeTransaction:data.type];
        }
    }
    return cell;
}


#pragma mark - updating Previous Month and Next Month

- (NSMutableArray *)getPreviousMonth {
    NSMutableArray *previousMonthDataIncome;
    DataAccess *accessData = [[DataAccess alloc] init];
    previousMonthDataIncome = [[accessData getIncomeWithStartDate:[self previousMonthCalculation:self.currentStartDate] endDate:[self previousMonthCalculation:self.currentEndDate]] mutableCopy];
    return previousMonthDataIncome;
}

- (NSMutableArray *)getNextMonth {
    NSMutableArray *nextMonthDataIncome;
    DataAccess *accessData = [[DataAccess alloc] init];
    
    nextMonthDataIncome = [[accessData getIncomeWithStartDate:[self nextMonthCalculation:self.currentStartDate] endDate:[self nextMonthCalculation:self.currentEndDate]] mutableCopy];
    return nextMonthDataIncome;
}


#pragma mark - ScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.incomeScrollView) {
        if(scrollView.contentOffset.x == 0) {
            NSDate *tempDate = self.currentStartDate;
            self.currentStartDate = [self previousMonthCalculation:self.currentStartDate];
            self.currentEndDate = tempDate;
            [self moveRight];
        } else if(scrollView.contentOffset.x == (self.view.bounds.size.width*2)) {
            self.currentStartDate = self.currentEndDate;
            self.currentEndDate = [self nextMonthCalculation:self.currentEndDate];
            [self moveLeft];
        } else
            return;
    }
}

-(void)moveLeft {
    
    UITableView *tempTblView = [self.arrayTableView objectAtIndex:0];
    [self.arrayTableView removeObjectAtIndex:0];
    [self.arrayTableView insertObject:tempTblView atIndex:2];
    
    [self updateScrollViewCotent];
    
    //load next month
    if ([tempTblView isEqual:self.incomeTableView1]) {
        self.incomeDataArray1 = [self getNextMonth];
        [self showNoDataView:self.incomeDataArray1 identifier:2];
    } else if ([tempTblView isEqual:self.incomeTableView2]) {
        self.incomeDataArray2 = [self getNextMonth];
        [self showNoDataView:self.incomeDataArray2 identifier:2];
    } else if ([tempTblView isEqual:self.incomeTableView3]) {
        self.incomeDataArray3 = [self getNextMonth];
        [self showNoDataView:self.incomeDataArray3 identifier:2];
    }
}

-(void)moveRight {
    
    UITableView *tempTblView = [self.arrayTableView objectAtIndex:2];
    [self.arrayTableView removeObjectAtIndex:2];
    [self.arrayTableView insertObject:tempTblView atIndex:0];
    
    [self updateScrollViewCotent];
    
    if ([tempTblView isEqual:self.incomeTableView1]) {
        self.incomeDataArray1 = [self getPreviousMonth];
        [self showNoDataView:self.incomeDataArray1 identifier:0];
    } else if ([tempTblView isEqual:self.incomeTableView2]) {
        self.incomeDataArray2 = [self getPreviousMonth];
        [self showNoDataView:self.incomeDataArray2 identifier:0];
    } else if ([tempTblView isEqual:self.incomeTableView3]) {
        self.incomeDataArray3 = [self getPreviousMonth];
        [self showNoDataView:self.incomeDataArray3 identifier:0];
    }
}

-(void)updateScrollViewCotent {
    for (int i = 0; i < self.arrayTableView.count; i++) {
        UITableView *tblView = [self.arrayTableView objectAtIndex:i];
        
        [tblView setFrame:CGRectMake(i * self.view.bounds.size.width, 0.0, tblView.frame.size.width, tblView.frame.size.height)];
        tblView.tag = i + 1;
        [self.arrayTableView replaceObjectAtIndex:i withObject:tblView];
    }
    CGPoint point = CGPointMake(self.view.bounds.size.width, 0.0);
    [self.incomeScrollView setContentOffset:point];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    StatisticsIncomeHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"StatisticsIncomeHeader"];
    DataAccess *accessData = [[DataAccess alloc] init];
    
    if (tableView.tag == 1) {//previous view section header
        //fixing wallet
        //data array 1............
        NSMutableArray *resultOfIncome1 = [[accessData getIncomeWithStartDate:[self previousMonthCalculation:self.currentStartDate] endDate:[self previousMonthCalculation:self.currentEndDate]]mutableCopy];
        //getting the income...previous week
        self.walletIncome1 = [self totalSumFromArray:resultOfIncome1];
        header.monthlyIncomeLabel.text = [NSString stringWithFormat:@"%.2f", self.walletIncome1];
        header.monthlyIncomeLabel.textColor = [UIColor blueColor];
    }
    if (tableView.tag == 2) { //current  view overview section header
        //fixing wallet
        NSMutableArray *resultOfIncome2 = [[accessData getIncomeWithStartDate:self.currentStartDate endDate:self.currentEndDate] mutableCopy];
        //getting the income...current week initially
        self.walletIncome2 = [self totalSumFromArray:resultOfIncome2];
        header.monthlyIncomeLabel.text = [NSString stringWithFormat:@"%.2f", self.walletIncome2];
        header.monthlyIncomeLabel.textColor = [UIColor blueColor];
    }
    if (tableView.tag == 3) { //next view section header
        //fixing wallet..........
        NSMutableArray *resultOfIncome3 = [[accessData getIncomeWithStartDate:[self nextMonthCalculation:self.currentStartDate] endDate:[self nextMonthCalculation:self.currentEndDate]] mutableCopy];
        self.walletIncome3 = [self totalSumFromArray:resultOfIncome3];
        ////
        header.monthlyIncomeLabel.text = [NSString stringWithFormat:@"%.2f", self.walletIncome3];
        header.monthlyIncomeLabel.textColor = [UIColor blueColor];
    }
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([tableView.dataSource tableView:tableView numberOfRowsInSection:section] == 0) {
        return 0;
    } else {
        return 120;
    }
}

- (void) showNoDataView:(NSArray *)checkArray identifier:(int)tableIdentifier {
    if (![checkArray count]) {
        UITableView *tblView1 = [self.arrayTableView objectAtIndex:tableIdentifier];
        [tblView1 reloadData];
        UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Question_mark_Icon_64.png"]];
        [tempImageView setFrame:tblView1.frame];
        tblView1.backgroundView = tempImageView;
        [tblView1 reloadData];
    } else if ([checkArray count]) {
        UITableView *tblView1 = [self.arrayTableView objectAtIndex:tableIdentifier];
        tblView1.backgroundView.hidden = YES;
        [tblView1 reloadData];
    }
}

- (NSDate *)setStartDateFromCurrentDate {
    
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents* components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:[NSDate date]];
    [components setHour:06];
    return [calendar dateFromComponents:components];
}

- (NSDate *) nextMonthCalculation:(NSDate *)givenDate {
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents* components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:givenDate];
    
    [components setMonth:([components month] + 1)];
    [components setHour:06];

    return [calendar dateFromComponents:components];
}

- (NSDate *) previousMonthCalculation:(NSDate *)givenDate {
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:givenDate];
    [components setMonth:([components month] - 1)];
    [components setHour:06];
    
    return [calendar dateFromComponents:components];
}

- (float) totalSumFromArray:(NSMutableArray *)arrayTotal {
    float sum = 0.0;
    if ([arrayTotal count]) {
        sum = [[[arrayTotal valueForKey:@"amount"] valueForKeyPath:@"@sum.self"] floatValue];
    } else {
        sum = 0.0;
    }
    return  sum;
}

@end



