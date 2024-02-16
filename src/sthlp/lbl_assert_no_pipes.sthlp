{smcl}
{* *! version 1.0 16FEB2024}{...}
{hline}
{pstd}help file for {hi:lbl_assert_no_pipes}{p_end}
{hline}

{title:Title}

{phang}{bf:lbl_assert_no_pipes} - Asserts that no variable labels have any pipes
{p_end}

{title:Syntax}

{phang}{bf:lbl_assert_no_pipes} , [{bf:{ul:ig}nore_pipes}({it:string}) {bf:{ul:out}put_level}({it:string}) {bf:{ul:v}arlist}({it:varlist})]
{p_end}

{synoptset 20}{...}
{synopthdr:options}
{synoptline}
{synopt: {bf:{ul:ig}nore_pipes}({it:string})}List of pipe names to be ignored{p_end}
{synopt: {bf:{ul:out}put_level}({it:string})}Toggle verbosity level in output{p_end}
{synopt: {bf:{ul:v}arlist}({it:varlist})}Restrict the scope of variables to consider{p_end}
{synoptline}

{title:Description}

{pstd}Data collected with SurveySolution (SuSo) commonly have pipes
in the format {inp:%pipename%} in the variable label. 
This command tests if there are any such pipes
in any labels in the dataset.
If there are any pipes, then this command throws an error and lists those remaining pipes.
{p_end}

{pstd}This command is intended to be used in a workflow with the commands
{inp:lbl_list_pipes} and {inp:lbl_replace_pipe} (both also in the {inp:labeller} package). 
After using {inp:lbl_replace_pipe} to replace pipes that were 
identified using {inp:lbl_replace_pipe}, 
{inp:lbl_assert_no_pipes} can be used to test that all pipes 
have been addressed.
{p_end}

{title:Options}

{pstd}{bf:{ul:ig}nore_pipes}({it:string}) is an option where the user can
list pipes that should not be ignored
even if they are found in the dataset.
This command will not throw an error if all pipes currently
in the dataset are listed in this option.
List the pipe names in a single string in this format:
{p_end}

{input}{space 8}lab_pipe, ignore_pipes("pipe1 pipe2")
{text}
{pstd}{bf:{ul:out}put_level}({it:string}) is an option that allows the user to
set how verbose the output should be.
The valid values for this option are
{inp:minimal}, {inp:verbose}, and {inp:veryverbose}. The default is {inp:verbose}. 
{p_end}

{pstd}{bf:{ul:v}arlist}({it:varlist}) restricts the scope of the search to the user-provided variable list. By default, the command searches for matches in all variables in memory. With {bf:varlist}(), the scope of the search can be narrowed.
{p_end}

{title:Examples}

{pstd}This simple example first creates a data set where
the pipe {inp:%unit%} is added to the variable label of the variable {inp:mpg}. 
Then {inp:lbl_replace_pipe} is used to replace {inp:%unit%} in the label with 
the value {inp:miles per gallon}. 
Finally, {inp:lbl_assert_no_pipes} is used to confirm there are 
no more pipes in any of the variable labels in the dataset.
{p_end}

{input}{space 8}* Create example data
{space 8}sysuse auto, clear
{space 8}label variable mpg "Mileage (%unit%)"
{space 8}
{space 8}* Replace the unit pipe
{space 8}lbl_replace_pipe, pipe("unit") replacement("miles per gallon")
{space 8}
{space 8}* Test that the dataset no longer has any pipes
{space 8}lbl_assert_no_pipes
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
