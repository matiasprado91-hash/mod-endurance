//================================================================================
// RecipeShopWnd.
//================================================================================

class RecipeShopWnd extends UICommonAPI;

var int m_BookItemCount;
var int m_ShopItemCount;
var array<int> m_arrBookItem;
var array<int> m_arrShopItem;
var int m_BookType;
var ItemInfo m_HandleItem;
const RECIPESHOP_MAX_ITEM_SELL= 20;

function OnLoad ()
{
  RegisterEvent(850);
  RegisterEvent(860);
  RegisterEvent(870);
  RegisterEvent(1710);
}

function OnClickButton (string strID)
{
  switch (strID)
  {
    case "btnEnd":
    Class'RecipeAPI'.static.RequestRecipeShopManageQuit();
    CloseWindow();
    break;
    case "btnMsg":
    DialogSetEditBoxMaxLength(29);
    DialogShow(DIALOG_OKCancelInput,GetSystemMessage(334));
    DialogSetID(0);
    DialogSetString(Class'UIDATA_PLAYER'.static.GetRecipeShopMsg());
    break;
    case "btnStart":
    StartRecipeShop();
    CloseWindow();
    break;
    case "btnMoveUp":
    HandleMoveUpItem();
    break;
    case "btnMoveDown":
    HandleMoveDownItem();
    break;
    default:
  }
}

function OnEvent (int Event_ID, string param)
{
  local string strPrice;
  local int RecipeID;
  local int CanbeMade;
  local int MakingFee;
  local int Price;
  local InventoryWnd InventoryWnd;

  InventoryWnd = InventoryWnd(GetScript("InventoryWnd"));
  if ( Event_ID == 850 )
  {
    Clear();
    InventoryWnd.LoadItemOrder();
    Class'UIAPI_WINDOW'.static.ShowWindow("RecipeShopWnd");
    Class'UIAPI_WINDOW'.static.SetFocus("RecipeShopWnd");
    ParseInt(param,"Type",m_BookType);
    if ( m_BookType == 1 )
    {
      Class'UIAPI_WINDOW'.static.SetWindowTitle("RecipeShopWnd",1212);
    } else {
      Class'UIAPI_WINDOW'.static.SetWindowTitle("RecipeShopWnd",1213);
    }
  } else {
    if ( Event_ID == 860 )
    {
      ParseInt(param,"RecipeID",RecipeID);
      AddRecipeBookItem(RecipeID);
    } else {
      if ( Event_ID == 870 )
      {
        ParseInt(param,"RecipeID",RecipeID);
        ParseInt(param,"CanbeMade",CanbeMade);
        ParseInt(param,"MakingFee",MakingFee);
        AddRecipeShopItem(RecipeID,CanbeMade,MakingFee);
      } else {
        if ( Event_ID == 1710 )
        {
          if ( DialogIsMine() )
          {
            if ( DialogGetID() == 0 )
            {
              Class'RecipeAPI'.static.RequestRecipeShopMessageSet(DialogGetString());
            } else {
              if ( DialogGetID() == 1 )
              {
                strPrice = DialogGetString();
                if ( Len(strPrice) > 0 )
                {
                  Price = int(strPrice);
                  if ( Price >= 2000000000 )
                  {
                    DialogSetID(2);
                    DialogShow(DIALOG_Warning,GetSystemMessage(1369));
                  } else {
                    m_HandleItem.Price = Price;
                    UpdateShopItem(m_HandleItem);
                  }
                }
                ClearHandleItem();
              }
            }
          }
        }
      }
    }
  }
}

function OnSendPacketWhenHiding ()
{
  Class'RecipeAPI'.static.RequestRecipeShopManageQuit();
  Clear();
}

function CloseWindow ()
{
  Clear();
  Class'UIAPI_WINDOW'.static.HideWindow("RecipeShopWnd");
  PlayConsoleSound(IFST_WINDOW_CLOSE);
}

function OnDBClickItem (string strID, int index)
{
  local int Max;
  local int i;
  local ItemInfo infItem;
  local ItemInfo DeleteItem;

  ClearHandleItem();
  if ( (strID == "BookItemWnd") && (m_BookItemCount > index) )
  {
    Class'UIAPI_ITEMWINDOW'.static.GetItem("RecipeShopWnd.BookItemWnd",index,infItem);
    Max = Class'UIAPI_ITEMWINDOW'.static.GetItemNum("RecipeShopWnd.ShopItemWnd");
    i = 0;
	JL0099:
    if ( i < Max )
    {
      if ( Class'UIAPI_ITEMWINDOW'.static.GetItem("RecipeShopWnd.ShopItemWnd",i,DeleteItem) )
      {
        if ( DeleteItem.ClassID == infItem.ClassID )
        {
          DeleteShopItem(infItem);
          return;
        }
      }
      i++;
      goto JL0099;
    }
    Class'UIAPI_ITEMWINDOW'.static.GetItem("RecipeShopWnd.BookItemWnd",index,infItem);
    ShowShopItemAddDialog(infItem);
  } else {
    if ( (strID == "ShopItemWnd") && (m_ShopItemCount > index) )
    {
      Class'UIAPI_ITEMWINDOW'.static.GetItem("RecipeShopWnd.ShopItemWnd",index,infItem);
      DeleteShopItem(infItem);
    }
  }
}

function OnDropItem (string strID, ItemInfo infItem, int X, int Y)
{
  if ( strID == "BookItemWnd" )
  {
    if ( infItem.DragSrcName == "ShopItemWnd" )
    {
      DeleteShopItem(infItem);
    }
  } else {
    if ( strID == "ShopItemWnd" )
    {
      if ( infItem.DragSrcName == "BookItemWnd" )
      {
        ShowShopItemAddDialog(infItem);
      }
    }
  }
}

function Clear ()
{
  ClearHandleItem();
  m_BookItemCount = 0;
  m_ShopItemCount = 0;
  UpdateShopItemCount(0);
  m_arrBookItem.Remove (0,m_arrBookItem.Length);
  m_arrShopItem.Remove (0,m_arrShopItem.Length);
  Class'UIAPI_ITEMWINDOW'.static.Clear("RecipeShopWnd.BookItemWnd");
  Class'UIAPI_ITEMWINDOW'.static.Clear("RecipeShopWnd.ShopItemWnd");
}

function ClearHandleItem ()
{
  local ItemInfo ItemClear;

  m_HandleItem = ItemClear;
}

function AddRecipeBookItem (int RecipeID)
{
  local ItemInfo infItem;
  local int ProductID;
  local int index;

  ProductID = Class'UIDATA_RECIPE'.static.GetRecipeProductID(RecipeID);
  index = Class'UIDATA_RECIPE'.static.GetRecipeIndex(RecipeID);
  infItem.ClassID = Class'UIDATA_RECIPE'.static.GetRecipeClassID(RecipeID);
  infItem.Level = Class'UIDATA_RECIPE'.static.GetRecipeLevel(RecipeID);
  infItem.ServerID = Class'UIDATA_RECIPE'.static.GetRecipeIndex(RecipeID);
  infItem.Name = Class'UIDATA_ITEM'.static.GetItemName(infItem.ClassID);
  infItem.Description = Class'UIDATA_ITEM'.static.GetItemDescription(infItem.ClassID);
  infItem.Weight = Class'UIDATA_ITEM'.static.GetItemWeight(infItem.ClassID);
  infItem.IconName = Class'UIDATA_ITEM'.static.GetItemTextureName(ProductID);
  infItem.CrystalType = Class'UIDATA_RECIPE'.static.GetRecipeCrystalType(RecipeID);
  Class'UIAPI_ITEMWINDOW'.static.AddItem("RecipeShopWnd.BookItemWnd",infItem);
  
  m_arrBookItem.Insert(m_arrBookItem.Length, 1);
  m_arrBookItem[m_arrBookItem.Length -1 ] = Index;
  m_BookItemCount++;
}

function AddRecipeShopItem (int RecipeID, int CanbeMade, int MakingFee)
{
  local ItemInfo infItem;
  local int ProductID;
  local int index;

  ProductID = Class'UIDATA_RECIPE'.static.GetRecipeProductID(RecipeID);
  index = Class'UIDATA_RECIPE'.static.GetRecipeIndex(RecipeID);
  infItem.ClassID = Class'UIDATA_RECIPE'.static.GetRecipeClassID(RecipeID);
  infItem.Level = Class'UIDATA_RECIPE'.static.GetRecipeLevel(RecipeID);
  infItem.ServerID = Class'UIDATA_RECIPE'.static.GetRecipeIndex(RecipeID);
  infItem.Price = MakingFee;
  infItem.Reserved = CanbeMade;
  infItem.Name = Class'UIDATA_ITEM'.static.GetItemName(infItem.ClassID);
  infItem.Description = Class'UIDATA_ITEM'.static.GetItemDescription(infItem.ClassID);
  infItem.Weight = Class'UIDATA_ITEM'.static.GetItemWeight(infItem.ClassID);
  infItem.IconName = Class'UIDATA_ITEM'.static.GetItemTextureName(ProductID);
  infItem.CrystalType = Class'UIDATA_RECIPE'.static.GetRecipeCrystalType(RecipeID);
  Class'UIAPI_ITEMWINDOW'.static.AddItem("RecipeShopWnd.ShopItemWnd",infItem);
  
  m_arrShopItem.Insert(m_arrShopItem.Length, 1);
  m_arrShopItem[m_arrShopItem.Length-1] = Index;
  
  m_ShopItemCount++;
  UpdateShopItemCount(m_ShopItemCount);
}

function ShowShopItemAddDialog (ItemInfo AddItem)
{
  m_HandleItem = AddItem;
  DialogSetID(1);
  DialogSetParamInt(-1);
  DialogSetDefaultOK();
  DialogShow(DIALOG_NumberPad,GetSystemMessage(963));
}

function UpdateShopItem (ItemInfo AddItem)
{
  local int i;
  local int Max;
  local ItemInfo infItem;
  local bool bDuplicated;

  bDuplicated = False;
  Max = Class'UIAPI_ITEMWINDOW'.static.GetItemNum("RecipeShopWnd.ShopItemWnd");
  i = 0;
  JL003F:
  if ( i < Max )
  {
    if ( Class'UIAPI_ITEMWINDOW'.static.GetItem("RecipeShopWnd.ShopItemWnd",i,infItem) )
    {
      if ( AddItem.ClassID == infItem.ClassID )
      {
        bDuplicated = True;
      } else {
        i++;
        goto JL003F;
      }
    }
  }
  if (  !bDuplicated )
  {
    Class'UIAPI_ITEMWINDOW'.static.AddItem("RecipeShopWnd.ShopItemWnd",AddItem);
    m_ShopItemCount++;
    UpdateShopItemCount(m_ShopItemCount);
  }
}

function DeleteShopItem (ItemInfo DeleteItem)
{
  local int i;
  local int Max;
  local ItemInfo infItem;

  Max = Class'UIAPI_ITEMWINDOW'.static.GetItemNum("RecipeShopWnd.ShopItemWnd");
  i = 0;
  JL0037:
  if ( i < Max )
  {
    if ( Class'UIAPI_ITEMWINDOW'.static.GetItem("RecipeShopWnd.ShopItemWnd",i,infItem) )
    {
      if ( DeleteItem.ClassID == infItem.ClassID )
      {
        Class'UIAPI_ITEMWINDOW'.static.DeleteItem("RecipeShopWnd.ShopItemWnd",i);
        m_ShopItemCount--;
        UpdateShopItemCount(m_ShopItemCount);
      } else {
        i++;
        goto JL0037;
      }
    }
  }
}

function UpdateShopItemCount (int Count)
{
  Class'UIAPI_TEXTBOX'.static.SetText("RecipeShopWnd.txtCount","(" $ string(Count) $ "/" $ string(20) $ ")");
}

function StartRecipeShop ()
{
  local int i;
  local int Max;
  local ItemInfo infItem;
  local string param;
  local int ServerID;
  local int Price;

  Max = Class'UIAPI_ITEMWINDOW'.static.GetItemNum("RecipeShopWnd.ShopItemWnd");
  ParamAdd(param,"Max",string(Max));
  i = 0;
  JL004E:
  if ( i < Max )
  {
    ServerID = 0;
    Price = 0;
    if ( Class'UIAPI_ITEMWINDOW'.static.GetItem("RecipeShopWnd.ShopItemWnd",i,infItem) )
    {
      ServerID = infItem.ServerID;
      Price = infItem.Price;
    }
    ParamAdd(param,"ServerID_" $ string(i),string(ServerID));
    ParamAdd(param,"Price_" $ string(i),string(Price));
    i++;
    goto JL004E;
  }
  Class'RecipeAPI'.static.RequestRecipeShopListSet(param);
}

function HandleMoveUpItem ()
{
  local ItemInfo infItem;

  if ( Class'UIAPI_ITEMWINDOW'.static.GetSelectedItem("RecipeShopWnd.ShopItemWnd",infItem) )
  {
    DeleteShopItem(infItem);
  }
}

function HandleMoveDownItem ()
{
  local ItemInfo infItem;

  if ( Class'UIAPI_ITEMWINDOW'.static.GetSelectedItem("RecipeShopWnd.BookItemWnd",infItem) )
  {
    ShowShopItemAddDialog(infItem);
  }
}
defaultproperties
{
}
