RegisterServerEvent("vnx-laptop:BennysShopPurchaseItems:ServerEvent");
AddEventHandler(
  "vnx-laptop:BennysShopPurchaseItems:ServerEvent",
  function (data) {
    const src = source;

    print(JSON.stringify(data));

    exports.oxmysql.insert(`INSERT INTO inventory`);

    TriggerClientEvent(
      "DoLongHudText",
      src,
      "Products purchased successfully!!!",
      0
    );
  }
);
