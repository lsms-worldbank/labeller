
    * Kristoffer's root path
    if "`c(username)'" == "wb462869" {
        global clone "C:\Users\wb462869\github\labeller"
    }

    * Set global to ado_fldr
    global src_fldr  "${clone}/src"
    global test_fldr "${src_fldr}/tests"
    global run_fldr  "${test_fldr}/lab_pipe"


    * Install the version of this package in 
    * the plus-ado folder in the test folder
    cap mkdir "${test_fldr}/plus-ado"
    repado , adopath("${test_fldr}/plus-ado") mode(strict)
    
    cap net uninstall labeller
    net install labeller, from("${src_fldr}") replace
    
    
    use "${run_fldr}/test-data/meta_PERSONS.dta", clear
    
    keep v530a v531 v532 v533 v534 v534a v534b v534c v534d
   
    lab var v532 "Did %NAME% have any clear broth?"
    lab var v533 "Did have any %name%"
    lab var v534a "Did %1name% have any broth?"
    lab var v534b "what is 20% of 20%?"
    lab var v530a "Did %rost3er_t1tle% have any?"
   
    
    lab_pipe