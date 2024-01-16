*! version XX XXXXXXXXX ADAUTHORNAME ADCONTACTINFO

cap program drop   lbl_list_matching_vals
    program define lbl_list_matching_vals, rclass

    version 17

    syntax [varlist], pattern(string) [NEGate Verbose]

    qui {

      * get list of variables with value labels
      ds `varlist', has(vallabel)
      local vars_w_val_lbl "`r(varlist)'"
      local n_vars_w_val_lbl : list sizeof vars_w_val_lbl

      * compile the list of labels with matching elements
      * by working in a frame so that the data can be converted into
      * a data set of labels
      tempname val_lbls
      frame copy default `val_lbls'
      frame `val_lbls' {

        * keep variables of interest
        keep `vars_w_val_lbl'

        * create a data set of labels
        uselabel, clear var
        
        * capture the list of value labels with a matching element
        d // for computing observation count
        if (`r(N)' == 0) {
          local val_lbls_w_matching_val ""
        }
        else if (`r(N)' > 0) {

          * labels that match
          levelsof lname if ustrregexm(label, "`pattern'"), ///
            local(val_lbls_w_matching_val) clean
          
          * construct labels that do not match, if negate option provided
          if (!mi("`negate'")) {
            * all label names
            levelsof lname, local(all_val_lbls) clean
            * labels to exclude
            local val_lbls_to_exclude "`val_lbls_w_matching_val'"
            * compliment of matching labels
            local val_lbls_w_matching_val : list all_val_lbls - val_lbls_to_exclude
          }

        }

      }

      * compile list of variables with whose value labels have a matching element
      if (mi("`val_lbls_w_matching_val'")) {
        local vars_w_matching_val_lbl ""
      }
      else if (!mi("`val_lbls_w_matching_val'")) {
        * list variables with one of the variable label names piped into `has()'
        ds, has(vallabel `val_lbls_w_matching_val')
        local vars_w_matching_val_lbl "`r(varlist)'"
      }

      * compile the list of matching labels
      * capture this from the val_lbls frame so that present in main frame
      local val_lbls_w_matching_val "`val_lbls_w_matching_val'"

      * compute the number of matches
      local n_matching_val_lbls : list sizeof val_lbls_w_matching_val
      local n_matching_vars : list sizeof vars_w_matching_val_lbl

      * report on findings
      if (`n_matching_val_lbls' == 0) {
        noi: di as result "No matching value labels found"
      }
      else if (`n_matching_val_lbls' > 0) {
        * print basic results message
        noi: di as result "Matching value labels found."
        noi: di as result "`n_matching_val_lbls' value labels attached to `n_matching_vars' variables."
        noi: di as result "Value labels: `val_lbls_w_matching_val'"
        noi: di as result "Variables: `vars_w_matching_val_lbl'"
        * if verbose mode, print out matching value label sets
        if (!mi("`verbose'")) {
          noi: label list `val_lbls_w_matching_val'
        }
      }

      * return results
      return local lbl_count "`n_matching_val_lbls'"
      return local val_lbl_list "`val_lbls_w_matching_val'"
      return local var_count "`n_matching_vars'"
      return local varlist "`vars_w_matching_val_lbl'"

    }

end
