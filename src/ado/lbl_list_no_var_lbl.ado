*! version XX XXXXXXXXX ADAUTHORNAME ADCONTACTINFO

cap program drop   lbl_list_no_var_lbl
    program define lbl_list_no_var_lbl, rclass

  version 13

  syntax [varlist]

  qui {

    * get all variables that lack a variable label
    ds `varlist', not(varlabel)
    local vars = "`r(varlist)'"

    * reset varlist to avoid collision with varlist in syntax
    local varlist ""

    * compute the number of matches
    local n_matches : list sizeof vars

    * return the varlist and count of matches
    return local varlist = "`vars'"
    return local count_matches = "`n_matches'"

    * message about outcome
    if (`n_matches' >= 1) {
      noi di as result "Variables found without a variable label :"
      noi di as result "`vars'"
    }
    else if (`n_matches' == 0) {
      noi di as result "No variables found without a label"
    }

  }

end
