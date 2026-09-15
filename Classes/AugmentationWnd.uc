//================================================================================
// AugmentationWnd.
//================================================================================

class AugmentationWnd extends UICommonAPI;

var WindowHandle Me;
var ItemWindowHandle WeaponItem;
var ItemWindowHandle CatalystItem;
var ItemWindowHandle GemstoneItem;
var ItemWindowHandle InventoryItem;
var int a_TargetItemServerID;
var int a_RefinerItemServerID;
var int a_GemStoneServerID;
var int UnkInt4;
var int UnkInt5;
var int a_GemStoneCount;
var AugmentationListWnd AugmentationListWnd;
var ComboBoxHandle ConditionBox;
var int AugmentSpeed;
var bool Pause;
const UNREFINE= 2;
const REFINE= 1;

function OnLoad ()
{
  Me = GetHandle("AugmentationWnd");
  AugmentationListWnd = AugmentationListWnd(GetScript("AugmentationListWnd"));
  WeaponItem = ItemWindowHandle(GetHandle("AugmentationWnd.WeaponItem"));
  CatalystItem = ItemWindowHandle(GetHandle("AugmentationWnd.CatalystItem"));
  GemstoneItem = ItemWindowHandle(GetHandle("AugmentationWnd.GemstoneItem"));
  InventoryItem = ItemWindowHandle(GetHandle("InventoryWnd.InventoryItem"));
  ConditionBox = ComboBoxHandle(GetHandle("AugmentationWnd.ConditionBox"));
  OnRegisterEvent();
  GemstoneItem.DisableWindow();
  SeemsLikeHandleAugmentAction(0);
  AugmentSpeed = 1600 - Class'UIAPI_SLIDERCTRL'.static.GetCurrentTick("AugmentationWnd.SpeedSliderCtrl") * 100;
  Class'UIAPI_TEXTBOX'.static.SetText("AugmentationWnd.Title","Augment");
}

function OnRegisterEvent ()
{
  RegisterEvent(2610);
  RegisterEvent(2600);
  RegisterEvent(2800);
  RegisterEvent(2830);
}

function OnEvent (int EventID, string param)
{
  switch (EventID)
  {
    case 2610:
    SeemsHandleItems(param);
    break;
    case 2600:
	SomethingWithGemstone(param);
    break;
    case 2800:
    SeemsLikeCheckForAugment(param);
    break;
    case 2830:
    SomethingWithResultslul(param);
    break;
    default:
  }
}

function OnClickButton (string param)
{
  switch (param)
  {
    case "BtnRefine":
    Pause = False;
    OnClickRefineButton();
    break;
    case "BtnPause":
    Pause = True;
    break;
    case "BtnList":
    if (  !Class'UIAPI_WINDOW'.static.IsShowWindow("AugmentationListWnd") )
    {
      Class'UIAPI_WINDOW'.static.ShowWindow("AugmentationListWnd");
    } else {
      Class'UIAPI_WINDOW'.static.HideWindow("AugmentationListWnd");
    }
    break;
    case "BtnClose":
    Class'UIAPI_WINDOW'.static.HideWindow("AugmentationWnd");
    break;
    default:
  }
}

function OnClickRefineButton ()
{
  local ItemInfo l_ItemInfo;
  local int i;

  i = InventoryItem.FindItemWithServerID(a_TargetItemServerID);
  InventoryItem.GetItem(i,l_ItemInfo);
  if ( l_ItemInfo.RefineryOp2 == 0 )
  {
    Class'RefineryAPI'.static.RequestRefine(a_TargetItemServerID,a_RefinerItemServerID,a_GemStoneServerID,a_GemStoneCount);
  } else {
    Me.SetTimer(2,0);
  }
}

function SeemsLikeCheckForAugment (string param)
{
  local int Result;
  local int Option1;
  local int Option2;
  local int i;

  ParseInt(param,"Result",Result);
  switch (Result)
  {
    case 1:
    ParseInt(param,"Option1",Option1);
    ParseInt(param,"Option2",Option2);
	SomethignWithAugmentResulttt(Option1,Option2);
    Class'UIAPI_TEXTBOX'.static.SetText("AugmentationWnd.Instruction",GetSystemMessage(1962));
    break;
    case 0:
    Pause = True;
    return;
    default:
  }
  if ( ConditionBox.GetSelectedNum() == 1 )
  {
    if ( Option2 < 14577 )
    {
      Me.SetTimer(2,AugmentSpeed);
    }
  }
  if ( ConditionBox.GetSelectedNum() == 2 )
  {
    if ( Option2 > 14577 )
    {
      i = 0;
	  JL0116:
      if ( i < AugmentationListWnd.SelectedList.GetRecordCount() )
      {
        if ( Option2 == int(AugmentationListWnd.SelectedList.GetRecord(i).szReserved) )
        {
          Pause = True;
          Me.NotifyAlarm();
          return;
        }
        i++;
        goto JL0116;
      }
    }
    Me.SetTimer(2,AugmentSpeed);
  }
}

function OnTimer (int TimerID)
{
  Me.KillTimer(TimerID);
  if ( Pause )
  {
    return;
  }
  switch (TimerID)
  {
    case 1:
    Class'RefineryAPI'.static.RequestRefine(a_TargetItemServerID,a_RefinerItemServerID,a_GemStoneServerID,a_GemStoneCount);
    break;
    case 2:
    Class'RefineryAPI'.static.RequestRefineCancel(a_TargetItemServerID);
    Me.SetTimer(1,AugmentSpeed);
    break;
    default:
  }
}

function SomethingWithResultslul (string param)
{
  local int Result;

  ParseInt(param,"Result",Result);
  if ( Result != 0 )
  {
    SeemsSetAugmentResultsDefaults();
    Class'UIAPI_TEXTBOX'.static.SetText("AugmentationWnd.Instruction","Augmentation has been removed!");
  } else {
    Pause = True;
  }
  return;
}

function SeemsLikeHandleAugmentAction (int idx)
{
  local string param;

  switch (idx)
  {
    case 0:
    Pause = True;
    WeaponItem.Clear();
    GemstoneItem.Clear();
    CatalystItem.Clear();
    CatalystItem.HideWindow();
    SeemsSetAugmentResultsDefaults();
    Class'UIAPI_TEXTBOX'.static.SetText("AugmentationWnd.GemstoneItemCounter","");
    Class'UIAPI_TEXTBOX'.static.SetText("AugmentationWnd.CatalystItemCounter","");
    Class'UIAPI_TEXTBOX'.static.SetText("AugmentationWnd.Instruction",GetSystemMessage(1957));
    SetPositions("AugmentationWnd.HighlightItem","AugmentationWnd.WeaponItem",7,0,0);
    Class'UIAPI_WINDOW'.static.ShowWindow("AugmentationWnd.HighlightItem");
    UnkInt5 = 0;
    a_GemStoneCount = 0;
    a_TargetItemServerID = 0;
    UnkInt4 = 0;
    a_RefinerItemServerID = 0;
    Class'UIAPI_WINDOW'.static.DisableWindow("AugmentationWnd.BtnRefine");
    break;
    case 1:
    Pause = True;
    GemstoneItem.Clear();
    GemstoneItem.EnableWindow();
    Class'UIAPI_TEXTBOX'.static.SetText("AugmentationWnd.GemstoneItemCounter","");
    SetPositions("AugmentationWnd.HighlightItem","AugmentationWnd.GemstoneItem",7,0,0);
    Class'UIAPI_WINDOW'.static.ShowWindow("AugmentationWnd.HighlightItem");
    param = Class'UIDATA_ITEM'.static.GetItemName(UnkInt5);
    Class'UIAPI_TEXTBOX'.static.SetText("AugmentationWnd.Instruction",MakeFullSystemMsg(GetSystemMessage(1959),param,"" $ string(a_GemStoneCount)));
    break;
    case 2:
    Pause = True;
    CatalystItem.Clear();
    Class'UIAPI_TEXTBOX'.static.SetText("AugmentationWnd.CatalystItemCounter","");
    CatalystItem.ShowWindow();
    Class'UIAPI_TEXTBOX'.static.SetText("AugmentationWnd.Instruction",GetSystemMessage(1958));
    SetPositions("AugmentationWnd.HighlightItem","AugmentationWnd.GemstoneItem",7,0,0);
    Class'UIAPI_WINDOW'.static.ShowWindow("AugmentationWnd.GemstoneItem");
    UnkInt4 = 0;
    a_RefinerItemServerID = 0;
    Class'UIAPI_WINDOW'.static.DisableWindow("AugmentationWnd.BtnRefine");
    break;
    case 3:
    Pause = True;
    Class'UIAPI_TEXTBOX'.static.SetText("AugmentationWnd.Instruction",GetSystemMessage(1984));
    Class'UIAPI_WINDOW'.static.HideWindow("AugmentationWnd.HighlightItem");
    Class'UIAPI_WINDOW'.static.EnableWindow("AugmentationWnd.BtnRefine");
    break;
    default:
  }
}

function OnShow ()
{
  if ( Class'UIAPI_TEXTBOX'.static.GetText("AugmentationWnd.Title") == "" )
  {
    //SetPositions("AugmentationWnd","AugmentationWnd.WeaponItem",1,0,0);
    Class'UIAPI_TEXTBOX'.static.SetTextColor("AugmentationWnd.Title",getColor("WHITE"));
  }
}

function bool ProbablyAddGemstoneItem ()
{
  local int i;
  local ItemInfo l_ItemInfo;

  i = InventoryItem.FindItemWithClassID(UnkInt5);
  InventoryItem.GetItem(i,l_ItemInfo);
  if ( l_ItemInfo.ItemNum != 0 )
  {
    a_GemStoneServerID = l_ItemInfo.ServerID;
    GemstoneItem.AddItem(l_ItemInfo);
    SeemsHandleItems("",l_ItemInfo);
    return True;
  }
}

function OnDropItem (string param, ItemInfo a_ItemInfo, int X, int Y)
{
  if ( param == "WeaponItem" )
  {
    if ( ValidGemstoneCount(a_ItemInfo) )
    {
      a_TargetItemServerID = a_ItemInfo.ServerID;
      PlaySound("InterfaceTextures.DragIn");
      GemstoneItem.Clear();
      WeaponItem.Clear();
      WeaponItem.AddItem(a_ItemInfo);
      if ( ProbablyAddGemstoneItem() )
      {
        SeemsLikeHandleAugmentAction(2);
      } else {
        SeemsLikeHandleAugmentAction(1);
      }
    } else {
      SemsNotifyImposible();
    }
  } else {
    if ( param == "CatalystItem" )
    {
      if ( TotallyUnknown(a_ItemInfo) )
      {
        a_RefinerItemServerID = a_ItemInfo.ServerID;
        PlaySound("InterfaceTextures.DragIn");
        CatalystItem.Clear();
        CatalystItem.AddItem(a_ItemInfo);
        SeemsHandleItems("",a_ItemInfo);
        SeemsLikeHandleAugmentAction(3);
      } else {
        SemsNotifyImposible();
      }
    } else {
      if ( param == "GemstoneItem" )
      {
        if ( GemstoneItem.GetItemNum() >= a_GemStoneCount )
        {
          if ( a_ItemInfo.ClassID == UnkInt5 )
          {
            PlaySound("InterfaceTextures.DragIn");
            a_GemStoneServerID = a_ItemInfo.ServerID;
            GemstoneItem.AddItem(a_ItemInfo);
            SeemsHandleItems("",a_ItemInfo);
            SeemsLikeHandleAugmentAction(2);
          } else {
            SemsNotifyImposible();
          }
        }
      }
    }
  }
}

function OnDBClickItem (string strID, int index)
{
  switch (strID)
  {
    case "WeaponItem":
    PlaySound("InterfaceTextures.DragOut");
    SeemsLikeHandleAugmentAction(0);
    break;
    case "CatalystItem":
    PlaySound("InterfaceTextures.DragOut");
    SeemsLikeHandleAugmentAction(2);
    break;
    default:
  }
}

function bool TotallyUnknown (ItemInfo a_ItemInfo)
{
  switch (a_ItemInfo.ClassID)
  {
    case 8762:
    case 8752:
    case 8742:
    case 8732:
    AugmentationListWnd.UnknownID1 = 1453;
    AugmentationListWnd.UnknownID2 = 1654;
    UnkInt4 = a_ItemInfo.ClassID;
    return True;
    case 8761:
    case 8751:
    case 8741:
    case 8731:
    AugmentationListWnd.UnknownID1 = 1291;
    AugmentationListWnd.UnknownID2 = 1452;
    UnkInt4 = a_ItemInfo.ClassID;
    return True;
    case 8760:
    case 8750:
    case 8740:
    case 8730:
    AugmentationListWnd.UnknownID1 = 1130;
    AugmentationListWnd.UnknownID2 = 1290;
    UnkInt4 = a_ItemInfo.ClassID;
    return True;
    case 8759:
    case 8749:
    case 8739:
    case 8729:
    AugmentationListWnd.UnknownID1 = 969;
    AugmentationListWnd.UnknownID2 = 1129;
    UnkInt4 = a_ItemInfo.ClassID;
    return True;
    case 8758:
    case 8748:
    case 8738:
    case 8728:
    AugmentationListWnd.UnknownID1 = 808;
    AugmentationListWnd.UnknownID2 = 968;
    UnkInt4 = a_ItemInfo.ClassID;
    return True;
    case 8757:
    case 8747:
    case 8737:
    case 8727:
    AugmentationListWnd.UnknownID1 = 808;
    AugmentationListWnd.UnknownID2 = 968;
    UnkInt4 = a_ItemInfo.ClassID;
    return True;
    case 8756:
    case 8746:
    case 8736:
    case 8726:
    AugmentationListWnd.UnknownID1 = 485;
    AugmentationListWnd.UnknownID2 = 645;
    UnkInt4 = a_ItemInfo.ClassID;
    return True;
    case 8755:
    case 8745:
    case 8735:
    case 8725:
    AugmentationListWnd.UnknownID1 = 324;
    AugmentationListWnd.UnknownID2 = 484;
    UnkInt4 = a_ItemInfo.ClassID;
    return True;
    case 8754:
    case 8744:
    case 8734:
    case 8724:
    AugmentationListWnd.UnknownID1 = 162;
    AugmentationListWnd.UnknownID2 = 323;
    UnkInt4 = a_ItemInfo.ClassID;
    return True;
    case 8753:
    case 8743:
    case 8733:
    case 8723:
    AugmentationListWnd.UnknownID1 = 0;
    AugmentationListWnd.UnknownID2 = 161;
    UnkInt4 = a_ItemInfo.ClassID;
    return True;
    default:
  }
  return False;
}

function bool ValidGemstoneCount (ItemInfo a_ItemInfo)
{
  if ( (a_ItemInfo.ItemType == 0) && (a_ItemInfo.CrystalType > 1) )
  {
    if ( a_ItemInfo.RefineryOp2 != 0 )
    {
      SomethignWithAugmentResulttt(a_ItemInfo.RefineryOp1,a_ItemInfo.RefineryOp2);
    } else {
      SeemsSetAugmentResultsDefaults();
    }
    switch (a_ItemInfo.CrystalType)
    {
      case 2:
      case 3:
      UnkInt5 = 2130;
      a_GemStoneCount = 20;
      return True;
      case 4:
      case 5:
      UnkInt5 = 2131;
      a_GemStoneCount = 25;
      return True;
      default:
    }
    return False;
  }
}

function SomethignWithAugmentResulttt (int Option1, int Option2)
{
  local int UnkStrQQ;
  local string strDesc1;
  local string strDesc2;
  local string strDesc3;
  local Color TextColor;

  SeemsSetAugmentResultsDefaults();
  MaybeGetAugmentQualityColor(Class'UIDATA_REFINERYOPTION'.static.GetQuality(Option2),TextColor);
  if ( Option2 < 14561 )
  {
    Class'UIDATA_REFINERYOPTION'.static.GetOptionDescription(Option2,strDesc1,strDesc2,strDesc3);
    if ( Len(strDesc1) != 0 )
    {
      Class'UIAPI_TEXTBOX'.static.SetText("AugmentationWnd.Result" $ string(UnkStrQQ),strDesc1);
      Class'UIAPI_TEXTBOX'.static.SetTextColor("AugmentationWnd.Result" $ string(UnkStrQQ),TextColor);
      UnkStrQQ++;
    }
    if ( Len(strDesc2) != 0 )
    {
      Class'UIAPI_TEXTBOX'.static.SetText("AugmentationWnd.Result" $ string(UnkStrQQ),strDesc2);
      Class'UIAPI_TEXTBOX'.static.SetTextColor("AugmentationWnd.Result" $ string(UnkStrQQ),TextColor);
      UnkStrQQ++;
    }
    if ( Len(strDesc3) != 0 )
    {
      Class'UIAPI_TEXTBOX'.static.SetText("AugmentationWnd.Result" $ string(UnkStrQQ),strDesc3);
      Class'UIAPI_TEXTBOX'.static.SetTextColor("AugmentationWnd.Result" $ string(UnkStrQQ),TextColor);
      UnkStrQQ++;
    }
    Class'UIDATA_REFINERYOPTION'.static.GetOptionDescription(Option1,strDesc1,strDesc2,strDesc3);
    if ( Len(strDesc1) != 0 )
    {
      Class'UIAPI_TEXTBOX'.static.SetText("AugmentationWnd.Result" $ string(UnkStrQQ),strDesc1);
      Class'UIAPI_TEXTBOX'.static.SetTextColor("AugmentationWnd.Result" $ string(UnkStrQQ),TextColor);
      UnkStrQQ++;
    }
    if ( Len(strDesc2) != 0 )
    {
      Class'UIAPI_TEXTBOX'.static.SetText("AugmentationWnd.Result" $ string(UnkStrQQ),strDesc2);
      Class'UIAPI_TEXTBOX'.static.SetTextColor("AugmentationWnd.Result" $ string(UnkStrQQ),TextColor);
      UnkStrQQ++;
    }
    if ( Len(strDesc3) != 0 )
    {
      Class'UIAPI_TEXTBOX'.static.SetText("AugmentationWnd.Result" $ string(UnkStrQQ),strDesc3);
      Class'UIAPI_TEXTBOX'.static.SetTextColor("AugmentationWnd.Result" $ string(UnkStrQQ),TextColor);
      UnkStrQQ++;
    }
  } else {
    Class'UIDATA_REFINERYOPTION'.static.GetOptionDescription(Option2,strDesc1,strDesc2,strDesc3);
    Class'UIAPI_TEXTBOX'.static.SetText("AugmentationWnd.Result0",strDesc1);
    Class'UIAPI_TEXTBOX'.static.SetTextColor("AugmentationWnd.Result0",TextColor);
  }
}

function SeemsSetAugmentResultsDefaults ()
{
  Class'UIAPI_TEXTBOX'.static.SetText("AugmentationWnd.Result0","");
  Class'UIAPI_TEXTBOX'.static.SetText("AugmentationWnd.Result1","");
  Class'UIAPI_TEXTBOX'.static.SetText("AugmentationWnd.Result2","");
  Class'UIAPI_TEXTBOX'.static.SetText("AugmentationWnd.Result3","");
}

function MaybeGetAugmentQualityColor (int Quality, out Color idx)
{
  switch (Quality)
  {
    case 1:
    idx.R = 187;
    idx.G = 181;
    idx.B = 138;
    break;
    case 2:
    idx.R = 132;
    idx.G = 174;
    idx.B = 216;
    break;
    case 3:
    idx.R = 193;
    idx.G = 112;
    idx.B = 202;
    break;
    case 4:
    idx.R = 225;
    idx.G = 109;
    idx.B = 109;
    break;
    default:
    idx.R = 187;
    idx.G = 181;
    idx.B = 138;
    break;
  }
}

function SeemsHandleItems (string param, optional ItemInfo l_ItemInfo)
{
  local ItemInfo a_ItemInfo;
  local ItemInfo idx;
  local int i;

  if ( l_ItemInfo.ClassID != 0 )
  {
    a_ItemInfo.ClassID = l_ItemInfo.ClassID;
    a_ItemInfo.ItemNum = l_ItemInfo.ItemNum;
  } else {
    ParamToItemInfo(param,a_ItemInfo);
  }
  switch (a_ItemInfo.ClassID)
  {
    case UnkInt5:
    if ( a_ItemInfo.ItemNum > 999 )
    {
      Class'UIAPI_TEXTBOX'.static.SetText("AugmentationWnd.GemstoneItemCounter","999+");
    } else {
      if ( a_ItemInfo.ItemNum < a_GemStoneCount )
      {
        SeemsLikeHandleAugmentAction(1);
      } else {
        Class'UIAPI_TEXTBOX'.static.SetText("AugmentationWnd.GemstoneItemCounter","" $ string(a_ItemInfo.ItemNum));
      }
    }
    break;
    case UnkInt4:
    if ( a_ItemInfo.ItemNum > 999 )
    {
      Class'UIAPI_TEXTBOX'.static.SetText("AugmentationWnd.CatalystItemCounter","999+");
    } else {
      if ( a_ItemInfo.ItemNum == 0 )
      {
        i = InventoryItem.FindItemWithClassID(UnkInt4);
        InventoryItem.GetItem(i,idx);
        if ( idx.ItemNum != 0 )
        {
          a_RefinerItemServerID = idx.ServerID;
          CatalystItem.Clear();
          CatalystItem.AddItem(idx);
          SeemsHandleItems("",idx);
        } else {
          SeemsLikeHandleAugmentAction(2);
        }
      } else {
        Class'UIAPI_TEXTBOX'.static.SetText("AugmentationWnd.CatalystItemCounter","" $ string(a_ItemInfo.ItemNum));
      }
    }
    break;
    default:
  }
}

function SomethingWithGemstone (string param)
{
  local ItemInfo a_ItemInfo;

  ParamToItemInfo(param,a_ItemInfo);
  if ( a_ItemInfo.ClassID == UnkInt5 )
  {
    OnDropItem("GemstoneItem",a_ItemInfo,0,0);
  }
}

function SemsNotifyImposible ()
{
  PlaySound("ItemSound3.Sys_Impossible");
  AddSystemMessage(GetSystemMessage(1960),getColor("SYSTEM"));
}

function OnModifyCurrentTickSliderCtrl (string strID, int iCurrentTick)
{
  AugmentSpeed = 1600 - iCurrentTick * 100;
}
defaultproperties
{
}
