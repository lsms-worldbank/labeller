*! version 1.0 20240212 LSMS Worldbank lsms@worldbank.org

cap program drop   lbl_assert_no_long_varlbl
    program define lbl_assert_no_long_varlbl, rclass

    version 14.1

  syntax, [MAXlen(integer 80) Varlist(varlist)]

  qui {

    * look for variables whose labels >= max length
    lbl_list_long_varlbl `varlist', maxlen(`maxlen')
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
