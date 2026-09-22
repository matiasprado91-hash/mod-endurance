//================================================================================
// ToolTip.
//================================================================================

class ToolTip extends UICommonAPI;



var CustomTooltip zzDeobfuscated4592;
var DrawItemInfo zzDeobfuscated2336;
var int textWidth;
var int textWidth2;
var int textHeight;
var bool BoolSelect;
var bool b_ShowID;
var bool isadmin;

var int LastTooltipServerID;
var string LastTooltipRequestParam;
var int LastTooltipRefreshServerID;
var int LastTooltipRefreshDurability;

const MACROCOMMAND_MAX_COUNT= 12;
const TOOLTIP_LINE_HGAP= 4;
const TOOLTIP_SETITEM_MAX= 3;
const TOOLTIP_MINIMUM_WIDTH= 290;

function OnLoad ()
{
    RegisterEvent(2920);
    RegisterEvent(580);
    RegisterEvent(2610);

    isadmin = False;
    BoolSelect = True;

    LastTooltipServerID = -1;
    LastTooltipRefreshServerID = -1;
    LastTooltipRefreshDurability = -1;
}


function setBoolSelect (bool B)
{
	BoolSelect = B;
}



function OnEvent (int Event_ID, string index)
{
    switch (Event_ID)
    {
        case 2920:
            HandleRequestTooltipInfo(index);
            break;

        case 2610:
            HandleInventoryItemUpdate(index);
            break;

        default:
            break;
    }
}

function HandleInventoryItemUpdate(string param)
{
    local ItemInfo Info;

    ParamToItemInfo(param, Info);

    if( LastTooltipServerID != Info.ServerID )
    {
        return;
    }

    if( LastTooltipRequestParam == "" )
    {
        return;
    }

    LastTooltipRefreshServerID = Info.ServerID;
    LastTooltipRefreshDurability = Info.CurrentDurability;

    ExecuteEvent(2920, LastTooltipRequestParam);
}

function Setadminboolean(bool NewValue)
{
	isadmin = NewValue;
}



function HandleRequestTooltipInfo (string index)
{
	local string TooltipType;
	local int SourceType;
	local ETooltipSourceType eSourceType;

	ClearTooltip();
	if ( !ParseString(index,"TooltipType",TooltipType) )
		return;
	
	if ( !ParseInt(index,"SourceType",SourceType) )
		return;
	
	eSourceType = ETooltipSourceType(SourceType);
	if ( TooltipType == "Text" )
	{
		ReturnTooltip_NTT_TEXT(index,eSourceType,False);
	} 
	else
	if ( TooltipType == "Description" )
	{
		ReturnTooltip_NTT_TEXT(index,eSourceType,True);
	} 
	else
	if ( TooltipType == "Action" )
	{
		ReturnTooltip_NTT_ACTION(index,eSourceType);
	} 
	else
	if ( TooltipType == "MACRO" )
	{
		ReturnTooltip_NTT_MACRO(index,eSourceType);
	} 
	else
	if ( TooltipType == "Skill" )
	{
		ReturnTooltip_NTT_SKILL_FARIS(index,eSourceType);
	} 
	else
	if ( TooltipType == "NormalItem" )
	{
		ReturnTooltip_NTT_NORMALITEM(index,eSourceType);
	} 
	else
	if ( TooltipType == "Shortcut" )
	{
		ReturnTooltip_NTT_SHORTCUT(index,eSourceType);
	} 
	else
	if ( TooltipType == "AbnormalStatus" )
	{
		ReturnTooltip_NTT_ABNORMALSTATUS(index,eSourceType);
	} 
	else
	if ( TooltipType == "RecipeManufacture" )
	{
		ReturnTooltip_NTT_RECIPE_MANUFACTURE(index,eSourceType);
	} 
	else
	if ( TooltipType == "Recipe" )
	{
		ReturnTooltip_NTT_RECIPE(index,eSourceType,False);
	} 
	else
	if ( TooltipType == "RecipePrice" )
	{
		ReturnTooltip_NTT_RECIPE(index,eSourceType,True);
	} 
	else
	if ( (TooltipType == "Inventory") || (TooltipType == "InventoryPrice1") || (TooltipType == "inventorylist") || (TooltipType == "InventoryPrice2") || (TooltipType == "InventoryPrice1HideEnchant") || (TooltipType == "InventoryPrice1HideEnchantStackable") || (TooltipType == "InventoryPrice2PrivateShop") )
	{
		ReturnTooltip_NTT_ITEM_FARIS(index,TooltipType,eSourceType);
	} 
	else
	if ( TooltipType == "PartyMatch" )
	{
		ReturnTooltip_NTT_PARTYMATCH(index,eSourceType);
	} 
	else
	if ( TooltipType == "QuestInfo" )
	{
		ReturnTooltip_NTT_QUESTINFO(index,eSourceType);
	} 
	else
	if ( TooltipType == "QuestList" )
	{
		ReturnTooltip_NTT_QUESTLIST(index,eSourceType);
	} 
	else
	if ( TooltipType == "RaidList" )
	{
		ReturnTooltip_NTT_RAIDLIST(index,eSourceType);
	} 
	else
	if ( TooltipType == "ClanInfo" )
	{
		ReturnTooltip_NTT_CLANINFO(index,eSourceType);
	} 
	else
	if ( TooltipType == "ItemSkillInfo" )
	{
		ReturnTooltip_NTT_ITEMSKILLINFO(index,eSourceType);
	} 
	else
	if ( (TooltipType == "ManorSeedInfo") || (TooltipType == "ManorCropInfo") || (TooltipType == "ManorSeedSetting") || (TooltipType == "ManorCropSetting") || (TooltipType == "ManorDefaultInfo") || (TooltipType == "ManorCropSell") )
	{
		ReturnTooltip_NTT_MANOR(index,TooltipType,eSourceType);
	} 
	else
	if ( Len(TooltipType) != 0 )
	{
		ReturnTooltip_NTT_SHORTCUT(index, eSourceType);
	}
}

function bool IsEnchantableItem (EItemParamType Deobfuscated1848)
{
	return (Deobfuscated1848 == 0) || (Deobfuscated1848 == 1) || (Deobfuscated1848 == 3) || (Deobfuscated1848 == 2);
}

function ClearTooltip ()
{
	textWidth = 0;
	textWidth2 = 0;
	zzDeobfuscated4592.SimpleLineCount = 0;
	zzDeobfuscated4592.MinimumWidth = 0;
	zzDeobfuscated4592.DrawList.Remove (0,zzDeobfuscated4592.DrawList.Length);

    LastTooltipServerID = -1;	}

function StartItem ()
{
	local DrawItemInfo infoClear;

	zzDeobfuscated2336 = infoClear;
}

function EndItem ()
{
	zzDeobfuscated4592.DrawList.Length = zzDeobfuscated4592.DrawList.Length + 1;
	zzDeobfuscated4592.DrawList[zzDeobfuscated4592.DrawList.Length - 1] = zzDeobfuscated2336;
}


function ReturnTooltip_NTT_TEXT (string param, ETooltipSourceType eSourceType, bool bDesc)
{
	local string strText;
	local int Id;

	if ( eSourceType == 0 )
	{
		if ( ParseString(param,"Text",strText) )
		{
			if ( (Len(strText) > 0) )
			{
				if ( bDesc )
				{
					zzDeobfuscated4592.MinimumWidth = 250;
					StartItem();
					zzDeobfuscated2336.eType = DIT_TEXT;
					zzDeobfuscated2336.t_color.R = 178;
					zzDeobfuscated2336.t_color.G = 190;
					zzDeobfuscated2336.t_color.B = 207;
					zzDeobfuscated2336.t_color.A = 255;
					zzDeobfuscated2336.t_strText = strText;
					EndItem();
				} 

				else 

				{
					StartItem();
					zzDeobfuscated2336.eType = DIT_TEXT;
					zzDeobfuscated2336.t_bDrawOneLine = True;
					zzDeobfuscated2336.t_strText = strText;
					EndItem();
				}
			}
		} 

		else 

		{
			if ( ParseInt(param,"ID",Id) )
			{
				if ( Id > 0 )
				{
					StartItem();
					zzDeobfuscated2336.eType = DIT_TEXT;
					zzDeobfuscated2336.t_bDrawOneLine = True;
					zzDeobfuscated2336.t_ID = Id;
					EndItem();
				}
			}
		}
	} 

	else 

	{
		return;
	}
	ReturnTooltipInfo(zzDeobfuscated4592);
}



function bool addItemIcon (ItemInfo item, string ForeTexture, optional int nOffSetX, optional int nOffSetY)
{
	if ( item.IconName == "" )
	{
		return False;
	}
	StartItem();
	zzDeobfuscated2336.eType = DIT_TEXTURE;
	zzDeobfuscated2336.u_nTextureWidth = 35;
	zzDeobfuscated2336.u_nTextureHeight = 35;
	zzDeobfuscated2336.u_nTextureUWidth = 35;
	zzDeobfuscated2336.u_nTextureUHeight = 35;
	zzDeobfuscated2336.nOffSetX = nOffSetX;
	zzDeobfuscated2336.u_strTexture = "L2UI_CH3.Tooltip.SlotBox_Default";
	EndItem();
	StartItem();
	zzDeobfuscated2336.eType = DIT_TEXTURE;
	zzDeobfuscated2336.u_nTextureWidth = 32;
	zzDeobfuscated2336.u_nTextureHeight = 32;
	zzDeobfuscated2336.u_nTextureUWidth = 32;
	zzDeobfuscated2336.u_nTextureUHeight = 32;
	zzDeobfuscated2336.nOffSetX = -33;
	zzDeobfuscated2336.nOffSetY = 1;
	zzDeobfuscated2336.u_strTexture = item.IconName;
	EndItem();
	if ( (item.Enchanted > 0) || (item.ItemNum > 1) )
	{
		StartItem();
		zzDeobfuscated2336.eType = DIT_TEXTURE;
		zzDeobfuscated2336.u_nTextureWidth = 32;
		zzDeobfuscated2336.u_nTextureHeight = 32;
		zzDeobfuscated2336.u_nTextureUWidth = 32;
		zzDeobfuscated2336.u_nTextureUHeight = 32;
		zzDeobfuscated2336.nOffSetX = -32;
		zzDeobfuscated2336.nOffSetY = 1;
		if ( (item.Enchanted <= 50) && (item.Enchanted > 0) && (item.SlotBitType > 0) )
		{
			zzDeobfuscated2336.u_strTexture = ("L2UI_CH3.ItemEnchant.enchant"$string(item.Enchanted));
		}
		if ( item.ItemNum > 1 )
		{
			if ( item.ItemNum > 99 )
			{
				zzDeobfuscated2336.u_strTexture = "L2UI_CH3.ItemCount.texCount99+";
			} 

			else 

			{
				zzDeobfuscated2336.u_strTexture = ("L2UI_CH3.ItemCount.texCount"$string(item.ItemNum));
			}
		}
		EndItem();
	}
	return True;
}









function AddTooltipText (string strDesc, bool bLineBreak, bool t_bDrawOneLine, optional bool isFirstLine, optional int offsetX, optional int offsetY)
{
	StartItem();
	zzDeobfuscated2336.eType = DIT_TEXT;
	if ( !isFirstLine )
	{
		zzDeobfuscated2336.nOffSetY = 4;
	}
	zzDeobfuscated2336.nOffSetX = (zzDeobfuscated2336.nOffSetX + offsetX);
	zzDeobfuscated2336.nOffSetY = (zzDeobfuscated2336.nOffSetY + offsetY);
	zzDeobfuscated2336.t_strText = strDesc;
	zzDeobfuscated2336.bLineBreak = bLineBreak;
	zzDeobfuscated2336.t_bDrawOneLine = t_bDrawOneLine;
	EndItem();
}


function AddTooltipColorTextfaris (string strDesc, Color TextColor, bool bLineBreak, bool t_bDrawOneLine, optional bool isFirstLine, optional string FontName, optional int offsetX, optional int offsetY)
{
	StartItem();
	zzDeobfuscated2336.eType = DIT_TEXT;
	if ( !(isFirstLine) )
	{
		zzDeobfuscated2336.nOffSetY = 4;
	}
	zzDeobfuscated2336.bLineBreak = bLineBreak;
	zzDeobfuscated2336.t_bDrawOneLine = t_bDrawOneLine;
	zzDeobfuscated2336.nOffSetX = (zzDeobfuscated2336.nOffSetX + offsetX);
	zzDeobfuscated2336.nOffSetY = (zzDeobfuscated2336.nOffSetY + offsetY);
	zzDeobfuscated2336.t_color = TextColor;
	zzDeobfuscated2336.t_strText = strDesc;
	zzDeobfuscated2336.nOffSetX = offsetX;
	zzDeobfuscated2336.nOffSetY = offsetY;
	EndItem();
}




function AddTooltipColorText (string strDesc, Color TextColor, bool bLineBreak, bool t_bDrawOneLine, optional bool isFirstLine, optional string FontName, optional int offsetX, optional int offsetY)
{
	StartItem();
	zzDeobfuscated2336.eType = DIT_TEXT;
	if ( !isFirstLine )
	{
		zzDeobfuscated2336.nOffSetY = 4;
	}
	zzDeobfuscated2336.bLineBreak = bLineBreak;
	zzDeobfuscated2336.t_bDrawOneLine = t_bDrawOneLine;
	zzDeobfuscated2336.nOffSetX = (zzDeobfuscated2336.nOffSetX + offsetX);
	zzDeobfuscated2336.nOffSetY = (zzDeobfuscated2336.nOffSetY + offsetY);
	zzDeobfuscated2336.t_color = TextColor;
	zzDeobfuscated2336.t_strText = strDesc;
	zzDeobfuscated2336.nOffSetX = offsetX;
	zzDeobfuscated2336.nOffSetY = offsetY;
	EndItem();
}



function int getMaxWidth ()
{
	local int tmp;

	if ( (textWidth2 >= 80 + textWidth + 20) )
	{
		tmp = (textWidth2 + 80);
	} 

	else 

	{
		tmp = (textWidth + 20);
	}
	if ( tmp < 250 )
	{
		tmp = 250;
	}
	return tmp;
}





function string GetTextWithOffset(string text, int offset)
{

	
	local int tmp;

	if ( (textWidth2 >= 80 + textWidth + 20) )
	{
		tmp = (textWidth2 + 80);
	}
	else
	{
		tmp = (textWidth + 20);
	}

	if ( tmp < 250 )
	{
		tmp = 250;
	}

	return Mid(text, textWidth);
}







/*function string GetTextWithOffset(string text, int offset)
{
    local int maxWidth;
    local int textWidth;

    // Llama a la funci??n getMaxWidth para obtener el valor de maxWidth
    maxWidth = getMaxWidth();

    // Calcula el nuevo ancho del texto sumando el offset
    textWidth = maxWidth + offset;

    // Aseg??rate de que el nuevo ancho sea al menos 174
    if (textWidth < 250)
    {
        textWidth = 250;
    }

    // Devuelve el texto con el nuevo ancho
    return Mid(text, 1, textWidth);
}*/


function AddTooltipItemBonusfaris (int nBasic, int nBonus, optional int offsetX, optional int offsetY)
{
	if ( nBonus > 0 )
	{
		AddTooltipColorText((" ("$string(nBasic)$" "), GetColortool(176, 155, 121, 255), False, True, False, "", offsetX, offsetY);
		AddTooltipColorText("+"$string(nBonus), GetColortool(238, 170, 34, 255), False, True, False, "", offsetX, offsetY);
		AddTooltipColorText(")", GetColortool(176, 155, 121, 255), False, True, False, "", offsetX, offsetY);


	}
}




function AddTooltipItemBonus(int nBasic, int nBonus, optional int offsetX, optional int offsetY)
{
	if ( nBonus > 0 )
	{
		AddTooltipColorText(" ("$string(nBasic)$" + "$string(nBonus)$")", GetColortool(238, 170, 34, 255), False, True, False, "", offsetX, offsetY);
	}
}

function AddTooltipItemOptionBonus (string TitleID, string Content, bool bTitle, bool bContent, bool IamFirst)
{
	if ( bTitle )
	{
		StartItem();
		zzDeobfuscated2336.eType = DIT_TEXT;
		if ( !IamFirst )
		{
			zzDeobfuscated2336.nOffSetY = 4;
		}
		zzDeobfuscated2336.nOffSetX = 3;
		zzDeobfuscated2336.bLineBreak = True;
		zzDeobfuscated2336.t_bDrawOneLine = True;
		zzDeobfuscated2336.t_color.R = 200;
		zzDeobfuscated2336.t_color.G = 200;
		zzDeobfuscated2336.t_color.B = 200;
		zzDeobfuscated2336.t_color.A = 255;
		zzDeobfuscated2336.t_strText = TitleID;
		EndItem();
	}
	if ( Content != "0" )
	{
		if ( bContent )
		{
			if ( bTitle )
			{
				StartItem();
				zzDeobfuscated2336.eType = DIT_TEXT;
				if ( !IamFirst )
				{
					zzDeobfuscated2336.nOffSetY = 4;
				}
				zzDeobfuscated2336.t_bDrawOneLine = True;
				zzDeobfuscated2336.t_color.R = 163;
				zzDeobfuscated2336.t_color.G = 163;
				zzDeobfuscated2336.t_color.B = 163;
				zzDeobfuscated2336.t_color.A = 255;
				zzDeobfuscated2336.t_strText = " : ";
				EndItem();
			}
			StartItem();
			zzDeobfuscated2336.eType = DIT_TEXT;
			if ( !IamFirst )
			{
				zzDeobfuscated2336.nOffSetY = 4;
			}
			if ( !bTitle )
			{
				zzDeobfuscated2336.bLineBreak = True;
			}
			zzDeobfuscated2336.t_bDrawOneLine = True;
			zzDeobfuscated2336.t_color.R = 4;
			zzDeobfuscated2336.t_color.G = 140;
			zzDeobfuscated2336.t_color.B = 220;
			zzDeobfuscated2336.t_color.A = 255;
			zzDeobfuscated2336.t_strText = Content;
			EndItem();
		}
	}
}

function AddCrossLine (optional int minimum_width)
{
	AddTooltipItemBlank(2);
	StartItem();
	zzDeobfuscated2336.eType = DIT_TEXTURE;
	if ( minimum_width > 0 )
	{
		zzDeobfuscated2336.u_nTextureWidth = minimum_width;
	} 

	else 

	{
		zzDeobfuscated2336.u_nTextureWidth = getMaxWidth();
	}
	zzDeobfuscated2336.u_nTextureHeight = 1;
	zzDeobfuscated2336.u_strTexture = "L2UI_CH3.tooltip_line";
	EndItem();
	AddTooltipItemBlank(4);
}



function addTooltipTextureSplitLineType (string Texture, int Width, int Height, int uWidth, int uHeight, optional int offsetX, optional int offsetY)
{
	StartItem();
	zzDeobfuscated2336.eType = DIT_TEXTURE;
	zzDeobfuscated2336.t_bDrawOneLine = True;
	zzDeobfuscated2336.bLineBreak = False;
	zzDeobfuscated2336.u_nTextureWidth = Width;
	zzDeobfuscated2336.u_nTextureHeight = Height;
	zzDeobfuscated2336.nOffSetX = offsetX;
	zzDeobfuscated2336.nOffSetY = offsetY;
	zzDeobfuscated2336.u_nTextureUWidth = uWidth;
	zzDeobfuscated2336.u_nTextureUHeight = uHeight;
	zzDeobfuscated2336.u_strTexture = Texture;
	EndItem();
}

function addTooltipTexture (string Texture, int Width, int Height, int uWidth, int uHeight, optional bool OneLine, optional bool bLineBreak, optional int offsetX, optional int offsetY)
{
	StartItem();
	zzDeobfuscated2336.eType = DIT_TEXTURE;
	zzDeobfuscated2336.t_bDrawOneLine = OneLine;
	zzDeobfuscated2336.bLineBreak = bLineBreak;
	zzDeobfuscated2336.u_nTextureWidth = Width;
	zzDeobfuscated2336.u_nTextureHeight = Height;
	zzDeobfuscated2336.nOffSetX = offsetX;
	zzDeobfuscated2336.nOffSetY = offsetY;
	zzDeobfuscated2336.u_nTextureUWidth = uWidth;
	zzDeobfuscated2336.u_nTextureUHeight = uHeight;
	zzDeobfuscated2336.u_strTexture = Texture;
	EndItem();
}


function AddTitleIconWithHeadLinefaris (string Icon, string titleStr, string descStr, optional int Type)
{
	local Color Color;

	if ( Type == 2 )
	{
		Color = xxgetInstanceL2Util().Red;
	} 

	else 

	{
		if ( Type == 1 )
		{
			Color = xxgetInstanceL2Util().Blue;
		} 

		else 

		{
			Color = xxgetInstanceL2Util().ColorYellow;
		}
	}
	addTooltipTextureSplitLineType("L2UI_CH3.AugBG",getMaxWidth(),25,0,0,0,0);
	if ( (Len(Icon) > 0) )
	{
		addTooltipTexture(("L2UI_CH3."$Icon),18,18,0,0,True,True,3, -23);
		AddTooltipColorText(titleStr,xxgetInstanceL2Util().Gold,False,True,False,"",3, -21);
		if ( (Len(descStr) > 0) )
		{
			AddTooltipColorText(descStr,Color,False,True,False,"",2, -21);
		}
	} 

	else 

	{
		AddTooltipColorText(titleStr,Color,True,True,False,"",32, -21);
		AddTooltipColorText(descStr,Color,False,True,False,"",(getMaxWidth() - 193), -21);
	}
}



function AddTitleIconWithHeadLine (string Icon, string titleStr, string descStr)
{
	addTooltipTextureSplitLineType("L2UI_CH3.AugBG",getMaxWidth(),25,0,0,0,0);
	if ( Len(Icon) > 0 )
	{
		addTooltipTexture(("L2UI_CH3."$Icon),18,18,0,0,True,True,3, -23);
	}
	AddTooltipColorText(titleStr,xxgetInstanceL2Util().Gold,False,True,False,"",3, -21);
	if ( Len(descStr) > 0 )
	{
		AddTooltipColorText(descStr,xxgetInstanceL2Util().ColorYellow,False,True,False,"",2, -21);
	}
}







function AddTooltipRefinery(ItemInfo item)
{
	local string strDesc1;
	local string strDesc2;
	local string strDesc3;
	local int ColorR;
	local int ColorG;
	local int ColorB;
	local int Quality;

	if ( (item.RefineryOp1 + item.RefineryOp2) != 0 )
	{
		AddTooltipItemBlank(4);
  //  AddTitleIconWithHeadLinefaris("LifeBG", GetSystemString(1490) @ Class'UIDATA_REFINERYOPTION'.static.GetOptionDescription(item.RefineryOp1, strDesc1, strDesc2, strDesc3), "");
		AddTitleIconWithHeadLinefaris("LifeBG", GetSystemString(1490), "", 0);
  
		if ( item.SlotBitType != 8192 )
		{
			Quality = Class'UIDATA_REFINERYOPTION'.static.GetQuality(item.RefineryOp1);
			GetRefineryColor(Quality, ColorR, ColorG, ColorB);
		} 

		else 

		{
			Quality = Class'UIDATA_REFINERYOPTION'.static.GetQuality(item.RefineryOp2);
			GetRefineryColor(Quality, ColorR, ColorG, ColorB);
		}
		if ( item.RefineryOp1 != 0 )
		{
			strDesc1 = "";
			strDesc2 = "";
			strDesc3 = "";
			if ( Class'UIDATA_REFINERYOPTION'.static.GetOptionDescription(item.RefineryOp1,strDesc1,strDesc2,strDesc3) )
			{
				if ( Len(strDesc1) > 0 )
				{
					AddTooltipColorText(strDesc1,GetColortool(ColorR,ColorG,ColorB,255),True,False,False);
				}
				if ( Len(strDesc2) > 0 )
				{
					AddTooltipColorText(strDesc2,GetColortool(ColorR,ColorG,ColorB,255),True,False,False);
				}
				if ( Len(strDesc3) > 0 )
				{
					AddTooltipColorText(strDesc3,GetColortool(ColorR,ColorG,ColorB,255),True,False,False);
				}
			}
		}
		if ( item.SlotBitType == 8192 )
		{
			Quality = Class'UIDATA_REFINERYOPTION'.static.GetQuality(item.RefineryOp2);
			GetRefineryColor(Quality,ColorR,ColorG,ColorB);
		}
		if ( item.RefineryOp2 != 0 )
		{
			strDesc1 = "";
			strDesc2 = "";
			strDesc3 = "";
			if ( Class'UIDATA_REFINERYOPTION'.static.GetOptionDescription(item.RefineryOp2,strDesc1,strDesc2,strDesc3) )
			{
				if ( Len(strDesc1) > 0 )
				{
					AddTooltipColorText(strDesc1,GetColortool(ColorR,ColorG,ColorB,255),True,False,False);
				}
				if ( Len(strDesc2) > 0 )
				{
					AddTooltipColorText(strDesc2,GetColortool(ColorR,ColorG,ColorB,255),True,False,False);
				}
				if ( Len(strDesc3) > 0 )
				{
					AddTooltipColorText(strDesc3,GetColortool(ColorR,ColorG,ColorB,255),True,False,False);
				}
			}
		}
		if ( item.SlotBitType != 8192 )
		{
			AddTooltipItemOptionfaris(1491, "", True, False, False);
			SetTooltipItemColor(ColorR, ColorG, ColorB, 0);
		}
		AddTooltipItemBlank(2);
	}
}




function int AddTooltipItemEnchantfaris (ItemInfo item, optional bool bFirstLineWidthCount, optional int offsetX, optional int offsetY)
{
	local int nSumWidth;
	local int sizeWidth;
	local int sizeHeight;
	local EItemParamType EItemParamType;

	EItemParamType = EItemParamType(item.ItemType);
	if ( (item.Enchanted > 0) && IsEnchantableItem(EItemParamType) )
	{
		StartItem();
		zzDeobfuscated2336.eType = DIT_TEXT;
		zzDeobfuscated2336.t_bDrawOneLine = True;
		zzDeobfuscated2336.t_color.R = 170;
		zzDeobfuscated2336.t_color.G = 110;
		zzDeobfuscated2336.t_color.B = 230;
		zzDeobfuscated2336.t_color.A = 255;
		zzDeobfuscated2336.t_strText = ("+"$string(item.Enchanted));
		zzDeobfuscated2336.nOffSetX = (zzDeobfuscated2336.nOffSetX + offsetX);
		zzDeobfuscated2336.nOffSetY = (zzDeobfuscated2336.nOffSetY + offsetY);
		EndItem();
		GetTextSize(zzDeobfuscated2336.t_strText,sizeWidth,sizeHeight);
		nSumWidth = (nSumWidth + sizeWidth);
	}
	return nSumWidth;
}



function AddTooltipItemCountfaris (ItemInfo item, optional int offsetX, optional int offsetY)
{
	if ( IsStackableItem(item.ConsumeType) )
	{
		StartItem();
		zzDeobfuscated2336.eType = DIT_TEXT;
		zzDeobfuscated2336.t_bDrawOneLine = True;
		zzDeobfuscated2336.t_strText = (" ("$MakeCostString(string(item.ItemNum))$")");
		zzDeobfuscated2336.nOffSetX = (zzDeobfuscated2336.nOffSetX + offsetX); 
		zzDeobfuscated2336.nOffSetY = (zzDeobfuscated2336.nOffSetY + offsetY);
		zzDeobfuscated2336.t_color.R = 176;
		zzDeobfuscated2336.t_color.G = 155;
		zzDeobfuscated2336.t_color.B = 121;
		zzDeobfuscated2336.t_color.A = 255;
		EndItem();
	}
}


function AddTooltipItemGradefaris(ItemInfo item, optional int offsetX, optional int offsetY)
{
	if ( item.CrystalType > 0 )
	{
		StartItem();
		zzDeobfuscated2336.eType = DIT_TEXTURE;
		zzDeobfuscated2336.nOffSetX = (zzDeobfuscated2336.nOffSetX + offsetX + 5);
		zzDeobfuscated2336.nOffSetY = (zzDeobfuscated2336.nOffSetY + offsetY);
		zzDeobfuscated2336.t_bDrawOneLine = True;
		zzDeobfuscated2336.u_nTextureWidth = 16;
		if ( item.CrystalType > 5 )
		{
			zzDeobfuscated2336.u_nTextureWidth = 32;
		}
		zzDeobfuscated2336.u_nTextureHeight = 16;
		zzDeobfuscated2336.u_strTexture = ("L2UI_CH3.grade_"$string(item.CrystalType));
		EndItem();
	}
}


function CompareWithEquipedItem (ItemInfo item)
{
	local EItemType EItemType;
	local ItemWindowHandle hItemWnd;
	local ItemInfo ItemSlot;
	local int ItemValue;
	local int ItemCompareValue;

	if ( compareUco(item.SlotBitType,hItemWnd) )
	{
		hItemWnd.GetItem(0,ItemSlot);
		EItemType = EItemType(item.ItemType);
		if ( ItemSlot.ClassID > 0 )
		{
			if ( (item.SlotBitType != ItemSlot.SlotBitType) && (hItemWnd.GetWindowName() != "EquipItem_RHand") )
			{
				return;
			}
			switch (EItemType)
			{
				case ITEM_WEAPON:
					ItemValue = EnchantCalculateWeapon(item);
					ItemCompareValue = EnchantCalculateWeapon(ItemSlot);
					break;
				case ITEM_ARMOR:
					ItemValue = EnchantCalculateArmor(item);
					ItemCompareValue = EnchantCalculateArmor(ItemSlot);
					break;
				case ITEM_ACCESSARY:
					ItemValue = EnchantCalculateJewel(item);
					ItemCompareValue = EnchantCalculateJewel(ItemSlot);
					break;
				default:
			}
			if ( ItemValue > ItemCompareValue )
			{
				AddCompareItemTexture("L2UI_CH3.ToolTip.up_stats");
				AddTooltipColorText("+"$string(ItemValue - ItemCompareValue), GetColortool(96, 182, 9, 255), False, True, False, "", 0, -17);

			} 

			else 

			{
				if ( ItemValue < ItemCompareValue )
				{
					AddCompareItemTexture("L2UI_CH3.ToolTip.down_stats");
					AddTooltipColorText(""$string(ItemValue - ItemCompareValue),xxgetInstanceL2Util().Red,False,True,False,"",0, -17);
				}
			}
		} 

		else 

		{
			switch (EItemType)
			{
				case ITEM_WEAPON:
					ItemValue = EnchantCalculateWeapon(item);
					break;
				case ITEM_ARMOR:
					ItemValue = EnchantCalculateArmor(item);
					break;
				case ITEM_ACCESSARY:
					ItemValue = EnchantCalculateJewel(item);
					break;
				default:
			}
			if ( ItemValue > 0 )
			{
				AddCompareItemTexture("L2UI_CH3.ToolTip.up_stats");
				AddTooltipColorText("+"$string(ItemValue),GetColortool(96,182,9,255),False,True,False,"",0, -17);
			}
		}
	}
}

function AddCompareItemTexture (string strTexture)
{
	StartItem();
	zzDeobfuscated2336.eType = DIT_TEXTURE;
	zzDeobfuscated2336.nOffSetX = 3;
	zzDeobfuscated2336.nOffSetY = -13;
	zzDeobfuscated2336.bLineBreak = False;
	zzDeobfuscated2336.t_bDrawOneLine = True;
	zzDeobfuscated2336.u_nTextureWidth = 14;
	zzDeobfuscated2336.u_nTextureHeight = 8;
	zzDeobfuscated2336.u_strTexture = strTexture;
	EndItem();
}


function string getSlotTypeWithItemTypeString (ItemInfo item)
{
	local string SlotString;
	local string strTmp;
	local EItemType EItemType;

	EItemType = EItemType(item.ItemType);
	SlotString = GetSlotTypeString(item.ItemType,item.SlotBitType,item.ArmorType);
	if ( EItemType == 0 )
	{
		strTmp = GetWeaponTypeString(item.WeaponType);
		if ( (Len(strTmp) > 0) )
		{
			SlotString = strTmp$" / "$SlotString;

		}
	}
	return SlotString;
}

function bool AddBGByType(ItemInfo zzinfo)
{
	local string zzparam;
	local EItemType EItemType;

	EItemType = EItemType(zzinfo.ItemType);
	switch(EItemType)
	{
        // End:0x1E
		case EItemType(1):
        // End:0x23
		case EItemType(0):
        // End:0x48
		case EItemType(2):
			zzparam = xxtierlist(zzinfo.Description, "Tier:");
            // End:0x4E
			break;
        // End:0xFFFF
		default:
            // End:0x4E
			break;
  
	}
    // End:0x192
	if( zzparam != "" )
	{
        // End:0xF5
		if( zzparam == "1" )
		{
			addTooltipTextureSplitLineType("L2UI_CH3.tooltip.bgRare", xxlikua(), 39, 256, 39, 0, -2);
			AddTooltipColorTextfaris("Rare", xxgetInstanceL2Util().Blue, False, True, False, "", -GetTextWidth("Rare"), 20);

			addItemIcon(zzinfo, zzinfo.IconName, -xxlikua() );
			return True;            
		}
		else
		{
            // End:0x192
			if( zzparam == "2" )
			{
				addTooltipTextureSplitLineType("L2UI_CH3.tooltip.bgSupreme", xxlikua(), 39, 256, 39, 0, -2);
				AddTooltipColorTextfaris("Legendary", SetCustomColor("Red"), False, True, False, "", -GetTextWidth("Legendary"), 25);
				addItemIcon(zzinfo, zzinfo.IconName, -xxlikua() );
				return True;
			}
		}
	}
	return False;

}





function xxsettier(ItemInfo zzinfo, bool zzbolean)
{
	local string zzparam;
	local EItemType EItemType;

	EItemType = EItemType(zzinfo.ItemType);
    // End:0x31
	/*if( (EItemType == 1) && !zzbolean )
	{
		return;
	}*/
	zzparam = xxtierlist(zzinfo.Description, "Tier:");
    // End:0xCD
	if( zzparam != "" )
	{
		AddTooltipItemBlank(5);
        // End:0x98
		if( zzparam == "1" )
		{
			xxtierpacketa("water", "Tier"$": ", "Rare", int(zzparam));            
		}
		else
		{
            // End:0xCD
			if( zzparam == "2" )
			{
				xxtierpacketa("fire", "Tier"$": ", "Legendary", int(zzparam));
			}
		}
	}
	return;
}


function xxtierpacketa(string zzparam, string zzpioka, string zzkjaula, optional int zzintekao)
{
	local Color Color;

    // End:0x20
	if( zzintekao == 2 )
	{
		Color = SetCustomColor("Red");        
	}
	else
	{
        // End:0x43
		if( zzintekao == 1 )
		{
			Color = xxgetInstanceL2Util().Red;            
		}
		else
		{
			Color = xxgetInstanceL2Util().Blue;
		}
	}
	addTooltipTextureSplitLineType("L2UI_CH3.AugBG", xxlikua(), 25, 0, 0, 0, 0);
    // End:0x100
	if( Len(zzparam) > 0 )
	{
		addTooltipTexture("L2UI_CH3."$zzparam, 18, 18, 0, 0, True, True, 3, -23);
		AddTooltipColorTextfaris(zzpioka, xxgetInstanceL2Util().Gold, False, True, False, "", 3, -21);
        // End:0xFD
		if( Len(zzkjaula) > 0 )
		{
			AddTooltipColorTextfaris(zzkjaula, Color, False, True, False, "", 2, -21);
		}        
	}
	else
	{
		AddTooltipColorTextfaris(zzpioka, Color, True, True, False, "", 32, -21);
		AddTooltipColorTextfaris(zzkjaula, Color, False, True, False, "", (xxlikua()) - 193, -21);
	}
	return;
}

function int xxlikua()
{
	local int zzlakiua;

    // End:0x29
	if( (textWidth2 + 80) >= (textWidth + 20) )
	{
		zzlakiua = textWidth2 + 80;        
	}
	else
	{
		zzlakiua = textWidth + 20;
	}
    // End:0x4C
	if( zzlakiua < 250 )
	{
		zzlakiua = 250;
	}
	return zzlakiua;

}

function ReturnTooltip_NTT_ITEM_FARIS (string param, string TooltipType, ETooltipSourceType eSourceType, optional bool isShortcut)
{
	local ItemInfo item;
	local EItemType EItemType;
	local EEtcItemType EEtcItemType;
	local bool bLargeWidth;
	local string SlotString;
	local int nTmp;
	local string ItemName;
	local string ItemSlotWithItemTypeStr;
	local string strAdena;
	local string strAdenaComma;
	local Color AdenaColor;
	local int nEnchantValueTextGap;
	local int nSimpleLineCountAdd;
	local int bMainIconGap;
	local int pAtkValue;
	local int mAtkValue;
	local int pAtkEnchant;
	local int mAtkEnchant;

	if ( eSourceType == 1 )
	{
		ParamToItemInfo(param,item);
        LastTooltipRequestParam = param;
        LastTooltipServerID = item.ServerID;
		if ( isShortcut )
		{
			FindItemByServerID(item.ServerID,item);
		}

        if( LastTooltipRefreshServerID == item.ServerID )
        {
            item.CurrentDurability = LastTooltipRefreshDurability;
            LastTooltipRefreshServerID = -1;
            LastTooltipRefreshDurability = -1;
        }

			


		EItemType = EItemType(item.ItemType);
		EEtcItemType = EEtcItemType(item.ItemSubType);
		ItemName = Class'UIDATA_ITEM'.static.GetRefineryItemName(item.Name,item.RefineryOp1,item.RefineryOp2);
		GetTextSize(" + Augmented "$string(item.Enchanted)$ItemName$" "$item.AdditionalName, textWidth, textHeight);

 //   GetTextSize(" + Augmented " ,string(item.Enchanted),ItemName ," " ,item.AdditionalName, textWidth, textHeight);

		if ( !(AddBGByType(item)) )
		{
			if ( addItemIcon(item,item.IconName) )
			{
				bMainIconGap = 3;
			}
		} 

		else 

		{
			bMainIconGap = 3;
		}
		if ( (TooltipType != "InventoryPrice1HideEnchant") && (TooltipType != "InventoryPrice1HideEnchantStackable") )
		{
			AddTooltipItemEnchantfaris(item,True,5,1);
			nEnchantValueTextGap = 2;
		}
		AddTooltipItemNamefaris(ItemName,item,1,(bMainIconGap + nEnchantValueTextGap),1);
		AddTooltipItemGradefaris(item,0,1);
		if ( TooltipType != "InventoryPrice1HideEnchantStackable" )
		{
			if ( TooltipType != "QuestReward" )
			{
				if ( item.ItemNum > 0 )
				{
					AddTooltipItemCountfaris(item,0,1);
				}
			}
		}
		ItemSlotWithItemTypeStr = getSlotTypeWithItemTypeString(item);
		if ( ItemSlotWithItemTypeStr != "" )
		{
			zzDeobfuscated4592.SimpleLineCount = (2 + nSimpleLineCountAdd);
			AddTooltipItemBlank(1);
			AddTooltipColorText(ItemSlotWithItemTypeStr,GetColortool(176,155,121,255),False,True,False,"",40, -17);
			GetTextSize(ItemSlotWithItemTypeStr,textWidth2,textHeight);
		}
		if ( TooltipType != "InventoryList" )
		{
			CompareWithEquipedItem(item);
		}
		if ( item.ClassID == 57 )
		{
			zzDeobfuscated4592.SimpleLineCount = (3 + nSimpleLineCountAdd);
			AddTooltipText("("$ConvertNumToText(string(item.ItemNum))$")", True, True);

		}
		if ( (TooltipType == "InventoryStackableUnitPrice") && !(item.bEquipped) )
		{
			strAdena = string(item.Price);
			strAdenaComma = MakeCostString(strAdena);
			AdenaColor = GetNumericColor(strAdenaComma);
			if ( IsStackableItem(item.ConsumeType) && (item.ItemNum > 1) )
			{
				AddTooltipItemBlank(4);
				AddTooltipColorText((GetSystemString(2511)$" : "),GetColortool(255,180,0,255),True,True,False);
				AddTooltipText("("$ConvertNumToText(string(item.ItemNum))$")", True, True);

			} 

			else 

			{
				AddTooltipItemOptionfaris(322, (strAdenaComma$" "$GetSystemString(469)), True, True, False, , , , AdenaColor);

			}
			if ( IsStackableItem(item.ConsumeType) && (item.ItemNum > 1) )
			{
				strAdena = string((item.Price * item.ItemNum));
				strAdenaComma = MakeCostString(strAdena);
				AdenaColor = GetNumericColor(strAdenaComma);
				AddTooltipItemOptionfaris(2595, (strAdenaComma$" "$GetSystemString(469)), True, True, False, , , , AdenaColor);

			}
			if ( item.Price > 0 )
			{
				AddTooltipItemOptionfaris(0, ("("$ConvertNumToText(strAdena)$")"), False, True, False);


				SetTooltipItemColor(AdenaColor.R,AdenaColor.G,AdenaColor.B,0);
			}
		}
		if ( (TooltipType == "InventoryPrice1") && (TooltipType == "InventoryPrice1HideEnchant") || (TooltipType == "InventoryPrice1HideEnchantStackable") || !(item.bEquipped) )
		{
			strAdena = string(item.Price);
			strAdenaComma = MakeCostString(strAdena);
			AdenaColor = GetNumericColor(strAdenaComma);
			AddTooltipItemOptionfaris(322, ("("$ConvertNumToText(strAdenaComma)$" "$GetSystemString(469)$")"), True, True, False);

			zzDeobfuscated4592.SimpleLineCount = (3 + nSimpleLineCountAdd);
			if ( item.Price > 0 )
			{
				zzDeobfuscated4592.SimpleLineCount = (4 + nSimpleLineCountAdd);
				AddTooltipItemOptionfaris(0, ("("$ConvertNumToText(strAdena)$")"), False, True, False);

				SetTooltipItemColor(AdenaColor.R,AdenaColor.G,AdenaColor.B,0);
			}
		}
		if ( (TooltipType == "InventoryPrice2") || (TooltipType == "InventoryPrice2PrivateShop") )
		{
			strAdena = string(item.Price);
			strAdenaComma = MakeCostString(strAdena);
			AdenaColor = GetNumericColor(strAdenaComma);
			AddTooltipItemOption2(322,468,True,True,False);
			SetTooltipItemColor(AdenaColor.R,AdenaColor.G,AdenaColor.B,0);
			AddTooltipColorText((" "$strAdenaComma$" "$GetSystemString(469)), AdenaColor, False, True, , , 4);

			zzDeobfuscated4592.SimpleLineCount = (3 + nSimpleLineCountAdd);
			if ( item.Price > 0 )
			{
				zzDeobfuscated4592.SimpleLineCount = (4 + nSimpleLineCountAdd);
				AddTooltipColorText("(",AdenaColor,True,True);
				AddTooltipColorText(GetSystemString(468),AdenaColor,False,True);
				AddTooltipColorText((" "$ConvertNumToText(strAdena)$")"), AdenaColor, False, True);

			}
		}
		if ( TooltipType == "InventoryPrice2PrivateShop" )
		{
			if ( IsStackableItem(item.ConsumeType) && (item.Reserved > 0) )
			{
				AddTooltipItemOptionfaris(808,string(item.Reserved),True,True,False);
			}
		}
		SlotString = "";
		SlotString = GetSlotTypeString(item.ItemType,item.SlotBitType,item.ArmorType);
		switch (EItemType)
		{
			case ITEM_WEAPON:
				bLargeWidth = True;
				if ( item.PhysicalDamage != 0 )
				{
					pAtkValue = GetPhysicalDamage(item.WeaponType,item.SlotBitType,item.CrystalType,item.Enchanted,item.PhysicalDamage);
					pAtkEnchant = ((pAtkValue - item.PhysicalDamage) / 2);
					AddTooltipItemOptionfaris(94,string(item.PhysicalDamage + pAtkEnchant),True,True,False,2,0,xxgetInstanceL2Util().BrightWhite,xxgetInstanceL2Util().ColorYellow);
					AddTooltipItemBonusfaris(item.PhysicalDamage,pAtkEnchant,0,4);
				}
				if ( item.MagicalDamage != 0 )
				{
					mAtkValue = GetMagicalDamage(item.WeaponType,item.SlotBitType,item.CrystalType,item.Enchanted,item.MagicalDamage);
					mAtkEnchant = ((mAtkValue - item.MagicalDamage) / 2);
					AddTooltipItemOptionfaris(98,string(item.MagicalDamage + mAtkEnchant),True,True,False,2,0,xxgetInstanceL2Util().BrightWhite,xxgetInstanceL2Util().ColorYellow);
					AddTooltipItemBonusfaris(item.MagicalDamage,mAtkEnchant,0,4);
				}
				AddTooltipItemOptionfaris(111,GetAttackSpeedString(item.AttackSpeed),True,True,False,2);
				if ( item.ShieldDefense > 0 )
				{
					AddTooltipItemOptionfaris(95,string(item.ShieldDefense),True,True,False,2,0,xxgetInstanceL2Util().BrightWhite,xxgetInstanceL2Util().ColorYellow);
				}
				if ( item.ShieldDefenseRate > 0 )
				{
					AddTooltipItemOptionfaris(317,string(item.ShieldDefenseRate),True,True,False,2);
				}
	  
				if ( item.SoulshotCount > 0 )
				{
					AddTooltipItemOptionfaris(404,"X "$string(item.SoulshotCount),True,True,False);
				}
				if ( item.SpiritshotCount > 0 )
				{
					AddTooltipItemOptionfaris(496,"X "$string(item.SpiritshotCount),True,True,False);
				}
	  
				if ( item.Weight == 0 )
				{
					AddTooltipItemOptionfaris(52," 0 ",True,True,False,2);
				} 

				else 

				{
					AddTooltipItemOptionfaris(52,string(item.Weight),True,True,False,2);
				}
				if ( item.MpConsume != 0 )
				{
					AddTooltipItemOptionfaris(320,string(item.MpConsume),True,True,False,2);
				}
				AddTooltipRefinery(item);
				break;
			case ITEM_ARMOR:
				bLargeWidth = True;
				if ( (item.SlotBitType == 256) || (item.SlotBitType == 128) )
				{
					if ( item.ShieldDefense != 0 )
					{
						AddTooltipItemOptionfaris(95,string(GetShieldDefense(item.CrystalType,item.Enchanted,item.ShieldDefense)),True,True,False,2,0,xxgetInstanceL2Util().BrightWhite,xxgetInstanceL2Util().ColorYellow);
						AddTooltipItemBonusfaris(item.ShieldDefense,(GetShieldDefense(item.CrystalType,item.Enchanted,item.ShieldDefense) - item.ShieldDefense),0,4);

					}
					if ( item.ShieldDefenseRate > 0 )
					{
						AddTooltipItemOptionfaris(317,string(item.ShieldDefenseRate),True,True,False,2,0);
					}
					AddTooltipItemOptionfaris(97,string(item.AvoidModify),True,True,False,2,0);
					AddTooltipItemOptionfaris(52,string(item.Weight),True,True,False,2,0);
				} 

				else 

				{
					if ( IsMagicalArmor(item.ClassID) )
					{
						if ( item.MpBonus > 0 )
						{
							AddTooltipItemOptionfaris(388,string(item.MpBonus),True,True,False,2,0,xxgetInstanceL2Util().BrightWhite,xxgetInstanceL2Util().ColorYellow);
						}
						if ( item.PhysicalDefense != 0 )
						{
							AddTooltipItemOptionfaris(95,string(GetPhysicalDefense(item.CrystalType,item.Enchanted,item.PhysicalDefense)),True,True,False,2,0,xxgetInstanceL2Util().BrightWhite,xxgetInstanceL2Util().ColorYellow);
							AddTooltipItemBonusfaris(item.PhysicalDefense,(GetPhysicalDefense(item.CrystalType,item.Enchanted,item.PhysicalDefense) - item.PhysicalDefense),0,4);

						}
						if ( item.Weight != 0 )
						{
							AddTooltipItemOptionfaris(52,string(item.Weight),True,True,False,2,0);
						}
					} 

					else 

					{
						if ( item.PhysicalDefense != 0 )
						{
							AddTooltipItemOptionfaris(95,string(GetPhysicalDefense(item.CrystalType,item.Enchanted,item.PhysicalDefense)),True,True,False,2,0,xxgetInstanceL2Util().BrightWhite,xxgetInstanceL2Util().ColorYellow);
							AddTooltipItemBonusfaris(item.PhysicalDefense,(GetPhysicalDefense(item.CrystalType,item.Enchanted,item.PhysicalDefense) - item.PhysicalDefense),0,4);

						}
						if ( item.Weight != 0 )
						{
							AddTooltipItemOptionfaris(52,string(item.Weight),True,True,False,2,0);
						}
					}
				}
				break;
			case ITEM_ACCESSARY:
				bLargeWidth = True;
				if ( (item.SlotBitType != 4194304) && (item.SlotBitType != 1048576) && (item.SlotBitType != 2097152) )
				{
					if ( (GetMagicalDefense(item.CrystalType,item.Enchanted,item.MagicalDefense) > 0) )
					{
						AddTooltipItemOptionfaris(99,string(GetMagicalDefense(item.CrystalType,item.Enchanted,item.MagicalDefense)),True,True,False,0,0,xxgetInstanceL2Util().BrightWhite,xxgetInstanceL2Util().ColorYellow);
					}
					AddTooltipItemBonusfaris(item.MagicalDefense,(GetPhysicalDefense(item.CrystalType,item.Enchanted,item.MagicalDefense) - item.MagicalDefense),0,4);
  
				}
				if ( item.Weight == 0 )
				{
					AddTooltipItemOptionfaris(52," 0 ",True,True,False);
				} 

				else 

				{
					AddTooltipItemOptionfaris(52,string(item.Weight),True,True,False);
				}
				AddTooltipRefinery(item);
				break;
			case ITEM_ETCITEM:
				bLargeWidth = True;
				if ( EEtcItemType == 7 )
				{
					if ( item.Damaged == 0 )
					{
						nTmp = 971;
					} 

					else 

					{
						nTmp = 970;
					}
					AddTooltipItemOption2(969,nTmp,True,True,False);
					AddTooltipItemOptionfaris(88,string(item.Enchanted),True,True,False);
				} 

				else 

				{
					if ( EEtcItemType == 15 )
					{
						AddTooltipItemOptionfaris(972,string(item.Enchanted),True,True,False);
					} 

					else 

					{
						if ( EEtcItemType == 13 )
						{
							AddTooltipItemOptionfaris(670,string(item.Blessed),True,True,False);
							AddTooltipItemOptionfaris(671,GetLottoString(item.Enchanted,item.Damaged),True,True,False);
						} 

						else 

						{
							if ( EEtcItemType == 14 )
							{
								AddTooltipItemOptionfaris(670,string(item.Enchanted),True,True,False);
								AddTooltipItemOptionfaris(671,GetRaceTicketString(item.Blessed),True,True,False);
								AddTooltipItemOptionfaris(744,string(item.Damaged * 100),True,True,False);
							}
						}
					}
				}
				if ( item.Weight == 0 )
				{
					AddTooltipItemOptionfaris(52," 0 ",True,True,False);
				} 

				else 

				{
					if ( item.ItemNum > 1 )
					{
						AddTooltipItemOptionfaris(52,string(item.Weight * item.ItemNum),True,True,False);
					} 

					else 

					{
						AddTooltipItemOptionfaris(52,string(item.Weight),True,True,False);
					}
				}
				break;
			default:
		}
		AddTooltipItemDurability(item);
		xxsettier(item,False);
		addDescTooltip(item);
		addSetitemTooltip(item);
		xxAcquire(item);
		addTooltipID(item);
	} 

	else 

	{
		return;
	}
	if ( bLargeWidth )
	{
		zzDeobfuscated4592.MinimumWidth = 250;
	}
		
	ReturnTooltipInfo(zzDeobfuscated4592);
}


function addItemIconSetitem(ItemInfo item, bool bDisable)
{
	local string disableTex;

    // End:0x30
	if( bDisable )
	{
		disableTex = "l2ui_ch3.ItemWindow_IconDisable";
	}
	addItemIconCustom(item, "", 26, 26, disableTex, 9, 2);
	return;
}


function addItemIconCustom(ItemInfo item, string ForeTexture, int iconWidth, int iconHeight, optional string DisableTexture, optional int FirstX, optional int FirstY)
{
	StartItem();
	zzDeobfuscated2336.eType = DIT_TEXTURE;
	zzDeobfuscated2336.u_nTextureWidth = iconWidth;
	zzDeobfuscated2336.u_nTextureHeight = iconHeight;
	zzDeobfuscated2336.u_nTextureUWidth = 32;
	zzDeobfuscated2336.u_nTextureUHeight = 32;
	zzDeobfuscated2336.nOffSetX = FirstX;
	zzDeobfuscated2336.nOffSetY = FirstY;
	zzDeobfuscated2336.u_strTexture = item.IconName;
	EndItem();
	StartItem();
	zzDeobfuscated2336.eType = DIT_TEXTURE;
	zzDeobfuscated2336.u_nTextureWidth = iconWidth;
	zzDeobfuscated2336.u_nTextureHeight = iconHeight;
	zzDeobfuscated2336.u_nTextureUWidth = 32;
	zzDeobfuscated2336.u_nTextureUHeight = 32;
	zzDeobfuscated2336.nOffSetX = -iconWidth;
	zzDeobfuscated2336.nOffSetY = FirstY;
	zzDeobfuscated2336.u_strTexture = item.IconName;
	EndItem();
    // End:0x1A3
	if( ForeTexture != "" )
	{
		StartItem();
		zzDeobfuscated2336.eType = DIT_TEXTURE;
		zzDeobfuscated2336.u_nTextureWidth = iconWidth;
		zzDeobfuscated2336.u_nTextureHeight = iconHeight;
		zzDeobfuscated2336.u_nTextureUWidth = 32;
		zzDeobfuscated2336.u_nTextureUHeight = 32;
		zzDeobfuscated2336.nOffSetX = -iconWidth;
		zzDeobfuscated2336.nOffSetY = FirstY;
		zzDeobfuscated2336.u_strTexture = ForeTexture;
		EndItem();
	}
    // End:0x234
	if( DisableTexture != "" )
	{
		StartItem();
		zzDeobfuscated2336.eType = DIT_TEXTURE;
		zzDeobfuscated2336.u_nTextureWidth = iconWidth;
		zzDeobfuscated2336.u_nTextureHeight = iconHeight;
		zzDeobfuscated2336.u_nTextureUWidth = 32;
		zzDeobfuscated2336.u_nTextureUHeight = 32;
		zzDeobfuscated2336.nOffSetX = -iconWidth;
		zzDeobfuscated2336.nOffSetY = FirstY;
		zzDeobfuscated2336.u_strTexture = DisableTexture;
		EndItem();
	}
	return;
}


function addTooltipID (ItemInfo item)
{
	AddCrossLine();
    AddTooltipColorText("Endurance : " $ string(item.CurrentDurability) $ " || L2Evolution", getAColor(176, 155, 121, 255), true, true,, "", 2);
}



function addSetitemTooltip (ItemInfo item)
{
	local int idx;
	local string strTmp;
	local int ClassID;
	local int SetID;
	local array<int> arrID;
	local bool bLargeWidth;

	if ( item.ClassID > 0 )
	{
		AddTooltipItemBlank(3);
		idx = 0;
		while ( idx < 3 )
		{
			Class'UIDATA_ITEM'.static.GetSetItemIDList(item.ClassID,idx,arrID);
			SetID = 0;
			while ( SetID < arrID.Length )
			{
				bLargeWidth = True;
				ClassID = arrID[SetID];
				if ( item.ClassID != ClassID )
				{
					strTmp = Class'UIDATA_ITEM'.static.GetItemName(ClassID);
					if ( Len(strTmp) > 0 )
					{
						StartItem();
						zzDeobfuscated2336.eType = DIT_TEXTURE;
						zzDeobfuscated2336.nOffSetX = 3;
						zzDeobfuscated2336.nOffSetY = 4;
						zzDeobfuscated2336.bLineBreak = True;
						zzDeobfuscated2336.t_bDrawOneLine = True;
						zzDeobfuscated2336.u_nTextureWidth = 18;
						zzDeobfuscated2336.u_nTextureHeight = 18;
						zzDeobfuscated2336.u_nTextureUWidth = 18;
						zzDeobfuscated2336.u_nTextureUHeight = 18;
						zzDeobfuscated2336.u_strTexture = "L2UI_CH3.Tooltip.lifeBG";
						EndItem();
						StartItem();
						zzDeobfuscated2336.eType = DIT_TEXTURE;
						zzDeobfuscated2336.nOffSetX = -17;
						zzDeobfuscated2336.nOffSetY = 5;
						zzDeobfuscated2336.t_bDrawOneLine = True;
						zzDeobfuscated2336.u_nTextureWidth = 16;
						zzDeobfuscated2336.u_nTextureHeight = 16;
						zzDeobfuscated2336.u_nTextureUWidth = 32;
						zzDeobfuscated2336.u_nTextureUHeight = 32;
						zzDeobfuscated2336.u_strTexture = Class'UIDATA_ITEM'.static.GetItemTextureName(ClassID);
						EndItem();
						StartItem();
						zzDeobfuscated2336.eType = DIT_TEXT;
						zzDeobfuscated2336.nOffSetX = 5;
						zzDeobfuscated2336.nOffSetY = 6;
						zzDeobfuscated2336.t_bDrawOneLine = True;
						zzDeobfuscated2336.t_color.R = 100;
						zzDeobfuscated2336.t_color.G = 100;
						zzDeobfuscated2336.t_color.B = 65;
						zzDeobfuscated2336.t_color.A = 255;
						zzDeobfuscated2336.t_strText = strTmp;
						ParamAdd(zzDeobfuscated2336.Condition,"Type","Equip");
						ParamAdd(zzDeobfuscated2336.Condition,"ServerID",string(item.ServerID));
						ParamAdd(zzDeobfuscated2336.Condition,"EquipID",string(ClassID));
						ParamAdd(zzDeobfuscated2336.Condition,"NormalColor","100,100,65");
						ParamAdd(zzDeobfuscated2336.Condition,"EnableColor","255,250,160");
						EndItem();
						AddTooltipItemBlank(1);
					}
				}

                // End:0x370
				if( SetID == (arrID.Length - 1) )
				{
					xxsettier(item, True);
				}

				SetID++;
        
			}
			strTmp = Class'UIDATA_ITEM'.static.GetSetItemEffectDescription(item.ClassID,idx);
			if ( Len(strTmp) > 0 )
			{
				xxarmorstatus(strTmp);
				bLargeWidth = True;
				StartItem();
				zzDeobfuscated2336.eType = DIT_TEXT;
				zzDeobfuscated2336.nOffSetX = 5;
				zzDeobfuscated2336.nOffSetY = 6;
				zzDeobfuscated2336.bLineBreak = True;
				zzDeobfuscated2336.t_color.R = 100;
				zzDeobfuscated2336.t_color.G = 70;
				zzDeobfuscated2336.t_color.B = 0;
				zzDeobfuscated2336.t_color.A = 255;
				zzDeobfuscated2336.t_strText = strTmp;
				ParamAdd(zzDeobfuscated2336.Condition,"Type","SetEffect");
				ParamAdd(zzDeobfuscated2336.Condition,"ServerID",string(item.ServerID));
				ParamAdd(zzDeobfuscated2336.Condition,"ClassID",string(item.ClassID));
				ParamAdd(zzDeobfuscated2336.Condition,"EffectID",string(idx));
				ParamAdd(zzDeobfuscated2336.Condition,"NormalColor","100,70,0");
				ParamAdd(zzDeobfuscated2336.Condition,"EnableColor","255,180,0");
				EndItem();
				AddTooltipItemBlank(2);
				AddCrossLine();
			}
			idx++;
      
		}
		strTmp = Class'UIDATA_ITEM'.static.GetSetItemEnchantEffectDescription(item.ClassID);
		if ( Len(strTmp) > 0 )
		{
			
			bLargeWidth = True;
			StartItem();
			zzDeobfuscated2336.eType = DIT_TEXT;
			zzDeobfuscated2336.nOffSetX = 5;
			zzDeobfuscated2336.nOffSetY = 2;
			zzDeobfuscated2336.bLineBreak = True;
			zzDeobfuscated2336.t_color.R = 74;
			zzDeobfuscated2336.t_color.G = 92;
			zzDeobfuscated2336.t_color.B = 104;
			zzDeobfuscated2336.t_color.A = 255;
			zzDeobfuscated2336.t_strText = strTmp;
			ParamAdd(zzDeobfuscated2336.Condition,"Type","EnchantEffect");
			ParamAdd(zzDeobfuscated2336.Condition,"ServerID",string(item.ServerID));
			ParamAdd(zzDeobfuscated2336.Condition,"ClassID",string(item.ClassID));
			ParamAdd(zzDeobfuscated2336.Condition,"NormalColor","74,92,104");
			ParamAdd(zzDeobfuscated2336.Condition,"EnableColor","110,140,170");
			EndItem();
		}
	}
}














function addDescTooltip(ItemInfo zzitem)
{
	local string zzparam;
	local array<int> zzarrid;

	Class'UIDATA_ITEM'.static.GetSetItemIDList(zzitem.ClassID, 0, zzarrid);
    // End:0x50
	if( zzarrid.Length > 0 )
	{
		AddTooltipItemBlank(4);
		AddTitleIconWithHeadLine("setBG", "Armor Set", "");        
	}
	else
	{
        // End:0x192
		if( InStr(zzitem.Description, "<Soul Crystal Enhancement>") > -1 )
		{
			AddTooltipItemBlank(4);
			AddTitleIconWithHeadLine("SaBG", "Special Ability"$": ", zzitem.AdditionalName);
            // End:0x126
			if( InStr(zzitem.Description, "<Soul Crystal Enhancement>\n ") > -1 )
			{
				zzparam = replace(zzitem.Description, "<Soul Crystal Enhancement>\n ", "");                
			}
			else
			{
				zzparam = replace(zzitem.Description, "<Soul Crystal Enhancement>\n", "");
			}
			AddTooltipItemBlank(4);
			xxlistkua2(zzparam);
			AddTooltipColorTextfaris(zzparam, GetColortool(110, 140, 160, 255), True, False, False, "", 2);            
		}
		else
		{
            // End:0x23A
			if( InStr(zzitem.Description, "<Enchant Chance>") > -1 )
			{
				AddCrossLine();
				AddTooltipColorTextfaris(Left(zzitem.Description, InStr(zzitem.Description, "<Enchant Chance>")), GetColortool(178, 190, 207, 255), True, False);
				AddTooltipItemBlank(4);
				AddTitleIconWithHeadLine("", "Enchant", "Chance of Success");
				xxlkia(zzitem);                
			}
			else
			{
                // End:0x2CF
				if( Len(zzitem.Description) > 1 )
				{
                    // End:0x26E
					if( Left(zzitem.Description, 5) != "Tier:" )
					{
						AddTooltipItemBlank(2);
					}
                    // End:0x289
					if( !xxlistkua2(zzitem.Description) )
					{
						AddCrossLine();
					}
                    // End:0x2CF
					if( zzitem.Description != "" )
					{
						AddTooltipColorTextfaris(setItemDecWidth(zzitem.Description, (xxlikua()) - 4), GetColortool(178, 190, 207, 255), True, False, False, "", 2);
					}
				}
			}
		}
	}
	return;

}

function xxAcquire(ItemInfo zzinfo)
{
	local int zzidka;
	local string zzparamkaa;

	zzidka = xxdescar("Acquire:{", zzinfo.Description);
    // End:0x2E
	if( zzidka <= 0 )
	{
		return;
	}
	zzparamkaa = Mid(zzinfo.Description, zzidka, InStr(zzinfo.Description, "}") - 9);
    // End:0x66
	if( zzparamkaa == "" )
	{
		return;
	}
	AddCrossLine();
	AddTooltipColorTextfaris(setItemDecWidth(zzparamkaa, (xxlikua()) - 4), xxgetInstanceL2Util().Gold, True, False,, "", 2);
	return;
}

function xxarmorstatus(out string zzparam)
{
	local int zzkila2;

	zzkila2 = InStr(zzparam, "ArmorStatus:");
    // End:0x2C
	if( zzkila2 == -1 )
	{
		return;
	}
	AddTooltipItemBlank(8);
	AddTitleIconWithHeadLine("lvBG", "Armor S Grade"$": ", ("Level"$" ")$Mid(zzparam, zzkila2 + 12, 1));
	xxlistkua2(zzparam);
	return;
}


function xxlkia(ItemInfo zzinfo)
{
	local int zzinktea, zzksajiak, zzlksuaka;
	local string zzparamasa, zzdwakkas2, zzksamap2;

	zzinktea = 0;
J0x07:

    // End:0x1D6 [Loop If]
	if( zzinktea < 10 )
	{
		zzksajiak = InStr(zzinfo.Description, ("["$string(zzinktea))$"]");
        // End:0x1CC
		if( zzksajiak > -1 )
		{
			zzlksuaka = InStr(zzinfo.Description, ("["$string(zzinktea + 1))$"]");
            // End:0x132
			if( zzlksuaka > -1 )
			{
				zzparamasa = Mid(zzinfo.Description, zzksajiak + 3, (zzlksuaka - zzksajiak) - 3);
				zzdwakkas2 = Left(zzparamasa, InStr(zzparamasa, "*"));
				zzksamap2 = Mid(zzparamasa, InStr(zzparamasa, "*") + 1);
				AddTooltipColorTextfaris(zzdwakkas2, GetColortool(178, 190, 207, 255), True, False, False, "", 10, 3);
				AddTooltipColorTextfaris(zzksamap2, GetColortool(68, 255, 0, 255), False, False, False, "", (xxlikua()) - 185, 3);
				AddTooltipItemBlank(2);
				AddCrossLine();
                // [Explicit Continue]
				goto J0x1CC;
			}
			zzparamasa = Mid(zzinfo.Description, zzksajiak + 3);
			zzdwakkas2 = Left(zzparamasa, InStr(zzparamasa, "*"));
			zzksamap2 = Mid(zzparamasa, InStr(zzparamasa, "*") + 1);
			AddTooltipColorTextfaris(zzdwakkas2, GetColortool(178, 190, 207, 255), True, False, False, "", 10, 3);
			AddTooltipColorTextfaris(zzksamap2, GetColortool(68, 255, 0, 255), False, False, False, "", (xxlikua()) - 185, 3);
            // [Explicit Break]
			goto J0x1D6;
		}
	J0x1CC:

		zzinktea++;
        // [Loop Continue]
		goto J0x07;
	}
J0x1D6:

	return;

}






function AddTooltipItemDurability (ItemInfo item)
{
	local Color tempColor;

	if ( (item.CurrentDurability >= 0) && (item.Durability > 0) )
	{
		AddTooltipItemBlank(4);
		AddTooltipItemOption(1492,"",True,False,False);
		SetTooltipItemColor(255,255,255,0);
		AddTooltipColorText(GetSystemString(1493),GetColortool(163,163,163,255),True,True);
		if ( item.CurrentDurability <= (1 + 5) )

		{
			tempColor = GetColortool(255,0,0,255);
		} 

		else 

		{
			tempColor = GetColortool(176,155,121,255);
		}
		AddTooltipColorText(" "$string(item.CurrentDurability)$"/"$string(item.Durability), tempColor, False, True);
		
		AddTooltipItemBlank(4);
	}
}





function AddTooltipItemOptionfaris (int TitleID, string Content, bool bTitle, bool bContent, bool isFirstLine, optional int offsetX, optional int offsetY, optional Color titleTextColor, optional Color contentTextColor)
{
	if ( bTitle )
	{
		StartItem();
		zzDeobfuscated2336.eType = DIT_TEXT;
		if ( !isFirstLine )
		{
			zzDeobfuscated2336.nOffSetY = 4;
		}
		zzDeobfuscated2336.bLineBreak = True;
		zzDeobfuscated2336.t_bDrawOneLine = True;
		if ( (titleTextColor.R == 0) && (titleTextColor.G == 0) && (titleTextColor.B == 0) && (titleTextColor.A == 0) )
		{
			zzDeobfuscated2336.t_color.R = 163;
			zzDeobfuscated2336.t_color.G = 163;
			zzDeobfuscated2336.t_color.B = 163;
			zzDeobfuscated2336.t_color.A = 255;
		} 

		else 

		{
			zzDeobfuscated2336.t_color = titleTextColor;
		}
		zzDeobfuscated2336.nOffSetX = (zzDeobfuscated2336.nOffSetX + offsetX);
		zzDeobfuscated2336.nOffSetY = (zzDeobfuscated2336.nOffSetY + offsetY);
		zzDeobfuscated2336.t_ID = TitleID;
		EndItem();
	}
	if ( Content != "0" )
	{
		if ( bContent )
		{
			if ( bTitle )
			{
				StartItem();
				zzDeobfuscated2336.eType = DIT_TEXT;
				if ( !isFirstLine )
				{
					zzDeobfuscated2336.nOffSetY = 4;
				}
				zzDeobfuscated2336.t_bDrawOneLine = True;
				if ( (titleTextColor.R == 0) && (titleTextColor.G == 0) && (titleTextColor.B == 0) && (titleTextColor.A == 0) )
				{
					zzDeobfuscated2336.t_color.R = 163;
					zzDeobfuscated2336.t_color.G = 163;
					zzDeobfuscated2336.t_color.B = 163;
					zzDeobfuscated2336.t_color.A = 255;
				} 

				else 

				{
					zzDeobfuscated2336.t_color = titleTextColor;
				}
				zzDeobfuscated2336.nOffSetX = (zzDeobfuscated2336.nOffSetX + offsetX);
				zzDeobfuscated2336.nOffSetY = (zzDeobfuscated2336.nOffSetY + offsetY);
				zzDeobfuscated2336.t_strText = " : ";
				EndItem();
			}
			StartItem();
			zzDeobfuscated2336.eType = DIT_TEXT;
			if ( !isFirstLine )
			{
				zzDeobfuscated2336.nOffSetY = 4;
			}
			if ( !bTitle )
			{
				zzDeobfuscated2336.bLineBreak = True;
			}
			zzDeobfuscated2336.t_bDrawOneLine = True;
			if ( (contentTextColor.R == 0) && (contentTextColor.G == 0) && (contentTextColor.B == 0) && (contentTextColor.A == 0) )
			{
				zzDeobfuscated2336.t_color.R = 176;
				zzDeobfuscated2336.t_color.G = 155;
				zzDeobfuscated2336.t_color.B = 121;
				zzDeobfuscated2336.t_color.A = 255;
			} 

			else 

			{
				zzDeobfuscated2336.t_color = contentTextColor;
			}
			zzDeobfuscated2336.nOffSetX = (zzDeobfuscated2336.nOffSetX + offsetX);
			zzDeobfuscated2336.nOffSetY = (zzDeobfuscated2336.nOffSetY + offsetY);
			zzDeobfuscated2336.t_strText = Content;
			EndItem();
		}
	}
}



function ReturnTooltip_NTT_ACTION (string param, ETooltipSourceType eSourceType)
{
	local ItemInfo item;

	if ( eSourceType == 1 )
	{
		ParamToItemInfo(param,item);
		addItemIcon(item,"");
		StartItem();
		zzDeobfuscated2336.eType = DIT_TEXT;
		zzDeobfuscated2336.t_bDrawOneLine = True;
		zzDeobfuscated2336.nOffSetX = 5;
		zzDeobfuscated2336.nOffSetY = 0;
		zzDeobfuscated2336.t_strText = item.Name;
		EndItem();
		AddTooltipItemBlank(4);
		if ( (Len(item.Description) > 0) )
		{
			zzDeobfuscated4592.MinimumWidth = 250;
			StartItem();
			zzDeobfuscated2336.eType = DIT_TEXT;
			zzDeobfuscated2336.nOffSetY = 4;
			zzDeobfuscated2336.t_bDrawOneLine = False;
			zzDeobfuscated2336.bLineBreak = True;
			zzDeobfuscated2336.t_color.R = 178;
			zzDeobfuscated2336.t_color.G = 190;
			zzDeobfuscated2336.t_color.B = 207;
			zzDeobfuscated2336.t_color.A = 255;
			zzDeobfuscated2336.t_strText = item.Description;
			EndItem();
		}
	} 

	else 

	{
		return;
	}
	ReturnTooltipInfo(zzDeobfuscated4592);
}




function bool isBuffSellable(ItemInfo Item)
{
	local int _skillId;
	local int _skillLevel;
	local String _name;
	local String _description;
	local String _additionalName;
	local color	_adenaColor;
	local int _temp;
	
	if ( Item.ClassId < 10000 )
		return False;

	_skillId = Item.ClassId - 10000;
	_skillLevel = Item.Enchanted;
	if ( Item.Enchanted >= 100 )
		_skillLevel = class'UIDATA_SKILL'.static.GetEnchantSkillLevel(_skillId, Item.Enchanted);
	
	_name = class'UIDATA_SKILL'.static.GetName(_skillId, Item.Enchanted);
	_description = class'UIDATA_SKILL'.static.GetDescription(_skillId, Item.Enchanted);
	_additionalName = class'UIDATA_SKILL'.static.GetEnchantName(_skillId, Item.Enchanted);
	
	//Lv 'X'
	StartItem();
	zzDeobfuscated2336.eType = DIT_TEXT;
	zzDeobfuscated2336.t_bDrawOneLine = True;
	zzDeobfuscated2336.t_color.R = 176;
	zzDeobfuscated2336.t_color.G = 155;
	zzDeobfuscated2336.t_color.B = 121;
	zzDeobfuscated2336.t_color.A = 255;
	zzDeobfuscated2336.t_strText = "Lv "$_skillLevel$" ";
	EndItem();
	
	StartItem();
	zzDeobfuscated2336.eType = DIT_TEXT;
	zzDeobfuscated2336.t_bDrawOneLine = True;
	zzDeobfuscated2336.t_strText = _name;
	EndItem();
	
	//if (Len(_additionalName) > 0)
	//{
	//	StartItem();
	//	m_Info.eType = DIT_TEXT;
	//	m_Info.t_bDrawOneLine = true;
	//	m_Info.t_color.R = 255;
	//	m_Info.t_color.G = 217;
	//	m_Info.t_color.B = 105;
	//	m_Info.t_color.A = 255;
	//	m_Info.t_strText = " " $ _additionalName;
	//	EndItem();
	//}
	
	//HP Consumption
	_temp = class'UIDATA_SKILL'.static.GetHpConsume(_skillId, Item.Enchanted);
	if ( _temp > 0 )
		AddTooltipItemOption(1195, String(_temp), True, True, False);
		
	//MP Consumption
	_temp = class'UIDATA_SKILL'.static.GetMpConsume(_skillId, Item.Enchanted);
	if ( _temp > 0 )
		AddTooltipItemOption(320, String(_temp), True, True, False);
	
	//Description
	if ( Len(_description) > 0 )
	{
		StartItem();
		zzDeobfuscated2336.eType = DIT_TEXT;
		zzDeobfuscated2336.nOffSetY = 6;
		zzDeobfuscated2336.bLineBreak = True;
		zzDeobfuscated2336.t_color.R = 178;
		zzDeobfuscated2336.t_color.G = 190;
		zzDeobfuscated2336.t_color.B = 207;
		zzDeobfuscated2336.t_color.A = 255;
		zzDeobfuscated2336.t_strText = _description;
		EndItem();	
	}	
	
	if ( Item.Price > 0 )
	{
		_adenaColor = GetNumericColor(MakeCostString(String(Item.Price)));
				
		//Price: For each
		AddTooltipItemOption2(322, 468, True, True, False);
		SetTooltipItemColor(_adenaColor.R, _adenaColor.G, _adenaColor.B, 0);
				
		//"xxx,xxx,xxx "
		StartItem();
		zzDeobfuscated2336.eType = DIT_TEXT;
		zzDeobfuscated2336.nOffSetY = 6;
		zzDeobfuscated2336.t_bDrawOneLine = True;
		zzDeobfuscated2336.t_color = _adenaColor;
		zzDeobfuscated2336.t_strText = " "$MakeCostString(String(Item.Price))$" Adena";
		EndItem();
	}
	zzDeobfuscated4592.MinimumWidth = 200;
	ReturnTooltipInfo(zzDeobfuscated4592);
	return True;
}







function ReturnTooltip_NTT_SKILL_FARIS (string param, ETooltipSourceType eSourceType)
{
	local ItemInfo item;
	local EItemParamType EItemParamType;
	local int nTmp;
	local int SkillLevel;
	local SkillInfo SkillInfo;

	if ( eSourceType == 1 )
	{
		ParseString(param,"Name",item.Name);
		ParseString(param,"AdditionalName",item.AdditionalName);
		ParseString(param,"Description",item.Description);
		ParseInt(param,"ClassID",item.ClassID);
		ParseInt(param,"Level",item.Level);
		GetSkillInfo(item.ClassID,item.Level,SkillInfo);
		item.IconName = Class'UIDATA_SKILL'.static.GetIconName(item.ClassID,item.Level);
		EItemParamType = EItemParamType(item.ItemType);
		SkillLevel = item.Level;
		zzDeobfuscated4592.MinimumWidth = 250;
		addItemIcon(item,"");
		StartItem();
		zzDeobfuscated2336.eType = DIT_TEXT;
		zzDeobfuscated2336.t_bDrawOneLine = True;
		zzDeobfuscated2336.nOffSetX = 5;
		zzDeobfuscated2336.t_strText = item.Name;
		EndItem();
		if ( (Len(item.AdditionalName) > 0) )
		{
			StartItem();
			zzDeobfuscated2336.eType = DIT_TEXT;
			zzDeobfuscated2336.nOffSetX = 5;
			zzDeobfuscated2336.t_bDrawOneLine = True;
			zzDeobfuscated2336.t_color.R = 255;
			zzDeobfuscated2336.t_color.G = 217;
			zzDeobfuscated2336.t_color.B = 105;
			zzDeobfuscated2336.t_color.A = 255;
			zzDeobfuscated2336.t_strText = item.AdditionalName;
			SkillLevel = Class'UIDATA_SKILL'.static.GetEnchantSkillLevel(item.ClassID,item.Level);
			EndItem();
		}
		StartItem();
		zzDeobfuscated2336.eType = DIT_TEXT;
		zzDeobfuscated2336.t_bDrawOneLine = True;
		zzDeobfuscated2336.t_strText = " ";
		EndItem();
		StartItem();
		zzDeobfuscated2336.eType = DIT_TEXT;
		zzDeobfuscated2336.t_bDrawOneLine = True;
		zzDeobfuscated2336.t_color.R = 163;
		zzDeobfuscated2336.t_color.G = 163;
		zzDeobfuscated2336.t_color.B = 163;
		zzDeobfuscated2336.t_color.A = 255;
		zzDeobfuscated2336.t_ID = 88;
		EndItem();
		StartItem();
		zzDeobfuscated2336.eType = DIT_TEXT;
		zzDeobfuscated2336.t_bDrawOneLine = True;
		zzDeobfuscated2336.t_color.R = 176;
		zzDeobfuscated2336.t_color.G = 155;
		zzDeobfuscated2336.t_color.B = 121;
		zzDeobfuscated2336.t_color.A = 255;
		zzDeobfuscated2336.t_strText = (" "$string(SkillLevel));
		EndItem();
		AddTooltipItemBlank(1);
		AddTooltipColorText(Class'UIDATA_SKILL'.static.GetOperateType(item.ClassID,item.Level),GetColortool(176,155,121,255),True,True,False,"",38, -19);
		nTmp = Class'UIDATA_SKILL'.static.GetHpConsume(item.ClassID,item.Level);
		if ( nTmp > 0 )
		{
			AddTooltipItemOptionfaris(1195,string(nTmp),True,True,False);
		}
		nTmp = Class'UIDATA_SKILL'.static.GetMpConsume(item.ClassID,item.Level);
		if ( nTmp > 0 )
		{
			AddTooltipItemOptionfaris(320,string(nTmp),True,True,False,0,0,xxgetInstanceL2Util().BrightWhite,xxgetInstanceL2Util().ColorYellow);
		}
		nTmp = Class'UIDATA_SKILL'.static.GetCastRange(item.ClassID,item.Level);
		if ( nTmp >= 0 )
		{
			AddTooltipItemOptionfaris(321,string(nTmp),True,True,False);
		}
		if ( (Len(item.Description) > 0) )
		{
			AddTooltipItemBlank(4);
			AddCrossLine();
			AddTooltipItemBlank(4);
			AddTooltipColorText(item.Description,GetColortool(178,190,207,255),True,False);

			AddTooltipItemBlank(4);
		}
		if ( (Len(item.AdditionalName) > 0) )
		{
			AddCrossLine();
			AddTooltipColorText((GetSystemString(1553)$" : "),GetColortool(163,163,163,255),True,False);
			AddTooltipColorText(item.AdditionalName,GetColortool(255,217,105,255),False,True);
			AddTooltipItemBlank(2);
			AddTooltipColorText(SkillInfo.EnchantDesc,GetColortool(178,190,207,255),True,False);
		}
		addTooltipID(item);
	} 

	else 

	{
		return;
	}
	ReturnTooltipInfo(zzDeobfuscated4592);
}





function ReturnTooltip_NTT_ABNORMALSTATUS (string param, ETooltipSourceType eSourceType)
{
	local ItemInfo item;
	local SkillInfo SkillInfo;
	local int ShowLevel;
	local EItemParamType EItemParamType;

	if ( eSourceType == 1 )
	{
		ParseInt(param,"ClassID",item.ClassID);
		ParseString(param,"Name",item.Name);
		ParseString(param,"AdditionalName",item.AdditionalName);
		ParseString(param,"Description",item.Description);
		ParseInt(param,"Level",item.Level);
		ParseInt(param,"Reserved",item.Reserved);
		EItemParamType = EItemParamType(item.ItemType);
		GetSkillInfo(item.ClassID,item.Level,SkillInfo);
		item.IconName = Class'UIDATA_SKILL'.static.GetIconName(item.ClassID,item.Level);
		zzDeobfuscated4592.MinimumWidth = 250;
		addItemIcon(item,"");
		StartItem();
		zzDeobfuscated2336.eType = DIT_TEXT;
		zzDeobfuscated2336.t_bDrawOneLine = True;
		zzDeobfuscated2336.nOffSetX = 5;
		zzDeobfuscated2336.t_strText = item.Name;
		EndItem();
		if ( (Len(item.AdditionalName) > 0) )
		{
			StartItem();
			zzDeobfuscated2336.eType = DIT_TEXT;
			zzDeobfuscated2336.nOffSetX = 5;
			zzDeobfuscated2336.t_bDrawOneLine = True;
			zzDeobfuscated2336.t_color.R = 255;
			zzDeobfuscated2336.t_color.G = 217;
			zzDeobfuscated2336.t_color.B = 105;
			zzDeobfuscated2336.t_color.A = 255;
			zzDeobfuscated2336.t_strText = item.AdditionalName;
			EndItem();
			item.Level = Class'UIDATA_SKILL'.static.GetEnchantSkillLevel(item.ClassID,item.Level);
		}
		ShowLevel = item.Level;
		StartItem();
		zzDeobfuscated2336.eType = DIT_TEXT;
		zzDeobfuscated2336.t_bDrawOneLine = True;
		zzDeobfuscated2336.t_strText = " ";
		EndItem();
		StartItem();
		zzDeobfuscated2336.eType = DIT_TEXT;
		zzDeobfuscated2336.t_bDrawOneLine = True;
		zzDeobfuscated2336.t_color.R = 163;
		zzDeobfuscated2336.t_color.G = 163;
		zzDeobfuscated2336.t_color.B = 163;
		zzDeobfuscated2336.t_color.A = 255;
		zzDeobfuscated2336.t_ID = 88;
		EndItem();
		StartItem();
		zzDeobfuscated2336.eType = DIT_TEXT;
		zzDeobfuscated2336.t_bDrawOneLine = True;
		zzDeobfuscated2336.t_color.R = 176;
		zzDeobfuscated2336.t_color.G = 155;
		zzDeobfuscated2336.t_color.B = 121;
		zzDeobfuscated2336.t_color.A = 255;
		zzDeobfuscated2336.t_strText = (" "$string(ShowLevel));
		EndItem();
		if ( (item.Reserved >= 0) && !(IsDebuff(item.ClassID,item.Level)) )
		{
			StartItem();
			zzDeobfuscated2336.eType = DIT_TEXT;
			zzDeobfuscated2336.bLineBreak = True;
			zzDeobfuscated2336.t_bDrawOneLine = True;
			zzDeobfuscated2336.nOffSetX = 39;
			zzDeobfuscated2336.nOffSetY = -15;
			zzDeobfuscated2336.t_color.R = 163;
			zzDeobfuscated2336.t_color.G = 163;
			zzDeobfuscated2336.t_color.B = 163;
			zzDeobfuscated2336.t_color.A = 255;
			zzDeobfuscated2336.t_ID = 1199;
			EndItem();
			StartItem();
			zzDeobfuscated2336.eType = DIT_TEXT;
			zzDeobfuscated2336.t_bDrawOneLine = True;
			zzDeobfuscated2336.nOffSetY = -15;
			zzDeobfuscated2336.t_color.R = 163;
			zzDeobfuscated2336.t_color.G = 163;
			zzDeobfuscated2336.t_color.B = 163;
			zzDeobfuscated2336.t_color.A = 255;
			zzDeobfuscated2336.t_strText = " : ";
			EndItem();
			StartItem();
			zzDeobfuscated2336.eType = DIT_TEXT;
			zzDeobfuscated2336.t_bDrawOneLine = True;
			zzDeobfuscated2336.nOffSetY = -15;
			zzDeobfuscated2336.t_color.R = 255;
			zzDeobfuscated2336.t_color.G = 221;
			zzDeobfuscated2336.t_color.B = 102;
			zzDeobfuscated2336.t_color.A = 255;
			zzDeobfuscated2336.t_strText = MakeBuffTimeStr(item.Reserved);
			ParamAdd(zzDeobfuscated2336.Condition,"Type","RemainTime");
			EndItem();
		}
		if ( (Len(item.Description) > 0) )
		{
			StartItem();
			zzDeobfuscated2336.eType = DIT_TEXT;
			zzDeobfuscated2336.nOffSetY = 4;
			zzDeobfuscated2336.bLineBreak = True;
			zzDeobfuscated2336.t_color.R = 178;
			zzDeobfuscated2336.t_color.G = 190;
			zzDeobfuscated2336.t_color.B = 207;
			zzDeobfuscated2336.t_color.A = 255;
			zzDeobfuscated2336.t_strText = item.Description;
  
			EndItem();
		}
		if ( (Len(item.AdditionalName) > 0) )
		{
			AddCrossLine();
			AddTooltipColorText((GetSystemString(1553)$" : "),GetColortool(163,163,163,255),True,False);
			AddTooltipColorText(item.AdditionalName,GetColortool(255,217,105,255),False,True);
			AddTooltipItemBlank(2);
			AddTooltipColorText(SkillInfo.EnchantDesc,GetColortool(178,190,207,255),True,False);
		}
		addTooltipID(item);
	} 

	else 

	{
		return;
	}
	ReturnTooltipInfo(zzDeobfuscated4592);
}



function ReturnTooltip_NTT_NORMALITEM (string index, ETooltipSourceType eSourceType)
{
	local ItemInfo item;

	if ( eSourceType == 1 )
	{
		ParseString(index,"Name",item.Name);
		ParseString(index,"Description",item.Description);
		ParseString(index,"AdditionalName",item.AdditionalName);
		ParseInt(index,"CrystalType",item.CrystalType);
		AddTooltipItemNamefaris(item.Name,item,1);
		AddTooltipItemGradefaris(item);
		if ( Len(item.Description) > 0 )
		{
			zzDeobfuscated4592.MinimumWidth = 250;
			StartItem();
			zzDeobfuscated2336.eType = DIT_TEXT;
			zzDeobfuscated2336.nOffSetY = 4;
			zzDeobfuscated2336.bLineBreak = True;
			zzDeobfuscated2336.t_color.R = 178;
			zzDeobfuscated2336.t_color.G = 190;
			zzDeobfuscated2336.t_color.B = 207;
			zzDeobfuscated2336.t_color.A = 255;
			zzDeobfuscated2336.t_strText = item.Description;
			EndItem();
		}
	} 
	else 
	{
		return;
	}
	ReturnTooltipInfo(zzDeobfuscated4592);
}


function ReturnTooltip_NTT_RECIPE (string param, ETooltipSourceType eSourceType, bool bShowPrice)
{
	local ItemInfo item;
	local string strAdena;
	local string strAdenaComma;
	local Color AdenaColor;

	if ( eSourceType == 1 )
	{
		ParseString(param,"Name",item.Name);
		ParseString(param,"Description",item.Description);
		ParseString(param,"AdditionalName",item.AdditionalName);
		ParseInt(param,"CrystalType",item.CrystalType);
		ParseInt(param,"Weight",item.Weight);
		ParseInt(param,"Price",item.Price);
		AddTooltipItemNamefaris(item.Name,item,1);
		AddTooltipItemGradefaris(item);
		if ( bShowPrice )
		{
			strAdena = string(item.Price);
			strAdenaComma = MakeCostString(strAdena);
			AdenaColor = GetNumericColor(strAdenaComma);
			AddTooltipItemOptionfaris(641,(strAdenaComma$" "),True,True,False);
			SetTooltipItemColor(AdenaColor.R,AdenaColor.G,AdenaColor.B,0);
			StartItem();
			zzDeobfuscated2336.eType = DIT_TEXT;
			zzDeobfuscated2336.nOffSetY = 6;
			zzDeobfuscated2336.t_bDrawOneLine = True;
			zzDeobfuscated2336.t_color = AdenaColor;
			zzDeobfuscated2336.t_ID = 469;
			EndItem();
			if ( strAdena != "" )
			{
				AddTooltipItemOptionfaris(0,(("("$ConvertNumToText(strAdena))$")"),False,True,False);
				SetTooltipItemColor(AdenaColor.R,AdenaColor.G,AdenaColor.B,0);
			}
		}
		AddTooltipItemOptionfaris(52,string(item.Weight),True,True,False);
		if ( (Len(item.Description) > 0) )
		{
			zzDeobfuscated4592.MinimumWidth = 250;
			StartItem();
			zzDeobfuscated2336.eType = DIT_TEXT;
			zzDeobfuscated2336.nOffSetY = 6;
			zzDeobfuscated2336.bLineBreak = True;
			zzDeobfuscated2336.t_color.R = 178;
			zzDeobfuscated2336.t_color.G = 190;
			zzDeobfuscated2336.t_color.B = 207;
			zzDeobfuscated2336.t_color.A = 255;
			zzDeobfuscated2336.t_strText = item.Description;
			EndItem();
		}
	} 
	else 
	{
		return;
	}
	ReturnTooltipInfo(zzDeobfuscated4592);
}





function ReturnTooltip_NTT_SHORTCUT(string param, ETooltipSourceType eSourceType)
{
	local ItemInfo item;
	local EItemParamType EItemParamType;
	local EShortCutItemType eShortCutType;
	local string ItemName;
	local int shortcutID;

    // End:0x8A8
	if( eSourceType == 1 )
	{
        // End:0x1C2
		if( BoolSelect )
		{
			ParseInt(param, "ItemSubType", item.ItemSubType);
			ParseString(param, "Name", item.Name);
			ParseInt(param, "RefineryOp1", item.RefineryOp1);
			ParseInt(param, "RefineryOp2", item.RefineryOp2);
			eShortCutType = EShortCutItemType(item.ItemSubType);
			ItemName = Class'UIDATA_ITEM'.static.GetRefineryItemName(item.Name, item.RefineryOp1, item.RefineryOp2);
			switch(eShortCutType)
			{
                // End:0x107
				case EShortCutItemType(1):
					ReturnTooltip_NTT_ITEM_FARIS(param, "Inventory", eSourceType, True);
                    // End:0x1A1
					break;
                // End:0x11F
				case EShortCutItemType(3):
					ReturnTooltip_NTT_ACTION(param, eSourceType);
                    // End:0x1A1
					break;
                // End:0x137
				case EShortCutItemType(2):
					ReturnTooltip_NTT_SKILL_FARIS(param, eSourceType);
                    // End:0x1A1
					break;
                // End:0x150
				case EShortCutItemType(4):
					ReturnTooltip_NTT_MACRO(param, eSourceType, True);
                    // End:0x1A1
					break;
                // End:0x19B
				case EShortCutItemType(5):
					zzDeobfuscated4592.MinimumWidth = 250;
					StartItem();
					zzDeobfuscated2336.eType = DIT_TEXT;
					zzDeobfuscated2336.t_bDrawOneLine = True;
					zzDeobfuscated2336.t_strText = ItemName;
					EndItem();
                    // End:0x1A1
					break;
                // End:0xFFFF
				default:
                    // End:0x1A1
					break;
					break;
			}
			ParseInt(param, "ShortcutID", shortcutID);
			return;            
		}
		else
		{
			ParseString(param, "Name", item.Name);
			ParseString(param, "AdditionalName", item.AdditionalName);
			ParseInt(param, "ClassID", item.ClassID);
			ParseInt(param, "Level", item.Level);
			ParseInt(param, "Reserved", item.Reserved);
			ParseInt(param, "Enchanted", item.Enchanted);
			ParseInt(param, "ItemType", item.ItemType);
			ParseInt(param, "ItemSubType", item.ItemSubType);
			ParseInt(param, "CrystalType", item.CrystalType);
			ParseInt(param, "ConsumeType", item.ConsumeType);
			ParseInt(param, "RefineryOp1", item.RefineryOp1);
			ParseInt(param, "RefineryOp2", item.RefineryOp2);
			ParseInt(param, "ItemNum", item.ItemNum);
			ParseInt(param, "MpConsume", item.MpConsume);
			eShortCutType = EShortCutItemType(item.ItemSubType);
			EItemParamType = EItemParamType(item.ItemType);
			ItemName = Class'UIDATA_ITEM'.static.GetRefineryItemName(item.Name, item.RefineryOp1, item.RefineryOp2);
			switch(eShortCutType)
			{
                // End:0x41F
				case EShortCutItemType(1):
					AddTooltipItemEnchantfaris(item,, 3);
					AddTooltipItemNamefaris(ItemName, item, 1, 3);
					AddTooltipItemGradefaris(item);
					AddTooltipItemCountfaris(item);
                    // End:0x8A5
					break;
                // End:0x73A
				case EShortCutItemType(2):
					StartItem();
					zzDeobfuscated2336.eType = DIT_TEXT;
					zzDeobfuscated2336.t_bDrawOneLine = True;
					zzDeobfuscated2336.t_strText = ItemName;
					EndItem();
                    // End:0x52E
					if( Len(item.AdditionalName) > 0 )
					{
						StartItem();
						zzDeobfuscated2336.eType = DIT_TEXT;
						zzDeobfuscated2336.nOffSetX = 5;
						zzDeobfuscated2336.t_bDrawOneLine = True;
						zzDeobfuscated2336.t_color.R = byte(255);
						zzDeobfuscated2336.t_color.G = 217;
						zzDeobfuscated2336.t_color.B = 105;
						zzDeobfuscated2336.t_color.A = byte(255);
						zzDeobfuscated2336.t_strText = item.AdditionalName;
						item.Level = Class'UIDATA_SKILL'.static.GetEnchantSkillLevel(item.ClassID, item.Level);
						EndItem();
					}
					StartItem();
					zzDeobfuscated2336.eType = DIT_TEXT;
					zzDeobfuscated2336.t_bDrawOneLine = True;
					zzDeobfuscated2336.t_strText = " ";
					EndItem();
					StartItem();
					zzDeobfuscated2336.eType = DIT_TEXT;
					zzDeobfuscated2336.t_bDrawOneLine = True;
					zzDeobfuscated2336.t_color.R = 163;
					zzDeobfuscated2336.t_color.G = 163;
					zzDeobfuscated2336.t_color.B = 163;
					zzDeobfuscated2336.t_color.A = byte(255);
					zzDeobfuscated2336.t_ID = 88;
					EndItem();
					StartItem();
					zzDeobfuscated2336.eType = DIT_TEXT;
					zzDeobfuscated2336.t_bDrawOneLine = True;
					zzDeobfuscated2336.t_color.R = 176;
					zzDeobfuscated2336.t_color.G = 155;
					zzDeobfuscated2336.t_color.B = 121;
					zzDeobfuscated2336.t_color.A = byte(255);
					zzDeobfuscated2336.t_strText = " "$string(item.Level);
					EndItem();
					StartItem();
					zzDeobfuscated2336.eType = DIT_TEXT;
					zzDeobfuscated2336.nOffSetX = -4;
					zzDeobfuscated2336.bLineBreak = True;
					zzDeobfuscated2336.t_bDrawOneLine = True;
					zzDeobfuscated2336.t_strText = " (";
					EndItem();
					StartItem();
					zzDeobfuscated2336.eType = DIT_TEXT;
					zzDeobfuscated2336.t_bDrawOneLine = True;
					zzDeobfuscated2336.t_ID = 91;
					EndItem();
					StartItem();
					zzDeobfuscated2336.eType = DIT_TEXT;
					zzDeobfuscated2336.t_bDrawOneLine = True;
					zzDeobfuscated2336.t_strText = (":"$string(item.MpConsume))$")";
					EndItem();
                    // End:0x8A5
					break;
                // End:0x85C
				case EShortCutItemType(3):
					StartItem();
					zzDeobfuscated2336.eType = DIT_TEXT;
					zzDeobfuscated2336.t_bDrawOneLine = True;
					zzDeobfuscated2336.nOffSetX = 5;
					zzDeobfuscated2336.nOffSetY = 0;
					zzDeobfuscated2336.t_strText = item.Name;
					EndItem();
					AddTooltipItemBlank(4);
                    // End:0x859
					if( Len(item.Description) > 0 )
					{
						zzDeobfuscated4592.MinimumWidth = 250;
						StartItem();
						zzDeobfuscated2336.eType = DIT_TEXT;
						zzDeobfuscated2336.nOffSetY = 4;
						zzDeobfuscated2336.t_bDrawOneLine = False;
						zzDeobfuscated2336.bLineBreak = True;
						zzDeobfuscated2336.t_color.R = 178;
						zzDeobfuscated2336.t_color.G = 190;
						zzDeobfuscated2336.t_color.B = 207;
						zzDeobfuscated2336.t_color.A = byte(255);
						zzDeobfuscated2336.t_strText = item.Description;
						EndItem();
					}
                    // End:0x8A5
					break;
                // End:0x861
				case EShortCutItemType(4):
                // End:0x89F
				case EShortCutItemType(5):
					StartItem();
					zzDeobfuscated2336.eType = DIT_TEXT;
					zzDeobfuscated2336.t_bDrawOneLine = True;
					zzDeobfuscated2336.t_strText = ItemName;
					EndItem();
                    // End:0x8A5
					break;
                // End:0xFFFF
				default:
                    // End:0x8A5
					break;
					break;
			}
		}        
	}
	else
	{
		return;
	}
	ReturnTooltipInfo(zzDeobfuscated4592);
	return;
}






function ReturnTooltip_NTT_MACRO (string param, ETooltipSourceType eSourceType, optional bool bUseUserMacro)
{
	local ItemInfo item;
	local MacroInfo MacroInfo;
	local int idx;
	local array<string> commandArray;
	local bool bCustomMacro;

	if ( eSourceType == 1 )
	{
		ParamToItemInfo(param,item);
		bCustomMacro = Class'UIDATA_MACRO'.static.GetMacroInfo(item.ClassID,MacroInfo);
		if ( (MacroInfo.IconTextureName != "") ) 
			addItemIcon(item,"");
		zzDeobfuscated4592.MinimumWidth = 250;
		AddTooltipText(item.Name,False,True,True,5,1);
		if ( (Len(item.Description) > 0) )
		{
			AddTooltipColorText(item.Description,GetColortool(178,190,207,255),True,False);
		}
		if ( (item.MacroCommand != "") && !(bUseUserMacro) )
		{
    
			idx = 0;
			if ( idx < commandArray.Length )
			{
				if ( commandArray[idx] != "" )
				{
					AddTooltipColorText(commandArray[idx],GetColortool(176,155,121,255),True,True);
				}
				idx++;
        
			}
		} 
		else 
		{
			if ( bCustomMacro )
			{
				idx = 0;
				if ( idx < 12 )
				{
					if ( MacroInfo.CommandList[idx] != "" )
					{
						AddTooltipColorText(MacroInfo.CommandList[idx],GetColortool(176,155,121,255),True,True);
					}
					idx++;
          
				}
			}
		}
	} 
	else 
	{
		return;
	}
	ReturnTooltipInfo(zzDeobfuscated4592);

}

function ReturnTooltip_NTT_RECIPE_MANUFACTURE (string param, ETooltipSourceType eSourceType)
{
	local ItemInfo item;

	if ( eSourceType == 1 )
	{
		ParseString(param,"Name",item.Name);
		ParseString(param,"Description",item.Description);
		ParseString(param,"AdditionalName",item.AdditionalName);
		ParseInt(param,"Reserved",item.Reserved);
		ParseInt(param,"CrystalType",item.CrystalType);
		ParseInt(param,"ItemNum",item.ItemNum);
		zzDeobfuscated4592.MinimumWidth = 250;
		AddTooltipItemNamefaris(item.Name,item,1);
		AddTooltipItemGradefaris(item);
		AddTooltipItemOptionfaris(736,string(item.Reserved),True,True,False);
		AddTooltipItemOptionfaris(737,string(item.ItemNum),True,True,False);
		if ( (Len(item.Description) > 0) )
		{
			StartItem();
			zzDeobfuscated2336.eType = DIT_TEXT;
			zzDeobfuscated2336.nOffSetY = 6;
			zzDeobfuscated2336.bLineBreak = True;
			zzDeobfuscated2336.t_color.R = 178;
			zzDeobfuscated2336.t_color.G = 190;
			zzDeobfuscated2336.t_color.B = 207;
			zzDeobfuscated2336.t_color.A = 255;
			zzDeobfuscated2336.t_strText = item.Description;
			EndItem();
		}
	} 
	else 
	{
		return;
	}
	ReturnTooltipInfo(zzDeobfuscated4592);
}

function ReturnTooltip_NTT_CLANINFO (string index, ETooltipSourceType eSourceType)
{
	local LVDataRecord Deobfuscated2965;

	if ( eSourceType == 2 )
	{
		ParamToRecord(index,Deobfuscated2965);
		AddTooltipItemOption(391,GetClassType(int(Deobfuscated2965.LVDataList[2].szData))$" (Double Click to Invite)",True,True,True);
	} 
	else 
	{
		return;
	}
	ReturnTooltipInfo(zzDeobfuscated4592);
}

function ReturnTooltip_NTT_PARTYMATCH (string index, ETooltipSourceType eSourceType)
{
	local LVDataRecord Deobfuscated2965;

	if ( eSourceType == 2 )
	{
		ParamToRecord(index,Deobfuscated2965);
		AddTooltipItemOption(391,GetClassType(int(Deobfuscated2965.LVDataList[1].szData)),True,True,True);
	} 
	else 
	{
		return;
	}
	ReturnTooltipInfo(zzDeobfuscated4592);
}

function ReturnTooltip_NTT_QUESTLIST (string index, ETooltipSourceType eSourceType)
{
	local LVDataRecord Deobfuscated2965;
	local int nTmp;

	if ( eSourceType == 2 )
	{
		ParamToRecord(index,Deobfuscated2965);
		AddTooltipItemOption(1200,Deobfuscated2965.LVDataList[0].szData,True,True,True);
		switch (Deobfuscated2965.LVDataList[3].nReserved1)
		{
			case 0:
			case 2:
				nTmp = 861;
				break;
			case 1:
			case 3:
				nTmp = 862;
				break;
			default:
		}
		AddTooltipItemOption2(1202,nTmp,True,True,False);
	} 
	else 
	{
		return;
	}
	ReturnTooltipInfo(zzDeobfuscated4592);
}

function ReturnTooltip_NTT_RAIDLIST (string index, ETooltipSourceType eSourceType)
{
	local LVDataRecord Deobfuscated2965;

	if ( eSourceType == 2 )
	{
		ParamToRecord(index,Deobfuscated2965);
		if ( Len(Deobfuscated2965.szReserved) < 1 )
		{
			return;
		}
		zzDeobfuscated4592.MinimumWidth = 144;
		StartItem();
		zzDeobfuscated2336.eType = DIT_TEXT;
		zzDeobfuscated2336.t_bDrawOneLine = False;
		zzDeobfuscated2336.t_color.R = 178;
		zzDeobfuscated2336.t_color.G = 190;
		zzDeobfuscated2336.t_color.B = 207;
		zzDeobfuscated2336.t_color.A = 255;
		zzDeobfuscated2336.t_strText = Deobfuscated2965.szReserved;
		EndItem();
	} 
	else 
	{
		return;
	}
	ReturnTooltipInfo(zzDeobfuscated4592);
}

function ReturnTooltip_NTT_QUESTINFO (string index, ETooltipSourceType eSourceType)
{
	local LVDataRecord Deobfuscated2965;
	local int nTmp;
	local int Width1;
	local int Width2;
	local int Height;

	if ( eSourceType == 2 )
	{
		ParamToRecord(index,Deobfuscated2965);
		AddTooltipItemOption(1200,Deobfuscated2965.LVDataList[0].szData,True,True,True);
		AddTooltipItemOption(1201,Deobfuscated2965.LVDataList[1].szData,True,True,False);
		GetTextSize(GetSystemString(1200)$" : "$Deobfuscated2965.LVDataList[0].szData,Width1,Height);
		GetTextSize(GetSystemString(1201)$" : "$Deobfuscated2965.LVDataList[1].szData,Width2,Height);
		if ( Width2 > Width1 )
		{
			Width1 = Width2;
		}
		if ( 144 > Width1 )
		{
			Width1 = 144;
		}
		zzDeobfuscated4592.MinimumWidth = Width1 + 30;
		AddTooltipItemOption(922,Deobfuscated2965.LVDataList[2].szData,True,True,False);
		switch (Deobfuscated2965.LVDataList[3].nReserved1)
		{
			case 0:
			case 2:
				nTmp = 861;
				break;
			case 1:
			case 3:
				nTmp = 862;
				break;
			default:
		}
		AddTooltipItemOption2(1202,nTmp,True,True,False);
		StartItem();
		zzDeobfuscated2336.eType = DIT_TEXT;
		zzDeobfuscated2336.nOffSetY = 6;
		zzDeobfuscated2336.t_bDrawOneLine = False;
		zzDeobfuscated2336.bLineBreak = True;
		zzDeobfuscated2336.t_color.R = 178;
		zzDeobfuscated2336.t_color.G = 190;
		zzDeobfuscated2336.t_color.B = 207;
		zzDeobfuscated2336.t_color.A = 255;
		zzDeobfuscated2336.t_strText = Deobfuscated2965.szReserved;
		EndItem();
	} 
	else 
	{
		return;
	}
	ReturnTooltipInfo(zzDeobfuscated4592);
}

function ReturnTooltip_NTT_MANOR (string index, string TooltipType, ETooltipSourceType eSourceType)
{
	local LVDataRecord Deobfuscated2965;
	local int idx1;
	local int idx2;
	local int idx3;

	if ( eSourceType == 2 )
	{
		ParamToRecord(index,Deobfuscated2965);
		if ( TooltipType == "ManorSeedInfo" )
		{
			idx1 = 4;
			idx2 = 5;
			idx3 = 6;
		} 
		else 
		{
			if ( TooltipType == "ManorCropInfo" )
			{
				idx1 = 5;
				idx2 = 6;
				idx3 = 7;
			} 
			else 
			{
				if ( TooltipType == "ManorSeedSetting" )
				{
					idx1 = 7;
					idx2 = 8;
					idx3 = 9;
				} 
				else 
				{
					if ( TooltipType == "ManorCropSetting" )
					{
						idx1 = 9;
						idx2 = 10;
						idx3 = 11;
					} 
					else 
					{
						if ( TooltipType == "ManorDefaultInfo" )
						{
							idx1 = 1;
							idx2 = 4;
							idx3 = 5;
						} 
						else 
						{
							if ( TooltipType == "ManorCropSell" )
							{
								idx1 = 7;
								idx2 = 8;
								idx3 = 9;
							}
						}
					}
				}
			}
		}
		AddTooltipItemOption(0,Deobfuscated2965.LVDataList[0].szData,False,True,True);
		AddTooltipItemOption(537,Deobfuscated2965.LVDataList[idx1].szData,True,True,False);
		AddTooltipItemOption(1134,Deobfuscated2965.LVDataList[idx2].szData,True,True,False);
		AddTooltipItemOption(1135,Deobfuscated2965.LVDataList[idx3].szData,True,True,False);
	} 
	else 
	{
		return;
	}
	ReturnTooltipInfo(zzDeobfuscated4592);
}

function AddTooltipItemOption (int TitleID, string Content, bool bTitle, bool bContent, bool IamFirst)
{
	if ( bTitle )
	{
		StartItem();
		zzDeobfuscated2336.eType = DIT_TEXT;
		if (  !IamFirst )
		{
			zzDeobfuscated2336.nOffSetY = 6;
		}
		zzDeobfuscated2336.bLineBreak = True;
		zzDeobfuscated2336.t_bDrawOneLine = True;
		zzDeobfuscated2336.t_color.R = 163;
		zzDeobfuscated2336.t_color.G = 163;
		zzDeobfuscated2336.t_color.B = 163;
		zzDeobfuscated2336.t_color.A = 255;
		zzDeobfuscated2336.t_ID = TitleID;
		EndItem();
	}
	if ( bContent )
	{
		if ( bTitle )
		{
			StartItem();
			zzDeobfuscated2336.eType = DIT_TEXT;
			if (  !IamFirst )
			{
				zzDeobfuscated2336.nOffSetY = 6;
			}
			zzDeobfuscated2336.t_bDrawOneLine = True;
			zzDeobfuscated2336.t_color.R = 163;
			zzDeobfuscated2336.t_color.G = 163;
			zzDeobfuscated2336.t_color.B = 163;
			zzDeobfuscated2336.t_color.A = 255;
			zzDeobfuscated2336.t_strText = " : ";
			EndItem();
		}
		StartItem();
		zzDeobfuscated2336.eType = DIT_TEXT;
		if (  !IamFirst )
		{
			zzDeobfuscated2336.nOffSetY = 6;
		}
		if (  !bTitle )
		{
			zzDeobfuscated2336.bLineBreak = True;
		}
		zzDeobfuscated2336.t_bDrawOneLine = True;
		zzDeobfuscated2336.t_color.R = 176;
		zzDeobfuscated2336.t_color.G = 155;
		zzDeobfuscated2336.t_color.B = 121;
		zzDeobfuscated2336.t_color.A = 255;
		zzDeobfuscated2336.t_strText = Content;
		EndItem();
	}
}


function AddTooltipItemOption2 (int TitleID, int ContentID, bool bTitle, bool bContent, bool IamFirst)
{
	if ( bTitle )
	{
		StartItem();
		zzDeobfuscated2336.eType = DIT_TEXT;
		if ( !(IamFirst) )
		{
			zzDeobfuscated2336.nOffSetY = 4;
		}
		zzDeobfuscated2336.bLineBreak = True;
		zzDeobfuscated2336.nOffSetX = 1;
		zzDeobfuscated2336.t_bDrawOneLine = True;
		zzDeobfuscated2336.t_color.R = 163;
		zzDeobfuscated2336.t_color.G = 163;
		zzDeobfuscated2336.t_color.B = 163;
		zzDeobfuscated2336.t_color.A = 255;
		zzDeobfuscated2336.t_ID = TitleID;
		EndItem();
	}
	if ( bContent )
	{
		if ( bTitle )
		{
			StartItem();
			zzDeobfuscated2336.eType = DIT_TEXT;
			if ( !(IamFirst) )
			{
				zzDeobfuscated2336.nOffSetY = 4;
			}
			zzDeobfuscated2336.t_bDrawOneLine = True;
			zzDeobfuscated2336.t_color.R = 163;
			zzDeobfuscated2336.t_color.G = 163;
			zzDeobfuscated2336.t_color.B = 163;
			zzDeobfuscated2336.t_color.A = 255;
			zzDeobfuscated2336.t_strText = " : ";
			EndItem();
		}
		StartItem();
		zzDeobfuscated2336.eType = DIT_TEXT;
		if ( !(IamFirst) )
		{
			zzDeobfuscated2336.nOffSetY = 4;
		}
		if ( !(bTitle) )
		{
			zzDeobfuscated2336.bLineBreak = True;
		}
		zzDeobfuscated2336.t_bDrawOneLine = True;
		zzDeobfuscated2336.t_color.R = 176;
		zzDeobfuscated2336.t_color.G = 155;
		zzDeobfuscated2336.t_color.B = 121;
		zzDeobfuscated2336.t_color.A = 255;
		zzDeobfuscated2336.t_ID = ContentID;
		EndItem();
	}
}

function SetTooltipItemColor (int R, int G, int B, int Deobfuscated1905)
{
	local int Deobfuscated1834;

	Deobfuscated1834 = zzDeobfuscated4592.DrawList.Length - 1 - Deobfuscated1905;
	zzDeobfuscated4592.DrawList[Deobfuscated1834].t_color.R = R;
	zzDeobfuscated4592.DrawList[Deobfuscated1834].t_color.G = G;
	zzDeobfuscated4592.DrawList[Deobfuscated1834].t_color.B = B;
	zzDeobfuscated4592.DrawList[Deobfuscated1834].t_color.A = 255;
}

function AddTooltipItemBlank (int Height)
{
	StartItem();
	zzDeobfuscated2336.eType = DIT_BLANK;
	zzDeobfuscated2336.b_nHeight = Height;
	EndItem();
}

function AddTooltipItemEnchant (ItemInfo item)
{
	local EItemParamType EItemParamType;

	EItemParamType = EItemParamType(item.ItemType);
	if ( (item.Enchanted > 0) && IsEnchantableItem(EItemParamType) )
	{
		StartItem();
		zzDeobfuscated2336.eType = DIT_TEXT;
		zzDeobfuscated2336.t_bDrawOneLine = True;
		zzDeobfuscated2336.t_color.R = 176;
		zzDeobfuscated2336.t_color.G = 155;
		zzDeobfuscated2336.t_color.B = 121;
		zzDeobfuscated2336.t_color.A = 255;
		zzDeobfuscated2336.t_strText = "+"$string(item.Enchanted)$" ";
		EndItem();
	}
}

function AddTooltipItemNameFaris (string Name, ItemInfo item, int AddTooltipItemName, optional int offsetX, optional int offsetY)
{
	StartItem();
	zzDeobfuscated2336.eType = DIT_TEXT;
	zzDeobfuscated2336.t_bDrawOneLine = True;
	zzDeobfuscated2336.t_color = GetItemNameWithoutTag(Name);
	zzDeobfuscated2336.nOffSetX = (zzDeobfuscated2336.nOffSetX + offsetX);
	zzDeobfuscated2336.nOffSetY = (zzDeobfuscated2336.nOffSetY + offsetY);
	zzDeobfuscated2336.t_strText = Name;
	EndItem();
  
	if ( Len(item.AdditionalName) > 0 )
	{
		StartItem();
		zzDeobfuscated2336.eType = DIT_TEXT;
		zzDeobfuscated2336.t_bDrawOneLine = True;
		zzDeobfuscated2336.t_color.R = 255;
		zzDeobfuscated2336.t_color.G = 217;
		zzDeobfuscated2336.t_color.B = 105;
		zzDeobfuscated2336.t_color.A = 255;
		zzDeobfuscated2336.nOffSetX = (zzDeobfuscated2336.nOffSetX + offsetX);
		zzDeobfuscated2336.nOffSetY = (zzDeobfuscated2336.nOffSetY + offsetY);
		zzDeobfuscated2336.t_strText = item.AdditionalName;
		EndItem();
	}
  
}














function GetRefineryColor (int Quality, out int R, out int G, out int B)
{
	switch (Quality)
	{
		case 1:
			R = 187;
			G = 181;
			B = 138;
			break;
		case 2:
			R = 132;
			G = 174;
			B = 216;
			break;
		case 3:
			R = 193;
			G = 112;
			B = 202;
			break;
		case 4:
			R = 225;
			G = 109;
			B = 109;
			break;
		default:
			R = 187;
			G = 181;
			B = 138;
			break;
	}
}

function ReturnTooltip_NTT_ITEMSKILLINFO (string index, ETooltipSourceType eSourceType)
{
	local string Deobfuscated4924;
	local LVDataRecord Deobfuscated2965;

	if ( eSourceType == 2 )
	{
		ParamToRecord(index,Deobfuscated2965);
		GetINIString("Description",Deobfuscated2965.LVDataList[0].szData,Deobfuscated4924,"ItemSkillGrp.ini");
		AddTooltipItemOption(0,Deobfuscated4924,False,True,False);
	} 
	else 
	{
		return;
	}
	ReturnTooltipInfo(zzDeobfuscated4592);
}
defaultproperties
{
}
