# Title

__lbl_list_unused_val_lbls__ - List value labels not attached to any variable.

# Syntax

__lbl_list_unused_val_lbls__ , [__**v**erbose__]

| _options_ | Description |
|-----------|-------------|
| __**v**erbose__   | Prints the contents of unused value labels with `label list`.  |

# Description

When attached to variables, value labels are an essential part of data documentation. Left unused, they create clutter and, potentially, confusion.

To tidy a data set, data producers should manage value label sets well. 
But in order to tidy, one needs an inventory of the things that need tidying. To that end, `lbl_list_unused_val_lbls` lists all value label sets that are unused--in other words, that need to be either attached to a variable or dropped.

# Options

__**v**erbose__ provides the user with more details on unused value labels by printing their contents with `label list`. In this way, the user can decide what should be done with unused labels (e.g. attach them to variables, drop them, etc).

# Examples

## Example 1: List unused value labels

```
* create one variable
gen v1 = .

* define more than one value label set
label define v1 1 "yes" 2 "no", modify
label define v3 1 "oui" 2 "non", modify
label define v4 1 "evet" 2 "hayır", modify

* attach one value label, but not the others
label values v1 v1

* list the value labels not attached (aka unused)
lbl_list_unused_val_lbls
```

## Example 2: List unused value labels and print their contents

```
* ... continuing from example 1
* print the contents of the unused labels
lbl_list_unused_val_lbls, verbose
```

# Feedback, Bug Reports, and Contributions

Read more about the commands in this package at https://github.com/lsms-worldbank/labeller.

Please provide any feedback by opening an issue at https://github.com/lsms-worldbank/labeller/issues.

PRs with suggestions for improvements are also greatly appreciated.

# Authors

LSMS Team, The World Bank lsms@worldbank.org
