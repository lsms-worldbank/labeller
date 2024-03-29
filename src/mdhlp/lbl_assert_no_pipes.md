# Title

__lbl_assert_no_pipes__ - Asserts that no variable labels have any pipes

# Syntax

__lbl_assert_no_pipes__ , [__**ig**nore_pipes__(_string_) __**out**put_level__(_string_) __**v**arlist__(_varlist_)]

| _options_ | Description |
|-----------|-------------|
| __**ig**nore_pipes__(_string_) | List of pipe names to be ignored |
| __**out**put_level__(_string_) | Toggle verbosity level in output  |
| __**v**arlist__(_varlist_) | Restrict the scope of variables to consider |

# Description

Data collected with SurveySolution (SuSo) commonly have pipes
in the format `%pipename%` in the variable label.
This command tests if there are any such pipes
in any labels in the dataset.
If there are any pipes, then this command throws an error and lists those remaining pipes.

This command is intended to be used in a workflow with the commands
`lbl_list_pipes` and `lbl_replace_pipe` (both also in the `labeller` package).
After using `lbl_replace_pipe` to replace pipes that were
identified using `lbl_replace_pipe`,
`lbl_assert_no_pipes` can be used to test that all pipes
have been addressed.

# Options

__**ig**nore_pipes__(_string_) is an option where the user can
list pipes that should not be ignored
even if they are found in the dataset.
This command will not throw an error if all pipes currently
in the dataset are listed in this option.
List the pipe names in a single string in this format:

```
lab_pipe, ignore_pipes("pipe1 pipe2")
```

__**out**put_level__(_string_) is an option that allows the user to
set how verbose the output should be.
The valid values for this option are
`minimal`, `verbose`, and `veryverbose`. The default is `verbose`.

__**v**arlist__(_varlist_) restricts the scope of the search to the user-provided variable list. By default, the command searches for matches in all variables in memory. With __varlist__(), the scope of the search can be narrowed.

# Examples

This simple example first creates a data set where
the pipe `%unit%` is added to the variable label of the variable `mpg`.
Then `lbl_replace_pipe` is used to replace `%unit%` in the label with
the value `miles per gallon`.
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

# Feedback, Bug Reports, and Contributions

Read more about the commands in this package at https://github.com/lsms-worldbank/labeller.

Please provide any feedback by opening an issue at https://github.com/lsms-worldbank/labeller/issues.

PRs with suggestions for improvements are also greatly appreciated.

# Authors

LSMS Team, The World Bank lsms@worldbank.org
