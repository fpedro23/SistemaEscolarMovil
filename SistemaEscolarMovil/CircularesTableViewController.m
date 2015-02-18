//
//  CircularesTableViewController.m
//  SistemaEscolarMovil
//
//  Created by Pedro Contreras Nava on 12/02/15.
//  Copyright (c) 2015 Pedro Contreras Nava. All rights reserved.
//

#import "CircularesTableViewController.h"
#import "ElementoEscolar.h"
#import "EventDetailViewController.h"
#import "ElementoTableViewCell.h"
@interface CircularesTableViewController ()
@property JSONHTTPClient *jsonClient;
@end

@implementation CircularesTableViewController
@synthesize updateControl;

-(void)JSONHTTPClientDelegate:(JSONHTTPClient *)client didFailResponseWithError:(NSError *)error{
    
    NSLog(@"Error : %@", [error localizedDescription]);
}

-(void)JSONHTTPClientDelegate:(JSONHTTPClient *)client didResponseToElements:(id)response{
    self.elementsData = response;
    [self reloadData];
}


-(void)viewDidAppear:(BOOL)animated{
    _jsonClient.delegate = self;
}

- (void)reloadData
{
    // Reload table data
    [self.tableView reloadData];
    
    // End the refreshing
    if (updateControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        updateControl.attributedTitle = attributedTitle;
        
        [updateControl endRefreshing];
    }
}


-(void)getLatestCirculars{
    [_jsonClient performPOSTRequestWithParameters:@{@"mobile":@"true"} toServlet:@"readCircular" withOptions:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _jsonClient = [JSONHTTPClient sharedJSONAPIClient];
    _jsonClient.delegate = self;
    [_jsonClient performPOSTRequestWithParameters:@{@"mobile":@"true"} toServlet:@"readCircular" withOptions:nil];
    //http://192.168.100.36:8080/SistemaEscolar/readCircular?mobile=true
    
    updateControl = [[UIRefreshControl alloc] init];
    updateControl.backgroundColor = [UIColor purpleColor];
    updateControl.tintColor = [UIColor whiteColor];
    [updateControl addTarget:self
                            action:@selector(getLatestCirculars)
                  forControlEvents:UIControlEventValueChanged];
    
    [self.tableView addSubview:updateControl];
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
    ElementoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ElementViewCell"];
    
    
    NSString *dateString = [NSDateFormatter localizedStringFromDate:[(ElementoEscolar*)[self.elementsData objectAtIndex:indexPath.row]  fecha]
                                                          dateStyle:NSDateFormatterLongStyle
                                                          timeStyle:NSDateFormatterNoStyle];
    dateString = [NSString stringWithFormat:@"Publicada el: %@" ,dateString];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.titleLabel.adjustsFontSizeToFitWidth = YES;
    cell.titleLabel.text = [(ElementoEscolar*)[self.elementsData objectAtIndex:indexPath.row] titulo];
    cell.remitenteLabel.text = [[(ElementoEscolar*)[self.elementsData objectAtIndex:indexPath.row] administrador]nombreAdministrador];
    cell.fechaEmisionLabel.text = dateString;
    
    
    //[cell.textLabel setText:[(ElementoEscolar*)[self.elementsData objectAtIndex:indexPath.row] titulo]];
    
    //[cell.detailTextLabel setText:[[(ElementoEscolar*)[self.elementsData objectAtIndex:indexPath.row] administrador ]nombreAdministrador]];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ElementoTableViewCell *cell = (ElementoTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];

    [self performSegueWithIdentifier:@"showCircular" sender:cell];

    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    EventDetailViewController *destinationViewController = (EventDetailViewController *)segue.destinationViewController;
    
    if([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath * indexPath = [self.tableView indexPathForCell:sender];
        //Your code here
        destinationViewController.elementoEscolar = [self.elementsData objectAtIndex:indexPath.row];
        
    }
    
}


@end
