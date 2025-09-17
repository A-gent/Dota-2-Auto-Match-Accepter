#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance, Force
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;
;;;        AUTOEXEC EXECUTION BLOCK 
;;;
;;;========================================
;;;========================================
;;;========================================


t1:=A_TickCount, Text:=X:=Y:=""

GLOBAL config_title := "settings.cfg"
GLOBAL config_file := A_ScriptDir . "\" . config_title

GLOBAL engine_title := "Queue Aegis"
GLOBAL engine_title_suffix := "(Dota 2 Queue Accepter)"



GLOBAL ToggleToolTipFlag := "0"
GLOBAL ToggleToolTipFlagPOS := "0"


GLOBAL SetToRunWithWindowsToggleFlag := "0"

GLOBAL PauseToggleFlag := "0"
GLOBAL CurrentPauseState := "UNPAUSED"



IniRead, bUACElevate, %config_file%, DEBUG, RunAsAdministrator, 0
GLOBAL UACElevate := bUACElevate
;                         {[
;;           ELEVATE TO ADMIN UAC PROMPT BELOW
; If the script is not elevated, relaunch as administrator and kill current instance:
            If(UACElevate="1")
            {
full_command_line := DllCall("GetCommandLine", "str")
 
if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)"))
{
    try ; leads to having the script re-launching itself as administrator
    {
        if A_IsCompiled
            Run *RunAs "%A_ScriptFullPath%" /restart
        else
            Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%"
    }
    ExitApp
}
;
;                          ]}
            }




ToolTip
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;
;;;        GUI CONSTRUCTION BLOCK
;;;
;;;========================================
;;;========================================
;;;========================================


Sleep, 500
;;;;; TRAY MENU STRUCT
Menu, Tray, NoStandard
Menu, Tray, Add, Settings, TrayBTN_SETTINGS  ; Creates a new menu item.
Menu, Tray, Add, Open Container, TrayBTN_CONTAINER  ; Creates a new menu item.
; Menu, Tray, Add  ; Creates a separator line.
; Menu, Tray, Add, Direct QuickHotspot, RunQHSThreadCall   ; Creates a new menu item.
; Menu, Tray, Add, Query PDAnet Uptime, pdaUptime_CallModuleBTN   ; Creates a new menu item.
; Menu, Tray, Add  ; Creates a separator line.
; Menu, Tray, Add, StopWatch, OpenStopWatch  ;
; Menu, Tray, Add, Countdown Timer, OpenCountdownTimer  ;
; Menu, Tray, Add, Run Battle.net Overseer, OpenBNETHandler  ;
Menu, Tray, Add  ; Creates a separator line.
Menu, Tray, Add, Toggle HUD, TrayBTN_HUD  ; Creates a new menu item.
Menu, Tray, Add, Cycle HUD Position, TrayBTN_HudPOS  ; Creates a new menu item.
Menu, Tray, Add  ; Creates a separator line.
Menu, Tray, Add, Check Auto-Startup Status, TrayBTN_CheckIfSetRunWithWindows  ; Creates a new menu item.
Menu, Tray, Add, Toggle Auto-Startup With Windows, TrayBTN_SetToRunWithWindowsMAIN  ; Creates a new menu item.
Menu, Tray, Add  ; Creates a separator line.
; Menu, Tray, Add, Halt Root Threads, clampRootThreadCalls   ; Creates a new menu item.
; Menu, Tray, Add, Start Auto-HotSpot, reRunHotSpotSThreadCall   ; Creates a new menu item.


; Menu, Tray, Add, Stop Auto-HotSpot, clampHotSpotSThreadCall   ; Creates a new menu item.

; Menu, Tray, Add, Toggle Auto-Update Settings, ToggleAutoConnect   ; Creates a new menu item.
GLOBAL CurrentPauseState := "UNPAUSED"

; Menu, Tray, Add, Toggle All Threads, ToggleAllThreads   ; Creates a new menu item.
; Menu, Tray, Add, Stop Auto-Server, clampServerThreadCalls   ; Creates a new menu item.
; Menu, Tray, Add, Start Auto-Server, reRunServerThreadCalls   ; Creates a new menu item.
; Menu, Tray, Add  ; Creates a separator line.
; Menu, Tray, Add, Refresh Routines, reRunThreads   ; Creates a new menu item.
Menu, Tray, Add, Re-Run Autoexec, TrayBTN_REFRESHALL   ; Creates a new menu item.
Menu, Tray, Add, Refresh String Table, TrayBTN_REFRESHsettings   ; Creates a new menu item.
Menu, Tray, Add, Re-Run PushBullet Token Setup, TrayBTN_RERUNTOKENWIZARD   ; Creates a new menu item.
Menu, Tray, Add  ; Creates a separator line.
Menu, Tray, Add, Pause AutoQueue -- (%CurrentPauseState%), TrayBTN_TOGGLEPAUSE   ; Creates a new menu item.
Menu, Tray, Add, Reboot %engine_title%, TrayBTN_RELOAD   ; Creates a new menu item.
Menu, Tray, Add, Exit, TrayBTN_EXIT   ; Creates a new menu item.


Menu, Tray, Tip , %engine_title% %engine_title_suffix%

;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;
;;;         SETTINGS READING BLOCK 
;;;
;;;========================================
;;;========================================
;;;========================================
ReExecuteAutoexec:



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;   SWITCHES SETTINGS
IniRead, bAutoRefreshSettings, %config_file%, MASTER_QUEUE_TOGGLE_SWITCHES, AutomaticallyRefreshSettings, 1
GLOBAL switches_AutoRefreshSettings := bAutoRefreshSettings
IniRead, bSwitches_AcceptBTN, %config_file%, MASTER_QUEUE_TOGGLE_SWITCHES, EnableAcceptButton, 1
GLOBAL switches_AcceptBTN := bSwitches_AcceptBTN
IniRead, bSwitches_ReadyBTN, %config_file%, MASTER_QUEUE_TOGGLE_SWITCHES, EnableReadyButton, 1
GLOBAL switches_ReadyBTN := bSwitches_ReadyBTN
IniRead, bSwitches_OkBTN, %config_file%, MASTER_QUEUE_TOGGLE_SWITCHES, EnableOkButton, 1
GLOBAL switches_OkBTN := bSwitches_OkBTN
IniRead, bSwitches_OkBTN2, %config_file%, MASTER_QUEUE_TOGGLE_SWITCHES, EnableOkButton2, 1
GLOBAL switches_OkBTN2 := bSwitches_OkBTN2
IniRead, bSwitches_ReturningToQueueMsg, %config_file%, MASTER_QUEUE_TOGGLE_SWITCHES, EnableReturningToQueueMsg, 1
GLOBAL switches_ReturningToQueueMsg := bSwitches_ReturningToQueueMsg
IniRead, bSwitches_ReturningToQueueMsg2, %config_file%, MASTER_QUEUE_TOGGLE_SWITCHES, EnableReturningToQueueMsg2, 1
GLOBAL switches_ReturningToQueueMsg2 := bSwitches_ReturningToQueueMsg2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;   TOGGLE-CLICK-ACTIONS SETTINGS
IniRead, bClickActions_Accept, %config_file%, MASTER_TOGGLE_QUEUE_BUTTONCLICKS, ClickAcceptButton, 1
GLOBAL ClickActions_Accept := bClickActions_Accept
IniRead, bClickActions_Ready, %config_file%, MASTER_TOGGLE_QUEUE_BUTTONCLICKS, ClickReadyButton, 1
GLOBAL ClickActions_Ready := bClickActions_Ready
IniRead, bClickActions_OK, %config_file%, MASTER_TOGGLE_QUEUE_BUTTONCLICKS, ClickOkButton, 1
GLOBAL ClickActions_OK := bClickActions_OK
IniRead, bClickActions_OK2, %config_file%, MASTER_TOGGLE_QUEUE_BUTTONCLICKS, ClickOkButton2, 1
GLOBAL ClickActions_OK2 := bClickActions_OK2
IniRead, bClickActions_ReturningMsg, %config_file%, MASTER_TOGGLE_QUEUE_BUTTONCLICKS, ClickReturningToMatchmakingMessage, 1
GLOBAL ClickActions_ReturningMsg := bClickActions_ReturningMsg
IniRead, bClickActions_ReturningMsg2, %config_file%, MASTER_TOGGLE_QUEUE_BUTTONCLICKS, ClickReturningToMatchmakingMessage2, 1
GLOBAL ClickActions_ReturningMsg2 := bClickActions_ReturningMsg2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;   PRE-TIMER-DELAYS SETTINGS
IniRead, bPreTimerExecDelay_accept, %config_file%, PRE_TIMER_DELAYS, Accept, 5000
GLOBAL PreTimerExecDelay_accept := bPreTimerExecDelay_accept
IniRead, bPreTimerExecDelay_ready, %config_file%, PRE_TIMER_DELAYS, Ready, 5000
GLOBAL PreTimerExecDelay_ready := bPreTimerExecDelay_ready
IniRead, bPreTimerExecDelay_ok, %config_file%, PRE_TIMER_DELAYS, Ok, 5000
GLOBAL PreTimerExecDelay_ok := bPreTimerExecDelay_ok
IniRead, bPreTimerExecDelay_ok2, %config_file%, PRE_TIMER_DELAYS, Ok2, 5000
GLOBAL PreTimerExecDelay_ok2 := bPreTimerExecDelay_ok2
IniRead, bPreTimerExecDelay_returning, %config_file%, PRE_TIMER_DELAYS, ReturningToQueue, 5000
GLOBAL PreTimerExecDelay_returning := bPreTimerExecDelay_returning
IniRead, bPreTimerExecDelay_returning2, %config_file%, PRE_TIMER_DELAYS, ReturningToQueue2, 5000
GLOBAL PreTimerExecDelay_returning2 := bPreTimerExecDelay_returning2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;   TIMER SETTINGS
IniRead, bAutoRefreshSettings, %config_file%, TIMERS, AutomaticallyRefreshSettings, 13000
GLOBAL Timers_AutoRefreshVarsDelay := AutoRefreshSettings
IniRead, bTimers_AcceptBTN, %config_file%, TIMERS, AcceptButtonDelay, 4
GLOBAL Timers_AcceptBTN := bTimers_AcceptBTN
IniRead, bTimers_ReadyBTN, %config_file%, TIMERS, ReadyButtonDelay, 4
GLOBAL Timers_ReadyBTN := bTimers_ReadyBTN
IniRead, bTimers_OkBTN, %config_file%, TIMERS, OkButtonDelay, 4
GLOBAL Timers_OkBTN := bTimers_OkBTN
IniRead, bTimers_OkBTN2, %config_file%, TIMERS, OkButton2Delay, 4
GLOBAL Timers_OkBTN2 := bTimers_OkBTN2
IniRead, bTimers_ReturningQueueMSG, %config_file%, TIMERS, ReturningToMatchmakingDelay, 4
GLOBAL Timers_ReturningQueueMSG := bTimers_ReturningQueueMSG
IniRead, bTimers_ReturningQueueMSG2, %config_file%, TIMERS, ReturningToMatchmaking2Delay, 4
GLOBAL Timers_ReturningQueueMSG2 := bTimers_ReturningQueueMSG2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;   DEBUG SETTINGS
IniRead, bDebug_QueueAcceptMsg, %config_file%, DEBUG, QueueAcceptNotify, 5
GLOBAL Debug_QueueAcceptMsg := bDebug_QueueAcceptMsg
IniRead, bDebug_MiscOkMsg, %config_file%, DEBUG, MiscOkButtonNotify, 5
GLOBAL Debug_MiscOkMsg := bDebug_MiscOkMsg
IniRead, bDebug_MiscOkMsg2, %config_file%, DEBUG, MiscOkButton2Notify, 5
GLOBAL Debug_MiscOkMsg2 := bDebug_MiscOkMsg2
IniRead, bDebug_PartyReadyCheckMsg, %config_file%, DEBUG, PartyReadyCheckNotify, 5
GLOBAL Debug_PartyReadyCheckMsg := bDebug_PartyReadyCheckMsg
IniRead, bDebug_QueueReturningToQueueMsg, %config_file%, DEBUG, QueueReturningToMatchmakingNotify, 5
GLOBAL Debug_QueueReturningToQueueMsg := bDebug_QueueReturningToQueueMsg
IniRead, bDebug_PickScreenReturningToQueueMsg, %config_file%, DEBUG, PickScreenReturningToMatchmakingNotify, 5
GLOBAL Debug_PickScreenReturningToQueueMsg := bDebug_PickScreenReturningToQueueMsg

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;   SMARTPHONE SETTINGS
IniRead, bPushBulletAccessToken, %config_file%, SMARTPHONE, PushBulletAccessToken, 5
GLOBAL PushBulletAccessToken := bPushBulletAccessToken
IniRead, bPushBulletNotifications, %config_file%, SMARTPHONE, EnablePushNotifications, 1
GLOBAL PushBulletNotifications := bPushBulletNotifications
IniRead, bPushNotifyClickAccept, %config_file%, SMARTPHONE, PushNotificationClickAcceptQueue, 1
GLOBAL PushNotifyClickAccept := bPushNotifyClickAccept
IniRead, bPushNotifyClickReady, %config_file%, SMARTPHONE, PushNotificationClickReadyCheck, 1
GLOBAL PushNotifyClickReady := bPushNotifyClickReady
IniRead, bPushNotifyClickOk, %config_file%, SMARTPHONE, PushNotificationClickErrorOk, 1
GLOBAL PushNotifyClickOk := bPushNotifyClickOk
IniRead, bPushNotifyClickOk2, %config_file%, SMARTPHONE, PushNotificationClickErrorOk2, 1
GLOBAL PushNotifyClickOk2 := bPushNotifyClickOk2
IniRead, bPushNotifyReturningQueuePick, %config_file%, SMARTPHONE, PushNotificationReturningToQueueFromPickScreen, 1
GLOBAL PushNotifyReturningQueuePick := bPushNotifyReturningQueuePick
IniRead, bPushNotifyReturningQueueMenu, %config_file%, SMARTPHONE, PushNotificationReturningToQueueFromMainMenuScreen, 1
GLOBAL PushNotifyReturningQueueMenu := bPushNotifyReturningQueueMenu


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;   PUSHBULLET NOTIFICATION SETTINGS
IniRead, bMatchFoundPushNotificationTitle, %config_file%, SMARTPHONE_MESSAGE_CONTENTS, MatchFoundPushNotificationTitle, 5
GLOBAL MatchFoundPushNotificationTitle := bMatchFoundPushNotificationTitle
IniRead, bMatchFoundPushNotificationMessage, %config_file%, SMARTPHONE_MESSAGE_CONTENTS, MatchFoundPushNotificationMessage, 5
GLOBAL MatchFoundPushNotificationMessage := bMatchFoundPushNotificationMessage

IniRead, bReadyCheckPushNotificationTitle, %config_file%, SMARTPHONE_MESSAGE_CONTENTS, ReadyCheckPushNotificationTitle, 5
GLOBAL ReadyCheckPushNotificationTitle := bReadyCheckPushNotificationTitle
IniRead, bReadyCheckPushNotificationMessage, %config_file%, SMARTPHONE_MESSAGE_CONTENTS, ReadyCheckPushNotificationMessage, 5
GLOBAL ReadyCheckPushNotificationMessage := bReadyCheckPushNotificationMessage

IniRead, bErrorOkPushNotificationTitle, %config_file%, SMARTPHONE_MESSAGE_CONTENTS, ErrorOkPushNotificationTitle, 5
GLOBAL ErrorOkPushNotificationTitle := bErrorOkPushNotificationTitle
IniRead, bErrorOkPushNotificationMessage, %config_file%, SMARTPHONE_MESSAGE_CONTENTS, ErrorOkPushNotificationMessage, 5
GLOBAL ErrorOkPushNotificationMessage := bErrorOkPushNotificationMessage

IniRead, bErrorOk2PushNotificationTitle, %config_file%, SMARTPHONE_MESSAGE_CONTENTS, ErrorOk2PushNotificationTitle, 5
GLOBAL ErrorOk2PushNotificationTitle := bErrorOk2PushNotificationTitle
IniRead, bErrorOk2PushNotificationMessage, %config_file%, SMARTPHONE_MESSAGE_CONTENTS, ErrorOk2PushNotificationMessage, 5
GLOBAL ErrorOk2PushNotificationMessage := bErrorOk2PushNotificationMessage

IniRead, bReturningQueuePickPushNotificationTitle, %config_file%, SMARTPHONE_MESSAGE_CONTENTS, ReturningQueuePickScreenPushNotificationTitle, 5
GLOBAL ReturningQueuePickPushNotificationTitle := bReturningQueuePickPushNotificationTitle
IniRead, bReturningQueuePickPushNotificationMessage, %config_file%, SMARTPHONE_MESSAGE_CONTENTS, ReturningQueuePickScreenPushNotificationMessage, 5
GLOBAL ReturningQueuePickPushNotificationMessage := bReturningQueuePickPushNotificationMessage

IniRead, bReturningQueueMenuPushNotificationTitle, %config_file%, SMARTPHONE_MESSAGE_CONTENTS, ReturningQueueMainMenuPushNotificationTitle, 5
GLOBAL ReturningQueueMenuPushNotificationTitle := bReturningQueueMenuPushNotificationTitle
IniRead, bReturningQueueMenuPushNotificationMessage, %config_file%, SMARTPHONE_MESSAGE_CONTENTS, ReturningQueueMainMenuPickScreenPushNotificationMessage, 5
GLOBAL ReturningQueueMenuPushNotificationMessage := bReturningQueueMenuPushNotificationMessage



GLOBAL PB_Token   := PushBulletAccessToken
; GLOBAL PB_Title   := MatchFoundPushNotificationTitle
; GLOBAL PB_Message := MatchFoundPushNotificationMessage

GLOBAL PB_Title1   := MatchFoundPushNotificationTitle
GLOBAL PB_Message1 := MatchFoundPushNotificationMessage

GLOBAL PB_Title2   := ReadyCheckPushNotificationTitle
GLOBAL PB_Message2 := ReadyCheckPushNotificationMessage

GLOBAL PB_Title3   := ErrorOkPushNotificationTitle
GLOBAL PB_Message3 := ErrorOkPushNotificationMessage

GLOBAL PB_Title4   := ErrorOk2PushNotificationTitle
GLOBAL PB_Message4 := ErrorOk2PushNotificationMessage

GLOBAL PB_Title5   := ReturningQueueMenuPushNotificationTitle
GLOBAL PB_Message5 := ReturningQueueMenuPushNotificationMessage

GLOBAL PB_Title6   := ReturningQueuePickPushNotificationTitle
GLOBAL PB_Message6 := ReturningQueuePickPushNotificationMessage



;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;
;;;          DEFINE ROUTINES BLOCK 
;;;
;;;========================================
;;;========================================
;;;========================================


AscertainPBToken:
IniRead, bPushBulletNotifications, %config_file%, SMARTPHONE, EnablePushNotifications, 1
GLOBAL cPushBulletNotifications := bPushBulletNotifications
If(cPushBulletNotifications="1")
{
  IniRead, bPushBulletAccessToken, %config_file%, SMARTPHONE, PushBulletAccessToken, 5
  GLOBAL cPushBulletAccessToken := bPushBulletAccessToken
  If(cPushBulletAccessToken="")
  {
    ; InputBox, PushAccessToken, [%engine_title%]:  PushBullet Access Token Wizard, ______Please Paste Your Pushbullet Access Token Below_______`n`n(Please ENSURE No Accidental Spaces Or Extra Characters!),,
    ; InputBox, PushAccessToken, [%engine_title%]:  PushBullet Access Token Startup Wizard, .     Please Paste Your Pushbullet Access Token Below`n`n(Please ENSURE No Accidental Spaces Or Extra Characters!),,
    InputBox, PushAccessToken, [%engine_title%]:  SmartPhone Notifications Setup Wizard, `n                                     Welcome to %engine_title% (Dota 2 Auto-Accepter)!`n`n      Make An Account On The PushBullet.com website`, And Download PushBullet From On Your Phone.`n`n   Next`, Log Into Your PusbBullet Account On The Website`, Go To The Settings Page On The Bottom Left.`n      In The Settings`, Click Create Access Token. Paste or Enter The New PushBullet Access Token Below.`n    Copy/Paste Is The Safest Way To Ensure Its Correctly Entered. Once Done`, Press OK below to proceed.`n`n         This Access Token Provides %engine_title% The Ability To Send Your Phone Push Notifications.`n`n     (PLEASE ENSURE No Accidental Spaces`, Extra Letters`, Or Incorrect Capitalization If Manually Typed!),, 648,319
    If ErrorLevel
    {
      BlankString := ""
      IniWrite, %BlankString%, %config_file%, SMARTPHONE, PushBulletAccessToken   ;;;; Ensure the token box gets reset back to empty
      MsgBox, 4, [%engine_title%]:  SmartPhone Notifications Setup Wizard, CANCEL was pressed and no PushBullet Access Token was provided.`nQueue Aegis is unable to send Phone Push Notifications in this state. `n`nDo you want to Try Again (YES)?`nOr do you want to Disable Smartphone Push Notifications (NO)?
      IfMsgBox, Yes
      {
        Goto, AscertainPBToken
      }
      IfMsgBox, No
      {
        BlankString := ""
        IniWrite, %BlankString%, %config_file%, SMARTPHONE, PushBulletAccessToken
        IniWrite, 0, %config_file%, SMARTPHONE, EnablePushNotifications
      }
    }
   Else
       {
         IniWrite, %PushAccessToken%, %config_file%, SMARTPHONE, PushBulletAccessToken
         MsgBox, 64, [%engine_title%]:  SmartPhone Notifications Setup Wizard, %engine_title% saved your PushBullet Token in file 'settings.cfg'.`nThis Wizard will not run again`, unless you manually run it again later.`n`nNow Continuing Queue Aegis Startup Sequence...
       }

  }
}
SkipPBToken:


;;;;; HUD TIP MESSAGE
IniRead, ToolTipEnabled, %config_file%, HUD, EnableHUD, 1
If(ToolTipEnabled="1")
{
  SetTimer, ToolTipLabel, -150
}


If(switches_AutoRefreshSettings="1")
{
    SetTimer, REREAD_SETTINGS, %Timers_AutoRefreshVarsDelay%
}


;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
; RunOrActivate(appTitle, appPath)

StartFindTextBlock:
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;
;;;      ACCEPT BUTTON FINDTEXT BLOCK
;;;
;;;========================================
;;;========================================
;;;========================================
                            If(switches_AcceptBTN="1")
                            {
                              Sleep, %PreTimerExecDelay_accept%
GLOBAL HOURbeforeExec := A_Hour
GLOBAL MINbeforeExec := A_Min
GLOBAL SECbeforeExec := A_Sec
GLOBAL HOURresult := ""
GLOBAL MINresult := ""
GLOBAL SECresult := ""
GLOBAL HOURresultFormatted := ""
GLOBAL MINresultFormatted := ""
GLOBAL SECresultFormatted := ""


GLOBAL WAITPERIOD1 := Timers_AcceptBTN



GLOBAL acceptBtn_string_0x2560x1440 := "|<AcceptBUTTON>**50$183.00DU0003zz001zzU3zzz0Dzy03zzzzs01a0003s0Q01w0C0k008301y0M000300ME000s00U0Q00E60010M00s20000M033000Q0040C0020k00M3001kE000300kM007000U3U00E60030M00620000M061U01k0040s0020k00M3000ME000301UA00A000U6000E60020800120000M0A0k0303z41U1zW0E7zk10T0ATz0Tz010600E1sTU80wDk20U0082Q1U0M2000M0M060Q0Q30C0C0E40010Ek4010E0020300U6000E300020U008260U082000k0A0A1k0060s000E40010Ek4010E00621U1UA000k600020zy08260U082001UE40A100060U000E00k10FU4010E00A70k10M000UA0002002082Q1U0820030s208300041U000E00E10T0A010E00MB0M10E000U800020020800100820061g308300041U000E00E1000M010E00k8UA10M000UA0002002080060082004361U8300041U000E7zk1001U010E01UTk61UA000k600020U00801s0082008000kA1U0060k000E40010Tw0010E0300030U6000E300020U0083s0008200M000M60M0030A000E40010E00010E060001Uk1kDUM0s3k20U008200008200k000A307zY1U3zm0E7zs10E00010E0A3zy0kQ03UUC01kE60030M200008201UM0k61U0040k0020k00830E00030E0M2020M6000U3000E60010M20000M2030k0M30Q0040C0020k00830E00030E0k6030A1k00U0s00E60010M20000M2061U0A1U3k0401s020k00830E00030E0zw01zw07zzU03zzk7zzz0Ty0000Ty04"

;;; IF THE TEXT SHAPE EXISTS AT ANY POINT, CLICK IT. DO IN FACT WAIT EXACTLY THE NUMBER OF SECONDS HOUSED IN THE 'WAITPERIOD' STRING FOR IT TO EXIST, AND THEN PROCEED TO EXIT. BASIC EXAMPLE.
;;;
; if (ok:=FindText(X:="wait", Y:=63, 1180-150000, 1076-150000, 1180+150000, 1076+150000, 0, 0, acceptBtn_string_0x2560x1440))
if (ok:=FindText(X:="wait", Y:=WAITPERIOD1, 1180-150000, 1076-150000, 1180+150000, 1076+150000, 0, 0, acceptBtn_string_0x2560x1440))
{
  IniRead, bClickActions_Accept, %config_file%, MASTER_TOGGLE_QUEUE_BUTTONCLICKS, ClickAcceptButton, 1
  GLOBAL ClickActions_Accept := bClickActions_Accept
  IniRead, bPushBulletNotifications, %config_file%, SMARTPHONE, EnablePushNotifications, 1
  GLOBAL PushBulletNotifications := bPushBulletNotifications
  If(PushBulletNotifications="1")
  {
    If(PushNotifyClickAccept="1")
    {
      PB_PushNote(PB_Token, PB_Title1, PB_Message1)
    }
  }
  If(ClickActions_Accept="1")
  {
  MouseGetPos, CurrentXPos, CurrentYPos
  FindText().Click(X, Y, "L")
  SendEvent {Click %CurrentXPos% %CurrentYPos%}
  }
}


; SetTimer, FormatContrastPostExecTime, -50
; Sleep, 350

GLOBAL HOURafterExec := A_Hour
GLOBAL MINafterExec := A_Min
GLOBAL SECafterExec := A_Sec

GLOBAL HOURresult := ""
GLOBAL MINresult := ""
GLOBAL SECresult := ""

GLOBAL HOURresult := HOURbeforeExec-HOURafterExec

GLOBAL MINresult := MINbeforeExec-MINafterExec
GLOBAL SECresult := SECbeforeExec-SECafterExec

GLOBAL HOURresultFormatted := HOURresult . A_Space . "h" . ":"
GLOBAL MINresultFormatted := MINresult . A_Space . "m" . ":"
GLOBAL SECresultFormatted := SECresult . A_Space . "s" . ":"

If(HOURresult="0")
{
    GLOBAL HOURresultFormatted := ""
}

If(MINresult="0")
{
GLOBAL MINresultFormatted := ""
}

If(SECresult="0")
{
GLOBAL SECresultFormatted := ""
}

        GLOBAL RESULTtimeCombo1 := HOURresultFormatted . MINresultFormatted . SECresultFormatted

        RESULTtimeCombo2 := StrReplace(RESULTtimeCombo1, A_Space, "")
        RESULTtimeCombo3 := StrReplace(RESULTtimeCombo2, "-", "")

IniRead, bDebug_QueueAcceptMsg, %config_file%, DEBUG, QueueAcceptNotify, 5
GLOBAL Debug_QueueAcceptMsg := bDebug_QueueAcceptMsg
If(Debug_QueueAcceptMsg="1")
{
MsgBox,, QueueAccept, EXECUTION WAS ALLOWED TO PIPE OUTSIDE OF THE FENCE OF THE TEXT FUNCTION AND ENGINE WILL NOW PROCEED TO EXIT`n`n TIME ELAPSED FROM BEGIN FUNCTION FENCE TO FENCE BREAKPOINT:`n`n%RESULTtimeCombo3%, 25
}

                            }
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;
;;;      READY BUTTON FINDTEXT BLOCK
;;;
;;;========================================
;;;========================================
;;;========================================
                            If(switches_ReadyBTN="1")
                            {
                              Sleep, %PreTimerExecDelay_ready%
GLOBAL HOURbeforeExec := A_Hour
GLOBAL MINbeforeExec := A_Min
GLOBAL SECbeforeExec := A_Sec
GLOBAL HOURresult := ""
GLOBAL MINresult := ""
GLOBAL SECresult := ""
GLOBAL HOURresultFormatted := ""
GLOBAL MINresultFormatted := ""
GLOBAL SECresultFormatted := ""



GLOBAL WAITPERIOD2 := Timers_ReadyBTN



GLOBAL readyBtn_string_0x2560x1440 :="|<>**50$159.zzy003zzz001w000zzy00Tz01zy01w00k00800Ak00A03y030Q0M3k00s060010032001U00w0M1U60S003U0k00M00MM00A001k1U60k6k00C060030063001U007060kA1a000k0k00M00kA00A000A0k31UAk0030600200A1U00U000k30MM320y0M0E7zk01U60041y060A1a0kE4s1020U00080k00U8w0M1U6k620VU80E400030300410k1060w1UE4A1020U000E0M00U830A0k3UM20VU80E4000601U0410A1U30M30E4A1020zy00kEA00U80k40A00k20X0M0E00k0A20U041060U1U060E7k30200201Us600U80E40601U20k0E0E00E0M70E041020k0M0M0E00602002031c300U80E6030302001U0E00E0kBUM041020k0A0k0E00s0200206141U0U80E401UA0200600E7zk0UMkA041060U061U0E60M020U00A3y0k0U80k400kA020s300E400100060410A1U061U0E5UA020U00M000M0U83UA00kA020g0k0E400300030410s10061U0E4k6020U00k000A0U8S0M00kA020X0M0k7zs60001U41z060061U0k4M1U60031UTzk61U000k00kA060VUA0k008A3060kA000A0061U0k4A0k600130E0E31U003000kA060Uk30k008M6030MA001k0061U0k430A600160k0M1VU00w000kA060UM1Uk008kA01UAA00y00041U0zw1zw7zzz7zU0DzVzzz0000zw04"

if (ok:=FindText(X:="wait", Y:=WAITPERIOD2, 364-150000, 1037-150000, 364+150000, 1037+150000, 0, 0, readyBtn_string_0x2560x1440))
{
  IniRead, bClickActions_Ready, %config_file%, MASTER_TOGGLE_QUEUE_BUTTONCLICKS, ClickReadyButton, 1
  GLOBAL ClickActions_Ready := bClickActions_Ready
  IniRead, bPushBulletNotifications, %config_file%, SMARTPHONE, EnablePushNotifications, 1
  GLOBAL PushBulletNotifications := bPushBulletNotifications
  If(PushBulletNotifications="1")
  {
    If(PushNotifyClickReady="1")
    {
    PB_PushNote(PB_Token, PB_Title2, PB_Message2)
    }
  }
  If(ClickActions_Ready="1")
  {
  FindText().Click(X, Y, "L")
  }
}

; SetTimer, FormatContrastPostExecTime, -50
; Sleep, 350

GLOBAL HOURafterExec := A_Hour
GLOBAL MINafterExec := A_Min
GLOBAL SECafterExec := A_Sec

GLOBAL HOURresult := ""
GLOBAL MINresult := ""
GLOBAL SECresult := ""

GLOBAL HOURresult := HOURbeforeExec-HOURafterExec

GLOBAL MINresult := MINbeforeExec-MINafterExec
GLOBAL SECresult := SECbeforeExec-SECafterExec

GLOBAL HOURresultFormatted := HOURresult . A_Space . "h" . ":"
GLOBAL MINresultFormatted := MINresult . A_Space . "m" . ":"
GLOBAL SECresultFormatted := SECresult . A_Space . "s" . ":"

If(HOURresult="0")
{
    GLOBAL HOURresultFormatted := ""
}

If(MINresult="0")
{
GLOBAL MINresultFormatted := ""
}

If(SECresult="0")
{
GLOBAL SECresultFormatted := ""
}

        GLOBAL RESULTtimeCombo1 := HOURresultFormatted . MINresultFormatted . SECresultFormatted

        RESULTtimeCombo2 := StrReplace(RESULTtimeCombo1, A_Space, "")
        RESULTtimeCombo3 := StrReplace(RESULTtimeCombo2, "-", "")

IniRead, bDebug_PartyReadyCheckMsg, %config_file%, DEBUG, PartyReadyCheckNotify, 5
GLOBAL Debug_PartyReadyCheckMsg := bDebug_PartyReadyCheckMsg
If(Debug_PartyReadyCheckMsg="1")
{
MsgBox,, PartyReadyCheck, EXECUTION WAS ALLOWED TO PIPE OUTSIDE OF THE FENCE OF THE TEXT FUNCTION AND ENGINE WILL NOW PROCEED TO EXIT`n`n TIME ELAPSED FROM BEGIN FUNCTION FENCE TO FENCE BREAKPOINT:`n`n%RESULTtimeCombo3%, 25
}

                            }
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;
;;;       OK BUTTON FINDTEXT BLOCK
;;;
;;;========================================
;;;========================================
;;;========================================
                            If(switches_OkBTN="1")
                            {
                              Sleep, %PreTimerExecDelay_ok%
GLOBAL HOURbeforeExec := A_Hour
GLOBAL MINbeforeExec := A_Min
GLOBAL SECbeforeExec := A_Sec
GLOBAL HOURresult := ""
GLOBAL MINresult := ""
GLOBAL SECresult := ""
GLOBAL HOURresultFormatted := ""
GLOBAL MINresultFormatted := ""
GLOBAL SECresultFormatted := ""



GLOBAL WAITPERIOD3 := Timers_OkBTN



GLOBAL okBtn_string_0x2560x1440 :="|<>**50$40.0Tk1y7kDzk7sz1k3kEa4C03V2slkw64/767wAEsskssl33361VYAMAM36EX0V0AN0Q240lY1kAE36E3UlUAN26371VYAA4CCAEsMMTkl3VlkM64/3XU0kEa77UC12AA7zk7szk3s0000U"

if (ok:=FindText(X:="wait", Y:=WAITPERIOD3, 469-150000, 1043-150000, 469+150000, 1043+150000, 0, 0, okBtn_string_0x2560x1440))
{
  IniRead, bClickActions_OK, %config_file%, MASTER_TOGGLE_QUEUE_BUTTONCLICKS, ClickOkButton, 1
  GLOBAL ClickActions_OK := bClickActions_OK
  IniRead, bPushBulletNotifications, %config_file%, SMARTPHONE, EnablePushNotifications, 1
  GLOBAL PushBulletNotifications := bPushBulletNotifications
  If(PushBulletNotifications="1")
  {
    If(PushNotifyClickOk="1")
    {
    PB_PushNote(PB_Token, PB_Title3, PB_Message3)
    }
  }
  If(ClickActions_OK="1")
  {
    FindText().Click(X, Y, "L")
  }
}

; SetTimer, FormatContrastPostExecTime, -50
; Sleep, 350
GLOBAL HOURafterExec := A_Hour
GLOBAL MINafterExec := A_Min
GLOBAL SECafterExec := A_Sec

GLOBAL HOURresult := ""
GLOBAL MINresult := ""
GLOBAL SECresult := ""

GLOBAL HOURresult := HOURbeforeExec-HOURafterExec

GLOBAL MINresult := MINbeforeExec-MINafterExec
GLOBAL SECresult := SECbeforeExec-SECafterExec

GLOBAL HOURresultFormatted := HOURresult . A_Space . "h" . ":"
GLOBAL MINresultFormatted := MINresult . A_Space . "m" . ":"
GLOBAL SECresultFormatted := SECresult . A_Space . "s" . ":"

If(HOURresult="0")
{
    GLOBAL HOURresultFormatted := ""
}

If(MINresult="0")
{
GLOBAL MINresultFormatted := ""
}

If(SECresult="0")
{
GLOBAL SECresultFormatted := ""
}

        GLOBAL RESULTtimeCombo1 := HOURresultFormatted . MINresultFormatted . SECresultFormatted

        RESULTtimeCombo2 := StrReplace(RESULTtimeCombo1, A_Space, "")
        RESULTtimeCombo3 := StrReplace(RESULTtimeCombo2, "-", "")

IniRead, bDebug_MiscOkMsg, %config_file%, DEBUG, MiscOkButtonNotify, 5
GLOBAL Debug_MiscOkMsg := bDebug_MiscOkMsg

If(Debug_MiscOkMsg="1")
{
MsgBox,, OkMsg, EXECUTION WAS ALLOWED TO PIPE OUTSIDE OF THE FENCE OF THE TEXT FUNCTION AND ENGINE WILL NOW PROCEED TO EXIT`n`n TIME ELAPSED FROM BEGIN FUNCTION FENCE TO FENCE BREAKPOINT:`n`n%RESULTtimeCombo3%, 25
}

                            }
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;
;;;      OK BUTTON 2 FINDTEXT BLOCK
;;;
;;;========================================
;;;========================================
;;;========================================
                            If(switches_OkBTN2="1")
                            {
                              Sleep, %PreTimerExecDelay_ok2%
GLOBAL HOURbeforeExec := A_Hour
GLOBAL MINbeforeExec := A_Min
GLOBAL SECbeforeExec := A_Sec
GLOBAL HOURresult := ""
GLOBAL MINresult := ""
GLOBAL SECresult := ""
GLOBAL HOURresultFormatted := ""
GLOBAL MINresultFormatted := ""
GLOBAL SECresultFormatted := ""


GLOBAL WAITPERIOD4 := Timers_OkBTN2



GLOBAL okBtn2_string_0x2560x1440 :="|<>**50$40.0Tk1y7kDzk7sz1k3kEa4C03V2slkw64/767wAEsskssl33361VYAMAM36EX0V0AN0Q240lY1kAE36E3UlUAN26371VYAA4CCAEsMMTkl3VlkM64/3XU0kEa77UC12AA7zk7szs"

if (ok:=FindText(X:="wait", Y:=WAITPERIOD4, 469-150000, 1044-150000, 469+150000, 1044+150000, 0, 0, okBtn2_string_0x2560x1440))
{
  IniRead, bClickActions_OK2, %config_file%, MASTER_TOGGLE_QUEUE_BUTTONCLICKS, ClickOkButton2, 1
  GLOBAL ClickActions_OK2 := bClickActions_OK2
  IniRead, bPushBulletNotifications, %config_file%, SMARTPHONE, EnablePushNotifications, 1
  GLOBAL PushBulletNotifications := bPushBulletNotifications
  If(PushBulletNotifications="1")
  {
    If(PushNotifyClickOk2="1")
    {
    PB_PushNote(PB_Token, PB_Title4, PB_Message4)
    }
  }
  If(ClickActions_OK2="1")
  {
  FindText().Click(X, Y, "L")
  }
}

; SetTimer, FormatContrastPostExecTime, -50
; Sleep, 350
GLOBAL HOURafterExec := A_Hour
GLOBAL MINafterExec := A_Min
GLOBAL SECafterExec := A_Sec

GLOBAL HOURresult := ""
GLOBAL MINresult := ""
GLOBAL SECresult := ""

GLOBAL HOURresult := HOURbeforeExec-HOURafterExec

GLOBAL MINresult := MINbeforeExec-MINafterExec
GLOBAL SECresult := SECbeforeExec-SECafterExec

GLOBAL HOURresultFormatted := HOURresult . A_Space . "h" . ":"
GLOBAL MINresultFormatted := MINresult . A_Space . "m" . ":"
GLOBAL SECresultFormatted := SECresult . A_Space . "s" . ":"

If(HOURresult="0")
{
    GLOBAL HOURresultFormatted := ""
}

If(MINresult="0")
{
GLOBAL MINresultFormatted := ""
}

If(SECresult="0")
{
GLOBAL SECresultFormatted := ""
}

        GLOBAL RESULTtimeCombo1 := HOURresultFormatted . MINresultFormatted . SECresultFormatted

        RESULTtimeCombo2 := StrReplace(RESULTtimeCombo1, A_Space, "")
        RESULTtimeCombo3 := StrReplace(RESULTtimeCombo2, "-", "")

IniRead, bDebug_MiscOkMsg2, %config_file%, DEBUG, MiscOkButton2Notify, 5
GLOBAL Debug_MiscOkMsg2 := bDebug_MiscOkMsg2

If(Debug_MiscOkMsg2="1")
{
MsgBox,, OkMsg2, EXECUTION WAS ALLOWED TO PIPE OUTSIDE OF THE FENCE OF THE TEXT FUNCTION AND ENGINE WILL NOW PROCEED TO EXIT`n`n TIME ELAPSED FROM BEGIN FUNCTION FENCE TO FENCE BREAKPOINT:`n`n%RESULTtimeCombo3%, 25
}

                            }
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;
;;;  RETURNING TO QUEUE MSG FINDTEXT BLOCK
;;;
;;;========================================
;;;========================================
;;;========================================
                            If(switches_ReturningToQueueMsg="1")
                            {
                              Sleep, %PreTimerExecDelay_returning%
GLOBAL HOURbeforeExec := A_Hour
GLOBAL MINbeforeExec := A_Min
GLOBAL SECbeforeExec := A_Sec
GLOBAL HOURresult := ""
GLOBAL MINresult := ""
GLOBAL SECresult := ""
GLOBAL HOURresultFormatted := ""
GLOBAL MINresultFormatted := ""
GLOBAL SECresultFormatted := ""


GLOBAL WAITPERIOD5 := Timers_ReturningQueueMSG


GLOBAL returningMsg_string_0x2560x1440 :="|<>**50$527.00000000000000000000000000000000000000000000000000000000zU00000000000Ds0000000000000000000000000000000000000000000000000000000003k007U00000000011000000000000EE00000000000000003zy0000000000000000003w000000000000000000Dk00TU00000000022000000000000UU00z00000000000004070000000000000000006M000000000000000000Mk00X000000000064000000000001V001a00000000000008030000000000000000008M000000000000000000lU0320000000000A8000000000003200260000000000000E0300000D000000000000Ek0000000000S00000011U04400003k00008E0000000000024004A0000000000000Vw300001u000000000000VU0000000003o0000002300M80000SU0000EU0000000000048008M00000000000012y2000024000000000001a0000000000480000004301UE0000V00000V0000000000008E00NU00000000000024C4000048000000000001s00000000008E00000086030U00012000012000000000000EU00S000000000000048AA00008E00000000000000000000000EU000000E60A1000024000024000000000000V000000000000000008E8M0Tw3kzXw1y3tzTbw0DkTbw00Tvs07Vz07y000U40M20Tw0wDs0zs49z07vy3y03zU121z3w7tz007yy00000EUEk3kS7VzDs3wDz7zwC0TVzwC07Uzs0D3y0wD0012A1W43kC1sTk7Uw8T3UTyDSC0S1k247y7sTz3U1sDy00000V0VUA0C802EE48kM63060V63060Q08k0E0470700248348A06200UM0AEk1VUk3k61U0k48QA8FUk1U702A000012320k0CE0BUU8FUUQ40612A4061U01U0U0MQ03004AMAMEE064033U0MV01X10206200k8FksEX101UM00M000024A431sAk0PV0EXU0w00424Q00460s201U0kk03008MEEkUlw6A06600l041b000046DUkEb30V70411UC0U00004DkM67wBsTV20V10z87wA4887wAADw403kz31y200kslXV0zw4S7sMDxW1z321w1wA7zUUVQA1221z333z100000801UMMAMEU241223UEQQ88EEQQ8ksC800V046C601Xkm731kA8480UsD477246A6A8C1V13kk244772AC3W00000E060lUMEV048244A0VUMEEUVUMFVUAE0120MM64036lgO6008E8E33008M648MMMME0122730488M64MM3400000U0s13zkV208E488M130EUV130EW60MU0240VUA806BVkqA1zsUEU4A00Ek48EkEkEUDz44AA08EEk48VU680000100k2001240EU8EEU240V12240V4A0l00481308M08NXXAMDU10V08M00V08EV0V0V1w088Ek0EUV08F30AE000027VU4002480V0EUV048122448128E1W008E240Mk0El26Mks02120EU0120EV21212700EE300V120EW40MU000049VU80048E120V1208E24488E24EU3400EU480lU0V30MkX004240V00240V242424M00UU3012240V480l000008H1UEzzsEU2412240EU488EEU48V06800V08E1301220VV63y84812004812484848kTl12302448128E1W00000EX30VU00V04824480V08EEUV08F30AE0120Ek2602463328QAE8E26008E248E8E8F3VW2630488E24Ek3400000V331X001308MA88E120EUV120EX60MU0260lUA80484464EkMUEk6A00EU48EUEUEW6344C308EEU48lU6800001263330C260EkkEEU240V12240V660l004A1VUkE08EAM48V0lUVUAA00V08EV0V0V486A8S30EUV08FVUAEDUy3u463273w640knUUV0481224481247D200A811XVU0EUAU8F3731V08C7l20EV212128MsMEi30V120EV1nkUnXCAw86663y8ADlUy11208E24488E24A7s400MTX1w600V0T0EW7w633wM7tW40V242424EzUkVC312240V31y1134AEsEA6600E81VU02240EU488EEU48A00800E3300A0320Q0V630A20MM034812484848kM1V2C324481230022288UkUA6C00UM13024480V08EEUV08EQ00E00k2301k0640012C04860EM068E248E8E8Fk0V24C3488E24700444EF1V0A4D070s23UC88E120EUV120EUC0MU01k43U700A80024C0MEC0UQ0QEU48EUEUEVk3248C28EEU483U688MVW7y0Ts7zs0zw3zzkTU3w0z1y3w0z0Dzl001zs3zs00Tk007sDzzUDz0Dzkz0Dkz0z0z1zzwDkDwTUz0Dk3zwETVy7s00001y00DU0y0000000000000001l2000T00y0000000003w003s03s00000000000TU000000000000QEUC0s7U000000000000000000000000000024000000000000000000000000000000000000000000000000000V0000000000000000000000000000000000A800000000000000000000000000000000000000000000000000320000000000000000000000000000000000kk00000000000000000000000000000000000000000000000000AA00000000000000000000000000000000zz1U000000000000000000000000000000000000000000000000DzkM000000000000000000000000000000031k60000000000000000000000000000000000000000000000000kQ1U0000000000000000000000000000000600Q0000000000000000000000000000000000000000000000001U0700000000000000000000000000000000801k000000000000000000000000000000000000000000000000200Q00000000000000000000000000000000TUy00000000000000000000000000000000000000000000000007sDU000000000000000000000000000000007zk00000000000000000000000000000000000000000000000001zw000000U"


if (ok:=FindText(X:="wait", Y:=WAITPERIOD5, 741-150000, 1043-150000, 741+150000, 1043+150000, 0, 0, GLOBAL returningMsg_string_0x2560x1440))
{
  IniRead, bClickActions_ReturningMsg, %config_file%, MASTER_TOGGLE_QUEUE_BUTTONCLICKS, ClickReturningToMatchmakingMessage, 1
  GLOBAL ClickActions_ReturningMsg := bClickActions_ReturningMsg
  IniRead, bPushBulletNotifications, %config_file%, SMARTPHONE, EnablePushNotifications, 1
  GLOBAL PushBulletNotifications := bPushBulletNotifications
  If(PushBulletNotifications="1")
  {
    If(PushNotifyReturningQueuePick="1")
    {
    PB_PushNote(PB_Token, PB_Title5, PB_Message5)
    }
  }
  If(ClickActions_ReturningMsg="1")
  {
  FindText().Click(X, Y, "L")
  }
}


; SetTimer, FormatContrastPostExecTime, -50
; Sleep, 350
GLOBAL HOURafterExec := A_Hour
GLOBAL MINafterExec := A_Min
GLOBAL SECafterExec := A_Sec

GLOBAL HOURresult := ""
GLOBAL MINresult := ""
GLOBAL SECresult := ""

GLOBAL HOURresult := HOURbeforeExec-HOURafterExec

GLOBAL MINresult := MINbeforeExec-MINafterExec
GLOBAL SECresult := SECbeforeExec-SECafterExec

GLOBAL HOURresultFormatted := HOURresult . A_Space . "h" . ":"
GLOBAL MINresultFormatted := MINresult . A_Space . "m" . ":"
GLOBAL SECresultFormatted := SECresult . A_Space . "s" . ":"

If(HOURresult="0")
{
    GLOBAL HOURresultFormatted := ""
}

If(MINresult="0")
{
GLOBAL MINresultFormatted := ""
}

If(SECresult="0")
{
GLOBAL SECresultFormatted := ""
}

        GLOBAL RESULTtimeCombo1 := HOURresultFormatted . MINresultFormatted . SECresultFormatted

        RESULTtimeCombo2 := StrReplace(RESULTtimeCombo1, A_Space, "")
        RESULTtimeCombo3 := StrReplace(RESULTtimeCombo2, "-", "")

IniRead, bDebug_QueueReturningToQueueMsg, %config_file%, DEBUG, QueueReturningToMatchmakingNotify, 5
GLOBAL Debug_QueueReturningToQueueMsg := bDebug_QueueReturningToQueueMsg

If(Debug_QueueReturningToQueueMsg="1")
{
MsgBox,, QueueReturningToQueue, EXECUTION WAS ALLOWED TO PIPE OUTSIDE OF THE FENCE OF THE TEXT FUNCTION AND ENGINE WILL NOW PROCEED TO EXIT`n`n TIME ELAPSED FROM BEGIN FUNCTION FENCE TO FENCE BREAKPOINT:`n`n%RESULTtimeCombo3%, 25
}

                            }
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;
;;; RETURNING TO QUEUE MSG 2 FINDTEXT BLOCK
;;;
;;;========================================
;;;========================================
;;;========================================
                            If(switches_ReturningToQueueMsg2="1")
                            {
                              Sleep, %PreTimerExecDelay_returning2%
GLOBAL HOURbeforeExec := A_Hour
GLOBAL MINbeforeExec := A_Min
GLOBAL SECbeforeExec := A_Sec
GLOBAL HOURresult := ""
GLOBAL MINresult := ""
GLOBAL SECresult := ""
GLOBAL HOURresultFormatted := ""
GLOBAL MINresultFormatted := ""
GLOBAL SECresultFormatted := ""


GLOBAL WAITPERIOD6 := Timers_ReturningQueueMSG2


GLOBAL returningMsg2_string_0x2560x1440 :="|<>**50$467.00000000000000000000000000000000000000000000000000z00000000003w0000000000000001zs0000000000000000000000000000000000000000000000320000000000A80000000000000003zy0000000000000000z00000000000000000000000000000640000000000ME03w0000000000004070000000000000001W00000000000000000000000000000C80000000000sU06800000000000080700003U00000000024000000000C00000000000000700004E0000000000F008E000000000000Ew60000T000000000048000000001w00000000000000y00008U0000000000W00EU000000000000Vy60000W0000000000Ck00000000280000000000000140000F00000000001400v00000000000012CA000140000000000D0000000004E0000000000000280000W00000000002800w00000000000034A800028000000000000000000008U00000000000004E0001400000000004E000000000000000688E3zkwTbs7kzzzzw1yDzy07zz03ly1zs01zzby0Tz1sz0Tz2Dz0zznz0DzU8Uz7szzs0Tzw00000AEEUA1l01ME8X3VVkC34ks70Q1a040470s0661w61k72023U64Q3X30y30s3UF32AH3UQ1k6M00000MVX0k0m02kUF64720A69V061U0A0808M0Q0A81U6203404A048U3640k3101UWAAMa40M600k00000l6633Uo0Bl0WC0D00AAHU06600M0E0lU0M0Q00064C280Mk08E03C000327114kklC00MM01U00001Xs8ADlj7tW1447q3w8MX1y4MTkk0wTW3sM0MD0yADz6SDl1zEUz2A7UT67zX2/31WA7sFVz300000300kMkl2814288Q4AQEl26C8lklU08UAAsE0En3Y8C644E663V3748NVm47324QA348MsX736000006070X1X4E284EFU8kMVW4MAF30X00F0EkMk0X26AE1y88U8M02A6AFV3680z48kk68FUl4A2A00000A0Q17z68U4E8UW0F0FX48U8mA1600W0X0lU144MMUTsEF0FU04E4MW2AAEDw8F30AEW0X8k4M00000MsM200AF08UF140W0X68F0FYM2A014160V0288kl3U0UW0X008U8l44MMVk0EUA0MV416FU8k00000lMM400MW0F0W281416AEW0X8U4M028281204EFVWA01141600F0FW88kl600V0M0l282AW0FU00001WMk8zzl40W144E282AMV416FU8k04E4M2408UX34ETW282A00W0X4EFVW8Dl28M1W4E4N60X0000034kkFU02816288U4E4Ml282AX0FU08U8kAM0F1669XX44E4M014168UX34llW4MM348U8mA160000048kkV004E2AAEF08U8lW4E4N30X00F0EkMk0W2AAH6688U8M0282AF1669X348sM68F0FYA2A000008ElVX0w8k48kUW0F0FX48U8n73600X0llV0144MMaAAEFUMsC4E4MW2AAH668FsMAEW0XAQAMT3sT0EVVX3zMEy8T1140W0X68F0Fa7wA013tVy60288klATkUVwkTo8U8l44MMaDsEWsMMV416MTklXANX0V1VX0kkUgMA3281416AEW0X600M022lUkM04EFVW8S111Mk08F0FW88kl4D0V4sMl282AM01X2MH2121VX01VU8E164E282AMV416600k060VU1k08UV34M0X30Ek0FW0X4EEVWA0FW8sNW4E4MM0344UY424313U71UEs6A8U4E4MV282A70FU0611k700F1268M3630Us1X4168UV34A1X4EkG48U8kQ16ANXAM7s3y3zs1zUzzsT0DUDly7k7s7zX007y1zs00y3wDkTzw3z0zz7s3wT1y7sDzyDUzbsT0TUTyADVwDU00000Q00w0D0000000000000016003k0S00000000DU01s07U0000000007k000000000004MC1kC000000000000000000000000006A00000000000000000000000000000000000000000000Mk000000000000000000000000000000QE00000000000000000000000000000000000000000001l00000000000000000000000000000DzlU000000000000000000000000000000000000000000zz600000000000000000000000000000Ny30000000000000000000000000000000000000000001bsA00000000000000000000000000000U0A000000000000000000000000000000000000000000200k0000000000000000000000000000101k000000000000000000000000000000000000000000407000000000000000000000000000003zz0000000000000000000000000000000000000000000Dzw000000000000000000000000000000Tk00000000000000000000000000000000000000000001z000001"


if (ok:=FindText(X:="wait", Y:=WAITPERIOD6, 796-150000, 1044-150000, 796+150000, 1044+150000, 0, 0, returningMsg2_string_0x2560x1440))
{
  IniRead, bClickActions_ReturningMsg2, %config_file%, MASTER_TOGGLE_QUEUE_BUTTONCLICKS, ClickReturningToMatchmakingMessage2, 1
  GLOBAL ClickActions_ReturningMsg2 := bClickActions_ReturningMsg2
  IniRead, bPushBulletNotifications, %config_file%, SMARTPHONE, EnablePushNotifications, 1
  GLOBAL PushBulletNotifications := bPushBulletNotifications
  If(PushBulletNotifications="1")
  {
    If(PushNotifyReturningQueueMenu="1")
    {
    PB_PushNote(PB_Token, PB_Title6, PB_Message6)
    }
  }
  If(ClickActions_ReturningMsg2="1")
  {
  FindText().Click(X, Y, "L")
  }
}


; SetTimer, FormatContrastPostExecTime, -50
; Sleep, 350
GLOBAL HOURafterExec := A_Hour
GLOBAL MINafterExec := A_Min
GLOBAL SECafterExec := A_Sec

GLOBAL HOURresult := ""
GLOBAL MINresult := ""
GLOBAL SECresult := ""

GLOBAL HOURresult := HOURbeforeExec-HOURafterExec

GLOBAL MINresult := MINbeforeExec-MINafterExec
GLOBAL SECresult := SECbeforeExec-SECafterExec

GLOBAL HOURresultFormatted := HOURresult . A_Space . "h" . ":"
GLOBAL MINresultFormatted := MINresult . A_Space . "m" . ":"
GLOBAL SECresultFormatted := SECresult . A_Space . "s" . ":"

If(HOURresult="0")
{
    GLOBAL HOURresultFormatted := ""
}

If(MINresult="0")
{
GLOBAL MINresultFormatted := ""
}

If(SECresult="0")
{
GLOBAL SECresultFormatted := ""
}

        GLOBAL RESULTtimeCombo1 := HOURresultFormatted . MINresultFormatted . SECresultFormatted

        RESULTtimeCombo2 := StrReplace(RESULTtimeCombo1, A_Space, "")
        RESULTtimeCombo3 := StrReplace(RESULTtimeCombo2, "-", "")

IniRead, bDebug_PickScreenReturningToQueueMsg, %config_file%, DEBUG, PickScreenReturningToMatchmakingNotify, 5
GLOBAL Debug_PickScreenReturningToQueueMsg := bDebug_PickScreenReturningToQueueMsg

If(Debug_PickScreenReturningToQueueMsg="1")
{
MsgBox,, PickScreenReturningToQueue, EXECUTION WAS ALLOWED TO PIPE OUTSIDE OF THE FENCE OF THE TEXT FUNCTION AND ENGINE WILL NOW PROCEED TO EXIT`n`n TIME ELAPSED FROM BEGIN FUNCTION FENCE TO FENCE BREAKPOINT:`n`n%RESULTtimeCombo3%, 25
}

                            }
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;
;;;    END OF FINDTEXT FUNCTION BLOCKS
;;;
;;;========================================
;;;========================================
;;;========================================
;;;========================================
EndFindTextBlock:

Goto, StartFindTextBlock

Return
; ExitApp
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;         RE-EXECUTION LABELS
;;;========================================
;;;========================================
;;;========================================
Return

ToolTipLabel:
IniRead, ToolTipEnabled, %config_file%, HUD, EnableHUD, 1
IniRead, ToolTipPOS, %config_file%, HUD, HUDPosition, CENTER
If(ToolTipEnabled="1")
{
; ToolTip, Dota2 Auto Accepter is active`nPress F11 to start the queue`npress F10 to disable this message`npress F9 to cancel search queue, 0, 0
  If(ToolTipPOS="left")
  {
    CoordMode, ToolTip
    ToolTip, %engine_title% %engine_title_suffix% is active, 0, 0   ;;;; TOP LEFT
    CoordMode, Screen
    Return
  }
  If(ToolTipPOS="right")
  {
    CoordMode, ToolTip
    ToolTip, %engine_title% %engine_title_suffix% is active, A_ScreenWidth-100, 0    ;;;; TOP RIGHT
    CoordMode, Screen
    Return
  }
  If(ToolTipPOS="center")
  {
  CoordMode, ToolTip
  ToolTip, %engine_title% %engine_title_suffix% is active, A_ScreenWidth/2.222, 0    ;;;; TOP RIGHT
  CoordMode, Screen
  Return
  }
}
Else
    {
    ToolTip   ;;;; TOOLTIP IS NOT ENABLED, DISABLE IT NOW IF ITS CURRENTLY RUNNING
    }
Return


;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;
;;;        TRAYBUTTON LABELS BLOCK
;;;
;;;========================================
;;;========================================
;;;========================================


TrayBTN_HudPOS:
If(ToggleToolTipFlagPOS="2")
{
  IniWrite, RIGHT, %config_file%, HUD, HUDPosition
  GLOBAL ToggleToolTipFlagPOS := "0"
  SetTimer, ToolTipLabel, -150
  Return
}
If(ToggleToolTipFlagPOS="1")
{
  IniWrite, CENTER, %config_file%, HUD, HUDPosition
  GLOBAL ToggleToolTipFlagPOS := "2"
  SetTimer, ToolTipLabel, -150
  Return
}
If(ToggleToolTipFlagPOS="0")
{
  IniWrite, LEFT, %config_file%, HUD, HUDPosition
  GLOBAL ToggleToolTipFlagPOS := "1"
  SetTimer, ToolTipLabel, -150
  Return
}
Return


TrayBTN_RERUNTOKENWIZARD:
  BlankString := ""
IniWrite, %BlankString%, %config_file%, SMARTPHONE, PushBulletAccessToken
IniWrite, 1, %config_file%, SMARTPHONE, EnablePushNotifications
Sleep, 250
  IniRead, bPushBulletAccessToken, %config_file%, SMARTPHONE, PushBulletAccessToken, 5
  GLOBAL cPushBulletAccessToken := bPushBulletAccessToken
Reload
Return


TrayBTN_HUD:
If(ToggleToolTipFlag="1")
{
  IniWrite, 1, %config_file%, HUD, EnableHUD
  GLOBAL ToggleToolTipFlag := "0"
  SetTimer, ToolTipLabel, -150
  Return
}
If(ToggleToolTipFlag="0")
{
  IniWrite, 0, %config_file%, HUD, EnableHUD
  GLOBAL ToggleToolTipFlag := "1"
  SetTimer, ToolTipLabel, -150
  Return
}
Return


TrayBTN_EXIT:
ExitApp
Return


TrayBTN_SETTINGS:
Run, "notepad.exe" %config_file%
Return


TrayBTN_CONTAINER:
Run, "explorer.exe" %A_ScriptDir%
Return


TrayBTN_REFRESHALL:
SetTimer, ReExecuteAutoexec, -150
Return


TrayBTN_REFRESHsettings:
SetTimer, REREAD_SETTINGS, -150
Return


TrayBTN_RELOAD:
Reload
Return


TrayBTN_TOGGLEPAUSE:

If(PauseToggleFlag="1")
{
  GLOBAL PauseToggleFlag := "0"
  GLOBAL CurrentPauseState := "UNPAUSED"
  Menu, Tray, DeleteAll
  Menu, Tray, Tip , %engine_title% %engine_title_suffix%

Menu, Tray, NoStandard
Menu, Tray, Add, Settings, TrayBTN_SETTINGS  ; Creates a new menu item.
Menu, Tray, Add, Open Container, TrayBTN_CONTAINER  ; Creates a new menu item.

Menu, Tray, Add  ; Creates a separator line.
Menu, Tray, Add, Toggle HUD, TrayBTN_HUD  ; Creates a new menu item.
Menu, Tray, Add, Cycle HUD Position, TrayBTN_HudPOS  ; Creates a new menu item.
Menu, Tray, Add  ; Creates a separator line.
Menu, Tray, Add, Check Auto-Startup Status, TrayBTN_CheckIfSetRunWithWindows  ; Creates a new menu item.
Menu, Tray, Add, Toggle Auto-Startup With Windows, TrayBTN_SetToRunWithWindowsMAIN  ; Creates a new menu item.
Menu, Tray, Add  ; Creates a separator line.

GLOBAL CurrentPauseState := "UNPAUSED"

Menu, Tray, Add, Re-Run Autoexec, TrayBTN_REFRESHALL   ; Creates a new menu item.
Menu, Tray, Add, Refresh String Table, TrayBTN_REFRESHsettings   ; Creates a new menu item.
Menu, Tray, Add, Re-Run PushBullet Token Setup, TrayBTN_RERUNTOKENWIZARD   ; Creates a new menu item.
Menu, Tray, Add  ; Creates a separator line.
Menu, Tray, Add, Pause AutoQueue -- (%CurrentPauseState%), TrayBTN_TOGGLEPAUSE   ; Creates a new menu item.
Menu, Tray, Add, Reboot %engine_title%, TrayBTN_RELOAD   ; Creates a new menu item.
Menu, Tray, Add, Exit, TrayBTN_EXIT   ; Creates a new menu item.

  
  Pause, Off
  Reload
  Return
}
If(PauseToggleFlag="0")
{
  GLOBAL PauseToggleFlag := "1"
  GLOBAL CurrentPauseState := "PAUSED"
  ; Menu, Tray, Rename, Toggle Pause %engine_title% (Currently: %CurrentPauseState%), Toggle Pause %engine_title% (Currently: %CurrentPauseState%)

  Menu, Tray, DeleteAll
  Menu, Tray, Tip , %engine_title% %engine_title_suffix% {%CurrentPauseState%}

Menu, Tray, NoStandard
Menu, Tray, Add, Settings, TrayBTN_SETTINGS  ; Creates a new menu item.
Menu, Tray, Add, Open Container, TrayBTN_CONTAINER  ; Creates a new menu item.

Menu, Tray, Add  ; Creates a separator line.
Menu, Tray, Add, Toggle HUD, TrayBTN_HUD  ; Creates a new menu item.
Menu, Tray, Add, Cycle HUD Position, TrayBTN_HudPOS  ; Creates a new menu item.
Menu, Tray, Add  ; Creates a separator line.
Menu, Tray, Add, Check Auto-Startup Status, TrayBTN_CheckIfSetRunWithWindows  ; Creates a new menu item.
Menu, Tray, Add, Toggle Auto-Startup With Windows, TrayBTN_SetToRunWithWindowsMAIN  ; Creates a new menu item.
Menu, Tray, Add  ; Creates a separator line.

Menu, Tray, Add, Re-Run Autoexec, TrayBTN_REFRESHALL   ; Creates a new menu item.
Menu, Tray, Add, Refresh String Table, TrayBTN_REFRESHsettings   ; Creates a new menu item.
Menu, Tray, Add, Re-Run PushBullet Token Setup, TrayBTN_RERUNTOKENWIZARD   ; Creates a new menu item.
Menu, Tray, Add  ; Creates a separator line.
Menu, Tray, Add, Pause AutoQueue -- (%CurrentPauseState%), TrayBTN_TOGGLEPAUSE   ; Creates a new menu item.
Menu, Tray, Add, Reboot %engine_title%, TrayBTN_RELOAD   ; Creates a new menu item.
Menu, Tray, Add, Exit, TrayBTN_EXIT   ; Creates a new menu item.

  Pause, On
  Return
}

Return




TrayBTN_CheckIfSetRunWithWindows:
GLOBAL PowerShellVerifyCommand := "powershell.exe -Command Get-ScheduledTask Dota2_RunQueueAegisOnStartup"

GLOBAL taskName := "Dota2_RunQueueAegisOnStartup" ; Replace with the actual task name
GLOBAL taskCheckerCreate := "VerifyDota2QueueAegisTaskExists.txt"
GLOBAL taskChecker := "VerifyDota2QueueAegisTaskExists.ps1"

Path_To_File = "%A_Temp%\%taskChecker%"

If FileExist(A_Temp . "\" . taskChecker)
{
	; MsgBox,, Title, VerifyTask2.ps1 EXISTS ALREADY!
}
Else
{
	; MsgBox,, Title, VerifyTask2.ps1 DOES NOT EXISTS ALREADY!
	FileAppend, %PowerShellVerifyCommand%, %A_Temp%\%taskCheckerCreate%
	If(ErrorLevel="1")
	{
		;;; CATCH ERRORS AND ALSO WAIT FOR EXECUTION TO FINISH TO ENSURE WE ONLY TRY TO RENAME AFTER ITS DONE
		; MsgBox,, Title, BUILD VerifyTask2.txt had an error trying to write the file needed to check if the task exists
	}
	Else
	{
		;;; CATCH ERRORS AND ALSO WAIT FOR EXECUTION TO FINISH TO ENSURE WE ONLY TRY TO RENAME AFTER ITS DONE
		; MsgBox,, Title, BUILD VerifyTask2.txt finished successfully!
		;;; RENAME THE FILE FROM A .TXT TO A .PS1 SINCE FILEAPPEND ISN'T ALLOWED TO MAKE A .PS1 FILE WITHOUT ADMIN
		FileMove, %A_Temp%\%taskCheckerCreate%, %A_Temp%\%taskChecker%, 1
	}
}
CheckTaskStateOutput := JEE_RunGetStdOut("PowerShell.exe -ExecutionPolicy Bypass -File " Path_To_File)

; MsgBox, , Title, %Path_To_File%

If(CheckTaskStateOutput="" && "null")
{
    MsgBox,, [%engine_title%]  Auto-Start With Windows, %engine_title% Is Currently NOT Set To Auto-Start With Windows.
	Return
}
else
{
	MsgBox,, [%engine_title%]  Auto-Start With Windows, %engine_title% Is Currently Set To Auto-Start With Windows.
	Return
}
Return




TrayBTN_SetToRunWithWindowsMAIN:
GLOBAL CurrentScriptFile := A_ScriptName
IniRead, bUACElevate, %config_file%, DEBUG, RunAsAdministrator, 0
GLOBAL UACElevate := bUACElevate

; GLOBAL RunQueueAegisContainer := A_ScriptDir . "\" . A_ScriptName
GLOBAL RunQueueAegisContainer := "'" . A_ScriptDir . "\" . A_ScriptName . "'"



GLOBAL PowerShellVerifyCommand := "powershell.exe -Command Get-ScheduledTask Dota2_RunQueueAegisOnStartup"

GLOBAL taskName := "Dota2_RunQueueAegisOnStartup" ; Replace with the actual task name
GLOBAL taskCheckerCreate := "VerifyDota2QueueAegisTaskExists.txt"
GLOBAL taskChecker := "VerifyDota2QueueAegisTaskExists.ps1"

Path_To_File = "%A_Temp%\%taskChecker%"

If FileExist(A_Temp . "\" . taskChecker)
{
	; MsgBox,, Title, VerifyTask2.ps1 EXISTS ALREADY!
}
Else
{
	; MsgBox,, Title, VerifyTask2.ps1 DOES NOT EXISTS ALREADY!
	FileAppend, %PowerShellVerifyCommand%, %A_Temp%\%taskCheckerCreate%
	If(ErrorLevel="1")
	{
		;;; CATCH ERRORS AND ALSO WAIT FOR EXECUTION TO FINISH TO ENSURE WE ONLY TRY TO RENAME AFTER ITS DONE
		; MsgBox,, Title, BUILD VerifyTask2.txt had an error trying to write the file needed to check if the task exists
	}
	Else
	{
		;;; CATCH ERRORS AND ALSO WAIT FOR EXECUTION TO FINISH TO ENSURE WE ONLY TRY TO RENAME AFTER ITS DONE
		; MsgBox,, Title, BUILD VerifyTask2.txt finished successfully!
		;;; RENAME THE FILE FROM A .TXT TO A .PS1 SINCE FILEAPPEND ISN'T ALLOWED TO MAKE A .PS1 FILE WITHOUT ADMIN
		FileMove, %A_Temp%\%taskCheckerCreate%, %A_Temp%\%taskChecker%, 1
	}
}
SetToRunWithWindowsToggleFlag := JEE_RunGetStdOut("PowerShell.exe -ExecutionPolicy Bypass -File " Path_To_File)

; MsgBox, , Title, %Path_To_File%

        If(SetToRunWithWindowsToggleFlag="" && "null")
        {
            ; MsgBox, %engine_title% Is Currently Set To Auto-Start With Windows.
            GLOBAL SetToRunWithWindowsToggleFlag := "0"
          ; Return
        }
        else
        {
          ; MsgBox, %engine_title% Is Currently NOT Set To Auto-Start With Windows.
          GLOBAL SetToRunWithWindowsToggleFlag := "1"
          ; Return
        }





If(SetToRunWithWindowsToggleFlag="0")
{
  GLOBAL SetToRunWithWindowsToggleFlag := "1"
  SetTimer, TrayBTN_SetToRunWithWindowsOFF, OFF
  SetTimer, TrayBTN_SetToRunWithWindowsON, -150
  Return
}
If(SetToRunWithWindowsToggleFlag="1")
{
  GLOBAL SetToRunWithWindowsToggleFlag := "0"
  SetTimer, TrayBTN_SetToRunWithWindowsON, OFF
  SetTimer, TrayBTN_SetToRunWithWindowsOFF, -150
  Return
}
Return


TrayBTN_SetToRunWithWindowsON:
If(UACElevate="0")
{
  Run, schtasks.exe /create /TN "Dota2_RunQueueAegisOnStartup" /TR "%RunQueueAegisContainer%" /sc ONLOGON /RU "%A_ComputerName%\%A_UserName%" /RL LIMITED /F
  MsgBox,, [%engine_title%]  Auto-Start With Windows, Successfully Enabled Auto-Starting %engine_title% With Windows.
  Return
}
If(UACElevate="1")
{
  Run, schtasks.exe /create /TN "Dota2_RunQueueAegisOnStartup" /TR "%RunQueueAegisContainer%" /sc ONLOGON /RU "%A_ComputerName%\%A_UserName%" /RL HIGHEST /F
  MsgBox,, [%engine_title%]  Auto-Start With Windows, Successfully Enabled Auto-Starting %engine_title% With Windows.
  Return
}
Return

TrayBTN_SetToRunWithWindowsOFF:
  Run, schtasks.exe /delete /TN "Dota2_RunQueueAegisOnStartup" /F
  MsgBox,, [%engine_title%]  Auto-Start With Windows, Successfully Disabled Auto-Starting %engine_title% With Windows.
Return



;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;
;;;         DEFINE ROUTINES BLOCK  
;;;
;;;========================================
;;;========================================
;;;========================================

Return
REREAD_SETTINGS:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;   SWITCHES SETTINGS
IniRead, bAutoRefreshSettings, %config_file%, MASTER_QUEUE_TOGGLE_SWITCHES, AutomaticallyRefreshSettings, 1
GLOBAL switches_AutoRefreshSettings := bAutoRefreshSettings
IniRead, bSwitches_AcceptBTN, %config_file%, MASTER_QUEUE_TOGGLE_SWITCHES, EnableAcceptButton, 1
GLOBAL switches_AcceptBTN := bSwitches_AcceptBTN
IniRead, bSwitches_ReadyBTN, %config_file%, MASTER_QUEUE_TOGGLE_SWITCHES, EnableReadyButton, 1
GLOBAL switches_ReadyBTN := bSwitches_ReadyBTN
IniRead, bSwitches_OkBTN, %config_file%, MASTER_QUEUE_TOGGLE_SWITCHES, EnableOkButton, 1
GLOBAL switches_OkBTN := bSwitches_OkBTN
IniRead, bSwitches_OkBTN2, %config_file%, MASTER_QUEUE_TOGGLE_SWITCHES, EnableOkButton2, 1
GLOBAL switches_OkBTN2 := bSwitches_OkBTN2
IniRead, bSwitches_ReturningToQueueMsg, %config_file%, MASTER_QUEUE_TOGGLE_SWITCHES, EnableReturningToQueueMsg, 1
GLOBAL switches_ReturningToQueueMsg := bSwitches_ReturningToQueueMsg
IniRead, bSwitches_ReturningToQueueMsg2, %config_file%, MASTER_QUEUE_TOGGLE_SWITCHES, EnableReturningToQueueMsg2, 1
GLOBAL switches_ReturningToQueueMsg2 := bSwitches_ReturningToQueueMsg2


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;   TOGGLE-CLICK-ACTIONS SETTINGS
IniRead, bClickActions_Accept, %config_file%, MASTER_TOGGLE_QUEUE_BUTTONCLICKS, ClickAcceptButton, 1
GLOBAL ClickActions_Accept := bClickActions_Accept
IniRead, bClickActions_Ready, %config_file%, MASTER_TOGGLE_QUEUE_BUTTONCLICKS, ClickReadyButton, 1
GLOBAL ClickActions_Ready := bClickActions_Ready
IniRead, bClickActions_OK, %config_file%, MASTER_TOGGLE_QUEUE_BUTTONCLICKS, ClickOkButton, 1
GLOBAL ClickActions_OK := bClickActions_OK
IniRead, bClickActions_OK2, %config_file%, MASTER_TOGGLE_QUEUE_BUTTONCLICKS, ClickOkButton2, 1
GLOBAL ClickActions_OK2 := bClickActions_OK2
IniRead, bClickActions_ReturningMsg, %config_file%, MASTER_TOGGLE_QUEUE_BUTTONCLICKS, ClickReturningToMatchmakingMessage, 1
GLOBAL ClickActions_ReturningMsg := bClickActions_ReturningMsg
IniRead, bClickActions_ReturningMsg2, %config_file%, MASTER_TOGGLE_QUEUE_BUTTONCLICKS, ClickReturningToMatchmakingMessage2, 1
GLOBAL ClickActions_ReturningMsg2 := bClickActions_ReturningMsg2


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;   PRE-TIMER-DELAYS SETTINGS
IniRead, bPreTimerExecDelay_accept, %config_file%, PRE_TIMER_DELAYS, Accept, 5000
GLOBAL PreTimerExecDelay_accept := bPreTimerExecDelay_accept
IniRead, bPreTimerExecDelay_ready, %config_file%, PRE_TIMER_DELAYS, Ready, 5000
GLOBAL PreTimerExecDelay_ready := bPreTimerExecDelay_ready
IniRead, bPreTimerExecDelay_ok, %config_file%, PRE_TIMER_DELAYS, Ok, 5000
GLOBAL PreTimerExecDelay_ok := bPreTimerExecDelay_ok
IniRead, bPreTimerExecDelay_ok2, %config_file%, PRE_TIMER_DELAYS, Ok2, 5000
GLOBAL PreTimerExecDelay_ok2 := bPreTimerExecDelay_ok2
IniRead, bPreTimerExecDelay_returning, %config_file%, PRE_TIMER_DELAYS, ReturningToQueue, 5000
GLOBAL PreTimerExecDelay_returning := bPreTimerExecDelay_returning
IniRead, bPreTimerExecDelay_returning2, %config_file%, PRE_TIMER_DELAYS, ReturningToQueue2, 5000
GLOBAL PreTimerExecDelay_returning2 := bPreTimerExecDelay_returning2


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;   TIMER SETTINGS
IniRead, bAutoRefreshSettings, %config_file%, TIMERS, AutomaticallyRefreshSettings, 13000
GLOBAL Timers_AutoRefreshVarsDelay := AutoRefreshSettings
IniRead, bTimers_AcceptBTN, %config_file%, TIMERS, AcceptButtonDelay, 4
GLOBAL Timers_AcceptBTN := bTimers_AcceptBTN
IniRead, bTimers_ReadyBTN, %config_file%, TIMERS, ReadyButtonDelay, 4
GLOBAL Timers_ReadyBTN := bTimers_ReadyBTN
IniRead, bTimers_OkBTN, %config_file%, TIMERS, OkButtonDelay, 4
GLOBAL Timers_OkBTN := bTimers_OkBTN
IniRead, bTimers_OkBTN2, %config_file%, TIMERS, OkButton2Delay, 4
GLOBAL Timers_OkBTN2 := bTimers_OkBTN2
IniRead, bTimers_ReturningQueueMSG, %config_file%, TIMERS, ReturningToMatchmakingDelay, 4
GLOBAL Timers_ReturningQueueMSG := bTimers_ReturningQueueMSG
IniRead, bTimers_ReturningQueueMSG2, %config_file%, TIMERS, ReturningToMatchmaking2Delay, 4
GLOBAL Timers_ReturningQueueMSG2 := bTimers_ReturningQueueMSG2


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;   DEBUG SETTINGS
IniRead, bDebug_QueueAcceptMsg, %config_file%, DEBUG, QueueAcceptNotify, 5
GLOBAL Debug_QueueAcceptMsg := bDebug_QueueAcceptMsg
IniRead, bDebug_MiscOkMsg, %config_file%, DEBUG, MiscOkButtonNotify, 5
GLOBAL Debug_MiscOkMsg := bDebug_MiscOkMsg
IniRead, bDebug_MiscOkMsg2, %config_file%, DEBUG, MiscOkButton2Notify, 5
GLOBAL Debug_MiscOkMsg2 := bDebug_MiscOkMsg2
IniRead, bDebug_PartyReadyCheckMsg, %config_file%, DEBUG, PartyReadyCheckNotify, 5
GLOBAL Debug_PartyReadyCheckMsg := bDebug_PartyReadyCheckMsg
IniRead, bDebug_QueueReturningToQueueMsg, %config_file%, DEBUG, QueueReturningToMatchmakingNotify, 5
GLOBAL Debug_QueueReturningToQueueMsg := bDebug_QueueReturningToQueueMsg
IniRead, bDebug_PickScreenReturningToQueueMsg, %config_file%, DEBUG, PickScreenReturningToMatchmakingNotify, 5
GLOBAL Debug_PickScreenReturningToQueueMsg := bDebug_PickScreenReturningToQueueMsg


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;   SMARTPHONE SETTINGS
IniRead, bPushBulletAccessToken, %config_file%, SMARTPHONE, PushBulletAccessToken, 5
GLOBAL PushBulletAccessToken := bPushBulletAccessToken
IniRead, bPushBulletNotifications, %config_file%, SMARTPHONE, EnablePushNotifications, 1
GLOBAL PushBulletNotifications := bPushBulletNotifications
IniRead, bPushNotifyClickAccept, %config_file%, SMARTPHONE, PushNotificationClickAcceptQueue, 1
GLOBAL PushNotifyClickAccept := bPushNotifyClickAccept
IniRead, bPushNotifyClickReady, %config_file%, SMARTPHONE, PushNotificationClickReadyCheck, 1
GLOBAL PushNotifyClickReady := bPushNotifyClickReady
IniRead, bPushNotifyClickOk, %config_file%, SMARTPHONE, PushNotificationClickErrorOk, 1
GLOBAL PushNotifyClickOk := bPushNotifyClickOk
IniRead, bPushNotifyClickOk2, %config_file%, SMARTPHONE, PushNotificationClickErrorOk2, 1
GLOBAL PushNotifyClickOk2 := bPushNotifyClickOk2
IniRead, bPushNotifyReturningQueuePick, %config_file%, SMARTPHONE, PushNotificationReturningToQueueFromPickScreen, 1
GLOBAL PushNotifyReturningQueuePick := bPushNotifyReturningQueuePick
IniRead, bPushNotifyReturningQueueMenu, %config_file%, SMARTPHONE, PushNotificationReturningToQueueFromMainMenuScreen, 1
GLOBAL PushNotifyReturningQueueMenu := bPushNotifyReturningQueueMenu


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;   PUSHBULLET NOTIFICATION SETTINGS
IniRead, bMatchFoundPushNotificationTitle, %config_file%, SMARTPHONE_MESSAGE_CONTENTS, MatchFoundPushNotificationTitle, 5
GLOBAL MatchFoundPushNotificationTitle := bMatchFoundPushNotificationTitle
IniRead, bMatchFoundPushNotificationMessage, %config_file%, SMARTPHONE_MESSAGE_CONTENTS, MatchFoundPushNotificationMessage, 5
GLOBAL MatchFoundPushNotificationMessage := bMatchFoundPushNotificationMessage

IniRead, bReadyCheckPushNotificationTitle, %config_file%, SMARTPHONE_MESSAGE_CONTENTS, ReadyCheckPushNotificationTitle, 5
GLOBAL ReadyCheckPushNotificationTitle := bReadyCheckPushNotificationTitle
IniRead, bReadyCheckPushNotificationMessage, %config_file%, SMARTPHONE_MESSAGE_CONTENTS, ReadyCheckPushNotificationMessage, 5
GLOBAL ReadyCheckPushNotificationMessage := bReadyCheckPushNotificationMessage

IniRead, bErrorOkPushNotificationTitle, %config_file%, SMARTPHONE_MESSAGE_CONTENTS, ErrorOkPushNotificationTitle, 5
GLOBAL ErrorOkPushNotificationTitle := bErrorOkPushNotificationTitle
IniRead, bErrorOkPushNotificationMessage, %config_file%, SMARTPHONE_MESSAGE_CONTENTS, ErrorOkPushNotificationMessage, 5
GLOBAL ErrorOkPushNotificationMessage := bErrorOkPushNotificationMessage

IniRead, bErrorOk2PushNotificationTitle, %config_file%, SMARTPHONE_MESSAGE_CONTENTS, ErrorOk2PushNotificationTitle, 5
GLOBAL ErrorOk2PushNotificationTitle := bErrorOk2PushNotificationTitle
IniRead, bErrorOk2PushNotificationMessage, %config_file%, SMARTPHONE_MESSAGE_CONTENTS, ErrorOk2PushNotificationMessage, 5
GLOBAL ErrorOk2PushNotificationMessage := bErrorOk2PushNotificationMessage

IniRead, bReturningQueuePickPushNotificationTitle, %config_file%, SMARTPHONE_MESSAGE_CONTENTS, ReturningQueuePickScreenPushNotificationTitle, 5
GLOBAL ReturningQueuePickPushNotificationTitle := bReturningQueuePickPushNotificationTitle
IniRead, bReturningQueuePickPushNotificationMessage, %config_file%, SMARTPHONE_MESSAGE_CONTENTS, ReturningQueuePickScreenPushNotificationMessage, 5
GLOBAL ReturningQueuePickPushNotificationMessage := bReturningQueuePickPushNotificationMessage

IniRead, bReturningQueueMenuPushNotificationTitle, %config_file%, SMARTPHONE_MESSAGE_CONTENTS, ReturningQueueMainMenuPushNotificationTitle, 5
GLOBAL ReturningQueueMenuPushNotificationTitle := bReturningQueueMenuPushNotificationTitle
IniRead, bReturningQueueMenuPushNotificationMessage, %config_file%, SMARTPHONE_MESSAGE_CONTENTS, ReturningQueueMainMenuPickScreenPushNotificationMessage, 5
GLOBAL ReturningQueueMenuPushNotificationMessage := bReturningQueueMenuPushNotificationMessage



GLOBAL PB_Token   := PushBulletAccessToken
; GLOBAL PB_Title   := MatchFoundPushNotificationTitle
; GLOBAL PB_Message := MatchFoundPushNotificationMessage

GLOBAL PB_Title1   := MatchFoundPushNotificationTitle
GLOBAL PB_Message1 := MatchFoundPushNotificationMessage

GLOBAL PB_Title2   := ReadyCheckPushNotificationTitle
GLOBAL PB_Message2 := ReadyCheckPushNotificationMessage

GLOBAL PB_Title3   := ErrorOkPushNotificationTitle
GLOBAL PB_Message3 := ErrorOkPushNotificationMessage

GLOBAL PB_Title4   := ErrorOk2PushNotificationTitle
GLOBAL PB_Message4 := ErrorOk2PushNotificationMessage

GLOBAL PB_Title5   := ReturningQueueMenuPushNotificationTitle
GLOBAL PB_Message5 := ReturningQueueMenuPushNotificationMessage

GLOBAL PB_Title6   := ReturningQueuePickPushNotificationTitle
GLOBAL PB_Message6 := ReturningQueuePickPushNotificationMessage

Return

;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;========================================
;;;
;;;      FUNCTIONS AND INCLUDES BLOCK
;;;
;;;========================================
;;;========================================
;;;========================================

PB_PushNote(PB_Token, PB_Title, PB_Message) {
WinHTTP := ComObjCreate("WinHTTP.WinHttpRequest.5.1")
WinHTTP.SetProxy(0)
WinHTTP.Open("POST", "https://api.pushbullet.com/v2/pushes", 0)
WinHTTP.SetCredentials(PB_Token, "", 0)
WinHTTP.SetRequestHeader("Content-Type", "application/json")
PB_Body := "{""type"": ""note"", ""title"": """ PB_Title """, ""body"": """ PB_Message """}"
WinHTTP.Send(PB_Body)
Result := WinHTTP.ResponseText
Status := WinHTTP.Status
return Status
}
Return

SetFont(ctrl, win, font=0) {
SendMessage, 0x30, %font%, 1, %ctrl%, ahk_id%win% 
KeyWait, esc, D
ToolTip
return
return errorLevel
}
Return

; RunOrActivate(appTitle, appPath)
; {
;     if WinActive(appTitle)
;         {
;             WinMinimize
;         }
;         else if not WinExist(appTitle)
;             {
;             Run (appPath)
;             }
;         else
;             {
;         WinActivate(appTitle)
;             }
; }
RunOrActivate(Target, WinTitle = "")
{
	; Get the filename without a path
	SplitPath, Target, TargetNameOnly

	Process, Exist, %TargetNameOnly%
	If ErrorLevel > 0
		PID = %ErrorLevel%
	Else
		Run, %Target%, , , PID

	; At least one app (Seapine TestTrack wouldn't always become the active
	; window after using Run), so we always force a window activate.
	; Activate by title if given, otherwise use PID.
	If WinTitle <> 
	{
		SetTitleMatchMode, 2
		WinWait, %WinTitle%, , 3
		TrayTip, , Activating Window Title "%WinTitle%" (%TargetNameOnly%)
		WinActivate, %WinTitle%
	}
	Else
	{
		WinWait, ahk_pid %PID%, , 3
		TrayTip, , Activating PID %PID% (%TargetNameOnly%)
		WinActivate, ahk_pid %PID%
	}
	SetTimer, RunOrActivateTrayTipOff, 1500
}

; Turn off the tray tip
RunOrActivateTrayTipOff:
	SetTimer, RunOrActivateTrayTipOff, off
	TrayTip
Return

#Include, trayicon_library.toolkit
Return

#Include, FindTextLibrary.toolkit
Return





;;;; FUNCTION TO CHECK IF THE TASK SCHEDULER TASK EXISTS, CAPTURING POWERSHELL SCRIPT EXECUTION. USED IS ONE OF THE TRAY MENU BUTTONS FOR THE CHECKER
JEE_RunGetStdOut(vTarget, vSize:="")
{
	DetectHiddenWindows, On
	vComSpec := A_ComSpec ? A_ComSpec : ComSpec
	Run, % vComSpec,, Hide, vPID
	WinWait, % "ahk_pid " vPID
	DllCall("kernel32\AttachConsole", "UInt",vPID)
	oShell := ComObjCreate("WScript.Shell")
	oExec := oShell.Exec(vTarget)
	vStdOut := ""
	if !(vSize = "")
		VarSetCapacity(vStdOut, vSize)
	while !oExec.StdOut.AtEndOfStream
		vStdOut := oExec.StdOut.ReadAll()
	DllCall("kernel32\FreeConsole")
	Process, Close, % vPID
	return vStdOut
}
Return