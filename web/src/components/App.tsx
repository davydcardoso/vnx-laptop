import "./App.css";

import React, { useState } from "react";

import { debugData } from "../utils/debugData";
// import { fetchNui } from "../utils/fetchNui";

import { FaWindows } from 'react-icons/fa'

import BnnysLogo from '../assets/bennys_logo.png'
import HnoImpotsPage from "./HnoImpotsPage";
import backgroundImage from '../assets/wallpaper.jpg'

import CarIcon from '../assets/car-icon.jpg'
import DesktopIcon from '../assets/desktop_icon.png'
import DesktopDocuments from "./DesktopDocuments";
import { useButtonsVisibility } from "../contexts/ButtonsVisibilityContexts";
import BennysShop from "./BennysShop";


debugData([
  {
    action: "setVisible",
    data: true,
  },
  {
    action: "ButtonsVisibilityContext:setBennysVisible",
    data: true
  },
  {
    action: "ButtonsVisibilityContext:setHnoImpostsVisible",
    data: true
  }
]);

const App: React.FC = () => {
  const { hnoImpostsVisible, bennysVisible } = useButtonsVisibility()
  const [visibleHNOImports, setVisibleHNOImports] = useState(false)
  const [visibleBennysShop, setVisibleBennysShop] = useState(false)
  const [visibleMyDocuments, setVisibleMyDocuments] = useState(false)

  const handleBennysShopVisibility = () => setVisibleBennysShop(!visibleBennysShop)
  const handleHnoImportsVisibility = () => setVisibleHNOImports(!visibleHNOImports)
  const handleMyDocumentsVisibility = () => setVisibleMyDocuments(!visibleMyDocuments)


  return (
    <div className="w-full h-screen bg-[#0000] flex items-center justify-center " >
      <div
        style={{
          backgroundImage: `url(${backgroundImage})`,
          backgroundSize: "cover",
          backgroundRepeat: "no-repeat",
        }}
        className="w-[85%] h-[80%] bg-[#b4b4b4] border-solid border-[3px] border-[#000] flex items-center justify-center rounded-md relative"
      >
        <div className="w-[100%] h-[100%] flex flex-col absolute p-7 gap-7 " >
          <div
            onClick={handleMyDocumentsVisibility}
            style={{
              backgroundImage: `url(${DesktopIcon})`,
              backgroundSize: "cover"
            }}
            className="w-[50px] h-[50px] hover:cursor-pointer hover:scale-110 ease-in-out duration-100   "
          />

          {
            hnoImpostsVisible
              ? (
                <div
                  onClick={handleHnoImportsVisibility}
                  className="w-[50px] -h-[50px] flex flex-col items-center gap-1 hover:cursor-pointer hover:scale-110 ease-in-out duration-100 "
                >
                  <div
                    style={{
                      backgroundImage: `url(${CarIcon})`,
                      backgroundSize: "cover"
                    }}
                    className="w-[50px] h-[50px]  rounded-md   "
                  />

                  <h1 className="text-[14px] font-bold " >Imports</h1>
                </div>
              )
              : null
          }

          {
            bennysVisible && (
              <div
                onClick={handleBennysShopVisibility}
                style={{
                  backgroundImage: `url(${BnnysLogo})`,
                  backgroundSize: "cover"
                }}
                className="w-[50px] h-[50px] hover:cursor-pointer hover:scale-110 ease-in-out duration-100 rounded-md  "
              />
            )
          }
        </div>

        {BennysShop({ visible: visibleBennysShop, onClose: handleBennysShopVisibility })}
        {HnoImpotsPage({ visible: visibleHNOImports, onClose: handleHnoImportsVisibility })}
        {DesktopDocuments({ visible: visibleMyDocuments, onClose: handleMyDocumentsVisibility })}

        <div className="w-[100%] h-[50px] bg-[#1d2235d7] absolute bottom-0 flex items-center justify-center gap-4  " >
          <FaWindows
            size={35}
            color="#FFF"
            className="hover:cursor-pointer hover:scale-110  "
          />
        </div>
      </div>
    </div>
  );

};

export default App;