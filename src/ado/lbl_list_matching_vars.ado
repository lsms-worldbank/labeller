*! version 1.0 20240216 LSMS Team, World Bank lsms@worldbank.org

capture program drop    lbl_list_matching_vars
        program define  lbl_list_matching_vars, rclass

qui {

    version 14.1

  syntax anything (name=pattern), [Varlist(varlist) NEGate]



  * get list of all (matching) variables
  ds `varlist', has(varlabel)
  local varlist = r(varlist)

  local vars_w_match_lbl ""

  foreach var of local varlist {

    * extract the variable label
    local var_label : variable label `var'

    * determine whether the label matches the user-provided regex pattern
    local lbl_matches = ustrregexm("`var_label'", `pattern')

    * include the variable name in list of variables with matching labels
    if (mi("`negate'") & (`lbl_matches' == 1)) {
        local vars_w_match_lbl "`vars_w_match_lbl' `var'"
    }
    else if (!mi("`negate'") & (`lbl_matches' == 0)) {
        local vars_w_match_lbl "`vars_w_match_lbl' `var'"
    }
  }

  * compute the number of matches
  local n_matches : list sizeof vars_w_match_lbl

  * return the varlist and count of matches
  return local varlist = "`vars_w_match_lbl'"
  return local count_regex_matches = "`n_matches'"

  * message about outcome
  if (`n_matches' >= 1) {
      noi di as result "Matches found (`n_matches' variables) :"
      noi di as result "`vars_w_match_lbl'"
  }
  else if (`n_matches' == 0) {
      noi di as error "No matching variables found"
      noi di as result "If this result is unexpected, please check the regular expression provided."
  }
}

end
