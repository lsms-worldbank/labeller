{smcl}
{* *! version 1.0 14FEB2024}{...}
{hline}
{pstd}help file for {hi:lbl_assert_have_varlbl}{p_end}
{hline}

{title:Title}

{phang}{bf:lbl_assert_var_have_lbl} - List variables without a variable label.
{p_end}

{title:Syntax}

{phang}{bf:lbl_assert_var_have_lbl}, [{bf:{ul:v}arlist}({it:varlist})]
{p_end}

{synoptset 16}{...}
{synopthdr:options}
{synoptline}
{synopt: {bf:{ul:v}arlist}({it:varlist})}Restrict the scope of variables to consider{p_end}
{synoptline}

{title:Description}

{pstd}For small data sets, visual inspection can identify variables without a variable label. For larger data sets (or repeat encounters with data sets), it is better to have a tool variables, if any, that remain without a variable label.
{p_end}

{pstd}This command does that. If any variables without variable labels are found, it returns and error and lists which variables are missing variable labels. If all variables have variable labels, it reports this fact. In this way, the user knows whether action is needed, and for which variables.
{p_end}

{title:Options}

{pstd}{bf:{ul:v}arlist}({it:varlist}) restricts the scope of the search to the user-provided variable list. By default, the command searches for matches in all variables in memory. With {bf:varlist}(), the scope of the search can be narrowed.
{p_end}

{title:Examples}

{input}{space 8}* create set of variables
{space 8}gen var1 = .
{space 8}gen var2 = .
{space 8}gen var3 = .
{space 8}gen var4 = .
{space 8}
{space 8}* apply variable labels to only some variables
{space 8}label variable var1 "Some label"
{space 8}label variable var4 "Another label"
{space 8}
{space 8}* assert that all variables have variable labels, globally
{space 8}lbl_assert_var_have_lbl
{space 8}
{space 8}* assert that all variables have variable labels, in the varlist
{space 8}lbl_assert_var_have_lbl var3 - var4
{text}
{title:Feedback, bug reports and contributions}

{pstd}Read more about the commands in this package at https://github.com/lsms-worldbank/labeller.
{p_end}

{pstd}Please provide any feedback by opening an issue at https://github.com/lsms-worldbank/labeller/issues.
{p_end}

{pstd}PRs with suggestions for improvements are also greatly appreciated.
{p_end}

{title:Authors}

{pstd}LSMS Team, The World Bank lsms@worldbank.org
{p_end}
