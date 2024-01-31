*! version XX XXXXXXXXX ADAUTHORNAME ADCONTACTINFO

cap program drop   lbl_list_unused_lbls
    program define lbl_list_unused_lbls, rclass

  version /* ADD VERSION NUMBER HERE */

  syntax , [Verbose]

  qui {

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

    * compute size of list
    local n_unused_labels : list sizeof unused_labels

    * report on findings
    if (`n_unused_labels' == 0) {     
      noi: di as result "{pstd}No unused value labels found.{p_end}"
    }
    else if (`n_unused_labels' > 0) {
      noi: di as result "{pstd}Unused value labels found:{p_end}"
      noi: di as result "{phang}`unused_labels'{p_end}"
      if (!mi("`verbose'")) {
        noi: label list `unused_labels'
      }
    }

    * return results
    return local names = trim("`unused_labels'")
    return local count "`n_unused_labels'"
  }

end
