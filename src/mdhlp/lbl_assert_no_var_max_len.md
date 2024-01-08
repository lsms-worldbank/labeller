# Title

__lbl_assert_no_var_max_len__ - Assert that there is no variable in memory whose variable length exceeds the desired character length.

# Syntax

__lbl_assert_no_var_max_len__ , __**max**len__(_integer_)

| _options_ | Description |
|-----------|-------------|
| __**max**len__(_integer_)   | Maximum character length allowed.

# Description

This command assert that there is no variable in memory whose variable label length exceeds the desired character length.

By default, the command take the maximum length to be Stata's maximum length for labels: 80 characters. If desired, the command can specify an alternative length through the __**max**len__(_integer_) option.

If there is at least one variable whose length exceeds the maximum length, the command will return an error and list the variables whose variable labels are too long.

# Options

__**max**len__(_integer_) sets the maximum length of variable labels.

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

* assert no variables with labels longer than default max length (80 characters)
lbl_assert_no_var_max_len

* assert no variables with labels longer than user-specified max length (80 characters)
lbl_assert_no_var_max_len, maxlen(12)
```

# Feedback, bug reports and contributions

Read more about the commands in this package at https://github.com/lsms-worldbank/labeller.

Please provide any feedback by opening an issue at https://github.com/lsms-worldbank/labeller/issues.

PRs with suggestions for improvements are also greatly appreciated.

# Authors

LSMS Team, The World Bank lsms@worldbank.org

