//================================================================================
// HennaListWnd.
//================================================================================

class HennaListWnd extends UICommonAPI;

var int m_iState;
var int m_iRootNameLength;
const HENNA_UNEQUIP=2;
const HENNA_EQUIP=1;
const FEE_OFFSET_Y_UNEQUIP= -12;
const FEE_OFFSET_Y_EQUIP= -13;

function OnLoad ()
{
  RegisterEvent(1640);
  RegisterEvent(1650);
  RegisterEvent(1670);
  RegisterEvent(1680);
}

function OnClickButton (string strID)
{
  local string strHennaID;

  switch (strID)
  {
    default:
  }
  strHennaID = Mid(strID,(m_iRootNameLength + 1));
  if ( (m_iState == 1) )
  {
    RequestHennaItemInfo(int(strHennaID));
  } else {
    if ( (m_iState == 2) )
    {
      RequestHennaUnEquipInfo(int(strHennaID));
    }
  }
  
}

function Clear ()
{
  Class'UIAPI_TREECTRL'.static.Clear("HennaListWnd.HennaListTree");
}

function OnEvent (int Event_ID, string param)
{
  local int iAdena;
  local string strName;
  local string strIconName;
  local string strDescription;
  local int iHennaID;
  local int iClassID;
  local int iNum;
  local int iFee;

  switch (Event_ID)
  {
    case 1640:
    m_iState = 1;
    Clear();
    ParseInt(param,"Adena",iAdena);
    ShowHennaListWnd(iAdena);
    break;
    case 1650:
    case 1680:
    ParseString(param,"Name",strName);
    ParseString(param,"Description",strDescription);
    ParseString(param,"IconName",strIconName);
    ParseInt(param,"HennaID",iHennaID);
    ParseInt(param,"ClassID",iClassID);
    ParseInt(param,"NumOfItem",iNum);
    ParseInt(param,"Fee",iFee);
    AddHennaListItem(strName,strIconName,strDescription,iFee,iHennaID);
    break;
    case 1670:
    m_iState = 2;
    Clear();
    ParseInt(param,"Adena",iAdena);
    ShowHennaListWnd(iAdena);
    break;
    default:
  }
}

function ShowHennaListWnd (int iAdena)
{
  local XMLTreeNodeInfo infNode;
  local string strTmp;

  if ( (m_iState == 1) )
  {
    Class'UIAPI_WINDOW'.static.SetWindowTitleByText("HennaListWnd",GetSystemString(651));
    Class'UIAPI_TEXTBOX'.static.SetText("HennaListWnd.txtList",GetSystemString(659));
  } else {
    if ( (m_iState == 2) )
    {
      Class'UIAPI_WINDOW'.static.SetWindowTitleByText("HennaListWnd",GetSystemString(652));
      Class'UIAPI_TEXTBOX'.static.SetText("HennaListWnd.txtList",GetSystemString(660));
    }
  }
  Class'UIAPI_TEXTBOX'.static.SetText("HennaListWnd.txtAdena",MakeCostString(("" $ string(iAdena))));
  Class'UIAPI_TEXTBOX'.static.SetTooltipString("HennaListWnd.txtAdena",ConvertNumToText(("" $ string(iAdena))));
  infNode.strName = "HennaListRoot";
  infNode.nOffSetX = 7;
  infNode.nOffSetY = -3;
  strTmp = Class'UIAPI_TREECTRL'.static.InsertNode("HennaListWnd.HennaListTree","",infNode);
  if ( (Len(strTmp) < 1) )
  {
    Debug(("ERROR: Can't insert root node. Name: " $ infNode.strName));
    return;
  }
  m_iRootNameLength = Len(infNode.strName);
  ShowWindow("HennaListWnd");
  Class'UIAPI_WINDOW'.static.SetFocus("HennaListWnd");
}

function AddHennaListItem (string strName, string strIconName, string strDescription, int iFee, int iHennaID)
{
  local XMLTreeNodeInfo infNode;
  local XMLTreeNodeItemInfo infNodeItem;
  local XMLTreeNodeInfo infNodeClear;
  local XMLTreeNodeItemInfo infNodeItemClear;
  local string strRetName;
  local string strAdenaComma;

  infNode = infNodeClear;
  infNode.strName = ("" $ string(iHennaID));
  infNode.bShowButton = 0;
  infNode.nTexExpandedOffSetX = -7;
  infNode.nTexExpandedOffSetY = 8;
  infNode.nTexExpandedHeight = 46;
  infNode.nTexExpandedRightWidth = 0;
  infNode.nTexExpandedLeftUWidth = 32;
  infNode.nTexExpandedLeftUHeight = 40;
  infNode.strTexExpandedLeft = "L2UI_CH3.etc.IconSelect2";
  strRetName = Class'UIAPI_TREECTRL'.static.InsertNode("HennaListWnd.HennaListTree","HennaListRoot",infNode);
  if ( (Len(strRetName) < 1) )
  {
    Debug(("ERROR: Can't insert node. Name: " $ infNode.strName));
    return;
  }
  infNodeItem = infNodeItemClear;
  infNodeItem.eType = XTNITEM_TEXTURE;
  infNodeItem.nOffSetX = 0;
  infNodeItem.nOffSetY = 15;
  infNodeItem.u_nTextureWidth = 32;
  infNodeItem.u_nTextureHeight = 32;
  infNodeItem.u_strTexture = strIconName;
  Class'UIAPI_TREECTRL'.static.InsertNodeItem("HennaListWnd.HennaListTree",strRetName,infNodeItem);
  infNodeItem = infNodeItemClear;
  infNodeItem.eType = XTNITEM_TEXT;
  infNodeItem.t_strText = strName;
  infNodeItem.t_bDrawOneLine = True;
  infNodeItem.nOffSetX = 5;
  if ( (m_iState == 1) )
  {
    infNodeItem.nOffSetY = 17;
  } else {
    if ( (m_iState == 2) )
    {
      infNodeItem.nOffSetY = 10;
    }
  }
  Class'UIAPI_TREECTRL'.static.InsertNodeItem("HennaListWnd.HennaListTree",strRetName,infNodeItem);
  if ( (m_iState == 2) )
  {
    infNodeItem = infNodeItemClear;
    infNodeItem.eType = XTNITEM_TEXT;
    infNodeItem.t_strText = strDescription;
    infNodeItem.bLineBreak = True;
    infNodeItem.t_bDrawOneLine = True;
    infNodeItem.nOffSetX = 37;
    infNodeItem.nOffSetY = -24;
    Class'UIAPI_TREECTRL'.static.InsertNodeItem("HennaListWnd.HennaListTree",strRetName,infNodeItem);
  }
  infNodeItem = infNodeItemClear;
  infNodeItem.eType = XTNITEM_TEXT;
  infNodeItem.t_strText = (GetSystemString(637) $ " : ");
  infNodeItem.bLineBreak = True;
  infNodeItem.t_bDrawOneLine = True;
  infNodeItem.nOffSetX = 37;
  if ( (m_iState == 1) )
  {
    infNodeItem.nOffSetY = -13;
  } else {
    if ( (m_iState == 2) )
    {
      infNodeItem.nOffSetY = -12;
    }
  }
  infNodeItem.t_color.R = 168;
  infNodeItem.t_color.G = 168;
  infNodeItem.t_color.B = 168;
  infNodeItem.t_color.A = 255;
  Class'UIAPI_TREECTRL'.static.InsertNodeItem("HennaListWnd.HennaListTree",strRetName,infNodeItem);
  strAdenaComma = MakeCostString(("" $ string(iFee)));
  infNodeItem = infNodeItemClear;
  infNodeItem.eType = XTNITEM_TEXT;
  infNodeItem.t_strText = strAdenaComma;
  infNodeItem.t_bDrawOneLine = True;
  infNodeItem.nOffSetX = 0;
  if ( (m_iState == 1) )
  {
    infNodeItem.nOffSetY = -13;
  } else {
    if ( (m_iState == 2) )
    {
      infNodeItem.nOffSetY = -12;
    }
  }
  infNodeItem.t_color = GetNumericColor(strAdenaComma);
  Class'UIAPI_TREECTRL'.static.InsertNodeItem("HennaListWnd.HennaListTree",strRetName,infNodeItem);
  infNodeItem = infNodeItemClear;
  infNodeItem.eType = XTNITEM_TEXT;
  infNodeItem.t_strText = GetSystemString(469);
  infNodeItem.t_bDrawOneLine = True;
  infNodeItem.nOffSetX = 5;
  if ( (m_iState == 1) )
  {
    infNodeItem.nOffSetY = -13;
  } else {
    if ( (m_iState == 2) )
    {
      infNodeItem.nOffSetY = -12;
    }
  }
  infNodeItem.t_color.R = 255;
  infNodeItem.t_color.G = 255;
  infNodeItem.t_color.B = 0;
  infNodeItem.t_color.A = 255;
  Class'UIAPI_TREECTRL'.static.InsertNodeItem("HennaListWnd.HennaListTree",strRetName,infNodeItem);
}
defaultproperties
{
}
