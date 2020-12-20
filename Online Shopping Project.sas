


libname SAS_data "C:\Users\Varsha's PC\Downloads\BIA652\SAS_PGM\SAS_data"; 

**copy the lung dataset into work lib **;

proc copy in=SAS_data out=work;

      select Onlineshopping ;

run;

/* Logistic Regression on Raw Data */

proc logistic data=Online_shopping outest=shop_out plots(only)=roc;

  class MONTH OPERATINGSYSTEMS BROWSER REGION TRAFFICTYPE VISITORTYPE WEEKEND ;

  model REVENUE = MONTH OPERATINGSYSTEMS BROWSER REGION TRAFFICTYPE VISITORTYPE WEEKEND

ADMINISTRATIVE ADMINIsTRATIVE_DURATION INFORMATIONAL

INFORMATIONAL_DURATION PRODUCTRELATED PRODUCTRELATED_DURATION BOUNCERATES

EXITRATES PAGEVALUES SPECIALDAY / selection=stepwise slstay=0.05 ctable; 

run;

/* Conversion of variables */

data Onlineshopping2;

set Onlineshopping_new ;

   browser_new= input(Browser, 1.);

   Region_new= input(Region, 1.);

   Traffictype_new= input(Traffictype, 1.);

   OperatingSystems_new= input(OperatingSystems, 1.);

run;

 

/* Display data types of Variables */

proc contents data=Onlineshopping2 ;

run;

 

/* Standardization of Data */

proc STANDARD data=Onlineshopping2 mean=0 std=1 out=shop_std;

      var OPERATINGSYSTEMS BROWSER REGION TRAFFICTYPE ADMINISTRATIVE ADMINIsTRATIVE_DURATION INFORMATIONAL

INFORMATIONAL_DURATION PRODUCTRELATED PRODUCTRELATED_DURATION BOUNCERATES EXITRATES PAGEVALUES SPECIALDAY ;

run;

 

/* Running PCA on independent variables */

proc princomp data=shop_std plots=(pattern scree) out=shop_princomp;

      var ADMINISTRATIVE ADMINISTRATIVE_DURATION INFORMATIONAL INFORMATIONAL_DURATION PRODUCTRELATED PRODUCTRELATED_DURATION

        BOUNCERATES EXITRATES PAGEVALUES SPECIALDAY ;

run;

 

data Final3;

set Final2 ;

   browser_new= put(Browser, $1.);

   Region_new= put(Region, $1.);

   Traffictype_new= put(Traffictype, $1.);

   OperatingSystems_new= put(OperatingSystems, $1.);  

run;

 

/* Running logistic regression after PCA */

proc logistic data=Final3 outest=out_Final plots(only)=roc;

  class OPERATINGSYSTEMS_NEW BROWSER_NEW REGION_NEW WEEKEND ;

  model REVENUE = OPERATINGSYSTEMS_NEW BROWSER_NEW REGION_NEW TRAFFICTYPE_NEW WEEKEND PRIN1 PRIN2 PRIN3 PRIN4 PRIN5 PRIN6

  / selection=backward ctable slstay=0.05; 

run;

 

/* Display data types of Final3 */

proc contents data = Final3;

run;

 

/* Correlation matrix of Raw data */

proc corr data=Onlineshopping2;

run;

 

/* Factor Analysis - Not implemented for final model */

proc factor data=Onlineshopping2 method=principal scree nfactors=4 out=factout;           

var OPERATINGSYSTEMS BROWSER REGION TRAFFICTYPE ADMINISTRATIVE INFORMATIONAL INFORMATIONAL_DURATION PRODUCTRELATED

      PRODUCTRELATED_DURATION BOUNCERATES EXITRATES PAGEVALUES SPECIALDAY;

run;

 

proc factor data=Onlineshopping2 nfactors=2;     

var OPERATINGSYSTEMS BROWSER REGION TRAFFICTYPE ADMINISTRATIVE INFORMATIONAL INFORMATIONAL_DURATION PRODUCTRELATED

      PRODUCTRELATED_DURATION BOUNCERATES EXITRATES PAGEVALUES SPECIALDAY;

run;

 

/* Performing logistic regression on Downsampled data */

proc logistic data=Down outest=out_down plots(only)=roc;

  class MONTH OPERATINGSYSTEMS_NEW BROWSER_NEW REGION_NEW TRAFFICTYPE_NEW VISITORTYPE WEEKEND ;

  model REVENUE = MONTH OPERATINGSYSTEMS_NEW BROWSER_NEW REGION_NEW TRAFFICTYPE_NEW VISITORTYPE WEEKEND PRIN1 PRIN2 PRIN3 PRIN4 PRIN5 PRIN6

  / selection=backward ctable slstay=0.05; 

run;

 

/* Performing regression on Upsampled data (This is the final model) */

proc logistic data=Up outest=out_down plots(only)=roc;

  class OPERATINGSYSTEMS_NEW BROWSER_NEW REGION_NEW TRAFFICTYPE_NEW WEEKEND ;

  model REVENUE = OPERATINGSYSTEMS_NEW BROWSER_NEW REGION_NEW TRAFFICTYPE_NEW  WEEKEND PRIN1 PRIN2 PRIN3 PRIN4 PRIN5 PRIN6

  / selection=stepwise ctable slstay=0.05 slentry = 0.05; 

run;
