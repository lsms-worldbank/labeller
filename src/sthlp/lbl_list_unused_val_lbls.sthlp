{smcl}
{* *! version 1.0 20240216}{...}
{hline}
{pstd}help file for {hi:lbl_list_unused_val_lbls}{p_end}
{hline}

{title:Title}

{phang}{bf:lbl_list_unused_val_lbls} - List value labels not attached to any variable.
{p_end}

{title:Syntax}

{phang}{bf:lbl_list_unused_val_lbls} , [{bf:{ul:v}erbose}]
{p_end}

{synoptset 7}{...}
{synopthdr:options}
{synoptline}
{synopt: {bf:{ul:v}erbose}}Prints the contents of unused value labels with {inp:label list}.{p_end}
{synoptline}

{title:Description}

{pstd}When attached to variables, value labels are an essential part of data documentation. Left unused, they create clutter and, potentially, confusion.
{p_end}

{pstd}To tidy a data set, data producers should manage value label sets well. 
But in order to tidy, one needs an inventory of the things that need tidying. To that end, {inp:lbl_list_unused_val_lbls} lists all value label sets that are unused--in other words, that need to be either attached to a variable or dropped. 
{p_end}

{title:Options}

{pstd}{bf:{ul:v}erbose} provides the user with more details on unused value labels by printing their contents with {inp:label list}. In this way, the user can decide what should be done with unused labels (e.g. attach them to variables, drop them, etc). 
{p_end}

{title:Examples}

{dlgtab:Example 1: List unused value labels}

{input}{space 8}* create one variable
{space 8}gen v1 = .
{space 8}
{space 8}* define more than one value label set
{space 8}label define v1 1 "yes" 2 "no", modify
{space 8}label define v3 1 "oui" 2 "non", modify
{space 8}label define v4 1 "evet" 2 "hayır", modify
{space 8}
{space 8}* attach one value label, but not the others
{space 8}label values v1 v1
{space 8}
{space 8}* list the value labels not attached (aka unused)
{space 8}lbl_list_unused_val_lbls
{text}
{dlgtab:Example 2: List unused value labels and print their contents}

{input}{space 8}* ... continuing from example 1
{space 8}* print the contents of the unused labels
{space 8}lbl_list_unused_val_lbls, verbose
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
