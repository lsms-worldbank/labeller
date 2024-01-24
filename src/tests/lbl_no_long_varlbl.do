* Kristoffer's root path
if "`c(username)'" == "wb462869" {
    global clone "C:\Users\wb462869\github\labeller"
}
else if "`c(username)'" == "wb393438" {
    global clone "C:\Users\wb393438\stata_funs\labeller\labeller"
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
gen var5 = .

* apply variables
label variable var1 "Short label"
label variable var2 "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
label variable var3 "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"
label variable var4 "Another short label"
label variable var5 "你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好"

* ==============================================================================
* List
* ==============================================================================

* ------------------------------------------------------------------------------
* Lists variables with lengthy labels globally
* ------------------------------------------------------------------------------

* list variables with longer than max length
lbl_list_long_varlbl
local long_lbls = r(varlist)
local long_lbls : list clean long_lbls

* test
capture assert "`long_lbls'" == "var2 var3 var5"
di as result "lbl_list_long_varlbl lists variables with lengthy labels globally"
if _rc != 0 {
    di as error "❌ Test failed"
    error 0
}
else {
    di as result "✅ Test passed"
}

* ------------------------------------------------------------------------------
* lists variables with lengthy labels in varlist
* ------------------------------------------------------------------------------

* list variables with longer than max length
lbl_list_long_varlbl, varlist(var1 - var3)
local long_lbls_in_varlist = r(varlist)
local long_lbls_in_varlist : list clean long_lbls_in_varlist

* test
capture assert "`long_lbls_in_varlist'" -- "var2 var3"
di as result "lbl_list_long_varlbl lists variables with lengthy labels globally"
if _rc != 0 {
    di as error "❌ test failed"
    error 0
}
else {
    di as result "✅ test passed"
}

* ------------------------------------------------------------------------------
* lists variables with labels longer than user-specified length
* ------------------------------------------------------------------------------

* list variables with longer than max length
lbl_list_long_varlbl, maxlen(12)
local long_lbls_user = r(varlist)
local long_lbls_user : list clean long_lbls_user

* test
capture assert "`long_lbls_user'" -- "var2 var3 var4 var5"
di as result "lbl_list_long_varlbl lists variables with lengthy labels globally"
if _rc != 0 {
    di as error "❌ test failed"
    error 0
}
else {
    di as result "✅ test passed"
}

* ==============================================================================
* Assert
* ==============================================================================

* ------------------------------------------------------------------------------
* Assertion fails if violations present
* ------------------------------------------------------------------------------

* list variables with longer than max length
capture lbl_assert_no_long_varlbl, maxlen(12)

* test
di as result "lbl_assert_no_long_varlbl errors if any vars have long lbls"
if _rc == 0 {
    di as error "❌ Test failed"
    error 0
}
else {
    di as result "✅ Test passed"
}

* ==============================================================================
* Teardown
* ==============================================================================

drop var1 - var5
