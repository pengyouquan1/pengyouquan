//
//  UIView+MASAdditions.m
//  Masonry
//
//  Created by Jonas Budelmann on 20/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "View+MASAdditions.h"
#import <objc/runtime.h>

@implementation MAS_VIEW (MASAdditions)

- (NSArray *)mas_makeConstraints:(void(^)(MX_MASConstraintMaker *))block {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    MX_MASConstraintMaker *constraintMaker = [[MX_MASConstraintMaker alloc] initWithView:self];
    block(constraintMaker);
    return [constraintMaker install];
}

- (NSArray *)mas_updateConstraints:(void(^)(MX_MASConstraintMaker *))block {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    MX_MASConstraintMaker *constraintMaker = [[MX_MASConstraintMaker alloc] initWithView:self];
    constraintMaker.updateExisting = YES;
    block(constraintMaker);
    return [constraintMaker install];
}

- (NSArray *)mas_remakeConstraints:(void(^)(MX_MASConstraintMaker *make))block {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    MX_MASConstraintMaker *constraintMaker = [[MX_MASConstraintMaker alloc] initWithView:self];
    constraintMaker.removeExisting = YES;
    block(constraintMaker);
    return [constraintMaker install];
}

#pragma mark - NSLayoutAttribute properties

- (MX_MASViewAttribute *)mas_left {
    return [[MX_MASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLeft];
}

- (MX_MASViewAttribute *)mas_top {
    return [[MX_MASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeTop];
}

- (MX_MASViewAttribute *)mas_right {
    return [[MX_MASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeRight];
}

- (MX_MASViewAttribute *)mas_bottom {
    return [[MX_MASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeBottom];
}

- (MX_MASViewAttribute *)mas_leading {
    return [[MX_MASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLeading];
}

- (MX_MASViewAttribute *)mas_trailing {
    return [[MX_MASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeTrailing];
}

- (MX_MASViewAttribute *)mas_width {
    return [[MX_MASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeWidth];
}

- (MX_MASViewAttribute *)mas_height {
    return [[MX_MASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeHeight];
}

- (MX_MASViewAttribute *)mas_centerX {
    return [[MX_MASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeCenterX];
}

- (MX_MASViewAttribute *)mas_centerY {
    return [[MX_MASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeCenterY];
}

- (MX_MASViewAttribute *)mas_baseline {
    return [[MX_MASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeBaseline];
}

- (MX_MASViewAttribute *(^)(NSLayoutAttribute))mas_attribute
{
    return ^(NSLayoutAttribute attr) {
        return [[MX_MASViewAttribute alloc] initWithView:self layoutAttribute:attr];
    };
}

#if TARGET_OS_IPHONE

- (MX_MASViewAttribute *)mas_leftMargin {
    return [[MX_MASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLeftMargin];
}

- (MX_MASViewAttribute *)mas_rightMargin {
    return [[MX_MASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeRightMargin];
}

- (MX_MASViewAttribute *)mas_topMargin {
    return [[MX_MASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeTopMargin];
}

- (MX_MASViewAttribute *)mas_bottomMargin {
    return [[MX_MASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeBottomMargin];
}

- (MX_MASViewAttribute *)mas_leadingMargin {
    return [[MX_MASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLeadingMargin];
}

- (MX_MASViewAttribute *)mas_trailingMargin {
    return [[MX_MASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeTrailingMargin];
}

- (MX_MASViewAttribute *)mas_centerXWithinMargins {
    return [[MX_MASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeCenterXWithinMargins];
}

- (MX_MASViewAttribute *)mas_centerYWithinMargins {
    return [[MX_MASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeCenterYWithinMargins];
}

#endif

#pragma mark - associated properties

- (id)mas_key {
    return objc_getAssociatedObject(self, @selector(mas_key));
}

- (void)setMas_key:(id)key {
    objc_setAssociatedObject(self, @selector(mas_key), key, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - heirachy

- (instancetype)mas_closestCommonSuperview:(MAS_VIEW *)view {
    MAS_VIEW *closestCommonSuperview = nil;

    MAS_VIEW *secondViewSuperview = view;
    while (!closestCommonSuperview && secondViewSuperview) {
        MAS_VIEW *firstViewSuperview = self;
        while (!closestCommonSuperview && firstViewSuperview) {
            if (secondViewSuperview == firstViewSuperview) {
                closestCommonSuperview = secondViewSuperview;
            }
            firstViewSuperview = firstViewSuperview.superview;
        }
        secondViewSuperview = secondViewSuperview.superview;
    }
    return closestCommonSuperview;
}

@end
