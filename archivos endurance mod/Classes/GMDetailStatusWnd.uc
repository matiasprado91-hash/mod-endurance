//================================================================================
// GMDetailStatusWnd.
//================================================================================

class GMDetailStatusWnd extends DetailStatusWnd;

var string temp1;
var bool bShow;
var UserInfo m_ObservingUserInfo;

function OnLoad ()
{
  temp1 = "Water/Air/Ground";
  RegisterEvent(2290);
  RegisterEvent(2404);
  bShow = False;
}

function OnShow ()
{
}

function OnHide ()
{
}

function ShowStatus (string a_Param)
{
  if ( a_Param == "" )
  {
    return;
  }
  if ( bShow )
  {
    m_hOwnerWnd.HideWindow();
    bShow = False;
  } else {
    Class'GMAPI'.static.RequestGMCommand(EGMCommandType(1),a_Param);
    bShow = True;
  }
}

function OnEvent (int a_EventID, string a_Param)
{
  switch (a_EventID)
  {
    case 2290:
    if ( HandleGMObservingUserInfoUpdate() )
    {
      m_hOwnerWnd.ShowWindow();
      m_hOwnerWnd.SetFocus();
    }
    break;
    case 2404:
    HandleGMUpdateHennaInfo(a_Param);
    break;
    default:
  }
}

function bool HandleGMObservingUserInfoUpdate ()
{
  local UserInfo ObservingUserInfo;

  if ( Class'GMAPI'.static.GetObservingUserInfo(ObservingUserInfo) )
  {
    HandleUpdateUserInfo();
    return True;
  } else {
    return False;
  }
}

function HandleGMUpdateHennaInfo (string a_Param)
{
  HandleUpdateHennaInfo(a_Param);
  HandleGMObservingUserInfoUpdate();
}

function bool GetMyUserInfo (out UserInfo a_MyUserInfo)
{
  local bool Result;

  Result = Class'GMAPI'.static.GetObservingUserInfo(m_ObservingUserInfo);
  if ( Result )
  {
    a_MyUserInfo = m_ObservingUserInfo;
    return True;
  } else {
    return False;
  }
}

function string GetMovingSpeed (UserInfo a_UserInfo)
{
  local int WaterMaxSpeed;
  local int WaterMinSpeed;
  local int AirMaxSpeed;
  local int AirMinSpeed;
  local int GroundMaxSpeed;
  local int GroundMinSpeed;
  local string MovingSpeed;

  WaterMaxSpeed = int((a_UserInfo.nWaterMaxSpeed * a_UserInfo.fNonAttackSpeedModifier));
  WaterMinSpeed = int((a_UserInfo.nWaterMinSpeed * a_UserInfo.fNonAttackSpeedModifier));
  AirMaxSpeed = int((a_UserInfo.nAirMaxSpeed * a_UserInfo.fNonAttackSpeedModifier));
  AirMinSpeed = int((a_UserInfo.nAirMinSpeed * a_UserInfo.fNonAttackSpeedModifier));
  GroundMaxSpeed = int((a_UserInfo.nGroundMaxSpeed * a_UserInfo.fNonAttackSpeedModifier));
  GroundMinSpeed = int((a_UserInfo.nGroundMinSpeed * a_UserInfo.fNonAttackSpeedModifier));
  MovingSpeed = ((string(WaterMaxSpeed) $ ",") $ string(WaterMinSpeed));
  MovingSpeed = ((((MovingSpeed $ "/") $ string(AirMaxSpeed)) $ ",") $ string(AirMinSpeed));
  MovingSpeed = ((((MovingSpeed $ "/") $ string(GroundMaxSpeed)) $ ",") $ string(GroundMinSpeed));
  return MovingSpeed;
}

function float GetMyExpRate ()
{
  return (GetExpRate(m_ObservingUserInfo.nCurExp,m_ObservingUserInfo.nLevel) * 100.0);
}


// Decompiled with UE Explorer.
defaultproperties
{
    m_WindowName="GMDetailStatusWnd"
}
