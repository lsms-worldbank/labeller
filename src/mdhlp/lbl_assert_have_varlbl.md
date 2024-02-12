# Title

__lbl_assert_var_have_lbl__ - List variables without a variable label.

# Syntax

__lbl_assert_var_have_lbl__, [__**v**arlist__(_varlist_)]

| _options_ | Description |
|-----------|-------------|
| __**v**arlist__(_varlist_) | Restrict the scope of variables to consider |

# Description

For small data sets, visual inspection can identify variables without a variable label. For larger data sets (or repeat encounters with data sets), it is better to have a tool variables, if any, that remain without a variable label.

This command does that. If any variables without variable labels are found, it returns and error and lists which variables are missing variable labels. If all variables have variable labels, it reports this fact. In this way, the user knows whether action is needed, and for which variables.

# Options

__**v**arlist__(_varlist_) restricts the scope of the search to the user-provided variable list. By default, the command searches for matches in all variables in memory. With __varlist__(), the scope of the search can be narrowed.

# Examples

```
* create set of variables
gen var1 = .
gen var2 = .
gen var3 = .
gen var4 = .

* apply variable labels to only some variables
label variable var1 "Some label"
label variable var4 "Another label"

* assert that all variables have variable labels, globally
lbl_assert_var_have_lbl

* assert that all variables have variable labels, in the varlist
lbl_assert_var_have_lbl var3 - var4
```

# Feedback, bug reports and contributions

Read more about the commands in this package at https://github.com/lsms-worldbank/labeller.

Please provide any feedback by opening an issue at https://github.com/lsms-worldbank/labeller/issues.

PRs with suggestions for improvements are also greatly appreciated.

# Authors

LSMS Team, The World Bank lsms@worldbank.org
