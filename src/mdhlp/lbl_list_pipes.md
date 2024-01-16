# Title

__lbl_list_pipes__ - Lists pipes in variable labels from Survey Solutions

# Syntax

__lbl_list_pipes__ , [__**ig**nore_pipes__(_string_) __**out**put_level__(_string_)]

| _options_ | Description |
|-----------|-------------|
| __**ig**nore_pipes__(_string_) | List of pipe names to be ignored |
| __**out**put_level__(_string_) | Toggle verbosity level in output |

# Description

Data collected with Survey Solutions (SuSo) commonly have pipes
in the format `%pipename%` in the variable label.
This command detects SuSo pipes in variable labels and outputs them.
The pipes can then be replaced with the `lbl_replace_pipe` command that
is also a part of the `labeller` package.

# Options

__**ig**nore_pipes__(_string_) is an option where the user can list pipes
that should not be included in the output.
List the pipe names in a single string in this format:

```
lbl_list_pipes, ignore_pipes("pipe1 pipe2")
```

__**out**put_level__(_string_) is an option that allows the user to
set how verbose the output should be.
The valid values for this option are
`minimal`, `verbose`, and `veryverbose`.
The default is `verbose`.

# Examples

This simple example first creates a data set where the pipe `%unit%` is
added to the variable label of the variable `mpg`.
Then the command `lbl_list_pipes` is used to detect and output this pipe.

```
* Create example data
sysuse auto, clear
label variable mpg "Mileage (%unit%)"

* List the pipes in the data
lbl_list_pipes, output_level(veryverbose)

```

# Feedback, Bug Reports, and Contributions

Read more about the commands in this package at https://github.com/lsms-worldbank/labeller.

Please provide any feedback by opening an issue at https://github.com/lsms-worldbank/labeller/issues.

PRs with suggestions for improvements are also greatly appreciated.

# Authors

LSMS Team, The World Bank lsms@worldbank.org
