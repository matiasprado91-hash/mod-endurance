package ext.mods.gameserver;

import ext.mods.gameserver.model.actor.Player;
import ext.mods.gameserver.model.item.instance.ItemInstance;
import ext.mods.gameserver.network.serverpackets.CustomEndurancePacket;

public final class EnduranceUpdate
{
	private EnduranceUpdate()
	{
	}

	public static void send(Player player, ItemInstance item)
	{
		if (player == null || item == null || !item.isEnduranceItem())
			return;

		player.sendPacket(new CustomEndurancePacket(item.getObjectId(), item.getEndurance()));
	}
}
