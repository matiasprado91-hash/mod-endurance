/*
 * Copyleft © 2024-2026 L2Lineternity
 * This file is part of L2Lineternity derived from aCis409/RusaCis3.8
 */
package ext.mods.gameserver;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import ext.mods.extensions.listener.command.OnBypassCommandListener;
import ext.mods.gameserver.data.xml.ItemData;
import ext.mods.gameserver.model.WorldObject;
import ext.mods.gameserver.model.actor.Npc;
import ext.mods.gameserver.model.actor.Player;
import ext.mods.gameserver.model.item.instance.ItemInstance;
import ext.mods.gameserver.network.serverpackets.NpcHtmlMessage;

public class EnduranceRepairListener implements OnBypassCommandListener
{
	private static final String COMMAND = "endurance";
	
	@Override
	public boolean onBypass(Player player, String command)
	{
		if (!EnduranceConfig.ENDURANCE_ENABLED || player == null || command == null)
			return false;
		
		if (command.equals(COMMAND))
		{
			showRepairWindow(player);
			return true;
		}
		
		if (!command.startsWith(COMMAND + " repair "))
			return false;
		
		final String objectIdText = command.substring((COMMAND + " repair ").length()).trim();
		try
		{
			final int objectId = Integer.parseInt(objectIdText);
			repairItem(player, objectId);
		}
		catch (NumberFormatException e)
		{
			player.sendMessage("Invalid repair request.");
		}
		return true;
	}
	
	private void showRepairWindow(Player player)
	{
		final Npc npc = getValidBlacksmith(player);
		if (npc == null)
		{
			player.sendMessage("You must be near a blacksmith to repair equipment.");
			return;
		}
		
		final List<ItemInstance> damagedItems = getDamagedItems(player);
		final NpcHtmlMessage html = new NpcHtmlMessage(npc.getObjectId());
		final String currencyName = getRepairCurrencyName();
		final StringBuilder content = new StringBuilder(1024);
		
		content.append("<html><body>");
		content.append("<center><font color=LEVEL>Equipment Repair</font></center><br>");
		
		if (damagedItems.isEmpty())
		{
			content.append("All supported equipment is fully repaired.");
		}
		else
		{
			content.append("Select an item to repair:<br><br>");
			for (ItemInstance item : damagedItems)
			{
				final long cost = calculateRepairCost(item);
				if (cost < 0)
					continue;
				
				content.append("<button value=\"")
					.append(escapeHtml(item.getItem().getName()))
					.append(" (")
					.append(item.getEndurance())
					.append("/")
					.append(EnduranceConfig.MAX_ENDURANCE)
					.append(") - ")
					.append(cost)
					.append(" ")
					.append(escapeHtml(currencyName))
					.append("\" action=\"bypass -h endurance repair ")
					.append(item.getObjectId())
					.append("\" width=240 height=24><br1>");
			}
		}
		
		content.append("<br><button value=\"Refresh\" action=\"bypass -h endurance\" width=100 height=24>");
		content.append("</body></html>");
		
		html.setHtml(content.toString());
		player.sendPacket(html);
	}
	
	private void repairItem(Player player, int objectId)
	{
		final Npc npc = getValidBlacksmith(player);
		if (npc == null)
		{
			player.sendMessage("You must be near a blacksmith to repair equipment.");
			return;
		}
		
		final ItemInstance item = player.getInventory().getItemByObjectId(objectId);
		if (item == null || !item.isEnduranceItem())
		{
			player.sendMessage("The selected item is not valid for endurance repair.");
			return;
		}
		
		if (item.getEndurance() >= EnduranceConfig.MAX_ENDURANCE)
		{
			player.sendMessage("This item is already fully repaired.");
			showRepairWindow(player);
			return;
		}
		
		final long cost = calculateRepairCost(item);
		if (cost < 0 || cost > Integer.MAX_VALUE)
		{
			player.sendMessage("The repair cost is invalid.");
			return;
		}
		
		synchronized (item)
		{
			if (player.getInventory().getItemByObjectId(objectId) != item || !item.isEnduranceItem())
			{
				player.sendMessage("The selected item is no longer available.");
				return;
			}
			
			if (item.getEndurance() >= EnduranceConfig.MAX_ENDURANCE)
			{
				showRepairWindow(player);
				return;
			}
			
			final long finalCost = calculateRepairCost(item);
			if (finalCost != cost || finalCost < 0 || finalCost > Integer.MAX_VALUE)
			{
				player.sendMessage("The repair cost changed. Please try again.");
				showRepairWindow(player);
				return;
			}
			
			if (finalCost > 0)
			{
				final ItemInstance currency = player.getInventory().getItemByItemId(EnduranceConfig.ENDURANCE_REPAIR_ITEM_ID);
				if (currency == null || currency.getCount() < finalCost)
				{
					player.sendMessage("You do not have enough " + getRepairCurrencyName() + " to repair this item.");
					return;
				}
				
				if (player.getInventory().destroyItem(currency, (int) finalCost) == null)
				{
					player.sendMessage("Unable to complete the repair payment.");
					return;
				}
			}
			
			item.setEndurance(EnduranceConfig.MAX_ENDURANCE);
		}
		
		player.sendMessage("Your " + item.getItem().getName() + " has been repaired.");
		showRepairWindow(player);
	}
	
	private List<ItemInstance> getDamagedItems(Player player)
	{
		final List<ItemInstance> result = new ArrayList<>();
		player.getInventory().forEachItem(item ->
		{
			if (item.isEnduranceItem() && item.getEndurance() < EnduranceConfig.MAX_ENDURANCE)
				result.add(item);
		});
		return result;
	}
	
	private long calculateRepairCost(ItemInstance item)
	{
		final long missing = EnduranceConfig.MAX_ENDURANCE - item.getEndurance();
		if (missing <= 0)
			return 0;
		
		if (EnduranceConfig.ENDURANCE_REPAIR_COST_PER_POINT > 0 && missing > (Long.MAX_VALUE - EnduranceConfig.ENDURANCE_REPAIR_BASE_COST) / EnduranceConfig.ENDURANCE_REPAIR_COST_PER_POINT)
			return -1;
		
		return EnduranceConfig.ENDURANCE_REPAIR_BASE_COST + missing * EnduranceConfig.ENDURANCE_REPAIR_COST_PER_POINT;
	}
	
	private Npc getValidBlacksmith(Player player)
	{
		final WorldObject target = player.getTarget();
		if (!(target instanceof Npc npc))
			return null;
		
		final String npcName = npc.getName();
		if (!npc.getTemplate().isType("Trainer") || npcName == null || !npcName.toLowerCase(Locale.ROOT).contains("blacksmith"))
			return null;
		
		return player.getAI() != null && player.getAI().canDoInteract(npc) ? npc : null;
	}
	
	private String getRepairCurrencyName()
	{
		final var item = ItemData.getInstance().getTemplate(EnduranceConfig.ENDURANCE_REPAIR_ITEM_ID);
		return item == null ? "the required item" : item.getName();
	}
	
	private String escapeHtml(String value)
	{
		if (value == null)
			return "";
		
		return value.replace("&", "&amp;")
			.replace("<", "&lt;")
			.replace(">", "&gt;")
			.replace("\"", "&quot;");
	}
}
