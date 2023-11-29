# Title

__lbl_assert_no_pipes__ - Testing that no varaible labels has any pipes

# Syntax

__lbl_assert_no_pipes__ , [__**ig**norepipes__(_string_) __**out**putlevel__(_string_)]

| _options_ | Description |
|-----------|-------------|
| __**ig**norepipes__(_string_) | List of pipe names to be ignored |
| __**out**putlevel__(_string_) | Toggle verbosity level in output  |

# Description

Data collected with SurveySolution (SuSo) commonly have pipes
on the format `%pipename%` in the variable label.
This command tests if there are any such pipes in any labels in the dataset.
If there are any pipes, then this command throws an error.

This command is intended to be used in a work flow with
the commands `lbl_list_pipes` and
`lbl_replace_pipe` (both also in the `labeller` package).
After using `lbl_replace_pipe` to replace pipes
that was identified using  `lbl_replace_pipe`,
`lbl_assert_no_pipes` can be used to test that
all pipes have been addressed.

# Options

__**ig**norepipes__(_string_) is an option where the user can list pipes
that should not be ignored even if they are found in the dataset.
This command will not throw an error if all pipes currently in the dataset
is listed in this option.
List the pipe names in a single string on this format:

```
lab_pipe, ignorepipes("pipe1 pipe2")
```

__**out**putlevel__(_string_) is an option that allows the user to set how verbose the output should be. The valid values this option takes is `minimal`, `verbose` and `veryverbose`. The default is `verbose`.

# Examples

This simple example first creates a data set where the pipe `%unit%` is
added to the variable label of the variable `mpg`.
Then `lbl_replace_pipe` is used to replace `%unit%` in the label
with the value `miles per gallon`.
Finally, `lbl_assert_no_pipes` is used to confirm there are
no more pipes in any of the variable labels in the dataset.

```
* Create example data
sysuse auto, clear
label variable mpg "Mileage (%unit%)"

* Replace the unit pipe
lbl_replace_pipe, pipe("unit") replacement("miles per gallon")

* Test that the dataset no longer has any pipes
lbl_assert_no_pipes

```
# Feedback, bug reports and contributions

Read more about the commands in this package at https://github.com/lsms-worldbank/labeller.

Please provide any feed back by opening and issue at https://github.com/lsms-worldbank/labeller/issues.

PRs with suggestions for improvements are also greatly appreciated.

# Authors

LSMS Team, The World Bank lsms@worldbank.org
