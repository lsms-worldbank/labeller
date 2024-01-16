# Title

__lbl_replace_pipe__ - Replaces pipes in variable labels with user-provided value

# Syntax

__lbl_replace_pipe__ , __pipe__(_string_) __**rep**lacement__(_string_) [__**trun**cate__(_string_) __**out**put_level__(_string_) __missing_ok__]

| _options_ | Description |
|-----------|-------------|
| __pipe__(_string_) | The name of the pipe to be replaced |
| __**rep**lacement__(_string_) | The value the pipe should be replaced with |
| __**trun**cate__(_string_) | Toggle behavior when the new label is too long |
| __**out**put_level__(_string_) | Toggle verbosity level in output |
| __missing_ok__ | Suppresses error when the pipe does not exist in any variable label  |

# Description

Data collected with Survey Solutions (SuSo) commonly have pipes in
the format `%pipename%` in the variable label.
This command can be used to replace such pipes with a value provided by the user.

This command is intended to be used together with
the command `lbl_list_pipes` (also in the `labeller` package).
The `lbl_list_pipes` command can be used to list
which pipes exist in the dataset,
and then `lbl_replace_pipe` can be used to replace the pipes.

`lbl_replace_pipe` can only replace one pipe at a time.
When more than one pipe exists in a dataset,
then this command is intended to be repeated once per pipe.

# Options

__pipe__(_string_) is the option that indicates which pipe
should be replaced.
This option only allows exactly one pipe at a time.
It is optional to include the `%` tags,
so the pipe can either be included as `%pipename%` or `pipename`.

__**rep**lacement__(_string_) is the value that the pipe
should be replaced with.
It can be any string allowed in a variable label.
However, since variable labels in Stata are not allowed to be
longer than 80 characters, the replacement value should not be too long.

__**trun**cate__(_string_) is an option that lets the user decide
what should happen if a label is too long after
the pipe has been replaced with the new value.
The options are `error` (the command throws an error and exits),
`warning` (the command outputs a warning and continues), and
`prompt` (the command asks the user to interactively confirm each case).
The default is `error`.

__**out**put_level__(_string_) is an option that allows the user to
set how verbose the output should be.
The valid values for this option are
`minimal`, `verbose`, and `veryverbose`.
The default is `verbose`.

__missing_ok__ suppresses the error thrown if a pipe the user is trying to
replace does not exist in any variable label in the dataset.
The default behavior is that the code is interrupted
with an error if the pipe does not exist.

# Examples

This simple example first creates a data set where
the pipe `%unit%` is added to the variable label of the variable `mpg`.
Then `lbl_replace_pipe` is used to replace `%unit%` in the label
with the value `miles per gallon`.

```
*Create example data
sysuse auto, clear
label variable mpg "Mileage (%unit%)"

*Replace the unit pipe
lbl_replace_pipe, pipe("unit") replacement("miles per gallon") ///
   output_level(veryverbose)

```

# Feedback, Bug Reports, and Contributions

Read more about the commands in this package at https://github.com/lsms-worldbank/labeller.

Please provide any feedback by opening an issue at https://github.com/lsms-worldbank/labeller/issues.

PRs with suggestions for improvements are also greatly appreciated.

# Authors

LSMS Team, The World Bank lsms@worldbank.org
