cap program drop   lbl_assert_no_var_max_len
    program define lbl_assert_no_var_max_len, rclass

  version 14

  syntax [varlist], [MAXlen(integer 80)]

  qui {

    * look for variables whose labels >= max length
    lbl_list_var_max_len `varlist', maxlen(`maxlen')
    local any_max_len = (`r(count_matches)' > 0)
    local which_max_len "`r(varlist)'"

    * return results
    return local varlist "`which_max_len'"
    return local count_matches "`any_max_len'"

    * if any variables with long labels found, message and error
    if (`any_max_len' == 1) {
      di as error "{pstd}Variables found whose labels are >= `maxlen' characters:{p_end}",
      di as error "{phang}`which_max_len'{p_end}"
      error 9
    }

  }

end
