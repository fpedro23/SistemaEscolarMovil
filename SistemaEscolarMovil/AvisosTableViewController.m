//
//  AvisosTableViewController.m
//  SistemaEscolarMovil
//
//  Created by Pedro Contreras Nava on 13/02/15.
//  Copyright (c) 2015 Pedro Contreras Nava. All rights reserved.
//

#import "AvisosTableViewController.h"
#import "ElementoEscolar.h"
#import "Administrador.h"
#import "ElementoTableViewCell.h"
#import "EventDetailViewController.h"
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
    [_jsonClient performPOSTRequestWithParameters:nil toServlet:@"mobileReadAvisos" withOptions:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _jsonClient = [JSONHTTPClient sharedJSONAPIClient];
    _jsonClient.delegate = self;
    [_jsonClient performPOSTRequestWithParameters:nil toServlet:@"mobileReadAvisos" withOptions:nil];
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
    
    [self performSegueWithIdentifier:@"showAviso" sender:cell];
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    EventDetailViewController *destinationViewController = (EventDetailViewController *)segue.destinationViewController;
    
    if([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath * indexPath = [self.tableView indexPathForCell:sender];
        //Your code here
        destinationViewController.elementoEscolar = [self.elementsData objectAtIndex:indexPath.row];
        destinationViewController.isEvent = NO;

        
    }
    
}


@end
