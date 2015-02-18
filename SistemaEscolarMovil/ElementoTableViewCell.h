//
//  ElementoTableViewCell.h
//  SistemaEscolarMovil
//
//  Created by Pedro Contreras Nava on 17/02/15.
//  Copyright (c) 2015 Pedro Contreras Nava. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ElementoTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *remitenteLabel;
@property (nonatomic, weak) IBOutlet UILabel *fechaEmisionLabel;

@end
