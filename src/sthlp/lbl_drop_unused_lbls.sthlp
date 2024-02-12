{smcl}
{* *! version 1.0 12FEB2024}{...}
{hline}
{pstd}help file for {hi:lbl_drop_unused_lbls}{p_end}
{hline}

{title:Title}

{phang}{bf:lbl_drop_unused_lbls} - Drop value labels not attached to any variable.
{p_end}

{title:Syntax}

{phang}{bf:lbl_drop_unused_lbls} , [{bf:{ul:c}onfirm}]
{p_end}

{synoptset 7}{...}
{synopthdr:options}
{synoptline}
{synopt: {bf:{ul:c}onfirm}}Prompts user before removing any unused value labels{p_end}
{synoptline}

{title:Description}

{pstd}When attached to variables, value labels are an essential part of data documentation. Left unused, they create clutter and, potentially, confusion.
{p_end}

{pstd}To eliminate any unattached value labels, drop them with {inp:lbl_drop_unused_lbls}. To check for and inspect unattached value labels, use {inp:lbl_list_unused_lbls}. 
{p_end}

{title:Options}

{pstd}{bf:{ul:c}onfirm} lists unused value labels and confirms whether the user indeed wants to drop them. When prompted, the user should type {inp:y} for yes or {inp:n} for no. With this response, the command will perform the appropriate action. 
{p_end}

{title:Examples}

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
{space 8}* drop the value labels not attached (aka unused)
{space 8}* if in doubt, ask first
{space 8}lbl_drop_unused_lbls, confirm
{space 8}n
{space 8}* if intrepid, drop without asking
{space 8}lbl_drop_unused_lbls
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
