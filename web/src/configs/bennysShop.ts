import RacingHarness from "../assets/itens/harness.png";
import PhoneDongleRacing from "../assets/itens/racing_usb_blue.png";

export interface ItemShopDTO {
  id: string;
  name: string;
  stock: number;
  price: number;
  photo: string;
}

export interface BENNYS_SHOP_ITEMS_DTO {
  cosmeticParts: ItemShopDTO[];
  perfomaceParts: ItemShopDTO[];
  consumableParts: ItemShopDTO[];
}

export const BENNYS_SHOP_ITEMS: BENNYS_SHOP_ITEMS_DTO = {
  cosmeticParts: [],
  perfomaceParts: [],
  consumableParts: [
    {
      id: "racingusb1",
      name: "Phone Dongle",
      price: 50,
      stock: 1,
      photo: PhoneDongleRacing,
    },
    {
      id: "harness",
      name: "Racing Harness",
      stock: 1,
      price: 35,
      photo: RacingHarness,
    },
  ],
};
