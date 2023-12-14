{smcl}
{* 01 Jan 1960}{...}
{hline}
{pstd}help file for {hi:lbl_list_pipes}{p_end}
{hline}

{title:Title}

{phang}{bf:lbl_list_pipes} - Lists pipes in variable labels from SurveySolution
{p_end}

{title:Syntax}

{phang}{bf:lbl_list_pipes} , [{bf:{ul:ig}norepipes}({it:string}) {bf:{ul:out}putlevel}({it:string})]
{p_end}

{synoptset 19}{...}
{synopthdr:options}
{synoptline}
{synopt: {bf:{ul:ig}norepipes}({it:string})}List of pipe names to be ignored{p_end}
{synopt: {bf:{ul:out}putlevel}({it:string})}Toggle verbosity level in output{p_end}
{synoptline}

{title:Description}

{pstd}Data collected with SurveySolution (SuSo) commonly have pipes
in the format {inp:%pipename%} in the variable label.
This command detects SuSo pipes in variable labels and outputs them.
The pipes can then be replaced with the {inp:lbl_replace_pipe} command that
is also a part of the {inp:labeller} package.
{p_end}

{title:Options}

{pstd}{bf:{ul:ig}norepipes}({it:string}) is an option where the user can list pipes
that should not be included in the output.
List the pipe names in a single string in this format:
{p_end}

{input}{space 8}lab_pipe, ignorepipes("pipe1 pipe2")
{text}
{pstd}{bf:{ul:out}putlevel}({it:string}) is an option that allows the user to
set how verbose the output should be.
The valid values for this option are
{inp:minimal}, {inp:verbose}, and {inp:veryverbose}.
The default is {inp:verbose}.
{p_end}

{title:Examples}

{pstd}This simple example first creates a data set where the pipe {inp:%unit%} is
added to the variable label of the variable {inp:mpg}.
Then the command {inp:lbl_list_pipes} is used to detect and output this pipe.
{p_end}

{input}{space 8}* Create example data
{space 8}sysuse auto, clear
{space 8}label variable mpg "Mileage (%unit%)"
{space 8}
{space 8}* List the pipes in the data
{space 8}lbl_list_pipes, outputlevel(veryverbose)
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
