class ManorShopWnd extends ShopWnd;

function OnLoad()
{
	registerEvent( EV_ManorShopWndOpen );
	registerEvent( EV_ManorShopWndAddItem );
	registerEvent( EV_DialogOK );
}

function OnEvent(int Event_ID,string param)
{
	switch( Event_ID )
	{
	case EV_ManorShopWndOpen:
		HandleOpenWindow(param);
		break;
	case EV_ManorShopWndAddItem:
		HandleAddItem(param);
		break;
	case EV_DialogOK:
		HandleDialogOK();
		break;
	default:
		break;
	}
}

function MoveItemTopToBottom( int index, bool bAllItem )
{
	local int bottomIndex;
	local ItemInfo info, bottomInfo;
	if( class'UIAPI_ITEMWINDOW'.static.GetItem(m_WindowName$".TopList", index, info) )
	{
		// 1?????? ?????? ???????? ???????????? ???????? ??????.
//		debug("info.ConsumeType:"$info.ConsumeType$", ????:"$info.ItemNum);
		if( !bAllItem && IsStackableItem( info.ConsumeType ) && (info.ItemNum!=1) )		// stackable?
		{
			DialogSetID( DIALOG_TOP_TO_BOTTOM );
			DialogSetReservedInt( info.ClassID );
			
			if( m_shopType == ShopSell || m_shopType == ShopBuy )
				DialogSetParamInt( info.ItemNum );
			else
				DialogSetParamInt(-1);

			DialogSetDefaultOK();
			DialogShow( DIALOG_NumberPad, MakeFullSystemMsg( GetSystemMessage(72), info.Name, "" ) );
		}
		else
		{
			info.bShowCount = false;

			if( m_shopType == ShopSell )
			{
				bottomIndex = class'UIAPI_ITEMWINDOW'.static.FindItemWithClassID( m_WindowName$".BottomList", info.ClassID );
				if( bottomIndex >= 0 && IsStackableItem( info.ConsumeType ) )
				{
					class'UIAPI_ITEMWINDOW'.static.GetItem( m_WindowName$".BottomList", bottomIndex, bottomInfo );
					bottomInfo.ItemNum += info.ItemNum;
					class'UIAPI_ITEMWINDOW'.static.SetItem( m_WindowName$".BottomList", bottomIndex, bottomInfo);
				}
				else
				{
					class'UIAPI_ITEMWINDOW'.static.AddItem( m_WindowName$".BottomList", info );
				}
				class'UIAPI_ITEMWINDOW'.static.DeleteItem( m_WindowName$".TopList", index );		// ?????? ?? ???? ?????? ???????? ???????? ???????? ????
			}
			else if( m_shopType == ShopBuy )												// ???? ???? ???????? ???????? ???? ????.
			{
				bottomIndex = class'UIAPI_ITEMWINDOW'.static.FindItemWithClassID( m_WindowName$".BottomList", info.ClassID );
				if( bottomIndex >= 0 && IsStackableItem( info.ConsumeType ) )
				{
					class'UIAPI_ITEMWINDOW'.static.GetItem( m_WindowName$".BottomList", bottomIndex, bottomInfo );
					bottomInfo.ItemNum += info.ItemNum;
					class'UIAPI_ITEMWINDOW'.static.SetItem( m_WindowName$".BottomList", bottomIndex, bottomInfo);
				}
				else
				{
					class'UIAPI_ITEMWINDOW'.static.AddItem( m_WindowName$".BottomList", info );
					class'UIAPI_INVENWEIGHT'.static.AddWeight( m_WindowName$".InvenWeight", info.Weight * info.ItemNum );
				}
				
				if(bAllItem)
				{
					class'UIAPI_ITEMWINDOW'.static.DeleteItem( m_WindowName$".TopList", index );		// ?????? ???????????? ???? ???? ???????? ???????? ?????? ????.
				}
			}
			else if( m_shopType == ShopPreview)	//????????
			{
				bottomIndex = class'UIAPI_ITEMWINDOW'.static.FindItemWithClassID( m_WindowName$".BottomList", info.ClassID );
				info.ItemNum = 1;
				class'UIAPI_ITEMWINDOW'.static.AddItem( m_WindowName$".BottomList", info );				
			}
			AddPrice(Int64Mul(info.Price, info.ItemNum));

		}
	}
}


function HandleOpenWindow( string param )
{

	Super.HandleOpenWindow(param);

	// ???? ?????? ???? - lancelot 2006. 11. 1.
	class'UIAPI_WINDOW'.static.SetWindowTitle(m_WindowName, 738);
	class'UIAPI_WINDOW'.static.SetTooltipType(  m_WindowName$".TopList", "InventoryPrice1HideEnchant");
}

function HandleAddItem( string param )
{
	local ItemInfo info;

	ParamToItemInfo( param, info );
	info.bShowCount=false;
	class'UIAPI_ITEMWINDOW'.static.AddItem( m_WindowName$".TopList", info );
}

function HandleOKButton()
{
	local string	param;
	local int		topCount, bottomCount, topIndex, bottomIndex;
	local ItemInfo	topInfo, bottomInfo;
	local int		limitedItemCount;

	bottomCount = class'UIAPI_ITEMWINDOW'.static.GetItemNum( m_WindowName$".BottomList" );
//	debug("ShopWnd m_shopType:" $ m_shopType $ ", bottomCount:" $ bottomCount);
	if( m_shopType == ShopBuy )
	{
		// limited item check
		topCount = class'UIAPI_ITEMWINDOW'.static.GetItemNum( m_WindowName$".TopList" );
		for( topIndex=0 ; topIndex < topCount ; ++topIndex )
		{
			class'UIAPI_ITEMWINDOW'.static.GetItem( m_WindowName$".TopList", topIndex, topInfo );
			if(	topInfo.ItemNum > 0 )		// this item can be purchased only by limited number
			{
				limitedItemCount = 0;
				// search in BottomList for same classID
				bottomCount = class'UIAPI_ITEMWINDOW'.static.GetItemNum( m_WindowName$".BottomList" );
				for( bottomIndex=0; bottomIndex < bottomCount ; ++bottomIndex )		// match found, then check whether the number exceeds limited number
				{
					class'UIAPI_ITEMWINDOW'.static.GetItem( m_WindowName$".BottomList", bottomIndex, bottomInfo );
					if( bottomInfo.ClassID == topInfo.ClassID )
						limitedItemCount += bottomInfo.ItemNum;
				}

				//debug("limited Item count " $ limitedItemCount );
				if( limitedItemCount > topInfo.ItemNum )
				{
					// warning dialog
					DialogShow( DIALOG_WARNING, GetSystemMessage(1338) );
					return;
				}
			}
		}
		// pack every item in BottomList
		ParamAdd( param, "merchant", string(m_merchantID) );
		ParamAdd( param, "num", string(bottomCount) );
		for( bottomIndex=0 ; bottomIndex < bottomCount; ++bottomIndex )
		{
			class'UIAPI_ITEMWINDOW'.static.GetItem( m_WindowName$".BottomList", bottomIndex, bottomInfo );
			ParamAdd( param, "classID" $ bottomIndex, string(bottomInfo.ClassID) );
			ParamAdd( Param, "count" $ bottomIndex, string(bottomInfo.ItemNum) );
		}
		RequestBuySeed( param );
	}
	else if( m_shopType == ShopSell )
	{
		// pack every item in BottomList
		ParamAdd( param, "merchant", string(m_merchantID) );
		ParamAdd( param, "num", string(bottomCount) );
		for( bottomIndex=0 ; bottomIndex < bottomCount; ++bottomIndex )
		{
			class'UIAPI_ITEMWINDOW'.static.GetItem( m_WindowName$".BottomList", bottomIndex, bottomInfo );
			ParamAdd( param, "serverID" $ bottomIndex, string(bottomInfo.ServerID) );
			ParamAdd( param, "classID" $ bottomIndex, string(bottomInfo.ClassID) );
			ParamAdd( Param, "count" $ bottomIndex, string(bottomInfo.ItemNum) );
		}

		// ?????????? SELL ?? ?????? ???? ???????? ?????? ?????????? - lancelot 2006. 11. 1.
		RequestProcureCrop( param );
	}
	else if( m_shopType == ShopPreview )
	{
		if( bottomCount > 0 )
		{
			DialogSetID( DIALOG_PREVIEW );
			DialogShow( DIALOG_Warning, GetSystemMessage(1157) );
		}
	}


	HideWindow(m_WindowName);
}


// Decompiled with UE Explorer.
defaultproperties
{
    m_WindowName="ManorShopWnd"
}
