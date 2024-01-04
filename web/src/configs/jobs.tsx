import React from "react";
import { FaDrumstickBite, FaFaucet, FaFish, FaGem, FaHorse, FaMailBulk, FaRecycle, FaTruck } from "react-icons/fa";

type JOBSPROPS = {
  id: string;
  name: string;
  icon: React.ReactNode;
  limit: number;
  vpnRequired: boolean
  x: number;
  y: number;
};

export const JOBS: JOBSPROPS[] = [
  {
    id: "trucker",
    name: "24/7 Deliveries",
    icon: <FaTruck size={50} color="#FFF" />,
    limit: 2,
    vpnRequired: false,
    x: 919.13482666016,
    y: -1256.0007324219,
  },
  {
    id: "recycle",
    name: "Garbage Collector",
    icon: <FaRecycle size={50} color="#FFF" />,
    limit: 4,
    vpnRequired: false,
    x: -353.16677856445,
    y: -1542.1300048828,
  },
  {
    id: "fishing",
    name: "Fishing",
    icon: <FaFish size={50} color="#FFF" />,
    limit: 4,
    vpnRequired: false,
    x: -335.83563232422,
    y: 6106.2534179688,
  },
  {
    id: "waterandpower",
    name: "Water & Power",
    icon: <FaFaucet size={50} color="#FFF" />,
    limit: 2,
    vpnRequired: false,
    x: 448.0541,
    y: -1969.967,
  },
  {
    id: "postop",
    name: "Post OP",
    icon: <FaMailBulk size={50} color="#FFF" />,
    limit: 2,
    vpnRequired: false,
    x: -410.2616,
    y: -2795.366,
  },
  {
    id: "hunting",
    name: "Hunting",
    icon: <FaHorse size={50} color="#FFF" />,
    limit: 1,
    vpnRequired: false,
    x: -681.4046,
    y: 5832.3022,
  },
  {
    id: "chicken",
    name: "Chicken",
    icon: <FaDrumstickBite size={50} color="#FFF" />,
    limit: 1,
    vpnRequired: false,
    x: 2386.385,
    y: 5043.8427,
  },
  {
    id: "mining",
    name: "Mining",
    icon: <FaGem size={50} color="#FFF" />,
    limit: 1,
    vpnRequired: false,
    x: -595.1467,
    y: 2091.7565,
  },
  {
    id: "trucker",
    name: "24/7 Deliveries",
    icon: "fa-truck",
    limit: 2,
    vpnRequired: true,
    x: 919.13482666016,
    y: -1256.0007324219
  },
  {
    id: "recycle",
    name: "Garbage Collector",
    icon: "fa-recycle",
    limit: 4,
    vpnRequired: true,
    x: -353.16677856445,
    y: -1542.1300048828
  },
  {
    id: "chop_shop",
    name: "Chop Shop",
    icon: "fa-car-crash",
    limit: 9,
    vpnRequired: true,
    x: -231.4058,
    y: -1364.013
  },
  {
    id: "fishing",
    name: "Fishing",
    icon: "fa-fish",
    limit: 4,
    vpnRequired: true,
    x: -335.83563232422,
    y: 6106.2534179688
  },
  {
    id: "waterandpower",
    name: "Water & Power",
    icon: "fa-faucet",
    limit: 2,
    vpnRequired: true,
    x: 448.0541,
    y: -1969.967
  },
  {
    id: "postop",
    name: "Post OP",
    icon: "fa-mail-bulk",
    limit: 2,
    vpnRequired: true,
    x: -410.2616,
    y: -2795.366
  },
  {
    id: "hunting",
    name: "Hunting",
    icon: "fa-horse",
    limit: 1,
    vpnRequired: true,
    x: -681.4046,
    y: 5832.3022
  },
  {
    id: "chicken",
    name: "Chicken",
    icon: "fa-drumstick-bite",
    limit: 1,
    vpnRequired: true,
    x: 2386.385,
    y: 5043.8427
  },
  {
    id: "mining",
    name: "Mining",
    icon: "fa-gem",
    limit: 1,
    vpnRequired: true,
    x: -595.1467,
    y: 2091.7565
  }
];
