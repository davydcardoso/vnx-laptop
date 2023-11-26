RegisterServerEvent("vnx-laptop:BennysShopPurchaseItems:ServerEvent");
AddEventHandler(
  "vnx-laptop:BennysShopPurchaseItems:ServerEvent",
  async function (data) {
    const src = source;

    const cid = exports["str-base"].getChar(src, "id");

    if (!data || !data.cart) {
      TriggerClientEvent(
        "DoLongHudText",
        src,
        "No items were specified when purchasing!!!",
        2
      );
      return;
    }

    const items = data.cart;

    for (let index = 0; index < items.length; index++) {
      const item = items[index];
      const itemId = item.id;

      exports.oxmysql.execute(
        "INSERT INTO bennys_requests (PlayerStateId, ItemId) VALUES(@playerId, @itemId)",
        {
          playerId: cid,
          itemId: itemId,
        }
      );
    }

    TriggerClientEvent(
      "DoLongHudText",
      src,
      "Products purchased successfully!!!",
      0
    );
  }
);

RegisterServerEvent("vnx-laptop:BennysIlegalShop:ReceiveMyOrder");
AddEventHandler(
  "vnx-laptop:BennysIlegalShop:ReceiveMyOrder",
  async function (data) {
    const src = source;

    const cid = exports["str-base"].getChar(src, "id");

    await exports.oxmysql.execute(
      "SELECT * FROM bennys_requests WHERE PlayerStateId = @playerId",
      { playerId: cid },
      async function (data) {
        if (!data) {
          TriggerClientEvent(
            "DoLongHudText",
            src,
            "You have no orders here, get out!!!",
            2
          );

          return;
        }

        for (const item of data) {
          TriggerEvent("player:receiveItem", src, item.ItemId, 1);
          TriggerClientEvent("player:receiveItem", src, item.ItemId, 1);
        }

        await exports.oxmysql.execute(
          "DELETE FROM bennys_requests WHERE PlayerStateId = @playerId",
          { playerId: cid }
        );

        TriggerClientEvent(
          "DoLongHudText",
          src,
          "Take your things and get out of here!!",
          0
        );
      }
    );
  }
);
