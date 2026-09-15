//================================================================================
// OnScreenMessageWnd.
//================================================================================

class OnScreenMessageWnd extends UIScript;

var string currentwnd1;
var bool onshowstat1;
var bool onshowstat2;
var int timerset1;
var int globalAlphavalue1;
var int globalAlphavalue2;
var int globalDuration;
var int droprate;
var int moveval;
var int moveval2;
var string MovedWndName;
var int m_TimerCount;
var bool linedivided;
//var NotificationWnd notif;

function OnLoad ()
{
  RegisterEvent(140);
  RegisterEvent(580);
  ResetAllMessage();
  timerset1 = 0;
  moveval = 0;
  moveval2 = 0;
  globalAlphavalue1 = 0;
  globalAlphavalue2 = 255;
  m_TimerCount = 0;
//  notif = NotificationWnd(GetScript("NotificationWnd"));
}

function OnTick ()
{
  if ( onshowstat1 == True )
  {
    FadeIn(currentwnd1);
  }
  if ( onshowstat2 == True )
  {
    FadeOut(currentwnd1);
  }
}

function OnTimer (int TimerID)
{
  if ( m_TimerCount > 0 )
  {
    Class'UIAPI_WINDOW'.static.KillUITimer("OnScreenMessageWnd1",m_TimerCount);
    m_TimerCount--;
    if ( m_TimerCount < 1 )
    {
      m_TimerCount = 0;
      onshowstat2 = True;
    }
  }
}

function OnHide ()
{
}


function ResetAllMessage ()
{
  local int i;
  local Color DefaultColor;
  local string WndName;

  DefaultColor.R = 255;
  DefaultColor.G = 255;
  DefaultColor.B = 255;
  globalAlphavalue1 = 0;
	
  globalAlphavalue2 = 255;
  currentwnd1 = "";
  onshowstat1 = False;
  onshowstat2 = False;
  Class'UIAPI_WINDOW'.static.HideWindow("OnScreenMessageWnd1");
  Class'UIAPI_WINDOW'.static.HideWindow("OnScreenMessageWnd2");
  Class'UIAPI_WINDOW'.static.HideWindow("OnScreenMessageWnd3");
  Class'UIAPI_WINDOW'.static.HideWindow("OnScreenMessageWnd4");
  Class'UIAPI_WINDOW'.static.HideWindow("OnScreenMessageWnd5");
  Class'UIAPI_WINDOW'.static.HideWindow("OnScreenMessageWnd6");
  Class'UIAPI_WINDOW'.static.HideWindow("OnScreenMessageWnd7");
  Class'UIAPI_WINDOW'.static.HideWindow("OnScreenMessageWnd8");
  i = 1;
  JL0175:
  if ( i <= 8 )
  {
    WndName = "OnScreenMessageWnd" $ string(i);
    Class'UIAPI_TEXTBOX'.static.SetTextColor(WndName $ ".TextBox" $ string(i),DefaultColor);
    ++i;
    goto JL0175;
  }
}

function ShowMsg (int WndNum, string TextValue, int Duration, int Animation, int FontType, int BackgroundType, int ColorR, int ColorG, int ColorB)
{
  local string WndName;
  local string TextBoxName;
  local string TextValue1;
  local string TextValue2;
  local string CurText;
  local Color FontColor;
  local int i;
  local int j;
  local int LengthTotal;
  local int TotalLength;
  local int TextOffsetTotal1;

  j = 1;
  TotalLength = Len(TextValue);
  TextValue1 = "";
  TextValue2 = "";
  linedivided = False;
  FontColor.R = ColorR;
  FontColor.G = ColorG;
  FontColor.B = ColorB;
  i = 1;
  JL0069:
  if ( i <= TotalLength )
  {
    LengthTotal = Len(TextValue) - 1;
    CurText = Left(TextValue,1);
    TextValue = Right(TextValue,LengthTotal);
    if ( CurText == "`" )
    {
      CurText = "";
    }
    if ( CurText == "#" )
    {
      CurText = "";
      j = 2;
      linedivided = True;
    }





		
    if ( j == 1 )
    {
      TextValue1 = TextValue1 $ CurText;
    } else {
      TextValue2 = TextValue2 $ CurText;
    }
    ++i;
    goto JL0069;
  }
  WndName = "OnScreenMessageWnd" $ string(WndNum);
  TextBoxName = WndName $ ".TextBox" $ string(WndNum);
  currentwnd1 = WndName;
  Class'UIAPI_TEXTBOX'.static.SetTextColor(TextBoxName,FontColor);
  if ( FontType == 0 )
  {
    Class'UIAPI_WINDOW'.static.ShowWindow(currentwnd1);
    Class'UIAPI_TEXTBOX'.static.SetText(TextBoxName,TextValue1);
  } else {
    if ( FontType == 1 )
    {
      Class'UIAPI_WINDOW'.static.ShowWindow(currentwnd1);
      Class'UIAPI_TEXTBOX'.static.SetText(TextBoxName,"");
    }
  }
  if ( WndNum == 2 )
  {
    if ( moveval != 0 ) {}
    MovedWndName = WndName;
    moveval2 = TextOffsetTotal1 / 2 * 29;
    if ( BackgroundType == 1 )
    {
      Class'UIAPI_WINDOW'.static.ShowWindow(MovedWndName $ ".texturetype1");
    } else {
      Class'UIAPI_WINDOW'.static.HideWindow(MovedWndName $ ".texturetype1");
    }
  } else {
    if ( WndNum == 5 )
    {
      if ( moveval != 0 ) {}
      MovedWndName = WndName;
    } else {
      if ( WndNum == 7 )
      {
        if ( moveval != 0 ) {}
        MovedWndName = WndName;
      } else {
        moveval = 0;
      }
    }
  }
  onshowstat1 = True;
  onshowstat2 = False;
  globalDuration = Duration;
  switch (Animation)
  {
    case 0:
    droprate = 255;
    break;
    case 1:
    droprate = 25;
    break;
    case 11:
    droprate = 15;
    break;
    case 12:
    droprate = 25;
    break;
    case 13:
    droprate = 35;
    break;
    default:
  }
}

function FadeIn (string WndName)
{
  globalAlphavalue1 = globalAlphavalue1 + droprate;
  if ( globalAlphavalue1 < 255 )
  {
    Class'UIAPI_WINDOW'.static.SetAlpha(WndName,globalAlphavalue1);
  } else {
    Class'UIAPI_WINDOW'.static.SetAlpha(WndName,255);
    globalAlphavalue1 = 0;
    onshowstat1 = False;
    m_TimerCount++;
    Class'UIAPI_WINDOW'.static.SetUITimer("OnScreenMessageWnd1",m_TimerCount,globalDuration);
  }
}

function FadeOut (string WndName)
{
  globalAlphavalue2 = globalAlphavalue2 - droprate;
  if ( globalAlphavalue2 > 1 )
  {
    Class'UIAPI_WINDOW'.static.SetAlpha(WndName,globalAlphavalue2);
  } else {
    Class'UIAPI_WINDOW'.static.SetAlpha(WndName,0);
    globalAlphavalue2 = 255;
    onshowstat2 = False;
    ResetAllMessage();
    moveval2 = 0;
    moveval = 0;
  }
}

function OnEvent (int a_EventID, string a_Param)
{
  local int MsgType;
  local int msgNo;
  local int WindowType;
  local int FontSize;
  local int FontType;
  local int MsgColor;
  local int msgcolorR;
  local int msgcolorG;
  local int msgcolorB;
  local int shadowtype;
  local int BackgroundType;
  local int Lifetime;
  local int AnimationType;
  local int SystemMsgIndex;
  local string msgtext;
  local string ParamString1;
  local string ParamString2;


  if ( a_EventID == 140 )
  {
    ParseInt(a_Param,"MsgType",MsgType);
    ParseInt(a_Param,"MsgNo",msgNo);
    ParseInt(a_Param,"WindowType",WindowType);
    ParseInt(a_Param,"FontSize",FontSize);
    ParseInt(a_Param,"FontType",FontType);
    ParseInt(a_Param,"MsgColor",MsgColor);
    if (  !ParseInt(a_Param,"MsgColorR",msgcolorR) )
    {
      msgcolorR = 255;
    }
    if (  !ParseInt(a_Param,"MsgColorG",msgcolorG) )
    {
      msgcolorG = 255;
    }
    if (  !ParseInt(a_Param,"MsgColorB",msgcolorB) )
    {
      msgcolorB = 255;
    }
    ParseInt(a_Param,"ShadowType",shadowtype);
    ParseInt(a_Param,"BackgroundType",BackgroundType);
    ParseInt(a_Param,"LifeTime",Lifetime);
    ParseInt(a_Param,"AnimationType",AnimationType);
    ParseString(a_Param,"Msg",msgtext);
    ResetAllMessage();
    switch (MsgType)
    {
      case 1:

      ShowMsg(WindowType,msgtext,Lifetime,AnimationType,FontType,BackgroundType,msgcolorR,msgcolorG,msgcolorB);
	
      break;
      case 0:
      msgtext = GetSystemMessage(msgNo);
	 

      ShowMsg(WindowType,msgtext,Lifetime,AnimationType,FontType,BackgroundType,msgcolorR,msgcolorG,msgcolorB);
      break;
      default:
    }
  }
  if ( a_EventID == 580 )
  {
    ParseInt(a_Param,"Index",SystemMsgIndex);
    ParseString(a_Param,"Param1",ParamString1);
    ParseString(a_Param,"Param2",ParamString2);
    if ( (SystemMsgIndex == 35) &&  !Class'UIAPI_CHECKBOX'.static.IsChecked("OptionWnd.CB_ShowDamage") )
    {
      return;
    }
    ValidateSystemMsg(SystemMsgIndex,ParamString1,ParamString2);
  }
}

function ValidateSystemMsg (int index, string StringTxt1, string StringTxt2)
{
  local SystemMsgData SystemMsgCurrent;
  local int WindowType;
  local int FontType;
  local int BackgroundType;
  local int Lifetime;
  local int AnimationType;
  local string msgtext;
  local Color TextColor;

  GetSystemMsgInfo(index,SystemMsgCurrent);
  if ( SystemMsgCurrent.WindowType != 0 )
  {
    WindowType = SystemMsgCurrent.WindowType;
    msgtext = SystemMsgCurrent.OnScrMsg;
    msgtext = MakeFullSystemMsg(msgtext,StringTxt1,StringTxt2);
    Lifetime = SystemMsgCurrent.Lifetime * 1000;
    AnimationType = SystemMsgCurrent.AnimationType;
    FontType = SystemMsgCurrent.FontType;
    BackgroundType = SystemMsgCurrent.BackgroundType;
    TextColor = SystemMsgCurrent.Color;
    if ( (TextColor.R == 0) && (TextColor.G == 0) && (TextColor.B == 0) )
    {
      TextColor.R = 255;
      TextColor.G = 255;
      TextColor.B = 255;
    } else {
      if ( (TextColor.R == 176) && (TextColor.G == 155) && (TextColor.B == 121) )
      {
        TextColor.R = 255;
        TextColor.G = 255;
        TextColor.B = 255;
      }
    }
    ShowMsg(WindowType,msgtext,Lifetime,AnimationType,FontType,BackgroundType,TextColor.R,TextColor.G,TextColor.B);
  }
}
defaultproperties
{
}
