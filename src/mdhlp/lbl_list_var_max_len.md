# Title

__lbl_list_var_max_len__ - List variables whose variable label is longer than the desired character length.

# Syntax

__lbl_list_var_max_len__ , __**max**len__(_integer_)

| _options_ | Description |
|-----------|-------------|
| __**max**len__(_integer_)   | Maximum character length allowed.

# Description

When variable labels are too long, Stata truncates them to the first 80 characters of the string provided. This situation might arise for data exported from Survey Solutions. If provided, Survey Solutions uses the Variable label field in Designer, whose length is capped at 80 characters (in line with Stata's limits). If no label is specified in that field, Survey Solutions uses the Question text field, whose length maximum length is 2,000 characters. In the latter case, Survey Solutions uses the first 80 characters of the question text as its label.

To detect possible cases of truncation, data producers can check the length of each variable label individually (e.g., `local var_lbl : variable label my_var; local lbl_len : ustrlen local var_lbl`).

However, there is no base Stata operation for doing so in batch.

This command provides just such a tool.

By default, the command take the maximum length to be Stata's maximum length for labels: 80 characters. If desired, the command can specify an alternative length through the __**max**len__(_integer_) option.

# Options

__**max**len__(_integer_) sets the maximum length of variable labels, beyond which a variable is listed by this command.

# Examples

```
* create set of variables
gen var1 = .
gen var2 = .
gen var3 = .
gen var4 = .
gen var5 = .

* apply variables
label variable var1 "Short label"
label variable var2 "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
label variable var3 "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"
label variable var4 "Another short label"
label variable var5 "你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好"

* list variables with longer than the default max length (80 characters)
lbl_list_var_max_len

* list variables with longer than the user-specified max length
lbl_list_var_max_len, maxlen(12)
```

# Feedback, bug reports and contributions

Read more about the commands in this package at https://github.com/lsms-worldbank/labeller.

Please provide any feedback by opening an issue at https://github.com/lsms-worldbank/labeller/issues.

PRs with suggestions for improvements are also greatly appreciated.

# Authors

LSMS Team, The World Bank lsms@worldbank.org
