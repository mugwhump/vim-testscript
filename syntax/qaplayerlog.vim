" Vim syntax file
" Language: Absolute Software QAPlayer Log file
" Maintainer: Grayson Bartlet
" Latest Revision: September 18 2014

" Check that syntax wasn't previously defined
if exists("b:current_syntax")
  finish
endif
let b:current_syntax = "testscript"

" NOTE: Lower items have higher priority

" First word of (most) lines are functions
" Keywords
syn keyword Function VerifyXmlDocElementExists VerifyCheckBox MaximizeWindow SelectWebValue GetWebSelectedLabel AddToDateVariable RestartService VerifyWinEvents FindInWebTable ClickWebCell SetBinGuidVariable ConvertIPDecVarToAddress CloseDBConnection MapDrive SetJsonDocObject SetAttributes SendEmailFromFiles VerifyRadio OpenWebUrl FocusWebWindow SuspendVMW RevertToVMWSnapshot ResetVMW EnableService WaitForWebCellValue SetWebProgressElement DragAndDropWebElement AddEscapeToVariable VerifyDBValue GenerateAMSecurityData VerifyRESTfulStatusCode VerifyWCFStatusCode AggregateMongoDBCollection CloneJsonDocObject ClickControl VerifyWinProcessRun GetWebValue GetWebCheckStatus VerifyRegValueExists DeleteVMWFolder StartSpiraTCRun TryNextScriptAgainIfError DisconnectServer CopyFolders VirtualMachine StopVM SubmitWebForm SetWebCheckBox MaximizeWebWindow CountWebTableRows DeleteVariable GetDBValue LogSpiraTCResults GetCurrentESN GetPerformanceCounterValue ConnectToServer VerifyJsonElementExists DeleteFolders DeleteFiles MoveFiles SendEmail CompareWebTitle RestoreFirstVMWSnapshot LoginGuestVMW CreateVMWSnapshot VerifyNotRunningService SendWebKeys AddToArrayVar WriteText WaitForDBData VerifyRESTfulHeaderValue VerifyWCFHeaderValue FinalizeJsonDocObject AddJsonDocRoot FlatJsonDocArray ConnectToVMServer SetMailServer GetXmlDocElementValue VerifyWinProcessCPU SelectWebIndex RefreshWebPage ClickWebLink DeleteWinEvents VerifyWebWindowCount OpenDBConnection StopExecutionTime StopScript AddPathSubfolder GenerateAMSerialNumber GetJsonDocElementValue CreateVMSnapshot LoadXmlDocFile GetWindow ClickItem VerifyWinProcessTitle IsWebElementPresent GetWebTextExists GetWebText SetVariable GetRegValue DeleteVMW SetDateVariable GoWebPageBack GetWebUrl SetGuidVariableFromBin GetReTryErrorCounter VerifyRESTfulCallTime VerifyWCFCallTime WaitIfPerformanceCounter GetXmlDocNodeCount ClickButton IsWebValueIncluded GetWebCell AddToIntegerVariable CallWCFWebService RemovePathSubfolder CompareStrings DisconnectServers CompressFolders ShutdownVM VerifyRegKeyExists DeleteVMWSnapshot CopyFileFromHostToVMWGuest CopyFileFromVMWGuestToHost VerifyDisplayNameService CreateWinEvents WaitForWebCellValueByRef GetWebTable GetWebControlsCount SetRandomStringToVariable SetFileVariable WaitMinutes WaitSeconds AddPath LoadDll RemoveMongoDBBsonDocuments AddJsonDocChild RestoreFirstVMSnapshot RightClickMenuOption ToggleWebControl KillProcessInVMWGuest ConnectToVMWServer IsWebElementVisible ClickWebRow ConvertIPAddressVarToDec CreateArrayVar RemovePath SetRESTfulHeader SetWCFHeader CallRESTfulWebService UnmapDrive GetMongoDBBsonDocuments CountMongoDBBsonDocuments JsonReadConfigFile RemoveJsonDocElement CopyFiles RestoreVMSnapshot SetXmlDocObject CreateXmlDoc TypeText IsWebTextPresent CompareWebText ClickWebControl OpenVMW DirectoryExistsInGuest VerifyWebColumnValue VerifyWebColumnOrder MoveWebColumn StartExecutionTime ExecuteProgram VerifyPerformanceCounter LogJsonDocOutput DeleteVMSnapshot VerifyItem ClickRadio DeleteVMWFile CloneVMW FocusWebControl ClickWebCellByRef RunDBScript SetSpira WaitForFile AnimateExecution UnmapDrives VerifyJsonDocPairs DecompressFiles StartVM VerifyText VerifyHelpText VerifyControlProperty CheckBox GetWebTitle UnpauseVMW ShutdownVMW RunProgramInVMWGuest StartService VerifyRunningService SplitToVariable SelectFromListToVariable DeleteArrayVar VerifyTextFileLine StopScriptIf SetVarFromRESTfulHeader SetVarFromWCFHeader EditRESTfulHeaderValue EditWCFHeaderValue Ping VerifyJsonValue CreateJsonDoc CloseWindow GetWebCellByRef RunScriptInVMWGuest PauseVMW FileExistsInGuest CreateVMWFolder DisableService RunDBStoredProcedure StopScriptIfError VerifyRESTfulHeaderExists VerifyWCFHeaderExists AddJsonDocPair ClearJsonObjects VerifyFileExists EmptyFolders MoveFolders VerifyXmlDocValue FinalizeXmlDocObject RestoreWindow WaitIfWinProcInstances KillWinTask WaitForWebPageToLoad StopWebEngine SelectWebWindow CompareWebSelectedLabel CloseWebWindow VerifyRegValue RenameFileInVMWGuest DisconnectToVMWServer SetWebWaitTime VerifyTextFile CheckNetwork UpdateMongoDBBsonDocuments SetPermissions CreateFolder AddXmlDocChild KillWinProcess VerifyWinProcessMemory StartWebEngine StartVMW LogoutGuestVMW SetIntegerVariable SetRandomNumberToVariable UpdateDB ResetErrorCounter GetErrorCounter ExecuteMethod DisconnectMongoDBServer ReplaceJsonDocSubstring CompareJsonDocObjects GetJsonDocArrayCount CompressFiles MinimizeWindow ClickCombo TypeWebText CaptureVMWScreenImage StopService WaitUntilWebTableRowIsDisplayed IsWebElementEditable CountWebTableColumns CreateFile StopScriptIfFileExists ResetReTryErrorCounter ConnectToMongoDBServer AddJsonDocElement IsWebElementClickable ExecuteScript CompareWebValue IsVariableExist StringMethods ConvertDateStrToDateTimeVar GetWebSelectElementIndexByAttrValue @param If While
syn keyword InternalVars contained DOUBLESLASH RANDOMNUMBER WAITFORWEBELEMENT CPUPERCENTAGE ERRORLIMIT CURRENTSCRIPTREPITION CURRENTSCRIPTFOLDER CURRENTDATAROW NEWGUID CURRENTDATAFILE ITEMCOUNTER
syn keyword StartEnd [Start] [End] [Stopped]
setlocal iskeyword+=-
setlocal iskeyword-=%
syn keyword Error --Error NullReferenceException WebDriverException WebException


" Strings. Keepend means end of string also ends all contained regions.
syn region string start='"' skip='\\.' end='\("\|$\)' contains=identifier,xpath keepend
syn region string start="'" skip='\\.' end="\('\|$\)" contains=identifier,xpath keepend
" Strings contain substituted variables
" \@<! is negative lookbehind: don't match a % that's preceded by a \
syn region identifier start="\\\@<!%" skip='\\.' end="%" contained contains=InternalVars keepend
" Hilight filepaths next to [Start] or [End]. Remember, [Start] and [End] are
" keywords so they can't be in the match. \zs tells it to start matching, \m
" is for magic. Double-clicking stuff in the filepath group opens that file.
syn match filepath "\m--> \zs\u:.\+\.ts" 
" Numbas
syn match number '\<\d\+\>'
" Date at beginning of each line
syn match Date '\d\+-\d\+-\d\+ \d\+:\d\+:\d\+,\d\+'


hi def link Time Delimiter
hi def link InternalVars PreProc
hi def link StartEnd Statement
hi def link filepath Underlined
hi def link Date Delimiter

" REGEX NOTES: \v at beginning of pattern makes it very magical
" (meaning special chars like () have special meanings)
