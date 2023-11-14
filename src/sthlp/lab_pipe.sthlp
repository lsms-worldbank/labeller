{smcl}
{* 01 Jan 1960}{...}
{hline}
{pstd}help file for {hi:lab_pipe}{p_end}
{hline}

{title:Title}

{phang}{bf:lab_pipe} - A command to replace SurveySolution pipes in variable labels
{p_end}

{title:Syntax}

{phang}{bf:lab_pipe} , [{bf:{ul:pipev}alues}({it:string}) {bf:{ul:ignorep}ipes}({it:string}) {bf:{ul:out}putlevel}({it:string}) {bf:{ul:trun}cate}({it:string})]
{p_end}

{synoptset 19}{...}
{synopthdr:options}
{synoptline}
{synopt: {bf:{ul:pipev}alues}({it:string})}Provide values the pipes will be replaced with{p_end}
{synopt: {bf:{ul:ignorep}ipes}({it:string})}List pipe names to be ignored{p_end}
{synopt: {bf:{ul:out}putlevel}({it:string})}Toggle verbosity level in output{p_end}
{synopt: {bf:{ul:trun}cate}({it:string})}Toggle behavior when new label is too long{p_end}
{synoptline}

{title:Description}

{pstd}This command detects SurveySolution (SuSo) pipes in variable labels.
Data collected with SuSo commonly have pipes
on the format {inp:%pipename%} in the variable label.
This is a value that during the SuSo data collection replaced on the screen
for the enumerator during the survey with a value from a previous question.
This command detects such pipes and offer the user to replace
the pipe with a more human friendly value.
{p_end}

{title:Options}

{pstd}{bf:{ul:pipev}alues}({it:string}) is the option where the user provide the values that the pipe should be replaced with. The string in this option must be on this format of a compounded string. See example below. Pipes are always one word but the value may have several words. The value may not include quote signs.
{p_end}

{input}{space 8}lab_pipe, pipevalues(`" "<pipe1> <value1>" "<pipe2> <value2>" "')
{text}
{pstd}{bf:{ul:ignorep}ipes}({it:string}) is an option where the user
can list pipes that should be ignored.
List the pipe names in a single string on this format:
{p_end}

{input}{space 8}lab_pipe, ignorepipes("pipe1 pipe2")
{text}
{pstd}{bf:{ul:out}putlevel}({it:string}) is an option that allows the user to set how verbose the output should be. The valid values this option takes is {inp:minimal}, {inp:verbose} and {inp:veryverbose}. The default is {inp:verbose}.
{p_end}

{pstd}{bf:{ul:trun}cate}({it:string}) is an option that let the user decide what should happen if a label is too long after the pipe has been replaced with the new value. The options are {inp:error} (the commands throws an error and exits), {inp:warning} (the command outputs a warning and continues) and {inp:prompt} (the command askes the user to interactively confirm each case).
{p_end}

{title:Examples}

{dlgtab:Example 1}

{pstd}This simple example creates a data set and shows
how {inp:lab_pipe} detects the pipe in the variable {inp:mpg}.
{p_end}

{input}{space 8}* Create example data
{space 8}sysuse auto, clear
{space 8}label variable mpg "Mileage (%unit%)"
{space 8}
{space 8}* List the pipes in the data
{space 8}lab_pipe
{space 8}
{space 8}* Display the label of mpg
{space 8}describe mpg
{text}
{dlgtab:Example 2}

{pstd}The intended workflow is that after a pipe has been detected,
as in example 1 above, the command can be used to replace the pipe
with a more human readable value next time the same code is run.
In this example the pipe {inp:%unit%} is replaced with the value {inp:mpg}.
{p_end}

{input}{space 8}* Create example data
{space 8}sysuse auto, clear
{space 8}label variable mpg "Mileage (%unit%)"
{space 8}
{space 8}* List the pipes in the data
{space 8}lab_pipe, pipevalues(`" "unit miles per galleon" "')
{space 8}
{space 8}* Display the label of mpg
{space 8}describe mpg
{text}
{title:Feedback, bug reports and contributions}

{pstd}Read more about the commands in this package at https://github.com/lsms-worldbank/labeller.
{p_end}

{pstd}Please provide any feed back by opening and issue at https://github.com/lsms-worldbank/labeller/issues.
{p_end}

{pstd}PRs with suggestions for improvements are also greatly appreciated.
{p_end}

{title:Authors}

{pstd}LSMS Team, The World Bank lsms@worldbank.org
{p_end}
