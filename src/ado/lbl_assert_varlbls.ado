*! version XX XXXXXXXXX ADAUTHORNAME ADCONTACTINFO

cap program drop   lbl_assert_have_varlbl
    program define lbl_assert_have_varlbl, rclass

  version 14

  syntax , Varlist(varlist)

  qui {

    * Get all variables in varlist or get all variables
    ds `varlist'
    local varlist "`r(varlist)'"

    * look for variables without a label
    lbl_list_no_varlbl, varlist(`varlist')
    local any_wo_var_lbl = (`r(count_matches)' > 0)
    local n_wo_var_lbl = "`r(count_matches)'"
    local which_no_var_lbl "`r(varlist)'"

    * return results
    return local varlist "`which_no_var_lbl'"
    return local any_matches "`any_wo_var_lbl'"
    return local count_matches "`n_wo_var_lbl'"

    * if any variables without labels found, message and error
    if (`any_wo_var_lbl' == 1) {
      di as error "{pstd}Variables found without a variable label :{p_end}",
      di as error "{phang}`which_no_var_lbl'{p_end}"
      error 9
    }
    else {
      di as result "{pstd}No variables found with a variable label.{p_end}"
    }
  }

end
