class MultiSellWnd extends UICommonAPI;

const MULTISELLWND_DIALOG_OK=1122;

struct NeededItem
{
	var int ID;
	var	string Name;
	var int Count;
	var string IconName;
	var string AdditionalName;
	var int Enchant;
	var int CrystalType;
	var int ItemType;
	var int RefineryOp1;
	var int RefineryOp2;
};

struct ItemList
{
	var int MultiSellType;
	var int NeededItemNum;
	var array< ItemInfo > ItemInfoList;
	var array< NeededItem > NeededItemList;
};

var array< ItemList >	m_itemLIst;
var int					m_shopID;
var int		pre_itemList;
var int lastFalseItem;
var int GlobalAvailable;
var ButtonHandle MultiSell_Up_Button;
var ButtonHandle MultiSell_Down_Button;
var ButtonHandle MultiSell_Input_Button;
var EditBoxHandle ItemCount_EditBox;
var EditBoxHandle Search_EditBox;

var ItemWindowHandle MultisellTabTotalWnd_ItemWindow;

function OnLoad()
{
	registerEvent( EV_MultiSellShopID );
	registerEvent( EV_MultiSellItemList );
	registerEvent( EV_MultiSellNeededItemList );
	registerEvent( EV_MultiSellItemListEnd );
	registerEvent( EV_DialogOK );
	pre_itemList = -1;
	MultisellTabTotalWnd_ItemWindow = xxGetItemWindowHandle("MultiSellWnd.ItemList");
	MultiSell_Up_Button = xxGetButtonHandle("MultiSellWnd.MultiSell_Up_Button");
	MultiSell_Down_Button = xxGetButtonHandle("MultiSellWnd.MultiSell_Down_Button");
	MultiSell_Input_Button = xxGetButtonHandle("MultiSellWnd.MultiSell_Input_Button");
	ItemCount_EditBox = xxGetEditBoxHandle("MultiSellWnd.ItemCountEdit");
	Search_EditBox = xxGetEditBoxHandle("MultiSellWnd.Search_EditBox");
	
	
}




function fildAndShowItemList(string searchStr)
{
	local ItemInfo Info;
	local int i;
	local string fullNameString;
  
	TreeClear("MultiSellWnd.ItemListInfo");
	MultisellTabTotalWnd_ItemWindow.Clear();
	
	iniListWithItemWindow();
	i = 0;
J0x4C:
  
	  // End:0x1BD [Loop If]
	if( i < m_itemLIst.Length )
	{
		Info = m_itemLIst[i].ItemInfoList[0];
		fullNameString = GetItemNameAll(Info);
		  // End:0x1B3
		if( (findMatchString(fullNameString, searchStr)) != -1 )
		{
			MultisellTabTotalWnd_ItemWindow.AddItem(Info);
			
			  // End:0x1B3
	
		}
		++i;
		  // [Loop Continue]
		goto J0x4C;
	}
	return;
}




function OnEvent(int Event_ID, string param)
{
	switch( Event_ID )
	{
		case EV_MultiSellShopID:
			HandleShopID( param );
			break;
		case EV_MultiSellItemList:
			HandleItemList( param );
			break;
		case EV_MultiSellNeededItemList:
			HandleNeededItemList( param );
			break;
		case EV_MultiSellItemListEnd:
			HandleItemListEnd( param );
			break;
		case EV_DialogOK:
			HandleDialogOK();
			break;
		default:
			break;
	};
}

function OnShow()
{
	class'UIAPI_EDITBOX'.static.Clear("MultiSellWnd.ItemCountEdit");
	lastFalseItem = -1;
	ItemCount_EditBox.SetString("1");
	Search_EditBox.SetString("");
	GlobalAvailable = 0;
}

function OnHide()
{
}

function OnClickButton( string ControlName )
{
	if( ControlName == "OKButton" )
	{
		HandleOKButton();
	}
	else if( ControlName == "CancelButton" )
	{
		Clear();
		HideWindow("MultiSellWnd");
	}
	
	else if( ControlName == "Search_Button" )
	{
		OnSearch_ButtonClick();
	}
	else if( ControlName == "Refresh_Button" )
	{
		OnRefresh_ButtonClick();
	}
	
	else if( ControlName == "Clear_Button" )
	{
		OnClear_ButtonClick();
	}
	
	else if( ControlName == "MultiSell_Up_Button" )
	{
		OnMultiSell_Up_ButtonClick();
	}
	else if( ControlName == "MultiSell_Down_Button" )
	{
		OnMultiSell_Down_ButtonClick();
	}

}

function iniListWithItemWindow()
{
	ItemCount_EditBox.SetString("1");
	TreeClear("MultiSellWnd.NeededItem");
	TreeClear("MultiSellWnd.ItemInfo");

	return;
}




function OnClear_ButtonClick()
{
	ItemCount_EditBox.SetString("1");

	return;
}

function OnSearch_ButtonClick()
{
	local string searchStr;
  
	searchStr = Search_EditBox.GetString();
	fildAndShowItemList(searchStr);
	return;
}
  
function OnRefresh_ButtonClick()
{
	ItemCount_EditBox.SetString("1");
	Search_EditBox.SetString("");
	fildAndShowItemList("");
	return;
}
  

  
function OnMultiSell_Up_ButtonClick()
{
	local string numStr;
	local int Count;
  
	numStr = ItemCount_EditBox.GetString();
	Count = int(numStr);
	Count++;
		  // End:0x52
		if( Count > 9999 )
		{
			Count = 9999;
		}
		ItemCount_EditBox.SetString(string(Count));
	
	
	
}
  
function OnMultiSell_Down_ButtonClick()
{
	local string numStr;
	local int Count;
  
	numStr = ItemCount_EditBox.GetString();
	Count = int(numStr);
	  // End:0x50
	if( Count > 1 )
	{
		Count--;
		ItemCount_EditBox.SetString(string(Count));
		
	}
	return;
}


function OnClickItem( String strID, int index )			// ItemWindow
{
	local int i;
	local string param;
	
	class'UIAPI_MULTISELLITEMINFO'.static.Clear("MultiSellWnd.ItemInfo");
	class'UIAPI_MULTISELLNEEDEDITEM'.static.Clear("MultiSellWnd.NeededItem");
	//debug("OnClickItem : " $ strID $ ", index : " $ index );
	if( strID == "ItemList" )
	{
		if( index >= 0 && index < m_itemList.Length )
		{
			for( i = 0 ; i < m_itemList[index].NeededItemList.Length ;++i )
			{
				param = "";
				ParamAdd( param, "Name", m_itemList[index].NeededItemList[i].Name );
				ParamAdd( param, "ID", string(m_itemList[index].NeededItemList[i].ID ));
				ParamAdd( param, "Num", string(m_itemList[index].NeededItemList[i].Count ));
				ParamAdd( param, "Icon", m_itemList[index].NeededItemList[i].IconName );
				ParamAdd( param, "Enchant", string(m_itemList[index].NeededItemList[i].Enchant) );
				ParamAdd( param, "CrystalType", string(m_itemList[index].NeededItemList[i].CrystalType) );
				ParamAdd( param, "ItemType", string(m_itemList[index].NeededItemList[i].ItemType) );

				//debug("AddData " $ param );
				class'UIAPI_MULTISELLNEEDEDITEM'.static.AddData("MultiSellWnd.NeededItem", param);
			}

			for( i = 0 ; i < m_itemList[index].NeededItemNum ;++i )
			{
				class'UIAPI_MULTISELLITEMINFO'.static.SetItemInfo("MultiSellWnd.ItemInfo", i, m_itemList[index].ItemInfoList[i] );
			}

			class'UIAPI_EDITBOX'.static.Clear("MultiSellWnd.ItemCountEdit");
			
			if( m_itemList[index].MultiSellType == 0 )
			{
				class'UIAPI_EDITBOX'.static.SetString("MultiSellWnd.ItemCountEdit", "1");
				class'UIAPI_WINDOW'.static.DisableWindow("MultiSellWnd.ItemCountEdit");
			}
			else if( m_itemList[index].MultiSellType == 1 )
			{
				class'UIAPI_EDITBOX'.static.SetString("MultiSellWnd.ItemCountEdit", "1");
				class'UIAPI_WINDOW'.static.EnableWindow("MultiSellWnd.ItemCountEdit");
			}
			
			if( pre_itemList != index )	//?????????????????? ????????????. - innowind
			{
				if( DialogIsMine() )
				{
					DialogHide();
				}
			}
		}
	}

	//Print();
}

function Print()
{
	local int i,j;
	for( i = 0; i < m_ItemList.Length ;++i )
	{
		for( j = 0 ; j < m_ItemList[i].NeededItemList.Length ;++j )
		{
			debug("Print ("$i$","$j$"), "$m_ItemList[i].NeededItemList[j].Name);
		}
	}
}

function setEditStateItemCount()
{
	ItemCount_EditBox.SetString("1");
	return;
}


function HandleShopID( string param )
{
	Clear();
	ParseInt( param, "shopID", m_shopID );
}

function Clear()
{
	m_itemList.Length = 0;
	class'UIAPI_MULTISELLITEMINFO'.static.Clear("MultiSellWnd.ItemInfo");
	class'UIAPI_MULTISELLNEEDEDITEM'.static.Clear("MultiSellWnd.NeededItem");
	class'UIAPI_ITEMWINDOW'.static.Clear("MultiSellWnd.ItemList");
}

function HandleItemList( string param )
{
	local ItemInfo info;
	local int index, type, i, classID;
	local bool bMatchFound;

	ParseInt( param, "classID", classID );
	class'UIDATA_ITEM'.static.GetItemInfo( classID, info );

	info.ClassID = classID;
	ParseInt( param, "index", index );
	ParseInt( param, "type", type );
	ParseInt( param, "ID", info.Reserved );
	ParseInt( param, "slotBitType", info.SlotBitType );
	ParseInt( param, "itemType", info.ItemType );
	ParseInt( param, "itemCount", info.ItemNum );
	ParseInt( param, "OutputRefineryOp1", info.RefineryOp1 );
	ParseInt( param, "OutputRefineryOp2", info.RefineryOp2 );

	// ??????????????? ?????? ?????????, 100% Durability??? ???????????? ????????? - NeverDie
	if( 0 < info.Durability )
		info.CurrentDurability = info.Durability;

	//debug("HandleItemList classID : " $ classID $ ", index : " $ index $ ", type : " $ type $ ", ID : " $ info.Reserved $ ", m_itemList.Length : " $ m_itemList.Length );
	
	if( index == 0 )			// ????????? ???????????? ????????????
	{
		i = m_itemList.Length;
		m_itemList.Length = i + 1;
		m_itemList[i].MultiSellType = type;
		m_itemList[i].NeededItemNum = 1;
		m_itemList[i].ItemInfoList.Length = index + 1;
		m_itemList[i].ItemInfoList[index] = info;
	}
	else if( index > 0 )			// index??? 0?????? ????????? ?????? ?????? ID??? ?????? ???????????? ?????? ????????? ???.
	{
		bMatchFound = False;
		// Find matching item with ID
		for( i = m_itemList.Length - 1; i >= 0 ;--i )
		{
			if( m_itemList[i].ItemInfoList[0].Reserved == info.Reserved
				&& m_itemList[i].ItemInfoList[0].RefineryOp1 == info.RefineryOp1
				&& m_itemList[i].ItemInfoList[0].RefineryOp2 == info.RefineryOp2 )
			{
				bMatchFound = True;
				break;
			}
		}

		if( bMatchFound )
		{
			if( m_itemList[i].ItemInfoList.Length <= index )
				m_itemList[i].ItemInfoList.Length = index + 1;

			m_itemList[i].MultiSellType = type;
			m_itemList[i].ItemInfoList[index] = info;
			++m_ItemList[i].NeededItemNum;
		}
		else
		{
			debug("MultiSellWnd Error!!");			// ?????? ??????.
		}
	}
}




function HandleNeededItemList(string param)
{
	local NeededItem item;
	local ItemInfo Info;
	local int i, Id, Index, RefineryOp1, RefineryOp2;
  
	ParseInt(param, "ID", Id);
	ParseInt(param, "refineryOp1", RefineryOp1);
	ParseInt(param, "refineryOp2", RefineryOp2);
	ParseInt(param, "ClassID", item.Id);
	ParseInt(param, "count", item.Count);
	ParseInt(param, "enchant", item.Enchant);
	ParseInt(param, "inputRefineryOp1", item.RefineryOp1);
	ParseInt(param, "inputRefineryOp2", item.RefineryOp2);
	ParseString(param, "AdditionalName", item.AdditionalName);
	  // End:0x19A
	if( item.Id == -100 )
	{
		item.Name = GetSystemString(1277);
		item.IconName = "icon.etc_i.etc_pccafe_point_i00";
		item.Enchant = 0;
		item.ItemType = -1;
		item.Id = 0;        
	}
	else
	{
		  // End:0x220
		if( item.Id == -200 )
		{
			item.Name = GetSystemString(1311);
			item.IconName = "icon.etc_i.etc_bloodpledge_point_i00";
			item.Enchant = 0;
			item.ItemType = -1;
			item.Id = 0;            
		}
		else
		{
			item.Name = Class'UIDATA_ITEM'.static.GetItemName(item.Id);
			item.IconName = Class'UIDATA_ITEM'.static.GetItemTextureName(item.Id);
			item.AdditionalName = Class'UIDATA_ITEM'.static.GetItemAdditionalName(item.Id);
		}
	}
	i = m_itemLIst.Length - 1;
J0x29B:
  
	  // End:0x436 [Loop If]
	if( i >= 0 )
	{
		  // End:0x42C
		if( ((m_itemLIst[i].ItemInfoList[0].Reserved == Id) && m_itemLIst[i].ItemInfoList[0].RefineryOp1 == RefineryOp1) && m_itemLIst[i].ItemInfoList[0].RefineryOp2 == RefineryOp2 )
		{
			Info = m_itemLIst[i].ItemInfoList[0];
			Index = m_itemLIst[i].NeededItemList.Length;
			m_itemLIst[i].NeededItemList.Length = Index + 1;
			item.ItemType = Class'UIDATA_ITEM'.static.GetItemDataType(item.Id);
			item.CrystalType = Class'UIDATA_ITEM'.static.GetItemCrystalType(item.Id);
			m_itemLIst[i].NeededItemList[Index] = item;
			  // End:0x3EC
			if( !compareWithInven(item, Info) )
			{
				m_itemLIst[i].ItemInfoList[0].ForeTexture = "";                
			}
			else
			{
				m_itemLIst[i].ItemInfoList[0].ForeTexture = "L2UI_CH3.MultiSellWnd.SellablePanel";
			}
			  // [Explicit Break]
			goto J0x436;
		}
		--i;
		  // [Loop Continue]
		goto J0x29B;
	}
J0x436:
  
	return;
 
}


function bool compareWithInven(NeededItem item, ItemInfo Info)
{
	local ItemInfo InvenItemInfo;
  
	  // End:0x16
	if( lastFalseItem == Info.ClassID )
	{
		return False;
	}
	  // End:0x66
	if( item.Id > 0 )
	{
		GetItemInvInfo(item.Id, InvenItemInfo);
		  // End:0x66
		if( item.Count > 0 )
		{
			  // End:0x66
			if( InvenItemInfo.ItemNum >= item.Count )
			{
				return True;
			}
		}
	}
	lastFalseItem = Info.ClassID;
	return False;
  
}

function GetItemInvInfo(int Id, out ItemInfo Info)
{
	local int Index;
	local ItemInfo item;
	local ItemWindowHandle InvWnd;
  
	InvWnd = ItemWindowHandle(GetHandle("InventoryWnd.InventoryItem"));
	Index = InvWnd.FindItemWithClassID(Id);
	InvWnd.GetItem(Index, item);
	  // End:0x7D
	if( Index > -1 )
	{
		Info = item;        
	}
	else
	{
		Info.ItemNum = 0;
	}
	return;
}
  




function HandleItemListEnd( string param )
{
	local WindowHandle m_inventoryWnd;
	
	m_inventoryWnd = GetHandle( "InventoryWnd" );	//????????????
	
	if( m_inventoryWnd.IsShowWindow() )			//???????????? ?????? ??????????????? ????????????. 
	{
		m_inventoryWnd.HideWindow();
	}	
	
	ShowWindow("MultiSellWnd");
	class'UIAPI_WINDOW'.static.SetFocus("MultiSellWnd");
	ShowItemList();
}

function ShowItemList()
{
	local ItemInfo info;
	local int i;

	for( i = 0 ; i < m_itemList.Length ;++i )
	{
		info = m_itemList[i].ItemInfoList[0];
		class'UIAPI_ITEMWINDOW'.static.AddItem( "MultiSellWnd.ItemList", info );
	}
}

function HandleOKButton()
{
	local int selectedIndex, itemNum;

	selectedIndex = class'UIAPI_ITEMWINDOW'.static.GetSelectedNum("MultiSellWnd.ItemList");
	itemNum = int(class'UIAPI_EDITBOX'.static.GetString("MultiSellWnd.ItemCountEdit"));
	//debug("HandleOKButton selectedIndex: " $ selectedIndex $ ", itemNum: " $ itemNum );
	if( selectedIndex >= 0 )
	{
		DialogSetReservedInt( selectedIndex );
		DialogSetReservedInt2( itemNum );
		DialogSetID( MULTISELLWND_DIALOG_OK );
		DialogShow(DIALOG_Warning, GetSystemMessage(1383));
		pre_itemList = selectedIndex;
	}
}

function HandleDialogOK()
{
	local string param;
	local int SelectedIndex;

	if( DialogIsMine() )
	{
		SelectedIndex = DialogGetReservedInt();

		ParamAdd( param, "ShopID", string(m_shopID) );
		ParamAdd( param, "ItemID", string( m_itemList[SelectedIndex].ItemInfoList[0].Reserved ) );
		ParamAdd( param, "RefineryOp1", string( m_itemList[SelectedIndex].ItemInfoList[0].RefineryOp1 ) );
		ParamAdd( param, "RefineryOp2", string( m_itemList[SelectedIndex].ItemInfoList[0].RefineryOp2 ) );
		ParamAdd( param, "ItemCount", string(DialogGetReservedInt2()) );		

		RequestMultiSellChoose( param );
	}
}
defaultproperties
{
}
