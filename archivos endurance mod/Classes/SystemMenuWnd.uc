//================================================================================
// SystemMenuWnd.
//================================================================================

class SystemMenuWnd extends UICommonAPI;

function OnLoad ()
{
  RegisterEvent(1710);
  RegisterEvent(1900);
  SetMenuString();
}

function OnClickButton (string strID)
{
  switch (strID)
  {
    case "btnBBS":
    HandleShowBoardWnd();
    break;
    case "btnMacro":
    HandleShowMacroListWnd();
    break;
    case "btnHelpHtml":
    HandleShowHelpHtmlWnd();
    break;
    case "btnPetition":
    HandleShowPetitionBegin();
    break;
    case "btnOption":
    HandleShowOptionWnd();
    break;
    case "btnRestart":
    ExecuteEvent(70694);
    break;
    case "btnQuit":
    ExecuteEvent(70695);
    break;
    default:
  }
}

function OnEvent (int Event_ID, string param)
{
  if ( (Event_ID == 1710) )
  {
    if ( DialogIsMine() )
    {
      if ( (DialogGetID() == 0) )
      {
        Class'UIAPI_WINDOW'.static.HideWindow("SystemMenuWnd");
        ExecRestart();
      } else {
        ExecQuit();
      }
    }
  } else {
    if ( (Event_ID == 1900) )
    {
      SetMenuString();
    }
  }
}

function HandleShowBoardWnd ()
{
  local string strParam;

  ParamAdd(strParam,"Init","1");
  ExecuteEvent(1190,strParam);
}

function HandleShowHelpHtmlWnd ()
{
  Class'UIAPI_HTMLCTRL'.static.ControllerExecution("BoardWnd.HtmlViewer","bypass _bbspag;Goddard.htm");
}

function HandleShowMacroListWnd ()
{
  ExecuteEvent(1230);
}

function HandleShowPetitionBegin ()
{
  if ( Class'UIAPI_WINDOW'.static.IsShowWindow("UserPetitionWnd") )
  {
    PlayConsoleSound(EInterfaceSoundType(6));
    Class'UIAPI_WINDOW'.static.HideWindow("UserPetitionWnd");
  } else {
    PlayConsoleSound(EInterfaceSoundType(5));
    Class'UIAPI_WINDOW'.static.ShowWindow("UserPetitionWnd");
    Class'UIAPI_WINDOW'.static.SetFocus("UserPetitionWnd");
  }
}

function HandleShowOptionWnd ()
{
  if ( Class'UIAPI_WINDOW'.static.IsShowWindow("OptionWnd") )
  {
    PlayConsoleSound(EInterfaceSoundType(6));
    Class'UIAPI_WINDOW'.static.HideWindow("OptionWnd");
  } else {
    PlayConsoleSound(EInterfaceSoundType(5));
    Class'UIAPI_WINDOW'.static.ShowWindow("OptionWnd");
    Class'UIAPI_WINDOW'.static.SetFocus("OptionWnd");
  }
}

function SetMenuString ()
{
  Class'UIAPI_TEXTBOX'.static.SetText("SystemMenuWnd.txtBBS",GetSystemString(387));
  Class'UIAPI_TEXTBOX'.static.SetText("SystemMenuWnd.txtPetition",GetSystemString(470));
}
defaultproperties
{
}
