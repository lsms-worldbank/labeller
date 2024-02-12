*! version 1.0 20231109 LSMS Worldbank lsms@worldbank.org

cap program drop   lbl_list_matching_vals
    program define lbl_list_matching_vals, rclass

    version 14.1

    syntax, pattern(string) [NEGate VERbose Varlist(varlist)]

    qui {

      * get list of variables with value labels
      ds `varlist', has(vallabel)
      local vars_w_val_lbl "`r(varlist)'"
      local n_vars_w_val_lbl : list sizeof vars_w_val_lbl

      * get list of labels for vars in varlist
      * providing a varlist if none specified
      if (mi("`varlist'")) {
        d, varlist
        local varlist = r(varlist)
      }
      local val_lbls_for_varlist ""
      foreach var of local varlist {
        local val_lbl_curr_var : value label `var'
        local val_lbls_for_varlist "`val_lbls_for_varlist' `val_lbl_curr_var'"
      }

      * compile the list of labels with matching elements
      * by working in a frame so that the data can be converted into
      * a data set of labels
      tempname val_lbls
      frame copy default `val_lbls'
      frame `val_lbls' {

        * create a data set of labels
        uselabel, clear var

        * capture the list of value labels with a matching element
        d // for computing observation count
        if (`r(N)' == 0) {
          local val_lbls_w_matching_val ""
        }
        else if (`r(N)' > 0) {

          * labels that match in whole data set
          levelsof lname if ustrregexm(label, "`pattern'"), ///
            local(val_lbls_w_matching_val) clean

          * construct list of matching variables
          if (mi("`negate'")) {
            local val_lbls_matching_in_varlist : list val_lbls_for_varlist & val_lbls_w_matching_val
          }
          if (!mi("`negate'")) {
            * all label names
            levelsof lname, local(all_val_lbls) clean
            * labels to exclude
            local val_lbls_to_exclude "`val_lbls_w_matching_val'"
            local val_lbls_to_exclude : list val_lbls_to_exclude & val_lbls_for_varlist
            * compliment of matching labels
            local val_lbls_matching_in_varlist : list all_val_lbls - val_lbls_to_exclude
          }

        }

      }

      * compile list of variables whose value labels have a matching element
      if (mi("`val_lbls_matching_in_varlist'")) {
        local vars_w_matching_val_lbl ""
      }
      else if (!mi("`val_lbls_matching_in_varlist'")) {
        * list variables with one of the variable label names piped into `has()'
        ds, has(vallabel `val_lbls_matching_in_varlist')
        local vars_w_matching_val_lbl "`r(varlist)'"
        * restrict to variables in the varlist with labels
        local vars_w_matching_val_lbl : list vars_w_matching_val_lbl & vars_w_val_lbl
      }

      * compile the list of matching labels
      * capture this from the val_lbls frame so that present in main frame
      local val_lbls_matching_in_varlist "`val_lbls_matching_in_varlist'"

      * compute the number of matches
      local n_matching_val_lbls : list sizeof val_lbls_matching_in_varlist
      local n_matching_vars : list sizeof vars_w_matching_val_lbl

      * report on findings
      if (`n_matching_val_lbls' == 0) {
        noi: di as result "No matching value labels found"
      }
      else if (`n_matching_val_lbls' > 0) {
        * print basic results message
        noi: di as result "Matching value labels found."
        noi: di as result "`n_matching_val_lbls' value labels attached to `n_matching_vars' variables."
        noi: di as result "Value labels: `val_lbls_matching_in_varlist'"
        noi: di as result "Variables: `vars_w_matching_val_lbl'"
        * if verbose mode, print out matching value label sets
        if (!mi("`verbose'")) {
          noi: label list `val_lbls_matching_in_varlist'
        }
      }

      * return results
      return local lbl_count "`n_matching_val_lbls'"
      return local val_lbl_list "`val_lbls_matching_in_varlist'"
      return local var_count "`n_matching_vars'"
      return local varlist "`vars_w_matching_val_lbl'"

    }

end
