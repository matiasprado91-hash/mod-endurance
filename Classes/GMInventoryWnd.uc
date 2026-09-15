//================================================================================
// GMInventoryWnd.
//================================================================================

class GMInventoryWnd extends InventoryWnd;

struct GMHennaInfo
{
  var int HennaID;
  var int IsActive;
};

var bool bShow;
var int m_ObservingUserInvenLimit;
var int m_Adena;
var bool m_HasLEar;
var bool m_HasLFinger;
var array<GMHennaInfo> m_HennaInfoList;



function OnLoad ()
{
  local WindowHandle hCrystallizeButton;
  local WindowHandle hTrashButton;
  local WindowHandle hInvenWeight;

  RegisterEvent(2401);
  RegisterEvent(2402);
  RegisterEvent(2403);
  RegisterEvent(2404);
  InitHandle();
  bShow = False;
  m_hOwnerWnd.SetWindowTitle(" ");
  hCrystallizeButton = GetHandle("CrystallizeButton");
  hTrashButton = GetHandle("TrashButton");
  hInvenWeight = GetHandle("InvenWeight");
  hCrystallizeButton.HideWindow();
  hTrashButton.HideWindow();
  hInvenWeight.HideWindow();
}

function OnShow ()
{
  SetAdenaText();
}

function ShowInventory (string a_Param)
{
  if ( (a_Param == "") )
  {
    return;
  }
  if ( bShow )
  {
    HandleClear();
    m_hOwnerWnd.HideWindow();
    bShow = False;
  } else {
    Class'GMAPI'.static.RequestGMCommand(EGMCommandType(5),a_Param);
    bShow = True;
  }
}

function OnEvent (int a_EventID, string a_Param)
{
  switch (a_EventID)
  {
    case 2401:
    HandleGMObservingInventoryAddItem(a_Param);
    break;
    case 2402:
    HandleGMObservingInventoryClear(a_Param);
    break;
    case 2403:
    HandleGMAddHennaInfo(a_Param);
    break;
    case 2404:
    HandleGMUpdateHennaInfo(a_Param);
    break;
    default:
  }
}

function HandleGMObservingInventoryAddItem (string a_Param)
{
  HandleAddItem(a_Param);
  SetItemCount();
}

function HandleAddItem (string param)
{
  local ItemInfo Info;

  ParamToItemInfo(param,Info);
  if ( IsEquipItem(Info) )
  {
    EquipItemUpdate(Info);
  } else {
    if ( IsQuestItem(Info) )
    {
      m_questItem.AddItem(Info);
    } else {
      if ( (Info.ClassID == 57) )
      {
        SetAdena(Info.ItemNum);
      }
      m_invenItem.AddItem(Info);
    }
  }
}

function SetAdena (int a_Adena)
{
  m_Adena = a_Adena;
  SetAdenaText();
}

function SetAdenaText ()
{
  local string adenaString;

  adenaString = MakeCostString(string(m_Adena));
  m_hAdenaTextBox.SetText(adenaString);
  m_hAdenaTextBox.SetTooltipString(ConvertNumToText(string(m_Adena)));
}

function int GetMyInventoryLimit ()
{
  return m_ObservingUserInvenLimit;
}

function HandleGMObservingInventoryClear (string a_Param)
{
  HandleClear();
  ParseInt(a_Param,"InvenLimit",m_ObservingUserInvenLimit);
  m_hOwnerWnd.ShowWindow();
  m_hOwnerWnd.SetFocus();
}

function HandleGMAddHennaInfo (string a_Param)
{
  m_HennaInfoList.Length = (m_HennaInfoList.Length + 1);
  ParseInt(a_Param,"ID",m_HennaInfoList[(m_HennaInfoList.Length - 1)].HennaID);
  ParseInt(a_Param,"bActive",m_HennaInfoList[(m_HennaInfoList.Length - 1)].IsActive);
  UpdateHennaInfo();
}

function HandleGMUpdateHennaInfo (string a_Param)
{
  m_HennaInfoList.Length = 0;
}

function OnDropItem (string strTarget, ItemInfo Info, int X, int Y)
{
}

function OnDropItemSource (string strTarget, ItemInfo Info)
{
}

function OnDBClickItem (string strID, int Index)
{
}

function OnRClickItem (string strID, int Index)
{
}

function EquipItemUpdate (ItemInfo a_Info)
{
  local ItemWindowHandle hItemWnd;

  Super.EquipItemUpdate(a_Info);
  switch (a_Info.SlotBitType)
  {
    case 2:
    case 4:
    case 6:
    if ( (0 == zzm_equipItem[8].GetItemNum()) )
    {
      hItemWnd = zzm_equipItem[8];
    } else {
      hItemWnd = zzm_equipItem[9];
    }
    break;
    case 16:
    case 32:
    case 48:
    if ( (0 == zzm_equipItem[13].GetItemNum()) )
    {
      hItemWnd = zzm_equipItem[13];
    } else {
      hItemWnd = zzm_equipItem[14];
    }
    break;
    default:
  }
  if ( (None != hItemWnd) )
  {
    hItemWnd.Clear();
    hItemWnd.AddItem(a_Info);
  }
}

function int IsLOrREar (int a_ServerID)
{
  return 0;
}

function int IsLOrRFinger (int a_ServerID)
{
  return 0;
}

function UpdateHennaInfo ()
{
  local int i;
  local ItemInfo HennaItemInfo;

  m_hHennaItemWindow.Clear();
  m_hHennaItemWindow.SetRow(m_HennaInfoList.Length);
  i = 0;
  
  for( i = 0;  i < m_HennaInfoList.Length; i++ )
  {
    if ( !(Class'UIDATA_HENNA'.static.GetItemName(m_HennaInfoList[i].HennaID,HennaItemInfo.Name)) )
    {
      break;
    }
    if ( !(Class'UIDATA_HENNA'.static.GetDescription(m_HennaInfoList[i].HennaID,HennaItemInfo.Description)) )
    {
      break;
    }
    if ( !(Class'UIDATA_HENNA'.static.GetIconTex(m_HennaInfoList[i].HennaID,HennaItemInfo.IconName)) )
    {
      break;
    }
    if ( (0 == m_HennaInfoList[i].IsActive) )
    {
      HennaItemInfo.bDisabled = True;
    } else {
      HennaItemInfo.bDisabled = False;
    }
    m_hHennaItemWindow.AddItem(HennaItemInfo);
   
    
  }
}


// Decompiled with UE Explorer.
defaultproperties
{
    m_WindowName="GMInventoryWnd"
}
