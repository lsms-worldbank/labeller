{smcl}
{* 01 Jan 1960}{...}
{hline}
{pstd}help file for {hi:lbl_replace_pipe}{p_end}
{hline}

{title:Title}

{phang}{bf:lbl_replace_pipe} - Replaces pipes in variable labels with user-provided value
{p_end}

{title:Syntax}

{phang}{bf:lbl_replace_pipe} , {bf:pipe}({it:string}) {bf:{ul:rep}lacement}({it:string}) [{bf:{ul:trun}cate}({it:string}) {bf:{ul:out}put_level}({it:string}) {bf:missing_ok} {bf:{ul:v}arlist}({it:varlist})]
{p_end}

{synoptset 20}{...}
{synopthdr:options}
{synoptline}
{synopt: {bf:pipe}({it:string})}The name of the pipe to be replaced{p_end}
{synopt: {bf:{ul:rep}lacement}({it:string})}The value the pipe should be replaced with{p_end}
{synopt: {bf:{ul:trun}cate}({it:string})}Toggle behavior when the new label is too long{p_end}
{synopt: {bf:{ul:out}put_level}({it:string})}Toggle verbosity level in output{p_end}
{synopt: {bf:missing_ok}}Suppresses error when the pipe does not exist in any variable label{p_end}
{synopt: {bf:{ul:v}arlist}({it:varlist})}Restrict the scope of variables to consider{p_end}
{synoptline}

{title:Description}

{pstd}Data collected with Survey Solutions (SuSo) commonly have pipes in
the format {inp:%pipename%} in the variable label. 
This command can be used to replace such pipes with a value provided by the user.
{p_end}

{pstd}This command is intended to be used together with
the command {inp:lbl_list_pipes} (also in the {inp:labeller} package). 
The {inp:lbl_list_pipes} command can be used to list 
which pipes exist in the dataset,
and then {inp:lbl_replace_pipe} can be used to replace the pipes. 
{p_end}

{pstd}{inp:lbl_replace_pipe} can only replace one pipe at a time. 
When more than one pipe exists in a dataset,
then this command is intended to be repeated once per pipe.
{p_end}

{title:Options}

{pstd}{bf:pipe}({it:string}) is the option that indicates which pipe
should be replaced.
This option only allows exactly one pipe at a time.
It is optional to include the {inp:%} tags, 
so the pipe can either be included as {inp:%pipename%} or {inp:pipename}. 
{p_end}

{pstd}{bf:{ul:rep}lacement}({it:string}) is the value that the pipe
should be replaced with.
It can be any string allowed in a variable label.
However, since variable labels in Stata are not allowed to be
longer than 80 characters, the replacement value should not be too long.
{p_end}

{pstd}{bf:{ul:trun}cate}({it:string}) is an option that lets the user decide
what should happen if a label is too long after
the pipe has been replaced with the new value.
The options are {inp:error} (the command throws an error and exits), 
{inp:warning} (the command outputs a warning and continues), and 
{inp:prompt} (the command asks the user to interactively confirm each case). 
The default is {inp:error}. 
{p_end}

{pstd}{bf:{ul:out}put_level}({it:string}) is an option that allows the user to
set how verbose the output should be.
The valid values for this option are
{inp:minimal}, {inp:verbose}, and {inp:veryverbose}. 
The default is {inp:verbose}. 
{p_end}

{pstd}{bf:missing_ok} suppresses the error thrown if a pipe the user is trying to
replace does not exist in any variable label in the dataset.
The default behavior is that the code is interrupted
with an error if the pipe does not exist.
{p_end}

{pstd}{bf:{ul:v}arlist}({it:varlist}) restricts the scope of the search to the user-provided variable list. By default, the command searches for matches in all variables in memory. With {bf:varlist}(), the scope of the search can be narrowed.
{p_end}

{title:Examples}

{pstd}This simple example first creates a data set where
the pipe {inp:%unit%} is added to the variable label of the variable {inp:mpg}. 
Then {inp:lbl_replace_pipe} is used to replace {inp:%unit%} in the label 
with the value {inp:miles per gallon}. 
{p_end}

{input}{space 8}*Create example data
{space 8}sysuse auto, clear
{space 8}label variable mpg "Mileage (%unit%)"
{space 8}
{space 8}*Replace the unit pipe
{space 8}lbl_replace_pipe, pipe("unit") replacement("miles per gallon") ///
{space 8}   output_level(veryverbose)
{space 8}
{text}
{title:Feedback, Bug Reports, and Contributions}

{pstd}Read more about the commands in this package at https://github.com/lsms-worldbank/labeller.
{p_end}

{pstd}Please provide any feedback by opening an issue at https://github.com/lsms-worldbank/labeller/issues.
{p_end}

{pstd}PRs with suggestions for improvements are also greatly appreciated.
{p_end}

{title:Authors}

{pstd}LSMS Team, The World Bank lsms@worldbank.org
{p_end}
