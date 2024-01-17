*! version XX XXXXXXXXX ADAUTHORNAME ADCONTACTINFO

cap program drop   lbl_list_long_varlbl
    program define lbl_list_long_varlbl, rclass

  version 14

  syntax, [MAXlen(integer 80) Varlist(varlist)]

  qui {

    * get list of all variables
    ds `varlist', has(varlabel)
    local varlist = r(varlist)

    * initialize list of variables with labels that are too long
    local vars_lbl_too_long ""

    * populate list of variables
    foreach var of local varlist {

      * extract variable label
      local var_lbl : variable label `var'

      * if length is greater than or equal to max, put in list
      if (`: ustrlen local var_lbl' >= `maxlen') {
        local vars_lbl_too_long "`vars_lbl_too_long' `var'"
      }
    }

    * compute the number of matches
    local n_matches : list sizeof vars_lbl_too_long

    * return the varlist and count of matches
    return local varlist "`vars_lbl_too_long'"
    return local count_matches "`n_matches'"

    * message about outcome
    if (`n_matches' >= 1) {
      noi di as result "{pstd}Variables with at least `maxlen' characters found (`n_matches' variables) :{p_end}"
      noi di as result "{phang}`vars_lbl_too_long'{p_end}"
    }
    else if (`n_matches' == 0) {
      noi di as result "{pstd}No variables found with a label >= `maxlen' characters found{p_end}"
    }
  }

end
