//================================================================================
// TradeWnd.
//================================================================================

class TradeWnd extends UICommonAPI;

var array<string> tmpParam;
var array<string> tmpParamOther;
var array<string> clearParam;
var ItemWindowHandle InventoryList;
var ItemWindowHandle MyList;
var ItemWindowHandle OtherList;
var WindowHandle Me;
const DELAY_WAIT= 100;
const TIMER_WAIT2= 29556;
const TIMER_WAIT= 29555;
const DIALOG_ID_ITEM_NUMBER= 1;
const DIALOG_ID_TRADE_REQUEST= 0;

function OnLoad ()
{
  RegisterEvent(99998);
  RegisterEvent(99999);
  RegisterEvent(1710);
  RegisterEvent(1720);
  RegisterEvent(1950);
  RegisterEvent(1960);
  RegisterEvent(1970);
  RegisterEvent(1980);
  RegisterEvent(1990);
  RegisterEvent(2000);
  Me = xxGetWindowHandle("TradeWnd");
  InventoryList = xxGetItemWindowHandle("TradeWnd.InventoryList");
  MyList = xxGetItemWindowHandle("TradeWnd.MyList");
  OtherList = xxGetItemWindowHandle("TradeWnd.OtherList");
}

function OnSendPacketWhenHiding ()
{
  RequestTradeDone(False);
}

function OnHide ()
{
  Clear();
}

function OnShow ()
{
  Me.SetTimer(29555,100);
}

function OnTimer ( int  val)
{
  if ( val == 29555 )
  {
    setAugmentItens();
    Me.KillTimer(29555);
  } else {
    if ( val == 29556 )
    {
      setAugmentOtherItens();
      Me.KillTimer(29556);
    }
  }
}

function OnEvent (int EventID, string param)
{
  switch (EventID)
  {
    case 99998:
    setAugmentParam(param,tmpParam);
    break;
    case 99999:
    setAugmentParam(param,tmpParamOther);
    break;
    case 1950:
    HandleStartTrade(param);
    break;
    case 1960:
    HandleTradeAddItem(param);
    break;
    case 1970:
    HandleTradeDone(param);
    break;
    case 1980:
    HandleTradeOtherOK(param);
    break;
    case 1990:
    HandleTradeUpdateInventoryItem(param);
    break;
    case 2000:
    HandleReceiveStartTrade(param);
    break;
    case 1710:
    HandleDialogOK();
    break;
    case 1720:
    HandleDialogCancel();
    break;
    default:
    break;
  }
}

function OnClickButton (string ControlName)
{
  if ( ControlName == "OKButton" )
  {
    Class'UIAPI_ITEMWINDOW'.static.SetFaded("TradeWnd.MyList",True);
    RequestTradeDone(True);
  } else {
    if ( ControlName == "CancelButton" )
    {
      RequestTradeDone(False);
    } else {
      if ( ControlName == "MoveButton" )
      {
        HandleMoveButton();
      }
    }
  }
}

function OnDBClickItem (string ControlName, int Index)
{
  local ItemInfo Info;

  if ( ControlName == "InventoryList" )
  {
    if ( Class'UIAPI_ITEMWINDOW'.static.GetItem("TradeWnd.InventoryList",Index,Info) )
    {
      if ( (IsStackableItem(Info.ConsumeType) && (Info.ItemNum != 1)) )
      {
        DialogSetID(1);
        DialogSetReservedInt(Info.ServerID);
        DialogSetParamInt(Info.ItemNum);
        DialogShow(EDialogType(6),MakeFullSystemMsg(GetSystemMessage(72),Info.Name,""));
      } else {
        RequestAddTradeItem(Info.ServerID,1);
      }
    }
  }
}

function OnDropItem (string strID, ItemInfo Info, int X, int Y)
{
  if ( ((strID == "MyList") && (Info.DragSrcName == "InventoryList")) )
  {
    if ( IsStackableItem(Info.ConsumeType) )
    {
      if ( Info.AllItemCount > 0 )
      {
        RequestAddTradeItem(Info.ServerID,Info.AllItemCount);
      } else {
        if ( Info.ItemNum == 1 )
        {
          RequestAddTradeItem(Info.ServerID,1);
        } else {
          DialogSetID(1);
          DialogSetReservedInt(Info.ServerID);
          DialogSetParamInt(Info.ItemNum);
          DialogShow(EDialogType(6),MakeFullSystemMsg(GetSystemMessage(72),Info.Name,""));
        }
      }
    } else {
      RequestAddTradeItem(Info.ServerID,1);
    }
  }
}

function MoveToMyList (int Index, int Num)
{
  local ItemInfo Info;

  if ( Class'UIAPI_ITEMWINDOW'.static.GetItem("TradeWnd.InventoryList",Index,Info) )
  {
    RequestAddTradeItem(Info.ServerID,Num);
  }
}

function HandleMoveButton ()
{
  local int Selected;
  local ItemInfo Info;

  Selected = Class'UIAPI_ITEMWINDOW'.static.GetSelectedNum("TradeWnd.InventoryList");
  if ( Selected >= 0 )
  {
    Class'UIAPI_ITEMWINDOW'.static.GetItem("TradeWnd.InventoryList",Selected,Info);
    if ( Info.ItemNum == 1 )
    {
      MoveToMyList(Selected,1);
    } else {
      DialogSetID(1);
      DialogSetReservedInt(Info.ServerID);
      DialogSetParamInt(Info.ItemNum);
      DialogShow(EDialogType(6),MakeFullSystemMsg(GetSystemMessage(72),Info.Name,""));
    }
  }
}

function HandleStartTrade (string param)
{
  local int targetID;
  local UserInfo targetinfo;
  local string ClanName;
  local WindowHandle m_inventoryWnd;
  local WindowHandle m_warehouseWnd;
  local WindowHandle m_privateShopWnd;
  local WindowHandle m_shopWnd;
  local WindowHandle m_multiSellWnd;

  m_inventoryWnd = GetHandle("InventoryWnd");
  m_warehouseWnd = GetHandle("WarehouseWnd");
  m_privateShopWnd = GetHandle("PrivateShopWnd");
  m_shopWnd = GetHandle("ShopWnd");
  m_multiSellWnd = GetHandle("MultiSellWnd");
  if ( m_inventoryWnd.IsShowWindow() )
  {
    m_inventoryWnd.HideWindow();
  }
  if ( m_warehouseWnd.IsShowWindow() )
  {
    m_warehouseWnd.HideWindow();
  }
  if ( m_privateShopWnd.IsShowWindow() )
  {
    m_privateShopWnd.HideWindow();
  }
  if ( m_shopWnd.IsShowWindow() )
  {
    m_shopWnd.HideWindow();
  }
  if ( m_multiSellWnd.IsShowWindow() )
  {
    m_multiSellWnd.HideWindow();
  }
  Class'UIAPI_WINDOW'.static.ShowWindow("TradeWnd");
  Class'UIAPI_WINDOW'.static.SetFocus("TradeWnd");
  ParseInt(param,"targetId",targetID);
  if ( targetID > 0 )
  {
    GetUserInfo(targetID,targetinfo);
    if ( targetinfo.nClanID > 0 )
    {
      ClanName = GetClanName(targetinfo.nClanID);
      Class'UIAPI_TEXTBOX'.static.SetText("TradeWnd.Targetname",((targetinfo.Name $ " - ") $ ClanName));
    } else {
      Class'UIAPI_TEXTBOX'.static.SetText("TradeWnd.Targetname",targetinfo.Name);
    }
  }
}

function HandleTradeAddItem (string param)
{
  local string strDest;
  local ItemInfo	ItemInfo, tempInfo;
  local int Index;

  ParseString(param,"destination",strDest);
  ParamToItemInfo(param,ItemInfo);
  if ( strDest == "inventoryList" )
  {
    strDest = "TradeWnd.InventoryList";
  } else {
    if ( strDest == "myList" )
    {
      strDest = "TradeWnd.MyList";
      Class'UIAPI_INVENWEIGHT'.static.ReduceWeight("TradeWnd.InvenWeight",(ItemInfo.ItemNum * ItemInfo.Weight));
    } else {
      if ( strDest == "otherList" )
      {
        strDest = "TradeWnd.OtherList";
        Class'UIAPI_INVENWEIGHT'.static.AddWeight("TradeWnd.InvenWeight",(ItemInfo.ItemNum * ItemInfo.Weight));
      }
    }
  }

      ItemInfo.RefineryOp2 = itemInfo.Blessed;
    ItemInfo.RefineryOp1 = itemInfo.Damaged;
  Index = Class'UIAPI_ITEMWINDOW'.static.FindItemWithServerID(strDest,ItemInfo.ServerID);
  if ( Index >=0 )
  {
    if ( IsStackableItem(ItemInfo.ConsumeType) )
    {
      Class'UIAPI_ITEMWINDOW'.static.GetItem(strDest,Index,tempInfo);
      (ItemInfo.ItemNum += tempInfo.ItemNum);
      Class'UIAPI_ITEMWINDOW'.static.SetItem(strDest,Index,ItemInfo);
    }
  } else {
    Class'UIAPI_ITEMWINDOW'.static.AddItem(strDest,ItemInfo);
    if ( strDest !="TradeWnd.InventoryList" )
    {
      Me.SetTimer(29556,100);
    }
  }
}

function HandleTradeDone (string param)
{
  Class'UIAPI_WINDOW'.static.HideWindow("TradeWnd");
}

function HandleTradeOtherOK (string param)
{
  Class'UIAPI_ITEMWINDOW'.static.SetFaded("TradeWnd.OtherList",True);
}

function HandleTradeUpdateInventoryItem (string param)
{
  local ItemInfo Info;
  local string Type;
  local int Index;

  ParseString(param,"type",Type);
  ParamToItemInfo(param,Info);
  if ( Type == "add" )
  {
    Class'UIAPI_ITEMWINDOW'.static.AddItem("TradeWnd.InventoryList",Info);
  } else {
    if ( Type == "update" )
    {
      Index = Class'UIAPI_ITEMWINDOW'.static.FindItemWithServerID("TradeWnd.InventoryList",Info.ServerID);
      if ( Index >= 0 )
      {
        Class'UIAPI_ITEMWINDOW'.static.SetItem("TradeWnd.InventoryList",Index,Info);
      }
    } else {
      if ( Type == "delete" )
      {
        Index = Class'UIAPI_ITEMWINDOW'.static.FindItemWithServerID("TradeWnd.InventoryList",Info.ServerID);
        if ( Index >= 0 )
        {
          Class'UIAPI_ITEMWINDOW'.static.DeleteItem("TradeWnd.InventoryList",Index);
        }
      }
    }
  }
}

function HandleReceiveStartTrade (string param)
{
  local int targetID;
  local UserInfo Info;

  ParseInt(param,"targetID",targetID);
  if ( ((targetID > 0) && GetUserInfo(targetID,Info)) )
  {
    DialogSetID(0);
    DialogSetParamInt((10 * 1000));
    DialogShow(EDialogType(7),MakeFullSystemMsg(GetSystemMessage(100),Info.Name,""));
  }
}

function HandleDialogOK ()
{
  local int ServerID;
  local int Num;

  if ( DialogIsMine() )
  {
    if ( DialogGetID() == 0 )
    {
      AnswerTradeRequest(True);
    } else {
      if ( DialogGetID() == 1 )
      {
        ServerID = DialogGetReservedInt();
        Num = int(DialogGetString());
        RequestAddTradeItem(ServerID,Num);
      }
    }
  }
}

function HandleDialogCancel ()
{
  if ( DialogIsMine() )
  {
    if ( DialogGetID() == 0 )
    {
      AnswerTradeRequest(False);
    }
  }
}

function Clear ()
{
  Class'UIAPI_ITEMWINDOW'.static.Clear("TradeWnd.InventoryList");
  Class'UIAPI_ITEMWINDOW'.static.Clear("TradeWnd.MyList");
  Class'UIAPI_ITEMWINDOW'.static.Clear("TradeWnd.OtherList");
  Class'UIAPI_TEXTBOX'.static.SetText("TradeWnd.TargetName","");
  Class'UIAPI_INVENWEIGHT'.static.ZeroWeight("TradeWnd.InvenWeight");
}

function setAugmentParam (string param, out array<string> tmpLocalParam)
{
  local string ServerID;
  local string refOp1;
  local string refOp2;
  local string tmp;

  ParseString(param,"objId",ServerID);
  ParseString(param,"refinery1",refOp1);
  ParseString(param,"refinery2",refOp2);
  ParamAdd(tmp,"ServerID",ServerID);
  ParamAdd(tmp,"refOp1",refOp1);
  ParamAdd(tmp,"refOp2",refOp2);
  tmpLocalParam[tmpLocalParam.Length] = tmp;
}

function setAugmentItens ()
{
  local int i;
  local int Index;
  local int ServerID;
  local int refOp1;
  local int refOp2;

  i = 0;
  if ( i < tmpParam.Length )
  {
    ParseInt(tmpParam[i],"ServerID",ServerID);
    ParseInt(tmpParam[i],"refOp1",refOp1);
    ParseInt(tmpParam[i],"refOp2",refOp2);
    Index = getItemIndex(InventoryList,ServerID);
    if ( Index < 0 )
    {
      return;
    }
    setRefItem(Index,InventoryList,refOp1,refOp2);
    i++;
    
  }
  tmpParam = clearParam;
}

function setAugmentOtherItens ()
{
  local int i;
  local int Index;
  local int ServerID;
  local int refOp1;
  local int refOp2;

  i = 0;
  if ( i < tmpParamOther.Length )
  {
    ParseInt(tmpParamOther[i],"ServerID",ServerID);
    ParseInt(tmpParamOther[i],"refOp1",refOp1);
    ParseInt(tmpParamOther[i],"refOp2",refOp2);
    Index = getItemIndex(MyList,ServerID);
    if ( Index >= 0 )
    {
      setRefItem(Index,MyList,refOp1,refOp2);
    }
    Index = getItemIndex(OtherList,ServerID);
    if ( Index >= 0 )
    {
      setRefItem(Index,OtherList,refOp1,refOp2);
    }
    i++;
    
  }
  tmpParamOther = clearParam;
}

function setRefItem (int Index, ItemWindowHandle itemBox, int refOp1, int refOp2)
{
  local ItemInfo ItemInfo;

  itemBox.GetItem(Index,ItemInfo);
  ItemInfo.RefineryOp1 = refOp1;
  ItemInfo.RefineryOp2 = refOp2;
  itemBox.SetItem(Index,ItemInfo);
}

function int getItemIndex (ItemWindowHandle itemBox, int ServerID)
{
  local int Index;

  Index = -1;
  Index = itemBox.FindItemWithServerID(ServerID);
  return Index;
}
defaultproperties
{
}
