# Title

__lab_pipe__ - A command to replace SurveySolution pipes in variable labels

# Syntax

__lab_pipe__ , [__**pipev**alues__(_string_) __**ignorep**ipes__(_string_) __**out**putlevel__(_string_) __**trun**cate__(_string_)]

| _options_ | Description |
|-----------|-------------|
| __**pipev**alues__(_string_)  | Provide values the pipes will be replaced with  |
| __**ignorep**ipes__(_string_) | List pipe names to be ignored  |
| __**out**putlevel__(_string_) | Toggle verbosity level in output |
| __**trun**cate__(_string_)    | Toggle behavior when new label is too long |

# Description

This command detects SurveySolution (SuSo) pipes in variable labels.
Data collected with SuSo commonly have pipes on the format `%pipename%`
in the variable label.
This is a value that during the SuSo data collection replaced on the screen
for the enumerator during the survey with a value from a previous question.
This command detects such pipes and offer the user to replace
the pipe with a more human friendly value.

# Options

__**pipev**alues__(_string_) is the option where the user provide the values that the pipe should be replaced with. The string in this option must be on this format of a compounded string. See example below. Pipes are always one word but the value may have several words. The value may not include a double quote (`"`).

```
lab_pipe, pipevalues(`" "<pipe1> <value1>" "<pipe2> <value2>" "')
```

__**ignorep**ipes__(_string_) is an option where the user can list pipes that should be ignored. List the pipe names in a single string on this format: `"pipe1 pipe2"`

__**out**putlevel__(_string_) is an option that allows the user to set how verbose the output should be. The valid values this option takes is `minimal`, `verbose` and `veryverbose`. The default is `verbose`

__**trun**cate__(_string_) is an option that let the user decide what should happen if a label is too long after the pipe has been replaced with the new value. The options are `error` (the commands throws an error and exits), `warning` (the command outputs a warning and continues) and `prompt` (the command askes the user to interactively confirm each case).

# Examples

## Example 1

This simple example creates a data set and shows how `lab_pipe`
detects the pipe in the variable `mpg`
```
* Create example data
sysuse auto, clear
label variable mpg "Mileage (%unit%)"

* List the pipes in the data
lab_pipe

* Display the label of mpg
describe mpg
```

## Example 2

The intended workflow is that after a pipe has been detected,
as in example 1 above, the command can be used to replace the pipe
with a more human readable value next time the same code is run.
In this example the pipe `%unit%` is replaced with the value `mpg`.

```
* Create example data
sysuse auto, clear
label variable mpg "Mileage (%unit%)"

* List the pipes in the data
lab_pipe, pipevalues(`" "unit miles per galleon" "')

* Display the label of mpg
describe mpg
```

# Feedback, bug reports and contributions

Read more about the commands in this package at https://github.com/lsms-worldbank/labeller.

Please provide any feed back by opening and issue at https://github.com/lsms-worldbank/labeller/issues.

PRs with suggestions for improvements are also greatly appreciated.

# Authors

LSMS Team, The World Bank lsms@worldbank.org
