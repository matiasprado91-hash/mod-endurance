//================================================================================
// HennaInfoWnd.
//================================================================================

class HennaInfoWnd extends UIScript;

var int m_iState;
var int m_iHennaID;
const HENNA_UNEQUIP=2;
const HENNA_EQUIP=1;

function OnLoad ()
{
  RegisterEvent(1660);
  RegisterEvent(1690);
}

function OnClickButton (string strID)
{
  Class'UIAPI_WINDOW'.static.HideWindow("HennaInfoWnd");
  switch (strID)
  {
    case "btnPrev":
    if ( (m_iState == 1) )
    {
      RequestHennaItemList();
    } else {
      if ( (m_iState == 2) )
      {
        RequestHennaUnEquipList();
      }
    }
    break;
    case "btnOK":
    if ( (m_iState == 1) )
    {
      RequestHennaEquip(m_iHennaID);
    } else {
      if ( (m_iState == 2) )
      {
        RequestHennaUnEquip(m_iHennaID);
      }
    }
    break;
    default:
  }
}

function OnShow ()
{
  if ( (m_iState == 1) )
  {
    Class'UIAPI_WINDOW'.static.SetWindowTitleByText("HennaInfoWnd",GetSystemString(651));
    Class'UIAPI_WINDOW'.static.HideWindow("HennaInfoWnd.HennaInfoWndUnEquip");
    Class'UIAPI_WINDOW'.static.ShowWindow("HennaInfoWnd.HennaInfoWndEquip");
  } else {
    if ( (m_iState == 2) )
    {
      Class'UIAPI_WINDOW'.static.SetWindowTitleByText("HennaInfoWnd",GetSystemString(652));
      Class'UIAPI_WINDOW'.static.HideWindow("HennaInfoWnd.HennaInfoWndEquip");
      Class'UIAPI_WINDOW'.static.ShowWindow("HennaInfoWnd.HennaInfoWndUnEquip");
    } else {
      Debug("???????????????? ????????????????~~");
    }
  }
}

function OnEvent (int Event_ID, string param)
{
  switch (Event_ID)
  {
    case 1660:
    m_iState = 1;
    ShowHennaInfoWnd(param);
    break;
    case 1690:
    m_iState = 2;
    ShowHennaInfoWnd(param);
    break;
    default:
  }
}

function ShowHennaInfoWnd (string param)
{
  local string strAdenaComma;
  local int iAdena;
  local string strDyeName;
  local string strDyeIconName;
  local int iHennaID;
  local int iClassID;
  local int iNum;
  local int iFee;
  local string strTattooName;
  local string strTattooAddName;
  local string strTattooIconName;
  local int iINTnow;
  local int iINTchange;
  local int iSTRnow;
  local int iSTRchange;
  local int iCONnow;
  local int iCONchange;
  local int iMENnow;
  local int iMENchange;
  local int iDEXnow;
  local int iDEXchange;
  local int iWITnow;
  local int iWITchange;
  local Color col;

  ParseInt(param,"Adena",iAdena);
  ParseString(param,"DyeIconName",strDyeIconName);
  ParseString(param,"DyeName",strDyeName);
  ParseInt(param,"HennaID",iHennaID);
  ParseInt(param,"ClassID",iClassID);
  ParseInt(param,"NumOfItem",iNum);
  ParseInt(param,"Fee",iFee);
  ParseString(param,"TattooIconName",strTattooIconName);
  ParseString(param,"TattooName",strTattooName);
  ParseString(param,"TattooAddName",strTattooAddName);
  ParseInt(param,"INTnow",iINTnow);
  ParseInt(param,"INTchange",iINTchange);
  ParseInt(param,"STRnow",iSTRnow);
  ParseInt(param,"STRchange",iSTRchange);
  ParseInt(param,"CONnow",iCONnow);
  ParseInt(param,"CONchange",iCONchange);
  ParseInt(param,"MENnow",iMENnow);
  ParseInt(param,"MENchange",iMENchange);
  ParseInt(param,"DEXnow",iDEXnow);
  ParseInt(param,"DEXchange",iDEXchange);
  ParseInt(param,"WITnow",iWITnow);
  ParseInt(param,"WITchange",iWITchange);
  m_iHennaID = iHennaID;
  if ( (m_iState == 1) )
  {
    Class'UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtDyeInfo",GetSystemString(638));
    Class'UIAPI_TEXTURECTRL'.static.SetTexture("HennaInfoWnd.textureDyeIconName",strDyeIconName);
    Class'UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtDyeName",strDyeName);
    col.R = 168;
    col.G = 168;
    col.B = 168;
    Class'UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtFee",(GetSystemString(637) $ " : "));
    Class'UIAPI_TEXTBOX'.static.SetTextColor("HennaInfoWnd.txtFee",col);
    strAdenaComma = MakeCostString(("" $ string(iFee)));
    col = GetNumericColor(strAdenaComma);
    Class'UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtAdena",strAdenaComma);
    Class'UIAPI_TEXTBOX'.static.SetTextColor("HennaInfoWnd.txtAdena",col);
    col.R = 255;
    col.G = 255;
    col.B = 0;
    Class'UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtAdenaString",GetSystemString(469));
    Class'UIAPI_TEXTBOX'.static.SetTextColor("HennaInfoWnd.txtAdenaString",col);
    Class'UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtTattooInfo",GetSystemString(639));
    Class'UIAPI_TEXTURECTRL'.static.SetTexture("HennaInfoWnd.textureTattooIconName",strTattooIconName);
    Class'UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtTattooName",strTattooName);
    Class'UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtTattooAddName",strTattooAddName);
  } else {
    if ( (m_iState == 2) )
    {
      Class'UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtTattooInfoUnEquip",GetSystemString(639));
      Class'UIAPI_TEXTURECTRL'.static.SetTexture("HennaInfoWnd.textureTattooIconNameUnEquip",strTattooIconName);
      Class'UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtTattooNameUnEquip",((GetSystemString(652) $ ":") $ strTattooName));
      Class'UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtTattooAddNameUnEquip",strTattooAddName);
      Class'UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtDyeInfoUnEquip",GetSystemString(638));
      Class'UIAPI_TEXTURECTRL'.static.SetTexture("HennaInfoWnd.textureDyeIconNameUnEquip",strDyeIconName);
      Class'UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtDyeNameUnEquip",strDyeName);
      col.R = 168;
      col.G = 168;
      col.B = 168;
      Class'UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtFeeUnEquip",(GetSystemString(637) $ " : "));
      Class'UIAPI_TEXTBOX'.static.SetTextColor("HennaInfoWnd.txtFeeUnEquip",col);
      strAdenaComma = MakeCostString(("" $ string(iFee)));
      col = GetNumericColor(strAdenaComma);
      Class'UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtAdenaUnEquip",strAdenaComma);
      Class'UIAPI_TEXTBOX'.static.SetTextColor("HennaInfoWnd.txtAdenaUnEquip",col);
      col.R = 255;
      col.G = 255;
      col.B = 0;
      Class'UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtAdenaStringUnEquip",GetSystemString(469));
      Class'UIAPI_TEXTBOX'.static.SetTextColor("HennaInfoWnd.txtAdenaStringUnEquip",col);
    }
  }
  Class'UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtSTRBefore",iSTRnow);
  Class'UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtSTRAfter",iSTRchange);
  Class'UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtDEXBefore",iDEXnow);
  Class'UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtDEXAfter",iDEXchange);
  Class'UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtCONBefore",iCONnow);
  Class'UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtCONAfter",iCONchange);
  Class'UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtINTBefore",iINTnow);
  Class'UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtINTAfter",iINTchange);
  Class'UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtWITBefore",iWITnow);
  Class'UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtWITAfter",iWITchange);
  Class'UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtMENBefore",iMENnow);
  Class'UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtMENAfter",iMENchange);
  strAdenaComma = MakeCostString(("" $ string(iAdena)));
  col = GetNumericColor(strAdenaComma);
  Class'UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtHaveAdena",strAdenaComma);
  Class'UIAPI_TEXTBOX'.static.SetTooltipString("HennaInfoWnd.txtHaveAdena",ConvertNumToText(("" $ string(iAdena))));
  Class'UIAPI_WINDOW'.static.HideWindow("HennaListWnd");
  Class'UIAPI_WINDOW'.static.ShowWindow("HennaInfoWnd");
  Class'UIAPI_WINDOW'.static.SetFocus("HennaInfoWnd");
}
defaultproperties
{
}
