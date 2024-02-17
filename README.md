# `labeller`

<img src='src/dev/assets/logo.png' align="right" height="139" />

<!-- badges: start -->
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

The goal of labeller is find, fix, and double-check common issues that arise when documenting data. This package is useful wherever variable and value labels are found, but particularly useful where those labels have been generated by [Survey Solutions](https://mysurvey.solutions/).

Note also: while this package does not require [selector](https://github.com/lsms-worldbank/selector), some commands in labeller do leverage the questionnaire metadata that selector adds to survey metadata.

## Commands

| Command | Description |
| --- | --- |
| [labeller](https://lsms-worldbank.github.io/labeller/reference/labeller.html) | Package command with utilities for the rest of the package
| [lbl_assert_no_long_varlbl](https://lsms-worldbank.github.io/labeller/reference/lbl_assert_no_long_varlbl.html) | Assert that there is no variable in memory whose variable length exceeds the desired character length. |
| [lbl_assert_no_pipes](https://lsms-worldbank.github.io/labeller/reference/lbl_assert_no_pipes.html) | Asserts that no variable labels have any pipes |
| [lbl_assert_have_varlbl](https://lsms-worldbank.github.io/labeller/reference/lbl_assert_have_varlbl.html) | List variables without a variable label. |
| [lbl_list_long_varlbl](https://lsms-worldbank.github.io/labeller/reference/lbl_list_long_varlbl.html) | List variables whose variable label is longer than the desired character length. |
| [lbl_list_matching_vars](https://lsms-worldbank.github.io/labeller/reference/lbl_list_matching_vars.html) | Identify variables whose label matches a pattern. |
| [lbl_list_matching_vals](https://lsms-worldbank.github.io/labeller/reference/lbl_list_matching_vals.html) | List value labels whose labels match a pattern. |
| [lbl_list_no_varlbl](https://lsms-worldbank.github.io/labeller/reference/lbl_list_no_varlbl.html) | List variables without a variable label. |
| [lbl_list_pipes](https://lsms-worldbank.github.io/labeller/reference/lbl_list_pipes.html) | Lists pipes in variable labels from Survey Solutions. |
| [lbl_replace_pipe](https://lsms-worldbank.github.io/labeller/reference/lbl_replace_pipe.html) | Replaces pipes in variable labels with user-provided value |

##  Installation

To install the latest published version of the package:

```stata
* install the package from the SSC package repository
ssc install labeller
```

To update the package:

```stata
* check for updates
* if any are available, apply them
adoupdate labeller
```

If there are updates, Stata will instruct you how to apply them.

### Development version

The version of `labeller` on SSC corresponds to the code in the `main` branch of [the package's GitHub repository](https://github.com/lsms-worldbank/labeller).

To get a bug fix or test bleeding-edge features, you can install code from other branches of the repository. To install the version in a particular branch:

```stata
* set tag to be the name of the target branch
* for example, the development branch, which contains code for the next release
local tag "dev"
* download the code from that GitHub branch
* install the package
net install labeller, ///
  from("https://raw.githubusercontent.com/lsms-worldbank/labeller/`tag'/src") replace
```

### Previous versions

If you need to install a previously releases version of `labeller`, then you can use the following method. This can be useful, for example, during reproducibility verifications. To install the version in a particular release, set the local `tag` to the target release you want to install in this code:

```stata
* set the tag to the name of the target release
* for example v1.0, say, if the current version were v2.0
local tag "v1.0"
* download the code from that GitHub release
* install the package
net install labeller, ///
  from("https://raw.githubusercontent.com/lsms-worldbank/labeller/`tag'/src") replace
```

## Usage

More details on

- [What](#what) objects labeller manages
- [How](#how) it manages those objects

### What

- [Variable labels](#variable-labels)
- [Value labels](#value-labels)

#### Variable labels

```stata
* missing
lbl_list_no_varlbl

* too long
lbl_list_long_varlbl, maxlen(80)

* contains text...
* ... SuSo pipes
lbl_list_pipes
* ... some text
lbl_matches_vars "string to find"
```

#### Value labels

```stata
* unused
lbl_list_unused_lbls, verbose

* too long
lbl_list_long_vallbl, max(100)

* contains text
* for example, French characters
lbl_list_matching_vals, pattern("[àâäÀÂÄéèêëÉÈÊËîïôöÔÖùûüçÇ]")
```

### How

Provides functions for the full data documentation workflow:

- [List](#list) problems
- [Fix](#fix) them
- [Assert](#assert) everything has been addressed

#### List

Step 1: Take stock of the problem's scope

```stata
* list all pipes and all variables with those pipes
lbl_list_pipe
```

#### Fix

Step 2: Treat problems where they appear

```stata
* replace "%rostertitle% with "[NAME]" in all variable labels
lbl_replace_pipe, ///
  pipe("%rostertitle%") ///
  replacement("[NAME]")
```

#### Assert

Step 3: Confirm that all problems have been resolved

```stata
lbl_assert_no_pipes
```

## Learn more

To learn more about the package:

- Consult the reference documentation
- Read how-to articles

## Contact

LSMS Team, World Bank
lsms@worldbank.org
