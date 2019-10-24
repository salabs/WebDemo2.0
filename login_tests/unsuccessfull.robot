*** Settings ***
Test Setup     Set Up Test Environment
Test Teardown  Close All Browsers
Resource       resources.robot
Resource       variables.robot
***Test Cases ***
Login With Invalid Credentials
    Verify That Login Page And Elements Are Ready
    Try Invalid Login
    Verify Unsuccessfull Login