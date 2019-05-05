*** Settings ***
Library    SeleniumLibrary    
library    XML
library    String

*** Keywords ***
LookingForAll
    [Documentation]    遍历全部员工的名字
    [Arguments]    ${root}    ${PonintsString}
    ${EmployeeNum}    XML.Get Element Count    ${root}    employee
     
    FOR    ${INDEX}    IN RANGE    1    ${EmployeeNum}+1
        ${Value}    XML.Get Element Attribute    ${root}    value    employee[${INDEX}]
	    Select From List By Value    id=values_assigned_to_id_1        ${Value}
		Click Link        应用
		${state}    Run Keyword And Return Status    Get Text    jquery=p.query-totals span.total-for-estimated-hours span.value
		Run keyword if    '${state}'=='False'    Continue For Loop
	    ${SpanValue}    Get Text    jquery=p.query-totals span.total-for-estimated-hours span.value
	    ${name}    Get Element    ${root}    employee[${INDEX}]
	    Set Element Text    ${name}    ${SpanValue}    None    ${PonintsString}
    END
    
*** Test Cases ***
MyFirstTest
    Log    Hello World...

MySecondTest
    Log    This is my 2nd Test

FirstSeleniumTest
    Open Browser      https://www.google.com    chrome
    Set Browser Implicit Wait    5
    Input Text        name=q                    Automation step by step
    Press Keys     name=q    ENTER
    # Click Button    name=btnK
    Sleep    2    
    Close Browser
    Log    Test Completed
        
SampleLoginTest
    [Documentation]        This is a sample login test
    Open Browser      http://10.0.0.221:9000/login    Chrome
    Input Text        id=username    haoyifan
    Input Password    id=password    asdfgh123
    Click Button      id=login-submit
    Click Link        /projects   
    Click Link        /issues
    Click Link        /issues?query_id=137
    Click Element     jquery=#filters legend  
    Select From List By Value    id=values_assigned_to_id_1        80
    Click Link        应用
    ${xx}    Get Text    jquery=p.query-totals span.total-for-estimated-hours span.value
    Log    ${xx}    
        
    
SampleLoginTest2
    [Documentation]        This is a sample login test
    Open Browser      http://10.0.0.221:9000/login    Chrome
    Input Text        id=username    haoyifan
    Input Password    id=password    asdfgh123
    Click Button      id=login-submit
    Click Link        /work_time/index
    Select From List By Index    jquery=div.contextual select:last-child    28    
     ${xx}    Get Text    jquery=#content h3
     @{words}    Split String     ${xx}    ${SPACE} 
     Log    开发积分=@{words}[5]
     log    管理积分=@{words}[7]
     Log    基准积分=@{words}[15]
     log    挑战积分=@{words}[19]
    
XMLTest
    ${root}    Parse Xml    H:/SomethingToLearn/1.xml    
    Should Be Equal    ${root.tag}    example
    ${first}    Get Element    ${root}    first
    ${xx}    Set Element Text    ${first}    new text  
    XML.Element Text Should Be    ${first}    new text     
    Save Xml    ${root}    H:/SomethingToLearn/2.xml    
    
XMLTest2
    ${root}    Parse Xml    H:/SomethingToLearn/redmine.xml
    ${NameNum}    XML.Get Element Count    ${root}    name
    FOR    ${INDEX}    IN RANGE    1    ${NameNum}+1
         ${name}    Get Element    ${root}    name[${INDEX}]
        Set Element Text    ${name}    60    None    PendingPoints
    END
    Save Xml    ${root}    H:/SomethingToLearn/2.xml
    
GetPoints
	${root}        Parse Xml    H:/SomethingToLearn/redmine.xml
	${EmployeeNum}     XML.Get Element Count    ${root}    employee
	${QIDNum}      XML.Get Element Count    ${root}    query_id
    Open Browser      http://10.0.0.221:9000/login    Chrome
    Input Text        id=username    haoyifan
    Input Password    id=password    asdfgh123
    Click Button      id=login-submit
    Click Link        /projects   
    Click Link        /issues
    
    FOR    ${QIDIndex}    IN RANGE    1    ${QIDNum}+1
        ${QID}    XML.Get Element TEXT    ${root}    query_id[${QIDIndex}]    
        Click Link        /issues?query_id=${QID}
        Click Element     jquery=#filters legend
        ${PonintsString}    XML.Get Element Attribute    ${root}    type    query_id[${QIDIndex}]
        LookingForAll    ${root}    ${PonintsString}  
    END
    
    Click Link        /work_time/index
	FOR    ${INDEX}    IN RANGE    1    ${EmployeeNum}+1
        ${NUM}    XML.Get Element Attribute    ${root}    number    employee[${INDEX}]
        Select From List By Index    jquery=div.contextual select:last-child    ${NUM}
        ${xx}    Get Text    jquery=#content h3
	    @{words}    Split String     ${xx}    ${SPACE}
        ${employee}    Get Element    ${root}    employee[${INDEX}]
        Set Element Text    ${employee}    @{words}[5]    None    DevelPoints
        Set Element Text    ${employee}    @{words}[7]    None    ManagePoints
        Set Element Text    ${employee}    @{words}[15]    None    BasicPoints
        Set Element Text    ${employee}    @{words}[19]    None    ChallengePoints
    END
    
    Save Xml    ${root}    H:/SomethingToLearn/2.xml  
    Close Browser
    
Test2
    ${root}        Parse Xml    H:/SomethingToLearn/redmine.xml
	${NameNum}     XML.Get Element Count    ${root}    name
	Open Browser      http://10.0.0.221:9000/login    Chrome
	Input Text        id=username    haoyifan
	Input Password    id=password    asdfgh123
	Click Button      id=login-submit
	Click Link        /work_time/index
	
	FOR    ${INDEX}    IN RANGE    1    ${NameNum}+1
        ${NUM}    XML.Get Element Attribute    ${root}    number    name[${INDEX}]
        Select From List By Index    jquery=div.contextual select:last-child    ${NUM}
        ${xx}    Get Text    jquery=#content h3
	    @{words}    Split String     ${xx}    ${SPACE}
        ${name}    Get Element    ${root}    name[${INDEX}]
        Set Element Text    ${name}    @{words}[5]    None    DevelPoints
        Set Element Text    ${name}    @{words}[7]    None    ManagePoints
        Set Element Text    ${name}    @{words}[15]    None    BasicPoints
        Set Element Text    ${name}    @{words}[19]    None    ChallengePoints
    END
    
    Save Xml    ${root}    H:/SomethingToLearn/3.xml
    
	Close Browser
    
            
    
    
       
                    