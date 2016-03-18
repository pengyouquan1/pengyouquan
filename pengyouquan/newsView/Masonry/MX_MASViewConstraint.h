//
//  MASConstraint.h
//  Masonry
//
//  Created by Jonas Budelmann on 20/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "MX_MASViewAttribute.h"
#import "MX_MASConstraint.h"
#import "MX_MASLayoutConstraint.h"
#import "MASUtilities.h"

/**
 *  A single constraint.
 *  Contains the attributes neccessary for creating a NSLayoutConstraint and adding it to the appropriate view
 */
@interface MX_MASViewConstraint : MX_MASConstraint <NSCopying>

/**
 *	First item/view and first attribute of the NSLayoutConstraint
 */
@property (nonatomic, strong, readonly) MX_MASViewAttribute *firstViewAttribute;

/**
 *	Second item/view and second attribute of the NSLayoutConstraint
 */
@property (nonatomic, strong, readonly) MX_MASViewAttribute *secondViewAttribute;

/**
 *	initialises the MASViewConstraint with the first part of the equation
 *
 *	@param	firstViewAttribute	view.mas_left, view.mas_width etc.
 *
 *	@return	a new view constraint
 */
- (id)initWithFirstViewAttribute:(MX_MASViewAttribute *)firstViewAttribute;

/**
 *  Returns all MASViewConstraints installed with this view as a first item.
 *
 *  @param  view  A view to retrieve constraints for.
 *
 *  @return An array of MASViewConstraints.
 */
+ (NSArray *)installedConstraintsForView:(MAS_VIEW *)view;

@end
