*! version XX XXXXXXXXX ADAUTHORNAME ADCONTACTINFO

cap program drop   lbl_list_no_varlbl
    program define lbl_list_no_varlbl, rclass

  version 14

  syntax, [Varlist(varlist)]

  qui {

    * get all variables that lack a variable label
    ds `varlist', not(varlabel)
    local varlist "`r(varlist)'"

    * compute the number of matches
    local n_matches : list sizeof varlist

    * return the varlist and count of matches
    return local varlist "`varlist'"
    return local count_matches "`n_matches'"

    * message about outcome
    if (`n_matches' >= 1) {
      noi di as result "{pstd}Variables found without a variable label :{p_end}"
      noi di as result "{phang}`vars'{p_end}"
    }
    else if (`n_matches' == 0) {
      noi di as result "{pstd}No variables found without a label{p_end}"
    }
  }

end
