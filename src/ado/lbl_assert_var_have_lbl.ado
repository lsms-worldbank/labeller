*! version XX XXXXXXXXX ADAUTHORNAME ADCONTACTINFO

cap program drop   lbl_assert_var_have_lbl
    program define lbl_assert_var_have_lbl, rclass

  version 13

  syntax [varlist]

  qui {

    * look for variables without a label
    lbl_list_no_var_lbl `varlist'
    local any_wo_var_lbl = `r(count_matches)' > 0
    local which_no_var_lbl = "`r(varlist)'"

    * return results
    return local varlist = "`which_no_var_lbl'"
    return local any_matches = "`any_wo_var_lbl'"

    * if any variables without labels found, message and error
    if (`any_wo_var_lbl' == 1) {
      di as error "Variables found without a variable label :",
      di as error "`which_no_var_lbl'"
      error 9
    }
    else {
      di as result "No variables found with a variable label."
    }

  }

end
