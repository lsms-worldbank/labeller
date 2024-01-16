  * Kristoffer's root path
  if "`c(username)'" == "wb462869" {
      global clone "C:/Users/wb462869/github/labeller"
  }
  else if "`c(username)'" == "wb393438" {
      global clone "C:\Users\wb393438\stata_funs\labeller"
  } 
  
  /*
  ad_setup, adf("${clone}")  ///
      name("labeller")             ///
      description("A packge with utility commands related to lables. Particularly, but not exclusively, in relation to data sets collected using SurveySolutions.")      ///
      author("LSMS Worldbank")           ///
      contact("lsms@worldbank.org")          ///
      url("https://github.com/lsms-worldbank/labeller") ///
      github
  */

  ad_sthlp , adf("${clone}")

  //ad_command create reprun_dataline , adf("`repkit'") pkg(repkit)
