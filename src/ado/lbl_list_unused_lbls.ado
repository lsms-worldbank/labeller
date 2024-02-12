*! version 1.0 20231109 LSMS Worldbank lsms@worldbank.org

cap program drop   lbl_list_unused_lbls
    program define lbl_list_unused_lbls, rclass

qui {

version 14.1

  syntax , [Verbose]

    * get the names of all labels in memory
    label dir
    local val_lbls "`r(names)'"

    * construct the list of unused value labels
    * checking to see if each label above is attached to a variable
    local unused_labels ""
    foreach val_lbl of local val_lbls {
      * return the variables with value label attached
      ds, has(vallabel `val_lbl')
      * if return is empty--i.e., label not used--add it to list
      if mi("`r(varlist)'") {
        local unused_labels "`unused_labels' `val_lbl'"
      }
    }

    * Count unused labels
    local n_unused_labels : list sizeof unused_labels

    ********************
    * report on findings

    * No value labels in the data set
    if (`: list sizeof val_lbls' == 0) {
      noi: di as text "{pstd}No value labels in data set.{p_end}"
    }

    * No unused value labels in the data set
    else if (`n_unused_labels' == 0) {
      noi: di as text "{pstd}No unused value labels found.{p_end}"
    }

    * Unused value labels found
    else {

      noi di as text "{pstd}Unused value labels found:{p_end}"
      * Display only a condensed list
      if missing("`verbose'") {
        noi di as result "{phang}`unused_labels'{p_end}"
      }
      * Display each label and its value
      else noi: label list `unused_labels'
    }

    * return results
    return local names = trim("`unused_labels'")
    return local count "`n_unused_labels'"
  }

end
