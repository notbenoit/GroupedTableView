GroupedTableView
================

A UITableView subclass to mimic iOS6 Grouped UITableView style.

## Usage
Simple change the type of your UITableView to GroupedTableView if using a nib. Or you can directly instantiate a GroupedTableView as you would do with a standard UITableView.

## Known issue
The trick to reduce the width of the tableview uses the frame property. If using auto-layout, this won't work. It'up to you to modify this behaviour in code, or directly set the desired width in your nib/storyboard.
