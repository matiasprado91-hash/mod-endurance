//================================================================================
// OlympiadTargetWnd.
//================================================================================

class OlympiadTargetWnd extends UIScript;

var int m_PlayerNum;
var int ID;
var string Name;
var int ClassID;
var int MaxHP;
var int CurHP;
var int MaxCP;
var int m_CurCP;
var int OlyTime;
var bool MaybeMatchStarted;
var int DmgDone;
var int DmgRecv;
var int Target_ID;

function OnLoad ()
{
  RegisterEvent(900);
  RegisterEvent(920);
  RegisterEvent(910);
  RegisterEvent(980);
  DmgDone = 0;
  DmgRecv = 0;
  RegisterEvent(580);
  OlyTime = 360;
  MaybeMatchStarted = False;
}

function OnEvent (int Event_ID, string param)
{
  if ( Event_ID == 900 )
  {
    Clear();
    ParseInt(param,"PlayerNum",m_PlayerNum);
    Class'UIAPI_WINDOW'.static.ShowWindow("OlympiadTargetWnd");
  } else {
    if ( Event_ID== 920 )
    {
      HandleUserInfo(param);
      UpdateStatus();
    } else {
      if ( Event_ID== 910 )
      {
        Clear();
      } else {
        if ( Event_ID== 580 )
        {
          ProbablyHandleOlyDmg(param);
        } else {
          if ( Event_ID== 980 )
          {
            Target_ID = Class'UIDATA_TARGET'.static.GetTargetID();
          }
        }
      }
    }
  }
}

function ProbablyHandleOlyDmg (string param)
{
  local int Index;
  local int Param2;
  local string Param1;

  ParseInt(param,"Index",Index);
  switch (Index)
  {
    case 35:
    if ( (ID >= 1) && ((Target_ID == ID) || (Target_ID < 1)) )
    {
      ParseInt(param,"Param1",Param2);
      DmgDone = DmgDone + Param2;
    }
    break;
    case 36:
    case 37:
    ParseInt(param,"Param2",Param2);
    ParseString(param,"Param1",Param1);
    if ( (Param1 != "Imperial Phoenix") && (Param1 != "kat the cat") && (Param1 != "mew the cat") && (Param1 != "feline queen") && (Param1 != "feline king") && (Param1 != "kai the cat") && (Param1 != "nightshade") && (Param1 != "spectral lord") && (Param1 != "magnus the unicorn") && (Param1 != "Dark Panther") )
    {
      DmgRecv = DmgRecv + Param2;
    }
    break;
    default:
  }
  SetDamages();
}

function OnEnterState (name a_PreStateName)
{
  Clear();
}

function Clear ()
{
  m_PlayerNum = 0;

  ID = 0;
  Name = "";
  ClassID = 0;
  MaxHP = 0;
  CurHP = 0;
  MaxCP = 0;
  m_CurCP = 0;
  DmgDone = 0;
  DmgRecv = 0;
  OlyTime = 360;
  SetDamages();
  UpdateStatus();
}

function SetDamages ()
{
  Class'UIAPI_TEXTBOX'.static.SetText("OlympiadTargetWnd.txtDamageDealt","Damage Dealt :            " $ string(DmgDone));
  Class'UIAPI_TEXTBOX'.static.SetText("OlympiadTargetWnd.txtDamageReceived","Damage Received :      " $ string(DmgRecv));
}

function HandleUserInfo (string param)
{
  local int IsPlayer;
  local int PlayerNum;

  ParseInt(param,"IsPlayer",IsPlayer);
  if ( IsPlayer != 0 )
  {
    return;
  }
  ParseInt(param,"PlayerNum",PlayerNum);
  if ( (m_PlayerNum != PlayerNum) || (PlayerNum < 1) )
  {
    return;
  }
  if (  !MaybeMatchStarted )
  {
    MaybeMatchStarted = True;
    Class'UIAPI_WINDOW'.static.KillUITimer("OlympiadTargetWnd",4412);
    Class'UIAPI_WINDOW'.static.SetUITimer("OlympiadTargetWnd",4412,1000);
  }
  ParseInt(param,"ID",ID);
  ParseString(param,"Name",Name);
  ParseInt(param,"ClassID",ClassID);
  ParseInt(param,"MaxHP",MaxHP);
  ParseInt(param,"CurHP",CurHP);
  ParseInt(param,"MaxCP",MaxCP);
  ParseInt(param,"CurCP",m_CurCP);
}

function UpdateStatus ()
{
  Class'UIAPI_TEXTBOX'.static.SetText("OlympiadTargetWnd.txtName",Name);
  if ( MaxCP > 0 )
  {
    Class'UIAPI_BARCTRL'.static.SetValue("OlympiadTargetWnd.barCP",MaxCP,m_CurCP);
  } else {
    Class'UIAPI_BARCTRL'.static.SetValue("OlympiadTargetWnd.barCP",MaxCP,0);
  }
  if ( MaxHP > 0 )
  {
    Class'UIAPI_BARCTRL'.static.SetValue("OlympiadTargetWnd.barHP",MaxHP,CurHP);
  } else {
    Class'UIAPI_BARCTRL'.static.SetValue("OlympiadTargetWnd.barHP",MaxHP,0);
  }
}

function OnLButtonDown (WindowHandle a_WindowHandle, int X, int Y)
{
  local UserInfo info;

  if ( GetUserInfo(ID,info) )
  {
    RequestAttack(ID,info.loc);
  }
}

function OnTimer (int Timer_ID)
{
  if ( Timer_ID == 4412 )
  {
    OlyTime--;
    if ( OlyTime <= 0 )
    {
      Class'UIAPI_WINDOW'.static.KillUITimer("OlympiadTargetWnd",4412);
    }
    Class'UIAPI_TEXTBOX'.static.SetText("OlympiadTargetWnd.txtTime",string(OlyTime / 60) $ ":" $ string(int(OlyTime % 60)));
  }
}
defaultproperties
{
}
