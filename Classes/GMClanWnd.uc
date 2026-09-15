//================================================================================
// GMClanWnd.
//================================================================================

class GMClanWnd extends ClanWnd;

var bool bShow;

function RegisterEvents ()
{
  RegisterEvent(2380);
  RegisterEvent(2390);
  RegisterEvent(2400);
}

function Load ()
{
  bShow = False;
  Class'UIAPI_WINDOW'.static.DisableWindow("GMClanWnd.ClanMemInfoBtn");
  Class'UIAPI_WINDOW'.static.DisableWindow("GMClanWnd.ClanMemAuthBtn");
  Class'UIAPI_WINDOW'.static.DisableWindow("GMClanWnd.ClanBoardBtn");
  Class'UIAPI_WINDOW'.static.DisableWindow("GMClanWnd.ClanInfoBtn");
  Class'UIAPI_WINDOW'.static.DisableWindow("GMClanWnd.ClanPenaltyBtn");
  Class'UIAPI_WINDOW'.static.DisableWindow("GMClanWnd.ClanQuitBtn");
  Class'UIAPI_WINDOW'.static.DisableWindow("GMClanWnd.ClanWarInfoBtn");
  Class'UIAPI_WINDOW'.static.DisableWindow("GMClanWnd.ClanWarDeclareBtn");
  Class'UIAPI_WINDOW'.static.DisableWindow("GMClanWnd.ClanWarCancleBtn");
  Class'UIAPI_WINDOW'.static.DisableWindow("GMClanWnd.ClanAskJoinBtn");
  Class'UIAPI_WINDOW'.static.DisableWindow("GMClanWnd.ClanAuthEditBtn");
  Class'UIAPI_WINDOW'.static.DisableWindow("GMClanWnd.ClanTitleManageBtn");
}

function OnShow ()
{
}

function OnHide ()
{
}

function ShowClan (string a_Param)
{
  if ( a_Param == "" )
  {
    return;
  }
  if ( bShow )
  {
    Clear();
    m_hOwnerWnd.HideWindow();
    bShow = False;
  } else {
    HandleGMObservingClan("");
    Class'GMAPI'.static.RequestGMCommand(EGMCommandType(2),a_Param);
    bShow = True;
  }
}

function OnEvent (int a_EventID, string a_Param)
{
  switch (a_EventID)
  {
    case 2380:
    HandleGMObservingClan(a_Param);
    break;
    case 2390:
    HandleGMObservingClanMemberStart();
    break;
    case 2400:
    HandleGMObservingClanMember(a_Param);
    break;
    default:
  }
}

function HandleGMObservingClan (string a_Param)
{
  m_hOwnerWnd.ShowWindow();
  m_hOwnerWnd.SetFocus();
  Clear();
  HandleClanInfo(a_Param);
}

function HandleGMObservingClanMemberStart ()
{
}

function HandleGMObservingClanMember (string a_Param)
{
  HandleAddClanMember(a_Param);
}


// Decompiled with UE Explorer.
defaultproperties
{
    m_WindowName="GMClanWnd"
}
