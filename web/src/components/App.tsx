import "./App.css";

import React, { useState } from "react";

import { debugData } from "../utils/debugData";
import { fetchNui } from "../utils/fetchNui";

import { FaWindows } from 'react-icons/fa'
import { RiMessage2Fill } from 'react-icons/ri'

import inDevelopment from "../utils/useDevelopment";

import { useButtonsVisibility } from "../contexts/ButtonsVisibilityContexts";

import WeedIcon from '../assets/weed_icon.png'
import BnnysLogo from '../assets/bennys_logo.png'
import JobsSystem from "./JobsSystem";
import BennysShop from "./BennysShop";
import RacingSystem from "./RacingSystem";
import HnoImpotsPage from "./HnoImpotsPage";
import BoostingSystem from "./BoostingSystem";

import BigMBackground from '../assets/BigM5.png'
import WindowsWallpaper from '../assets/windows_wallpaper.jpg'

import CarIcon from '../assets/car-icon.jpg'
import JobsIcon from '../assets/jobs_icon.png'
import RacingIcon from '../assets/racing_icon.png'
import DesktopIcon from '../assets/desktop_icon.png'
import BoostingIcon from '../assets/boosting_icon.png'
import DesktopDocuments from "./DesktopDocuments";
import WeedSystem from "./WeedSystem";


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
  },
  {
    action: "ButtonsVisibilityContext:setBoostingVisible",
    data: true,
  },
  {
    action: "BoostingContext:setPlayerIsPuppet",
    data: true
  },
  {
    action: "ButtonsVisibilityContext:setRacingVisible",
    data: true
  },
  {
    action: "ButtonsVisibilityContext:setWeedAppVisible",
    data: true
  }
]);

const App: React.FC = () => {
  const { hnoImpostsVisible, racingVisible, weedAppVisible, bennysVisible, boostingVisible } = useButtonsVisibility()

  const [visibleRacing, setVisibleRacing] = useState(false)
  const [visibleJobsSystem, setVisibleJobsSystem] = useState(false)
  const [visibleHNOImports, setVisibleHNOImports] = useState(false)
  const [visibleBennysShop, setVisibleBennysShop] = useState(false)
  const [visibleWeedSystem, setVisibleWeedSystem] = useState(false)
  const [visibleMyDocuments, setVisibleMyDocuments] = useState(false)
  const [visibleBoostingSystem, setVisibleBoostingSystem] = useState(false)

  const handleJobsSystemVisiblity = () => setVisibleJobsSystem(!visibleJobsSystem)
  const handleBennysShopVisibility = () => setVisibleBennysShop(!visibleBennysShop)
  const handleHnoImportsVisibility = () => setVisibleHNOImports(!visibleHNOImports)

  const handleWeedSystemVisibility = async () => {
    const isDevAmbient = inDevelopment()

    if (!isDevAmbient) {
      await fetchNui("vnx-laptop:NUIEvent:Weed:GetWedData")
    }

    setVisibleWeedSystem(!visibleWeedSystem)
  }

  const handleRacingSystemVisibility = async () => {
    const isDevAmbient = inDevelopment()

    if (!isDevAmbient) {
      await fetchNui("vnx-laptop:NUIEvent:Racing:CheckPlayerData")
    }

    setVisibleRacing(!visibleRacing)
  }

  const handleMyDocumentsVisibility = async () => {
    const isDevAmbient = inDevelopment()

    if (!visibleMyDocuments) {
      if (!isDevAmbient) {
        await fetchNui("vnx-laptop:NUIEvent:Documents:GetMyDocuments")
      }
    }

    setVisibleMyDocuments(!visibleMyDocuments)
  }

  const handleBoostingSystemVisibility = async () => {

    if (!visibleBoostingSystem) {
      const isDevAmbient = inDevelopment()

      if (!isDevAmbient) {
        await fetchNui("vnx-laptop:Boosting:OpenBoostingApp:StartEvents", {})
      }
    }

    setVisibleBoostingSystem(!visibleBoostingSystem)
  }

  return (
    <div className="w-full h-screen bg-[#0000] flex items-center justify-center " >
      <div
        className="w-[85%] h-[80%] bg-[#b4b4b4] border-solid border-[3px] border-[#000] flex items-center justify-center rounded-md relative"
      >
        <img
          src={boostingVisible ? BigMBackground : WindowsWallpaper}
          className="w-[100%] h-[100%] absolute  "
        />

        <div className="w-[100%] h-[100%] flex flex-col absolute p-7 gap-7 " >
          <div
            onClick={handleMyDocumentsVisibility}
            style={{
              backgroundImage: `url(${DesktopIcon})`,
              backgroundSize: "contain"
            }}
            className="w-[50px] h-[50px] hover:cursor-pointer hover:scale-110 ease-in-out duration-100   "
          />

          <div
            onClick={handleJobsSystemVisiblity}
            className="w-[50px] -h-[50px]  flex flex-col items-center gap-1 hover:cursor-pointer hover:scale-110 ease-in-out duration-100 "
          >
            <div
              className="w-[50px] h-[50px]  rounded-md  bg-white flex items-center justify-center "
            >
              <div
                style={{
                  backgroundImage: `url(${JobsIcon})`,
                  backgroundSize: "cover"
                }}
                className="w-[40px] h-[40px]"
              />
            </div>

            <h1 className="text-[12px] text-white font-bold  " >Jobs</h1>
          </div>



          {
            bennysVisible && (
              <div
                onClick={handleBennysShopVisibility}
                className="w-[50px] -h-[50px]  flex flex-col items-center gap-1 hover:cursor-pointer hover:scale-110 ease-in-out duration-100 "
              >
                <div className="w-[50px] h-[50px]  rounded-md  bg-white flex items-center justify-center ">
                  <div
                    style={{ backgroundImage: `url(${BnnysLogo})`, backgroundSize: "cover" }}
                    className="w-[40px] h-[40px]"
                  />
                </div>

                <h1 className="text-[12px] text-white font-bold  " >Bennys</h1>
              </div>
            )
          }

          {
            weedAppVisible && (
              <div
                onClick={handleWeedSystemVisibility}
                className="w-[50px] -h-[50px]  flex flex-col items-center gap-1 hover:cursor-pointer hover:scale-110 ease-in-out duration-100 "
              >
                <div className="w-[50px] h-[50px]  rounded-md  bg-white flex items-center justify-center ">
                  <div
                    style={{ backgroundImage: `url(${WeedIcon})`, backgroundSize: "cover" }}
                    className="w-[40px] h-[40px]"
                  />
                </div>

                <h1 className="text-[12px] text-white font-bold  " >Weed</h1>
              </div>
            )
          }

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

                  <h1 className="text-[12px] text-white font-bold  " >Imports</h1>
                </div>
              )
              : null
          }

          {
            boostingVisible
              ? (
                <div
                  onClick={handleBoostingSystemVisibility}
                  className="w-[50px] -h-[50px]  flex flex-col items-center gap-1 hover:cursor-pointer hover:scale-110 ease-in-out duration-100 "
                >
                  <div
                    className="w-[50px] h-[50px]  rounded-md  bg-white flex items-center justify-center "
                  >
                    <div
                      style={{
                        backgroundImage: `url(${BoostingIcon})`,
                        backgroundSize: "cover"
                      }}
                      className="w-[40px] h-[40px]"
                    />
                  </div>

                  <h1 className="text-[12px] text-white font-bold  " >Boosting</h1>
                </div>
              )
              : null
          }


          {
            racingVisible
              ? (
                <div
                  onClick={handleRacingSystemVisibility}
                  className="w-[50px] -h-[50px]  flex flex-col items-center gap-1 hover:cursor-pointer hover:scale-110 ease-in-out duration-100 "
                >
                  <div
                    className="w-[50px] h-[50px]  rounded-md  bg-white flex items-center justify-center "
                  >
                    <div
                      style={{
                        backgroundImage: `url(${RacingIcon})`,
                        backgroundSize: "cover"
                      }}
                      className="w-[40px] h-[40px]"
                    />
                  </div>

                  <h1 className="text-[12px] text-white font-bold  " >Races</h1>
                </div>
              )
              : null
          }

        </div>

        {JobsSystem({ visible: visibleJobsSystem, onClose: handleJobsSystemVisiblity })}
        {BennysShop({ visible: visibleBennysShop, onClose: handleBennysShopVisibility })}
        {RacingSystem({ visible: visibleRacing, onClose: handleRacingSystemVisibility })}
        {WeedSystem({ visible: visibleWeedSystem, onClose: handleWeedSystemVisibility })}
        {HnoImpotsPage({ visible: visibleHNOImports, onClose: handleHnoImportsVisibility })}
        {BoostingSystem({ visible: visibleBoostingSystem, onClose: handleBoostingSystemVisibility })}
        {DesktopDocuments({ visible: visibleMyDocuments, onClose: handleMyDocumentsVisibility })}

        <div className="w-[100%] h-[50px] bg-[#1d2235d7] absolute bottom-0 flex items-center justify-center gap-4  " >
          <FaWindows
            size={35}
            color="#FFF"
            className="hover:cursor-pointer hover:scale-110  "
          />

          <div className="absolute right-3  " >
            <RiMessage2Fill
              size={35}
              color="#FFF"
              className="hover:cursor-pointer hover:scale-110  "
            />
          </div>
        </div>
      </div>
    </div>
  );

};

export default App;