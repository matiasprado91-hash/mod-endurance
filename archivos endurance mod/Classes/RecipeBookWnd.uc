//================================================================================
// RecipeBookWnd.
//================================================================================

class RecipeBookWnd extends UICommonAPI;

var int m_ItemCount;
var array<int> m_arrItem;
var int m_BookType;
var int m_ItemMaxCount_Dwarf;
var int m_ItemMaxCount_Normal;
var int m_DeleteItemID;

function OnLoad ()
{
  RegisterEvent(820);
  RegisterEvent(830);
  RegisterEvent(2070);
  RegisterEvent(1710);
}

function OnEvent (int Event_ID, string param)
{
  local Rect rectWnd;
  local int RecipeAddBookItem;

  if ( Event_ID == 820 )
  {
    Clear();
    rectWnd = Class'UIAPI_WINDOW'.static.GetRect("RecipeManufactureWnd");
    Class'UIAPI_WINDOW'.static.MoveTo("RecipeBookWnd",rectWnd.nX,rectWnd.nY);
    Class'UIAPI_WINDOW'.static.ShowWindow("RecipeBookWnd");
    Class'UIAPI_WINDOW'.static.SetFocus("RecipeBookWnd");
    ParseInt(param,"Type",m_BookType);
    if ( m_BookType == 1 )
    {
      Class'UIAPI_WINDOW'.static.SetWindowTitle("RecipeBookWnd",1214);
    } else {
      Class'UIAPI_WINDOW'.static.SetWindowTitle("RecipeBookWnd",1215);
    }
  } else {
    if ( Event_ID == 830 )
    {
      ParseInt(param,"RecipeID",RecipeAddBookItem);
      AddRecipeBookItem(RecipeAddBookItem);
    } else {
      if ( Event_ID == 2070 )
      {
        ParseInt(param,"recipe",m_ItemMaxCount_Normal);
        ParseInt(param,"dwarvenRecipe",m_ItemMaxCount_Dwarf);
        SetItemCount(m_ItemCount);
      } else {
        if ( Event_ID == 1710 )
        {
          if ( DialogIsMine() )
          {
            Class'RecipeAPI'.static.RequestRecipeItemDelete(m_DeleteItemID);
          }
        }
      }
    }
  }
}

function OnDBClickItem (string strID, int index)
{
  if ( (strID == "RecipeItem") && (m_ItemCount > index) )
  {
    Class'RecipeAPI'.static.RequestRecipeItemMakeInfo(m_arrItem[index]);
  }
}

function OnDropItem (string strID, ItemInfo infItem, int X, int Y)
{
  if ( strID == "btnTrash" )
  {
    DeleteItem(infItem);
  }
}

function OnClickButton (string strID)
{
  local ItemInfo infItem;

  switch (strID)
  {
    case "btnTrash":
    if ( Class'UIAPI_ITEMWINDOW'.static.GetSelectedItem("RecipeBookWnd.RecipeItem",infItem) )
    {
      DeleteItem(infItem);
    }
    break;
    default:
  }
}

function Clear ()
{
  SetItemCount(0);
  m_arrItem.Remove (0,m_arrItem.Length);
  Class'UIAPI_ITEMWINDOW'.static.Clear("RecipeBookWnd.RecipeItem");
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
  infItem.ItemSubType = 5;
  infItem.Name = Class'UIDATA_ITEM'.static.GetItemName(infItem.ClassID);
  infItem.Description = Class'UIDATA_ITEM'.static.GetItemDescription(infItem.ClassID);
  infItem.Weight = Class'UIDATA_ITEM'.static.GetItemWeight(infItem.ClassID);
  infItem.IconName = Class'UIDATA_ITEM'.static.GetItemTextureName(ProductID);
  infItem.CrystalType = Class'UIDATA_RECIPE'.static.GetRecipeCrystalType(RecipeID);
  Class'UIAPI_ITEMWINDOW'.static.AddItem("RecipeBookWnd.RecipeItem",infItem);
  
  m_arrItem.Insert(m_arrItem.Length, 1);
  m_arrItem[m_arrItem.Length-1] = Index;
  m_ItemCount++;
  SetItemCount(m_ItemCount);
}

function SetItemCount (int MaxCount)
{
  local int nTmp;

  m_ItemCount = MaxCount;
  if ( m_BookType == 1 )
  {
    nTmp = m_ItemMaxCount_Normal;
  } else {
    nTmp = m_ItemMaxCount_Dwarf;
  }
  Class'UIAPI_TEXTBOX'.static.SetText("RecipeBookWnd.txtCount","(" $ string(m_ItemCount) $ "/" $ string(nTmp) $ ")");
}

function DeleteItem (ItemInfo infItem)
{
  local string strMsg;

  strMsg = MakeFullSystemMsg(GetSystemMessage(74),infItem.Name,"");
  m_DeleteItemID = infItem.ServerID;
  DialogShow(DIALOG_Warning,strMsg);
}
defaultproperties
{
}
