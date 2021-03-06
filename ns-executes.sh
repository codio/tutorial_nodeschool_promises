#!/bin/bash 
 
# Check parameters 
if [[ "$#" -ne 3 ]]; then 
    echo "3 parameters required" 
    exit 0 
fi 
 
# Translate lesson name into correct name for Workshopper projects 
if [ $2 == "fulfill_a_promise" ]; then 
    STR="fulfill_a_promise" 
elif [ $2 == "reject_a_promise" ]; then 
    STR="reject_a_promise" 
elif [ $2 == "to_reject_or_not_to_reject" ]; then 
    STR="to_reject_or_not_to_reject" 
elif [ $2 == "always_async" ]; then 
    STR="always_async" 
elif [ $2 == "values_and_promises" ]; then 
    STR="values_and_promises" 
elif [ $2 == "throw_an_error" ]; then 
    STR="throw_an_error" 
elif [ $2 == "using_qfcall" ]; then 
    STR="using_qfcall" 
elif [ $2 == "an_important_rule" ]; then 
    STR="an_important_rule" 
elif [ $2 == "multiple_promises" ]; then 
    STR="multiple_promises" 
elif [ $2 == "fetch_json" ]; then 
    STR="fetch_json" 
elif [ $2 == "do_some_work" ]; then 
    STR="do_some_work" 
elif [ $2 == "more_functional" ]; then 
    STR="more_functional" 
else 
    echo UNKNOWN: Make sure you have your code file selected before running/verifying 
    exit 0 
fi 
echo SELECTED FILE IS : $STR 
 
#Select the workshopper lesson 
promise-it-wont-hurt select $STR > /dev/null 
 
# Run or Verify? 
if [ $1 == "run" ]; then 
    promise-it-wont-hurt run $3/$2.js 
elif [ $1 == "verify" ]; then 
    promise-it-wont-hurt verify $3/$2.js 
else  
    echo "BAD COMMAND" 
fi