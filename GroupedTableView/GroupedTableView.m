//
//  GroupedTableView.m
//  GroupedTableView
//
//  Created by Benoit Layer on 28/02/14.
//  Copyright (c) 2014 Benoit Layer. All rights reserved.
//

#import "GroupedTableView.h"

#define IS_IOS7_AND_UP() ([[UIDevice currentDevice].systemVersion floatValue] >= 7.f)

@implementation GroupedTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Apply our modification only on iOS7 and above
    if (self.style == UITableViewStyleGrouped && IS_IOS7_AND_UP())
    {
        // For each section, we round the first and last cell
        NSInteger numberOfSections = [self.dataSource numberOfSectionsInTableView:self];
        for (int i = 0 ; i < numberOfSections ; i++)
        {
            static CGFloat cornerRadius = 8.f;
            
            // Get first and last cell
            NSInteger numberOfRows = [self.dataSource tableView:self numberOfRowsInSection:i];
            UITableViewCell *topCell = [self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
            UITableViewCell *bottomCell = [self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:numberOfRows-1 inSection:i]];
            
            // If there is a single row, we round the cell by each corner
            if (topCell == bottomCell)
            {
                CAShapeLayer *shape = [[CAShapeLayer alloc] init];
                shape.path = [UIBezierPath bezierPathWithRoundedRect:topCell.bounds
                                                        cornerRadius:cornerRadius].CGPath;
                topCell.layer.mask = shape;
                topCell.layer.masksToBounds = YES;
            }
            else
            {
                // Create the top mask we will apply on the cell to round it.
                CAShapeLayer *topShape = [[CAShapeLayer alloc] init];
                topShape.path = [UIBezierPath bezierPathWithRoundedRect:topCell.bounds
                                                      byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight
                                                            cornerRadii:CGSizeMake(cornerRadius, cornerRadius)].CGPath;
                topCell.layer.mask = topShape;
                topCell.layer.masksToBounds = YES;
                
                // Create the bottom mask we will apply on the cell to round it.
                CAShapeLayer *bottomShape = [[CAShapeLayer alloc] init];
                bottomShape.path = [UIBezierPath bezierPathWithRoundedRect:bottomCell.bounds
                                                         byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight
                                                               cornerRadii:CGSizeMake(cornerRadius, cornerRadius)].CGPath;
                bottomCell.layer.mask = bottomShape;
                bottomCell.layer.masksToBounds = YES;
            }
            
            // For performance issue, and to avoid offscreen rendering, we rasterize our layers.
            topCell.layer.shouldRasterize = YES;
            topCell.layer.rasterizationScale = [[UIScreen mainScreen] scale];
            bottomCell.layer.shouldRasterize = YES;
            bottomCell.layer.rasterizationScale = [[UIScreen mainScreen] scale];
            
            // Because the TableView reuses some cells, we don't want our middle cells to be rounded,
            // so we force their mask to be nil (not a random rounded one).
            for (int j = 1 ; j < numberOfRows-1 ; j++)
            {
                UITableViewCell *cell = [self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
                cell.layer.mask = nil;
                cell.layer.shouldRasterize = NO;
            }
        }
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    if (newSuperview && self.style == UITableViewStyleGrouped && IS_IOS7_AND_UP())
    {
        // Side margin
        CGFloat sideOffset = 8.f;
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.separatorInset = UIEdgeInsetsZero;
        self.frame = CGRectInset(self.frame, sideOffset, 0.f);
    }
}

@end
