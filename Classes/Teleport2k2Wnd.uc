//================================================================================
// Teleport2k2Wnd.
//================================================================================

class Teleport2k2Wnd extends UICommonAPI;

var WindowHandle Me;
var TextureHandle zzt_BG;
var int zzi_TownsCount;
var int zzzzi_AreasCount;
var int zzi_QuestAreasCount;
var string zzs_lastBypass;
var array<string> zzs_ClanArea;
var TextBoxHandle zztxtzone;
var TextBoxHandle zztxtQuest;
var TextBoxHandle zzTxtDbClick;
const Teleport2k2Wnd= "Teleport2k2Wnd.";
const zzTREENameQuest= "QuestInfo";
const zzTREENameArea= "HuntingInfo";
const zzTREENameTown= "TownsInfo";

function OnLoad ()
{

	Me = xxGetWindowHandle("Teleport2k2Wnd");
	zzt_BG = xxGetTextureHandle("Teleport2k2Wnd.bgTeleport");
	zztxtzone = xxGetTextBoxHandle("Teleport2k2Wnd.txtzoneName");
	zztxtQuest = xxGetTextBoxHandle("Teleport2k2Wnd.txtHuntingZone");
	zzTxtDbClick = xxGetTextBoxHandle("Teleport2k2Wnd.txtDoubleClick");
	zzi_TownsCount = 0;
	zzzzi_AreasCount = 0;
	zzi_QuestAreasCount = 0;
	HideWindow(("Teleport2k2Wnd."$"QuestInfo"));
}



function OnEnterState (name State)
{
	xxResetTeleport();
}



function xxResetTeleport()
{
	zztxtzone.SetText("Zone Set");
	zztxtQuest.SetText("Teleport Now");
	zzTxtDbClick.SetText("Double Click to Move");
	xxGetWindowHandle("Teleport2k2Wnd.txtHuntingZone2").HideWindow();
	HideWindow(("Teleport2k2Wnd."$"QuestInfo"));

	TreeClear((("Teleport2k2Wnd."$"")$"HuntingInfo"));

	TreeClear((("Teleport2k2Wnd."$"")$"QuestInfo"));
	SetQuestTab(False);
	zzi_TownsCount = 0;
	zzzzi_AreasCount = 0;
	zzi_QuestAreasCount = 0;
	xxHandleLoadTeleport();
}

function OnShow ()
{

	xxResetTeleport();
}

function xxHandleLoadTeleport()
{
	local int zzi;
	local string zzzzt_Name;

	zzi = 1;
J0x07:

    // End:0x8C [Loop If]
	if( zzi < 20 )
	{
        // End:0x82
		if( GetINIString("TownsInfo", string(zzi), zzzzt_Name, "teleport") )
		{
            // End:0x59
			if( zzi_TownsCount == 0 )
			{
				xxfirstTeleport("TownsInfo");
			}
			xxaddTeleport("TownsInfo", zzzzt_Name, string(zzi_TownsCount), zzi_TownsCount);
			zzi_TownsCount++;
		}
		zzi++;
        // [Loop Continue]
		goto J0x07;
	}
	return;
}

function xxHandleTeleportAreas(int zzi_Area)
{
	local int zzi;
	local int zzj;
	local string zzt_Param;
	local string zzt_Name;
	local string zzt_Bypass;
	local string zzt_Level;
	local string zzt_Price;
	local string zzt_Itens;
	local string zzt_Types;
	local array<string> zzs_EventArea;
	local bool zzisEventArea;

	SetQuestTab(False);
	xxGetWindowHandle("Teleport2k2Wnd.txtHuntingZone2").HideWindow();
	zzi = 1;
J0x3B:

    // End:0x27A [Loop If]
	if( zzi < 20 )
	{
		zzisEventArea = False;
        // End:0x270
		if( GetINIString(("HuntingInfo"$"_")$string(zzi_Area), string(zzi), zzt_Param, "teleport") )
		{
            // End:0xEE
			if( zzi_Area == 4 )
			{
				zzj = 0;
			J0x9C:

                // End:0xEE [Loop If]
				if( zzj < zzs_ClanArea.Length )
				{
					zzs_EventArea = xxlista23(zzs_ClanArea[zzj], ",");
                    // End:0xE4
					if( string(zzi) == zzs_EventArea[0] )
					{
						zzisEventArea = True;
                        // [Explicit Break]
						goto J0xEE;
					}
					zzj++;
                    // [Loop Continue]
					goto J0x9C;
				}
			}
		J0xEE:

            // End:0x10C
			if( zzzzi_AreasCount == 0 )
			{
				xxfirstTeleport("HuntingInfo");
			}
			ParseString(zzt_Param, "Name", zzt_Name);
            // End:0x146
			if( !ParseString(zzt_Param, "price", zzt_Price) )
			{
				zzt_Price = "";
			}
            // End:0x16A
			if( !ParseString(zzt_Param, "level", zzt_Level) )
			{
				zzt_Level = "";
			}
            // End:0x18E
			if( !ParseString(zzt_Param, "itens", zzt_Itens) )
			{
				zzt_Itens = "";
			}
            // End:0x1B2
			if( !ParseString(zzt_Param, "types", zzt_Types) )
			{
				zzt_Types = "";
			}
            // End:0x1E6
			if( !ParseString(zzt_Param, "quest", zzt_Bypass) )
			{
				ParseString(zzt_Param, "Bypass", zzt_Bypass);
			}
            // End:0x233
			if( zzisEventArea )
			{
				xxaddTeleport("HuntingInfo", zzt_Name, zzt_Bypass, zzzzi_AreasCount, zzt_Price, zzt_Level, zzt_Itens, zzt_Types, zzs_ClanArea[zzj]);                
			}
			else
			{
				xxaddTeleport("HuntingInfo", zzt_Name, zzt_Bypass, zzzzi_AreasCount, zzt_Price, zzt_Level, zzt_Itens, zzt_Types);
			}
			zzzzi_AreasCount++;
		}
		zzi++;
        // [Loop Continue]
		goto J0x3B;
	}
	return;
}

function xxHandleTeleportQuestAreas(int zzi_Area)
{
	local string zzt_Param;
	local string zzt_Name;
	local string zzt_Bypass;
	local string zzt_Level;
	local string zzt_Price;
	local string zzt_Itens;
	local string zzt_Types;
	local int zzi;
	local string zztmpTabName;

	SetQuestTab(True);
	if ( GetINIString((("QuestInfo"$"_")$string(zzi_Area)),"AreaName",zztmpTabName,"teleport") )
	{
		xxGetTextBoxHandle("Teleport2k2Wnd.txtHuntingZone2").SetText(zztmpTabName);
		xxGetWindowHandle("Teleport2k2Wnd.txtHuntingZone2").ShowWindow();
	} 
	else 
	{
		xxGetWindowHandle("Teleport2k2Wnd.txtHuntingZone2").HideWindow();
	}
	zzi = 1;
J0xD8:

    // End:0x23B [Loop If]
	if( zzi < 20 )
	{
        // End:0x231
		if( GetINIString(("QuestInfo"$"_")$string(zzi_Area), string(zzi), zzt_Param, "teleport") )
		{
            // End:0x138
			if( zzi_QuestAreasCount == 0 )
			{
				xxfirstTeleport("QuestInfo");
			}
			ParseString(zzt_Param, "Name", zzt_Name);
			ParseString(zzt_Param, "Bypass", zzt_Bypass);
            // End:0x18A
			if( !ParseString(zzt_Param, "price", zzt_Price) )
			{
				zzt_Price = "";
			}
            // End:0x1AE
			if( !ParseString(zzt_Param, "level", zzt_Level) )
			{
				zzt_Level = "";
			}
            // End:0x1D2
			if( !ParseString(zzt_Param, "itens", zzt_Itens) )
			{
				zzt_Itens = "";
			}
            // End:0x1F6
			if( !ParseString(zzt_Param, "types", zzt_Types) )
			{
				zzt_Types = "";
			}
			xxaddTeleport("QuestInfo", zzt_Name, zzt_Bypass, zzi_QuestAreasCount, zzt_Price, zzt_Level, zzt_Itens, zzt_Types);
			zzi_QuestAreasCount++;
		}
		zzi++;
        // [Loop Continue]
		goto J0xD8;
	}
	return;
}

function xxfirstTeleport(string zzl_TREEName)
{
	local XMLTreeNodeInfo zzinfNode;
	local string zztmpTREEName;
	local string zzval;
	zztmpTREEName = ("Teleport2k2Wnd."$zzl_TREEName);
	
	TreeClear(zztmpTREEName);
	
	zzinfNode.strName = zzl_TREEName;
	zzinfNode.nOffSetX = 0;
	zzinfNode.nOffSetY = 0;
	zzval = getxml(zztmpTREEName,"",zzinfNode);
}

function xxaddTeleport(string zzl_TREEName, string zzt_Name, string zzt_Bypass, int zzi_Line, optional string zzt_Price, optional string zzt_Level, optional string zzt_Itens, optional string zzt_Types, optional string zzs_AreaInfo)
{
	local XMLTreeNodeInfo zzinfNode;
	local string zzstrRetName;
	local string zztmpTREEName;
	local array<string> zzs_EventArea;

	if ( zzs_AreaInfo != "" )
	{
		zzs_EventArea = xxlista23(zzs_AreaInfo,",");
	}
	zztmpTREEName = ("Teleport2k2Wnd."$zzl_TREEName);
	zzinfNode.strName = zzt_Bypass;
	zzinfNode.bFollowCursor = True;
	if ( zzt_Itens != "" )
	{
		zzinfNode.ToolTip = xxMakeTooltipItens(zzt_Name,zzt_Itens,zzt_Types,zzs_EventArea);
	} 
	else 
	{
		zzinfNode.ToolTip = xxMakeTooltipTeleport(zzt_Name,zzt_Bypass);
	}
	zzinfNode.nOffSetY = 0;
	zzinfNode.bShowButton = 0;
	zzinfNode.nTexExpandedHeight = 38;
	zzinfNode.nTexExpandedRightWidth = 5;
	zzinfNode.nTexExpandedLeftUWidth = 30;
	zzinfNode.nTexExpandedLeftUHeight = 38;
	zzinfNode.strTexExpandedLeft = "L2UI_CH3.etc.IconSelect2";
	zzstrRetName = getxml(zztmpTREEName,zzl_TREEName,zzinfNode);
	if ( ((zzi_Line % 2) == 0) )
	{
		if ( (zzs_EventArea.Length > 0) && (int(zzs_EventArea[1]) == 1) )
		{
			xxstx2k23(zztmpTREEName,zzstrRetName,"L2UI_CH3.red_bg",262,38);
		} 
		else 
		{
			xxstx2k23(zztmpTREEName,zzstrRetName,"L2UI_CH3.Null",262,38);
		}
	} 
	else 
	{
		if ( (zzs_EventArea.Length > 0) && (int(zzs_EventArea[1]) == 1) )
		{
			xxstx2k23(zztmpTREEName,zzstrRetName,"L2UI_CH3.red_bg",262,38);
		} 
		else 
		{
			xxstx2k23(zztmpTREEName,zzstrRetName,"L2UI_CH3.etc.GroupBox_df_LineBack",262,38);
		}
	}
	if ( "TownsInfo" != zzl_TREEName )
	{
		if ( zzt_Price != "" )
		{
			xxstx2k23(zztmpTREEName,zzstrRetName,"L2UI_CH3.teleportIcon2",15,15, -255,4);
		} 
		else 
		{
			if ( ((zzs_EventArea.Length > 0) && (int(zzs_EventArea[1]) == 1)) )
			{
				xxstx2k23(zztmpTREEName,zzstrRetName,"L2UI_CH3.pvp_icon",15,20, -251,8);
			} 
			else 
			{
				xxstx2k23(zztmpTREEName,zzstrRetName,"L2UI_CH3.teleportIcon",15,15, -251,11);
			}
		}
	} 
	else 
	{
		xxstx2k23(zztmpTREEName,zzstrRetName,"L2UI_CH3.teleportIcon",15,15, -251,11);
	}
	if ( (Len(zzt_Name) > 28) )
	{
		zzt_Name = (Left(zzt_Name,28)$"...");
	}
	if ( "TownsInfo" != zzl_TREEName )
	{
		if ( zzt_Price != "" )
		{
			xxStxXml(zztmpTREEName,zzstrRetName,zzt_Name,7,5,0,True);
		} 
		else 
		{
			xxStxXml(zztmpTREEName,zzstrRetName,zzt_Name,7,12,0,True);
		}
	} 
	else 
	{
		xxStxXml(zztmpTREEName,zzstrRetName,zzt_Name,7,12,0,True);
	}
	if ( zzt_Level != "" )
	{
		xxStxXml(zztmpTREEName,zzstrRetName,("Lv "$zzt_Level),29, -15,2,True,True);
	}
	if ( zzt_Price != "" )
	{
		xxStxXml(zztmpTREEName,zzstrRetName,zzt_Price,(168 - (Len(zzt_Price) * 5)), -15,2,True,True);
		xxstx2k23(zztmpTREEName,zzstrRetName,"L2UI_CH3.InventoryWnd.IconAdena",15,15,2, -15,True);
	}
}

function SetQuestTab (bool tabOn)
{

	if ( tabOn )
	{
		Me.SetWindowSize(680,430);
		zzt_BG.SetTexture("L2UI_CH3.FastTeleportWnd.FastTeleportWnd_BGExt");
		ShowWindow("Teleport2k2Wnd."$"QuestInfo");
	} 
	else 
	{
		Me.SetWindowSize(459,430);
		zzt_BG.SetTexture("L2UI_CH3.FastTeleportWnd.FastTeleportWnd_BG");
		HideWindow("Teleport2k2Wnd."$"QuestInfo");
	}
}

function OnClickButton (string zzclick )
{
	local string zzb_Bypass;
	local string zzb_Town;
	local string zzb_Area;
	local string zzb_Quest;

	zzb_Town = Left(zzclick,Len("TownsInfo"));
	zzb_Area = Left(zzclick,Len("HuntingInfo"));
	zzb_Quest = Left(zzclick,Len("QuestInfo"));
	zzs_lastBypass = "";
	if ( zzb_Town == "TownsInfo" )
	{
		zzi_QuestAreasCount = 0;
		zzzzi_AreasCount = 0;
		zzb_Bypass = Mid(zzclick,(Len("TownsInfo") + 1));
	
		xxHandleTeleportAreas((int(zzb_Bypass) + 1));
	} 
	else 
	{
		if ( zzb_Area == "HuntingInfo" )
		{
			zzi_QuestAreasCount = 0;
			zzb_Bypass = Mid(zzclick,(Len("HuntingInfo") + 1));
			if ( (InStr(zzb_Bypass,"QuestInfo") > -1) )
			{
				zzb_Bypass = Mid(zzb_Bypass,(Len("QuestInfo") + 1));
		
				xxHandleTeleportQuestAreas(int(zzb_Bypass));
			} 
			else 
			{
				zzs_lastBypass = zzb_Bypass;
			}
		} 
		else 
		{
			if ( zzb_Quest == "QuestInfo" )
			{
				zzb_Bypass = Mid(zzclick,(Len("QuestInfo") + 1));
				zzs_lastBypass = zzb_Bypass;
			}
		}
	}
}

function OnLButtonDblClick (int zzX, int zzY)
{
	local  Rect zzTeleport2k2WndRect;
	local  Rect zzQuestInfoRect;

	zzTeleport2k2WndRect = Class'UIAPI_WINDOW'.static.GetRect(("Teleport2k2Wnd."$"HuntingInfo"));
	zzQuestInfoRect = Class'UIAPI_WINDOW'.static.GetRect(("Teleport2k2Wnd."$"QuestInfo"));
	if ( ((zzX >= zzTeleport2k2WndRect.nX) && (zzX <= (zzQuestInfoRect.nX + zzQuestInfoRect.nWidth - 10)) && (zzY >= zzQuestInfoRect.nY)) )
	{
		if ( (Left(zzs_lastBypass,1) == "_") )
		{
			xxbypass(zzs_lastBypass);
		}
	}
	if ( ((zzX >= zzTeleport2k2WndRect.nX) && (zzX <= (zzQuestInfoRect.nX + zzQuestInfoRect.nWidth - 10)) && (zzY >= zzQuestInfoRect.nY)) )
	{
		if ( (Left(zzs_lastBypass,1) == "_") )
		{
			xxbypass(zzs_lastBypass);
		}
	}
}


/*function OnLButtonDblClick (int zzX, int zzY)
{
	local  Rect zzTeleport2k2WndRect;
	local  Rect zzQuestInfoRect;

	zzTeleport2k2WndRect = Class'UIAPI_WINDOW'.static.GetRect(("Teleport2k2Wnd."$"HuntingInfo"));
	zzQuestInfoRect = Class'UIAPI_WINDOW'.static.GetRect(("Teleport2k2Wnd."$"QuestInfo"));
	if ( ((zzX >= zzTeleport2k2WndRect.nX) && (zzX <= (zzQuestInfoRect.nX + zzQuestInfoRect.nWidth - 10)) && (zzY >= zzQuestInfoRect.nY)) )
	{
		//if ( (Left(zzs_lastBypass,1) == " ") )
	//	{
		xxbypass(zzs_lastBypass);
	//	}
	}
	if ( ((zzX >= zzTeleport2k2WndRect.nX) && (zzX <= (zzQuestInfoRect.nX + zzQuestInfoRect.nWidth - 10)) && (zzY >= zzQuestInfoRect.nY)) )
	{
	//	if ( (Left(zzs_lastBypass,1) == " ") )
	//	{
		xxbypass(zzs_lastBypass);
	//	}
	}
}*/


function xxbypass(string zzs_lastBypass)
{
	Me.HideWindow();
 //   ExecuteCommand(".GkGo " $ zzs_lastBypass);
 
//	RequestBypassToServer("GkGo "$zzs_lastBypass);
//	RequestBypassToServer("goto "$zzs_lastBypass);
//	RequestBypassToServer("_LotusUI Teleport "$zzs_lastBypass);
RequestBypassToServer("GkGo "$zzs_lastBypass);
//	RequestBypassToServer("_bpUI teleport "$zzs_lastBypass);
}




function CustomTooltip xxMakeTooltipTeleport(string zzTeleportName, string zzBypass)
{
	local int zzi;
	local CustomTooltip zzToolTip;

	zzi = 0;
	zzToolTip.DrawList.Length = 5;
	if ( (Left(zzBypass,1) == "_") )
	{
		zzToolTip.DrawList[zzi] = xxDrawText(zzTeleportName,xxgetInstanceL2Util().BWhite,True,False,3,5);
		zzi++;
		zzToolTip.DrawList[zzi] = DrawTex("L2UI_CH3.tooltip_line",200,1,1,1,0,8,True,True);
		zzi++;
		zzToolTip.DrawList[zzi] = xxDrawText(GetSystemString(1653),GetColortool(176,155,121,255),True,True,3,4);
		zzi++;
		zzToolTip.DrawList[zzi] = xxDrawBlank(3);
		zzi++;
	} 
	else 
	{
		zzToolTip.DrawList[zzi] = xxDrawText(zzTeleportName,xxgetInstanceL2Util().BWhite,True,False,3,5);
		zzi++;
		zzToolTip.DrawList[zzi] = xxDrawText(" ",xxgetInstanceL2Util().Yellow,True,False,3,5);
		zzi++;
		zzToolTip.DrawList[zzi] = xxDrawBlank(4);
		zzi++;
	}
	return zzToolTip;
}

function CustomTooltip xxMakeTooltipItens(string zzTeleportName, string strItens, string strTypes, array<string> zzs_EventArea)
{
	local int i;
	local int j;
	local CustomTooltip zzToolTip;
	local array<string> zzarrItens;
	local array<string> zzarrTypes;
	local int zzIconSize;
	local string zzClanName;
	local Texture zzClanCrestTexture;
	local Texture zzAllyCrestTexture;


	if ( ((zzs_EventArea.Length >= 1) && (int(zzs_EventArea[2]) > 0)) )
	{
		zzClanName = zzs_EventArea[3];
		Class'UIDATA_CLAN'.static.GetAllianceCrestTexture(int(zzs_EventArea[2]),zzAllyCrestTexture);
		Class'UIDATA_CLAN'.static.GetCrestTexture(int(zzs_EventArea[2]),zzClanCrestTexture);
	}
	zzIconSize = 24;
	zzarrItens = xxlista23(strItens,",");
	zzarrTypes = xxlista23(strTypes,",");
	i = 0;
	zzToolTip.MinimumWidth = 200;
	zzToolTip.DrawList.Length = 5;
	zzToolTip.DrawList[i] = xxDrawText(zzTeleportName,xxgetInstanceL2Util().BWhite,True,False,3,5);
	i++;
	zzToolTip.DrawList[i] = DrawTex("L2UI_CH3.tooltip_line",200,1,1,1,0,8,True,True);
	i++;
	if ( zzClanName != "" )
	{
		zzToolTip.DrawList[i] = xxDrawText(GetSystemString(1693),GetColortool(176,155,121,255),True,True,3,4);
		i++;
		if ( zzAllyCrestTexture != None )
		{
			zzToolTip.DrawList[i] = DrawTex(string(zzAllyCrestTexture),8,16,8,16,5,5,True,True);
			i++;
			if ( zzClanCrestTexture != None )
			{
				zzToolTip.DrawList[i] = DrawTex(string(zzClanCrestTexture),16,16,16,16,0,5,True,False);
				i++;
				zzToolTip.DrawList[i] = DrawTex("L2UI_CH3.crestLine",30,22, -1, -1, -26,3,True,False);
				i++;
			} 
			else 
			{
				zzToolTip.DrawList[i] = DrawTex("L2UI_CH3.crestLine",30,22, -1, -1, -10,3,True,False);
				i++;
			}
		} 
		else 
		{
			if ( zzClanCrestTexture != None )
			{
				zzToolTip.DrawList[i] = DrawTex(string(zzClanCrestTexture),16,16,16,16,15,5,True,True);
				i++;
				zzToolTip.DrawList[i] = DrawTex("L2UI_CH3.crestLine",30,22, -1, -1, -26,3,True,False);
				i++;
			} 
			else 
			{
				zzToolTip.DrawList[i] = DrawTex("L2UI_CH3.crestLine",30,22, -1, -1,3,3,True,True);
				i++;
			}
		}
		zzToolTip.DrawList[i] = xxDrawText(zzClanName,GetColortool(75,185,220,255),True,False,3,8);
		i++;
		zzToolTip.DrawList[i] = DrawTex("L2UI_CH3.tooltip_line",200,1,1,1,0,3,True,True);
		i++;
	}
	zzToolTip.DrawList[i] = xxDrawText(GetSystemString(1652),GetColortool(176,155,121,255),True,True,3,4);
	i++;
	j = 0;
J0x417:

    // End:0x575 [Loop If]
	if( j < zzarrItens.Length )
	{
		zzToolTip.DrawList[i] = DrawTex("L2UI_CH3.Tooltip.lifeBG", zzIconSize + 2, zzIconSize + 2, 18, 18, 3, 8, True, True);
		i++;
		zzToolTip.DrawList[i] = DrawTex(Class'UIDATA_ITEM'.static.GetItemTextureName(int(zzarrItens[j])), zzIconSize, zzIconSize, 32, 32, -zzIconSize - 1, 9, True, False);
		i++;
		zzToolTip.DrawList[i] = xxDrawText(Class'UIDATA_ITEM'.static.GetItemName(int(zzarrItens[j])), GetColortool(206, 185, 151, 255), True, False, 5, 7);
		i++;
		zzToolTip.DrawList[i] = xxDrawText(xxGetItemType(int(zzarrTypes[j])), xxGetItemTypeColor(int(zzarrTypes[j])), True, True, 33, -14);
		i++;
		j++;
        // [Loop Continue]
		goto J0x417;
	}
	zzToolTip.DrawList[i] = DrawTex("L2ui_ch3.tooltip_line", 200, 1, 1, 1, 0, 8, True, True);
	i++;
	zzToolTip.DrawList[i] = xxDrawText(GetSystemString(1653), GetColortool(176, 155, 121, 255), True, True, 3, 4);
	i++;
	zzToolTip.DrawList[i] = xxDrawBlank(3);
	i++;
	return zzToolTip;
 
}

function string xxGetItemType(int zzType)
{
	switch (zzType)
	{
		case 0:
			return "Normal Drop";
		case 1:
			return "Spoil";
		case 2:
			return "Event";
		case 3:
			return "Champion";
		case 4:
			return "Bosses";
		case 5:
			return "Tyrannosaurus";
		default:
	}
}

function Color xxGetItemTypeColor(int zzType)
{
	switch (zzType)
	{
		case 0:
			return GetColortool(57,194,55,255);
		case 1:
			return GetColortool(226,229,38,255);
		case 2:
			return GetColortool(19,114,224,255);
		case 3:
			return GetColortool(221,121,62,255);
		case 4:
			return GetColortool(217,41,236,255);
		case 5:
			return GetColortool(210,60,80,255);
		default:
	}
}
defaultproperties
{
}
