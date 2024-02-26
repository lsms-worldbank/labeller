* Kristoffer's root path
if "`c(username)'" == "wb462869" {
    global clone "C:\Users\wb462869\github\labeller"
}
else if "`c(username)'" == "wb393438" {
    global clone "C:\Users\wb393438\stata_funs\labeller"
}

* Set global to ado_fldr
global src_fldr  "${clone}/src"
global test_fldr "${src_fldr}/tests"
global data_fldr "${test_fldr}/testdata"

* Set up a dev environement for testing locally
cap mkdir    "${tests}/dev-env"
repado using "${tests}/dev-env"

cap net uninstall labeller
net install labeller, from("${src_fldr}") replace

* output version of this package
labeller

* ==============================================================================
* Setup
* ==============================================================================

clear

* create set of variables
gen var1 = .
gen var2 = .
gen var3 = .
gen var4 = .

* apply variables
label variable var1 "First label"
label variable var2 "2. label"
label variable var3 "3. label"
label variable var4 "Fourth label"

* ==============================================================================
* Selects variables without regex
* ==============================================================================

* find variables whose label contains "First"
lbl_list_matching_vars, pattern("First")
local first_vars = r(varlist)
local first_vars : list clean first_vars

* test
capture assert "`first_vars'" == "var1"
di as result "lbl_list_matching_var_lbls selects variables without regex"
if _rc != 0 {
    di as error "❌ Test failed"
    error 0
}
else {
    di as result "✅ Test passed"
}

* ==============================================================================
* Selects variables with regex
* ==============================================================================

* find variables whose labels start with a number
lbl_list_matching_vars, pattern("^[0-9]")
local have_num_labels = r(varlist)
local have_num_labels : list clean have_num_labels

* test
capture assert "`have_num_labels'" == "var2 var3"
di as result "lbl_list_matching_var_lbls selects variables with regex"
if _rc != 0 {
    di as error "❌ Test failed"
    error 0
}
else {
    di as result "✅ Test passed"
}

* ==============================================================================
* Selects variables in variable list
* ==============================================================================

* find variables whose label starts with "F" in `var1 - var3`
lbl_list_matching_vars, pattern("^F") varlist(var1 - var3)
local matches_in_varlist = r(varlist)
local matches_in_varlist : list clean matches_in_varlist

* test
capture assert "`matches_in_varlist'" == "var1"
di as result "lbl_list_matching_var_lbls selects variables in varlist"
if _rc != 0 {
    di as error "❌ Test failed"
    error 0
}
else {
    di as result "✅ Test passed"
}

* ==============================================================================
* Selects variables whose labels do not match
* ==============================================================================

* find variables whose labels do NOT start with a number
lbl_list_matching_vars, pattern("^[0-9]") negate
local does_not_match = r(varlist)
local does_not_match : list clean does_not_match

* test
capture assert "`does_not_match'" == "var1 var4"
di as result "lbl_list_matching_var_lbls selects variables whose labels do not match"
if _rc != 0 {
    di as error "❌ Test failed"
    error 0
}
else {
    di as result "✅ Test passed"
}

* ==============================================================================
* Can handle a pattern containing a quote
* ==============================================================================

* modify label of first variable to contain double quotes
label variable var1 `"My "label" contains double quotes"'

* find variable label with double quotes
lbl_list_matching_vars, pattern(`""label""')
local w_dbl_quotes = r(varlist)
local w_dbl_quotes : list clean w_dbl_quotes

* test
capture assert "`w_dbl_quotes'" == "var1"
di as result "Can handle a pattern containing a quote"
if _rc != 0 {
    di as error "❌ Test failed"
    error 0
}
else {
    di as result "✅ Test passed"
}

* ==============================================================================
* Teardown
* ==============================================================================

drop var1 - var4
