# Title

__lbl_use_meta__ - This command accesses metadata and, optionally, uses it to set the value of data attributes.

# Syntax

__lbl_use_meta__ , __**v**arlist__(_varlist_) __**from**_meta__(_string_) [ __**tem**plate__(_string_) __**app**ly_to__(_string_) __**miss**ing_ok__ ]

| _options_ | Description |
|-----------|-------------|
| __**v**arlist__(_varlist_) | Lists the variables this command should be applied to |
| __**from**_meta__(_string_) | The name of the metadata the command should use |
| __**tem**plate__(_string_) | A template that the metadata value should be combined with |
| __**app**ly_to__(_string_) | Provide the name of the data attribute to which the template will be applied |
| __**miss**ing_ok__ | Suppresses the error thrown if no variable in __varlist()__ has a `char` with the name used in __from_meta()__ |

# Description

This command tackles two related tasks: first, accessing metadata (e.g., question text, answer text, etc.); and second, applying that retrieved metadata to the attributes of in-memory data sets (e.g., variable label).

As a getter, this command retrieves metadata stored in [chars](https://www.stata.com/manuals/pchar.pdf). While intended to be used in combination with metadata added by the [sel_add_metadata](https://lsms-worldbank.github.io/selector/reference/sel_add_metadata.html), this command will work with any other `char` value as well.

As a setter, this command can also set the value of data attributes using the the retrieved metadata. In the most basic case, it retrieves metadata and sets the value of a user-specified data attribute--for example, retrieving `question_text` for a variable and applying that string to the variable label. In other cases, it can retrieve metadata and set the value of a data attribute using a template (see the `template()` option below)--for example, retrieving the `answer_text` of a multi-select question and applying it to the variable label (e.g., `"Water source: {META}"`). And in still other cases, it can effortlessly perform this operation in batch--for example, identifying all questions derived from a multi-select question in Survey Solutions (through the `varlist(asset_owned*)` option), retrieving their `answer_text` metadata (through the `from_meta()` option), and applying that metadata to the variable label through sensible string template (via `apply_to("varlabel") template("Asset: {META}")`).

# Options

__**v**arlist__(_varlist_) lists the variables this command should be applied to. It can either be a single variable or a list of variables.

__**from**_meta__(_string_) indicates the name of the metadata the command should use. This metadata is expected to be saved in a [char](https://www.stata.com/manuals/pchar.pdf) with the same name as the metadata. The command [sel_add_metadata](https://lsms-worldbank.github.io/selector/reference/sel_add_metadata.html) stores Survey Solution metadata this way.

__**tem**plate__(_string_) allows the user to provide a template describing how the metadata should be writen into the template. The template should be a single string and must include `{META}`, a placeholder indicating where that the metadata value will written. See below for an example.

__**app**ly_to__(_string_) indicates that the template should be applied to a variable label for that variable. If the option `template()` is used, then the metadata value in combination with the template will be used. The only valid value this option accepts is `varlabel`. Future versions of this command might allow more options.

__**miss**ing_ok__ suppresses the error thrown if no variable in __varlist()__ has a `char` with the name used in __from_meta()__. Variables in __varlist()__ without the relevant `char` will be ignored by this command.

# Examples

Set up example data used in all examples below:

```
clear

gen region1 = .
gen region2 = .
gen region3 = .
gen region4 = .

char region1[region] "North"
char region2[region] "East"
char region3[region] "South"
char region4[region] "West"

char region2[other] "something"

char list
```

## Example 1: Retrieve a metadata value

This example use the example data set up above. It takes the meta data value in `other` for the variable `region2` and stores it in a returned local.

```
* retrieve the metadata name `other`
* return it to a macro
lbl_use_meta, varlist(region2) from_meta(other)
return list
```

## Example 2: Set the variable label of a single variable with a template

```
* retrieve the metadata named `other` and
* apply it to the variable label for variable `region2`
* with a template
lbl_use_meta, varlist(region2) from_meta(other) ///
  template("This meta value is {META}. Does it look correct?") ///
  apply_to("varlabel")
return list
```

## Example 3: Set the variable label of multiple variables at once with a template
This example use the example data set up above. It takes the meta data value in `region` for each variable, and applies it to the template `Region: {META}`. And then it stores the respective result for each variable in its variable label.

```
* retrieve the metadata named `region` and
* apply it to the variable label for ALL variables matching `region?`
* with a template
lbl_use_meta, varlist(region?) from_meta(region) ///
  template("Region: {META}") apply_to("varlabel")
return list
describe
```

# Feedback, Bug Reports, and Contributions

Read more about the commands in this package at https://github.com/lsms-worldbank/labeller.

Please provide any feedback by opening an issue at https://github.com/lsms-worldbank/labeller/issues.

PRs with suggestions for improvements are also greatly appreciated.

# Authors

LSMS Team, The World Bank lsms@worldbank.org
