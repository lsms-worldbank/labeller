
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
    


    * Create example data
    sysuse auto, clear
    label variable mpg "Mileage (%unit%)"
    
    * Basic run
    lab_pipe
    
    lab_pipe, outputlevel(minimal)
    
    lab_pipe, outputlevel(veryverbose)

    * List the pipes in the data
    lab_pipe, pipevalues(`" "unit miles per galleon" "') ///
        outputlevel(veryverbose)