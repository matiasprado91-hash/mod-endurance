//================================================================================
// PartyWndOption.
//================================================================================

class PartyWndOption extends UIScript;

var bool m_OptionShow;
var WindowHandle m_PartyOption;
var WindowHandle m_PartyWndBig;
var WindowHandle m_PartyWndSmall;

function OnLoad ()
{
  m_OptionShow = False;
  m_PartyOption = GetHandle("PartyWndOption");
  m_PartyWndBig = GetHandle("PartyWnd");
  m_PartyWndSmall = GetHandle("PartyWndCompact");
}

function OnShow ()
{
  Class'UIAPI_CHECKBOX'.static.SetCheck("ShowSmallPartyWndCheck",GetOptionBool("Game","SmallPartyWnd"));
  Class'UIAPI_WINDOW'.static.SetFocus("PartyWndOption");
  m_OptionShow = True;
}

function OnClickCheckBox (string CheckBoxID)
{
  switch (CheckBoxID)
  {
    case "ShowSmallPartyWndCheck":
    break;
    default:
  }
}

function SwapBigandSmall ()
{
  local PartyWnd script1;
  local PartyWndCompact Script2;

  script1 = PartyWnd(GetScript("PartyWnd"));
  Script2 = PartyWndCompact(GetScript("PartyWndCompact"));
  Class'UIAPI_WINDOW'.static.SetAnchor("PartyWndCompact","PartyWnd","TopLeft","TopLeft",0,0);
  script1.samnnasdjuawe();
  Script2.ResizeWnd();
}

function OnClickButton (string strID)
{
  switch (strID)
  {
    case "okbtn":
    switch (Class'UIAPI_CHECKBOX'.static.IsChecked("ShowSmallPartyWndCheck"))
    {
      case True:
      SetOptionBool("Game","SmallPartyWnd",True);
      break;
      case False:
      SetOptionBool("Game","SmallPartyWnd",False);
      break;
      default:
    }
    SwapBigandSmall();
    m_PartyOption.HideWindow();
    m_OptionShow = False;
    break;
    default:
  }
}

function ShowPartyWndOption ()
{
  if ( m_OptionShow == False )
  {
    m_PartyOption.ShowWindow();
    m_OptionShow = True;
  } else {
    m_PartyOption.HideWindow();
    m_OptionShow = False;
  }
}
defaultproperties
{
}
