//
//  AvisosTableViewController.m
//  SistemaEscolarMovil
//
//  Created by Pedro Contreras Nava on 13/02/15.
//  Copyright (c) 2015 Pedro Contreras Nava. All rights reserved.
//

#import "AvisosTableViewController.h"
#import "ElementoEscolar.h"
@interface AvisosTableViewController ()
@property JSONHTTPClient *jsonClient;
@end

@implementation AvisosTableViewController

-(void)JSONHTTPClientDelegate:(JSONHTTPClient *)client didFailResponseWithError:(NSError *)error{
    
    NSLog(@"Error : %@", [error localizedDescription]);
}

-(void)viewDidAppear:(BOOL)animated{
    _jsonClient.delegate = self;
}


-(void)JSONHTTPClientDelegate:(JSONHTTPClient *)client didResponseToElements:(id)response{
    self.elementsData = response;
    [self reloadData];
}

- (void)reloadData
{
    // Reload table data
    [self.tableView reloadData];
    
    // End the refreshing
    if (self.refreshControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
        
        [self.refreshControl endRefreshing];
    }
}


-(void)getLatestAvisos{
    [_jsonClient performPOSTRequestWithParameters:@{@"mobile":@"true"} toServlet:@"readAvisos" withOptions:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _jsonClient = [JSONHTTPClient sharedJSONAPIClient];
    _jsonClient.delegate = self;
    [_jsonClient performPOSTRequestWithParameters:@{@"mobile":@"true"} toServlet:@"readAvisos" withOptions:nil];
    //http://192.168.100.36:8080/SistemaEscolar/readCircular?mobile=true
    
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(getLatestAvisos)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.elementsData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSString *dateString = [NSDateFormatter localizedStringFromDate:[(ElementoEscolar*)[self.elementsData objectAtIndex:indexPath.row]  fecha]
                                                          dateStyle:NSDateFormatterMediumStyle
                                                          timeStyle:NSDateFormatterNoStyle];
    dateString = [NSString stringWithFormat:@"Fecha de Publicación: %@" ,dateString];
    
    
    UILabel *titulo =(UILabel*)[cell.contentView viewWithTag:1];
    UILabel *fecha =(UILabel*)[cell.contentView  viewWithTag:2];
    UILabel *remitente =(UILabel*)[cell.contentView  viewWithTag:3];
    
    
    
    // Configure the cell...
    [titulo setText:[(ElementoEscolar*)[self.elementsData objectAtIndex:indexPath.row] titulo]];
    [fecha setText: dateString];
    fecha.adjustsFontSizeToFitWidth = YES;
    cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    [remitente setText:[(ElementoEscolar*)[self.elementsData objectAtIndex:indexPath.row] remitente]];
    remitente.adjustsFontSizeToFitWidth =YES;
    
    return cell;
}


@end
