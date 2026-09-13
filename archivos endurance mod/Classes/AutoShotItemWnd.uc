
class AutoShotItemWnd extends UICommonAPI;



var WindowHandle zzMe;
var ItemWindowHandle zzinventory_item;
var ItemWindowHandle zzrhand;
var ItemInfo zziteminfoka;
var int zzidkiua;
var int zzikaujua;
var int zzkiauak;
var int zzkiaka2a;
var bool zzasnewk;
var ShortcutWnd zzshortcut;

function xxregisterload()
{
	RegisterEvent(150);
	RegisterEvent(40);
	RegisterEvent(2610);
	RegisterEvent(693);
	RegisterEvent(44467);
	return;
}

function OnLoad()
{	handleEquipRHandItem();
	xxregisterload();
	xxinithandle();
	xxweamkjja();
	return;
}

function xxinithandle()
{
	zzMe = GetHandle("AutoShotItemWnd");
	zzshortcut = ShortcutWnd(GetScript("ShortcutWnd"));
	zzinventory_item = ItemWindowHandle(GetHandle("InventoryWnd.InventoryItem"));
	zzrhand = ItemWindowHandle(GetHandle("InventoryWnd.EquipItem_RHand"));
	zzidkiua = 1;
	zzikaujua = 1;
	xxkja2dasd();
	return;
}

	function xxkja2dasd()
{
    local int zzinka;
    local ItemInfo zzitukaainfo;

    zzinka = 1;

    while (zzinka < 3)
    {
        xxGetItemWindowHandle("AutoShotItemWnd.AutoShotItemWnd_HorWnd.ShotItemSlot" $ string(zzinka)).Clear();
        xxGetItemWindowHandle("AutoShotItemWnd.AutoShotItemWnd_VerWnd.ShotItemSlot" $ string(zzinka)).Clear();

        if ((zzinka == 1) || zzinka == 2)
        {
            xxGetItemWindowHandle("AutoShotItemWnd.AutoShotItemWnd_HorWnd.ShotItemSlot" $ string(zzinka)).SetTooltipText(GetSystemMessage(6828));
            xxGetItemWindowHandle("AutoShotItemWnd.AutoShotItemWnd_VerWnd.ShotItemSlot" $ string(zzinka)).SetTooltipText(GetSystemMessage(6828));
            xxGetWindowHandle("AutoShotItemWnd.AutoShotItemWnd_HorWnd.texToggle" $ string(zzinka) $ "_hor_AniTex").HideWindow();
            xxGetWindowHandle("AutoShotItemWnd.AutoShotItemWnd_VerWnd.texToggle" $ string(zzinka) $ "_ver_AniTex").HideWindow();
        }
        else
        {
            xxGetItemWindowHandle("AutoShotItemWnd.AutoShotItemWnd_HorWnd.ShotItemSlot" $ string(zzinka)).SetTooltipText(GetSystemMessage(6829));
            xxGetItemWindowHandle("AutoShotItemWnd.AutoShotItemWnd_VerWnd.ShotItemSlot" $ string(zzinka)).SetTooltipText(GetSystemMessage(6829));
        }

        ++zzinka;
    }

    zzasnewk = False;
    zziteminfoka = zzitukaainfo;
    xxGetWindowHandle(xxdawea2(False, 1)).HideWindow();
    xxGetWindowHandle(xxdawea2(True, 1)).HideWindow();
    zzMe.HideWindow();
    zzMe.KillTimer(30021);

       return;
}

function handleEquipRHandItem()
{
    local ItemInfo rightHandItemInfo;

    // Desequipar o item da m??o direita
    zzrhand.GetItem(0, rightHandItemInfo);
    if (rightHandItemInfo.ClassID > 0)
    {
        zzrhand.Clear();
    }

    // Equipar novamente o item na m??o direita
    zzrhand.AddItem(rightHandItemInfo);
}


function OnTimer(int zztimerid)
{
	switch(zztimerid)
	{
        // End:0x32
		case 30021:
			xxaweaa();
			xxmukaja2();
			zzMe.KillTimer(30021);
            // End:0xB8
			break;
        // End:0x57
		case 30022:
			xxaweaa();
			zzMe.KillTimer(30022);
            // End:0xB8
			break;
        // End:0x86
		case zzkiauak:
			zzMe.KillTimer(zzkiauak);
			xxweamkjja(zzkiauak, zzidkiua);
            // End:0xB8
			break;
        // End:0xB5
		case zzkiaka2a:
			zzMe.KillTimer(zzkiaka2a);
			xxweamkjja(zzkiaka2a, zzikaujua);
            // End:0xB8
			break;
        // End:0xFFFF
		default:
			break;
	}
	return;
}

function xxpositions()
{
    // End:0x0D
	if( !xxIsUseAutoEquipSoulShot() )
	{
		return;
	}
	xxGetWindowHandle("AutoShotItemWnd").ClearAnchor();
    // End:0x9A
	if( xxisvertical() )
	{
		xxGetWindowHandle("AutoShotItemWnd").SetAnchor("ShortcutWnd.ShortcutWndVertical"$(xxgetnumpand()), "TopLeft", "TopRight", 1, 17);        
	}
	else
	{
		xxGetWindowHandle("AutoShotItemWnd").SetAnchor("ShortcutWnd.ShortcutWndHorizontal"$(xxgetnumpand()), "TopLeft", "BottomLeft", 16, -2);
	}
	return;
}

function string xxgetnumpand()
{
	local int zziukaju2aa;
	local string zzparam;

	zziukaju2aa = zzshortcut.GetExpandNum();
    // End:0x2B
	if( zziukaju2aa <= 0 )
	{
		zzparam = "";        
	}
	else
	{
		zzparam = "_"$string(zziukaju2aa);
	}
	return zzparam;

}

function OnEvent(int zzid, string zzparam)
{
	switch(zzid)
	{
        // End:0x1D
		case 44467:
			ActivateAnimation(zzparam);
            // End:0x88
			break;
        // End:0x4A
		case 150:
			xxmukaja2();
			xxpositions();
			zzMe.SetTimer(30021, 2000);
            // End:0x88
			break;
        // End:0x60
		case 2610:
			xxliketa(zzparam);
            // End:0x88
			break;
        // End:0x6E
		case 40:
			xxkja2dasd();
            // End:0x88
			break;
        // End:0x85
		case 693:
			xxpositions();
			xxmukaja2();
            // End:0x88
			break;
        // End:0xFFFF
		default:
			break;
	}
 
}

function xxliketa(string zzparam)
{
	zzkiauak = 1;
	zzkiaka2a = 1;
	zzMe.KillTimer(30022);
	zzMe.SetTimer(30022, 200);
	return;
}

function xxaweaa()
{
	xxekuaja();
	xxmjua21ska(xxmjuaka2(1));
	xxmjua21ska(xxmjuaka2(2));
	return;
}

function string xxmjuaka2(int zzid)
{
	local ItemInfo zzinfolocka, zzsuprainfoitem;
	local int zzkenkjua2, zzjuliganax;
	local string zzinstriona;

	zzinfolocka = zzsuprainfoitem;
	zzkenkjua2 = -1;
	switch(zzid)
	{
        // End:0x71
		case 1:
			zzjuliganax = zzidkiua;
			zzkenkjua2 = zzinventory_item.FindItemWithClassID(xxGetSoulShotID(zziteminfoka.CrystalType));
			zzkiauak = 10000 + (xxGetSoulShotID(zziteminfoka.CrystalType));
            // End:0x116
			break;
        // End:0x113
		case 2:
			zzjuliganax = zzikaujua;
			zzkenkjua2 = zzinventory_item.FindItemWithClassID(xxGetSpiritShotID(zziteminfoka.CrystalType));
			zzkiaka2a = 10000 + (xxGetSpiritShotID(zziteminfoka.CrystalType));
            // End:0x110
			if( zzkenkjua2 < 0 )
			{
				zzkenkjua2 = zzinventory_item.FindItemWithClassID(xxGetBlessedSpiritShotID(zziteminfoka.CrystalType));
				zzkiaka2a = 10000 + (xxGetBlessedSpiritShotID(zziteminfoka.CrystalType));
			}
            // End:0x116
			break;
        // End:0xFFFF
		default:
			break;
	}
	zzinventory_item.GetItem(zzkenkjua2, zzinfolocka);
	ItemInfoToParam(zzinfolocka, zzinstriona);
    // End:0x197
	if( zzinfolocka.ItemNum <= 0 )
	{
		zzinstriona = (((("type="$string(zzid))$" have=")$string(zzinfolocka.ItemNum))$" activate=")$string(zzjuliganax);        
	}
	else
	{
		zzinstriona = (((((("type="$string(zzid))$" have=")$string(zzinfolocka.ItemNum))$" activate=")$string(zzjuliganax))$" ")$zzinstriona;
	}
	return zzinstriona;

}

function xxekuaja()
{
	local ItemInfo zziteminfoka;

	zzrhand.GetItem(0, zziteminfoka);
	zzMe.KillTimer(zzkiauak);
	zzMe.KillTimer(zzkiaka2a);
	xxdmkaju2ka(zziteminfoka);
	return;
}

function xxmukaja2()
{
    // End:0x0D
	if( !xxIsUseAutoEquipSoulShot() )
	{
		return;
	}
    // End:0x3C
	if( xxIsUseAutoEquipSoulShot() )
	{
        // End:0x39
		if( !zzMe.IsShowWindow() )
		{
			zzMe.ShowWindow();
		}        
	}
	else
	{
        // End:0x5F
		if( zzMe.IsShowWindow() )
		{
			zzMe.HideWindow();
			return;
		}
	}
	xxGetWindowHandle(xxdawea2(False, 1)).HideWindow();
	xxGetWindowHandle(xxdawea2(True, 1)).HideWindow();
	xxGetWindowHandle(xxdawea2(xxisvertical(), 1)).ShowWindow();
	return;
}

function xxdmkaju2ka(ItemInfo zzinfoa)
{
	zziteminfoka = zzinfoa;
    // End:0x26
	if( zzinfoa.ClassID > 0 )
	{
		zzasnewk = True;        
	}
	else
	{
		zzasnewk = False;
	}
	return;
}

function string xxdawea2(bool zzisna, int zzid)
{
	local string zzparam;

	zzparam = "AutoShotItemWnd";
    // End:0x63
	if( zzisna )
	{
		zzparam = zzparam$".AutoShotItemWnd_VerWnd.WeaponSlotGroupWnd_VerWnd";        
	}
	else
	{
		zzparam = zzparam$".AutoShotItemWnd_HorWnd.WeaponSlotGroupWnd_HorWnd";
	}
	return zzparam;

}

function ItemWindowHandle xxitemwindka(bool zzisbola, int zzidkeua)
{
	local ItemWindowHandle zzmenkia;

    // End:0x70
	if( zzisbola )
	{
		zzmenkia = xxGetItemWindowHandle("AutoShotItemWnd.AutoShotItemWnd_VerWnd.WeaponSlotGroupWnd_VerWnd.ShotItemSlot"$string(zzidkeua));        
	}
	else
	{
		zzmenkia = xxGetItemWindowHandle("AutoShotItemWnd.AutoShotItemWnd_HorWnd.WeaponSlotGroupWnd_HorWnd.ShotItemSlot"$string(zzidkeua));
	}
	return zzmenkia;

}

function xxkuakamj(int zzid, int zzikaua, optional ItemInfo zziteminkfoaa)
{
    // End:0x44
	if( zzikaua == 1 )
	{
		xxitemwindka(False, zzid).AddItem(zziteminkfoaa);
		xxitemwindka(True, zzid).AddItem(zziteminkfoaa);        
	}
	else
	{
        // End:0x8B
		if( zzikaua == 2 )
		{
			xxitemwindka(False, zzid).SetItem(0, zziteminkfoaa);
			xxitemwindka(True, zzid).SetItem(0, zziteminkfoaa);            
		}
		else
		{
            // End:0xCE
			if( zzikaua == 3 )
			{
				xxitemwindka(True, zzid).Clear();
				xxitemwindka(False, zzid).Clear();
				ResetAnimation(zzid);
			}
		}
	}
	return;
}

function xxmjua21ska(string param)
{
	local int zzid, zzmujkaa2, zzuekaju2;
	local ItemInfo zzinfosuperitem, zzinfokuask2;
	local string zzparam;

	ParseInt(param, "type", zzid);
	ParseInt(param, "have", zzmujkaa2);
	ParseInt(param, "activate", zzuekaju2);
	ParamToItemInfo(param, zzinfosuperitem);
    // End:0x1BF
	if( zzid > -1 )
	{
        // End:0xAA
		if( xxitemwindka(False, zzid).GetItem(0, zzinfokuask2) )
		{
            // End:0xAA
			if( zzinfokuask2.ClassID != zzinfosuperitem.ClassID )
			{
				xxkuakamj(zzid, 3);
			}
		}
        // End:0x1BF
		if( zzmujkaa2 > 0 )
		{
            // End:0x1BF
			if( (((zzid == 1) || zzid == 2) && zzasnewk) && zzinfosuperitem.ClassID > 0 )
			{
                // End:0x119
				if( zzinfokuask2.ClassID == zzinfosuperitem.ClassID )
				{
					xxkuakamj(zzid, 2, zzinfosuperitem);                    
				}
				else
				{
					xxkuakamj(zzid, 1, zzinfosuperitem);
					zzparam = "AutoShotItemWnd.EffectSlot"$string(zzid);
                    // End:0x17B
					if( xxisvertical() )
					{
						zzparam = zzparam$"_ver_AniTex";                        
					}
					else
					{
						zzparam = zzparam$"_hor_AniTex";
					}
					xxGetAnimTextureHandle(zzparam).Stop();
					xxGetAnimTextureHandle(zzparam).Play();
				}
			}
		}
	}
	xxmukaja2();
	return;
}

function OnRButtonUp(int X, int Y)
{
	xxpojteua(X, Y);
	return;
}

function xxpojteua(int X, int Y)
{
	local string zzparams;
	local ItemInfo zzinfosuperitem;
	local Rect zzrecta, zzminirecta, zzchocorecta;

	zzparams = "AutoShotItemWnd.";
    // End:0x49
	if( xxisvertical() )
	{
		zzparams = zzparams$"AutoShotItemWnd_VerWnd";        
	}
	else
	{
		zzparams = zzparams$"AutoShotItemWnd_HorWnd";
	}
	zzrecta = Class'UIAPI_WINDOW'.static.GetRect(zzparams$".ShotItemSlot1");
	zzminirecta = Class'UIAPI_WINDOW'.static.GetRect(zzparams$".ShotItemSlot2");
	zzchocorecta = Class'UIAPI_WINDOW'.static.GetRect(zzparams$".header_weapon_Texture");
    // End:0x1C6
	if( (((X >= zzrecta.nX) && X <= (zzrecta.nX + zzrecta.nWidth)) && Y >= zzrecta.nY) && Y <= (zzrecta.nY + zzrecta.nHeight) )
	{
		xxGetItemWindowHandle("AutoShotItemWnd.ShotItemSlot1").GetItem(0, zzinfosuperitem);
		zzidkiua = xxmukjaiwa(zzidkiua);
		xxweamkjja(zzinfosuperitem.ClassID, zzidkiua);        
	}
	else
	{
        // End:0x292
		if( (((X >= zzminirecta.nX) && X <= (zzminirecta.nX + zzminirecta.nWidth)) && Y >= zzminirecta.nY) && Y <= (zzminirecta.nY + zzminirecta.nHeight) )
		{
			xxGetItemWindowHandle("AutoShotItemWnd.ShotItemSlot2").GetItem(0, zzinfosuperitem);
			zzikaujua = xxmukjaiwa(zzikaujua);
			xxweamkjja(zzinfosuperitem.ClassID, zzikaujua);            
		}
		else
		{
            // End:0x31B
			if( (((X >= zzchocorecta.nX) && X <= (zzchocorecta.nX + zzchocorecta.nWidth)) && Y >= zzchocorecta.nY) && Y <= (zzchocorecta.nY + zzchocorecta.nHeight) )
			{
				xxmjua21ska(xxmjuaka2(1));
				xxmjua21ska(xxmjuaka2(2));
			}
		}
	}
	return;
}

function int xxmukjaiwa(int State)
{
	local int zzinka;

	switch(State)
	{
        // End:0x15
		case 0:
			zzinka = 1;
            // End:0x26
			break;
        // End:0x23
		case 1:
			zzinka = 0;
            // End:0x26
			break;
        // End:0xFFFF
		default:
			break;
	}
	return zzinka;

}

function ResetAnimation(int zzid)
{
	local string zzparam;

	zzparam = "AutoShotItemWnd.AutoShotItemWnd_HorWnd.texToggle"$string(zzid);
    // End:0x67
	if( xxisvertical() )
	{
		zzparam = zzparam$"_ver_AniTex";        
	}
	else
	{
		zzparam = zzparam$"_hor_AniTex";
	}
	xxGetAnimTextureHandle(zzparam).Stop();
	xxGetWindowHandle(zzparam).HideWindow();
	return;
}

function OnTextureAnimEnd(AnimTextureHandle zzanimekaj)
{
	local ItemInfo zzitemkasj2a, zzswaea2a;
	local string zzparamiua, zzparmasia;

	zzparamiua = "AutoShotItemWnd.EffectSlot1";
	zzparmasia = "AutoShotItemWnd.EffectSlot2";
    // End:0x86
	if( xxisvertical() )
	{
		zzparamiua = zzparamiua$"_ver_AniTex";
		zzparmasia = zzparmasia$"_ver_AniTex";        
	}
	else
	{
		zzparamiua = zzparamiua$"_hor_AniTex";
		zzparmasia = zzparmasia$"_hor_AniTex";
	}
	switch(zzanimekaj)
	{
        // End:0x11D
		case xxGetAnimTextureHandle(zzparamiua):
			xxGetItemWindowHandle("AutoShotItemWnd.ShotItemSlot1").GetItem(0, zzitemkasj2a);
			zzMe.SetTimer(zzkiauak, 100);
            // End:0x17F
			break;
        // End:0x17C
		case xxGetAnimTextureHandle(zzparmasia):
			xxGetItemWindowHandle("AutoShotItemWnd.ShotItemSlot2").GetItem(0, zzswaea2a);
			zzMe.SetTimer(zzkiaka2a, 1000);
            // End:0x17F
			break;
        // End:0xFFFF
		default:
			break;
	}
	return;
}

function ActivateAnimation(string zzparam)
{
	local int shotID, bEnable;
	local string zzparamiua, zzparmasia, zzvertical, zzhorizontal;

	ParseInt(zzparam, "ShotID", shotID);
	ParseInt(zzparam, "bEnable", bEnable);
	zzparamiua = "AutoShotItemWnd.AutoShotItemWnd_VerWnd.texToggle"$string(xxGetShotSlot(shotID));
	zzparmasia = "AutoShotItemWnd.AutoShotItemWnd_HorWnd.texToggle"$string(xxGetShotSlot(shotID));
	zzvertical = zzparamiua$"_ver_AniTex";
	zzhorizontal = zzparmasia$"_hor_AniTex";
    // End:0x189
	if( bEnable == 1 )
	{
		xxGetAnimTextureHandle(zzvertical).SetLoopCount(-1);
		xxGetWindowHandle(zzvertical).ShowWindow();
		xxGetAnimTextureHandle(zzvertical).Play();
		xxGetAnimTextureHandle(zzhorizontal).SetLoopCount(-1);
		xxGetWindowHandle(zzhorizontal).ShowWindow();
		xxGetAnimTextureHandle(zzhorizontal).Play();        
	}
	else
	{
		xxGetAnimTextureHandle(zzvertical).Stop();
		xxGetWindowHandle(zzvertical).HideWindow();
		xxGetAnimTextureHandle(zzhorizontal).Stop();
		xxGetWindowHandle(zzhorizontal).HideWindow();
	}
	return;
}

function xxweamkjja(optional int zzconteoklca, optional int zzventiukaaa2)
{
	local string zzparam;

    // End:0x21
	if( zzconteoklca > 10000 )
	{
		zzconteoklca = zzconteoklca - 10000;
	}
		RequestBypassToServer((("RequestAutoShot: ShotID="$string(zzconteoklca))$" bEnable=")$string(zzventiukaaa2));

		ParamAdd(zzparam, "ShotID", string(zzconteoklca));
		ParamAdd(zzparam, "bEnable", string(zzventiukaaa2));
	if( zzventiukaaa2 == 1 )
	{
		ActivateAnimation(zzparam);
	}
	return;
}



function bool xxisvertical()
{
	return zzshortcut.IsVertical();

}
defaultproperties
{
}
