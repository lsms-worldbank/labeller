# Title

__lbl_drop_unused_lbls__ - Drop value labels not attached to any variable.

# Syntax

__lbl_drop_unused_lbls__ , [__**c**onfirm__]

# Description

When attached to variables, value labels are an essential part of data documentation. Left unused, they create clutter and, potentially, confusion.

To eliminate any unattached value labels, drop them with `lbl_drop_unused_lbls`. To check for and inspect unattached value labels, use `lbl_list_unused_lbls`.

# Options

__**c**onfirm__ lists unused value labels and confirms whether the user indeed wants to drop them. When prompted, the user should type `y` for yes or `n` for no. With this response, the command will perform the appropriate action.

# Examples

```
* create one variable
gen v1 = .

* define more than one value label set
label define v1 1 "yes" 2 "no", modify
label define v3 1 "oui" 2 "non", modify
label define v4 1 "evet" 2 "hayır", modify

* attach one value label, but not the others
label values v1 v1

* drop the value labels not attached (aka unused)
* if in doubt, ask first
lbl_drop_unused_lbls, confirm
n
* if intrepid, drop without asking
lbl_drop_unused_lbls
```

# Feedback, Bug Reports, and Contributions

Read more about the commands in this package at https://github.com/lsms-worldbank/labeller.

Please provide any feedback by opening an issue at https://github.com/lsms-worldbank/labeller/issues.

PRs with suggestions for improvements are also greatly appreciated.

# Authors

LSMS Team, The World Bank lsms@worldbank.org
