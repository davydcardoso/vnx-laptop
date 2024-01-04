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

    const userCrypto = await new Promise((resolve) => {
      exports.oxmysql.execute(
        "SELECT * FROM user_crypto uc WHERE cryptocid = @playerId AND cryptoid = 2",
        { playerId: cid },
        function (data) {
          resolve(data[0]);
        }
      );
    });

    if (userCrypto == undefined || userCrypto == null || !userCrypto) {
      TriggerClientEvent(
        "DoLongHudText",
        src,
        "You don't have enough Nort Coin",
        2
      );
      return;
    }

    const playerGNEAmount = userCrypto.cryptoamount;

    const items = data.cart;
    let priceTotal = 0;

    for await (const item of items) {
      priceTotal = priceTotal + item.price;
    }

    if (playerGNEAmount < priceTotal) {
      TriggerClientEvent(
        "DoLongHudText",
        src,
        "You don't have enough Nort Coin, check you Wallet",
        2
      );
      return;
    }

    for await (const item of items) {
      const itemId = item.id;
      const itemPrice = item.price;
      const itemAmount = 1;

      await new Promise((resolve) => {
        exports.oxmysql.execute(
          "INSERT INTO bennys_requests (PlayerStateId, ItemId, ItemPrice, ItemAmount) VALUES(@playerId, @itemId, @itemPrice, @itemAmount)",
          {
            playerId: cid,
            itemId: itemId,
            itemPrice: itemPrice,
            itemAmount: itemAmount,
          },
          function () {
            resolve();
          }
        );
      });
    }

    await new Promise((resolve) => {
      exports.oxmysql.execute(
        "UPDATE user_crypto SET cryptoamount = @cryptoAmount WHERE cryptoid = 2 AND cryptocid = @playerId",
        {
          cryptoAmount: playerGNEAmount - priceTotal,
          playerId: cid,
        },
        function () {
          resolve();
        }
      );
    });

    TriggerClientEvent(
      "DoLongHudText",
      src,
      "Products purchased successfully!!!",
      0
    );

    TriggerClientEvent(
      "vnx-laptop:BennysShopPurchaseItems:LocationPurchase",
      src
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
