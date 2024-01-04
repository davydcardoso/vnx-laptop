import { useState } from "react"
import { fetchNui } from "../../utils/fetchNui"
import { useNuiEvent } from "../../hooks/useNuiEvent"

import { LuMapPin } from 'react-icons/lu'
import { FaEye } from "react-icons/fa";
import { GiCancel, GiTrophy } from "react-icons/gi";
import { FaRegTrashAlt } from "react-icons/fa";
import { FaFlagCheckered } from "react-icons/fa";
import { IoArrowRedoSharp, IoCheckmarkDoneSharp } from "react-icons/io5";

import inDevelopment from "../../utils/useDevelopment";

import ModalSaveRace from "./ModalSaveRace"
import ModalStartRace from "./ModalStartRace";
import ModalPlayersRace from "./ModalPlayersRace";
import { IoIosExit } from "react-icons/io";

export type RacingItemProps = {
  id: number
  track_name: string
  creator: string
  checkpoints: string
  distance: string
  description: string
}

export type PlayersRaceProps = {
  src: number
  name: string
  stateId: string
}

export type RacingEventProps = {
  name: string;
  laps: number;
  started: boolean
  reverse: boolean
  finished: boolean
  distance: number
  uniqueID: string;
  countdown: number;
  creatorId: number
  checkpoints: object
  players: PlayersRaceProps[]
}

type Props = {
  visible: boolean
  onClose: () => void
}

export default function RacingSystem({ visible, onClose }: Props) {
  const [tab, setTab] = useState<"RACINGS" | "RACING_LIST">("RACINGS")
  const [racesEvents, setRacesEvents] = useState<RacingEventProps[]>([])
  const [playerSource, setPlayerSource] = useState<number>()
  const [inRaceCreate, setInRaceCreate] = useState(false)
  const [selectedRace, setSelectedRace] = useState<object>()
  const [playerIsPuppet, setPlayerIsPuppet] = useState(false)
  const [racesEventList, setRacesEventList] = useState<RacingItemProps[]>([])
  const [modalSaveRaceVisible, setModalSaveRaceVisible] = useState(false)
  const [modalStartRaceVisible, setModalStartRaceVisible] = useState(false)
  const [modalPlayerRaceVisible, setModalPlayerRaceVisible] = useState(false)
  const [playersFromRaceSelected, setPlayersFromRaceSelected] = useState<PlayersRaceProps[]>([])


  useNuiEvent<[]>("RacingSystem:setRacesEvents", setRacesEvents)
  useNuiEvent<number>("RacingSystem:setPlayerSource", setPlayerSource)
  useNuiEvent<boolean>("RacingSystem:setPlayerIsPuppet", setPlayerIsPuppet)

  const handleOpenRacesListEvents = async () => {
    const isDevAmbient = inDevelopment()

    if (!isDevAmbient) {
      const result = await fetchNui<RacingItemProps[]>("vnx-laptop:NUIEvent:Racing:ListEvents")
      setRacesEventList(result)
    }

    setTab("RACING_LIST")
  }

  const handleModalSaveRaceVisibility = () => setModalSaveRaceVisible(!modalSaveRaceVisible)

  const handleModalStartRaceVisibility = () => setModalStartRaceVisible(!modalStartRaceVisible)

  const handleModalPlayerRaceVisibility = () => setModalPlayerRaceVisible(!modalPlayerRaceVisible)

  const handleRaceCreation = async () => {
    await fetchNui("vnx-laptop:NUIEvent:Racing:Create")

    setInRaceCreate(true)
  }

  const handleCancelCreateRace = async () => {

    await fetchNui("vnx-laptop:NUIEvent:Racing:CancelCreate")

    setInRaceCreate(false)
  }

  const handleShowPlayerJoined = async (raceUniqueID: string) => {
    const result = await fetchNui<RacingEventProps>("vnx-laptop:NUIEvent:Racing:GetPlayerRaceList", { raceUniqueID })

    if (result) {
      setPlayersFromRaceSelected(result.players)

      setModalPlayerRaceVisible(!modalPlayerRaceVisible)
    }
  }

  const handleViewerRaceEvent = async (raceUniqueID: string) => {
    await fetchNui("vnx-laptop:NUIEvent:Racing:ViewRaceEvent", { raceUniqueID })
  }

  const handleStartRaceEvent = async (raceUniqueID: string) => {
    await fetchNui("vnx-laptop:NUIEvent:Racing:StartRaceEvent", { raceUniqueID, playerSource })
  }

  const handleCancelRaceEnvent = async (raceUniqueID: string) => {
    await fetchNui("vnx-laptop:NUIEvent:Racing:CancelEvent", { raceUniqueID })
  }

  const handleMarkerStartRace = async (raceUniqueID: string) => {
    await fetchNui("vnx-laptop:NUIEvent:Racing:MarkerRaceInMap", { raceUniqueID })
  }

  const handleExitRaceEvent = async (raceUniqueID: string) => {
    await fetchNui("vnx-laptop:NUIEvent:Racing:ExitRaceEvent", { raceUniqueID, playerSource })
  }

  const handleJoinRace = async (raceUniqueID: string) => {
    await fetchNui("vnx-laptop:NUIEvent:Racing:JoinEvent", { raceUniqueID, playerSource })
  }

  const handleFinishRaceEvent = async (raceUniqueID: string) => {
    await fetchNui("vnx-laptop:NUIEvent:Racing:FinishRaceEvent", { raceUniqueID, playerSource })
  }

  const render = () => {
    switch (tab) {
      case "RACING_LIST":
        return (
          <div className="w-[100% -h-[95%] grid grid-cols-2  overflow-auto p-2 gap-2 " >
            {racesEventList.map((race, index) => {
              return (
                <div
                  key={index}
                  className="w-[100%] h-[60px] flex items-center bg-[#202938] hover:cursor-pointer hover:bg-[#293241] relative  "
                >
                  <div className="p-2 " >
                    <div
                      className="h-[90%]  " >
                      <h1 className="text-[15px] text-white font-semibold " >
                        {race.track_name}
                      </h1>

                      <h1 className="text-[13px] text-white font-semibold " >
                        {race.description}
                      </h1>
                    </div>
                  </div>

                  <div className="flex items-center gap-2 absolute right-3   " >
                    <button
                      onClick={() => {
                        setSelectedRace(race)
                        handleModalStartRaceVisibility()
                      }}
                      className="text-[18px] text-white hover:scale-105 ease-in-out duration-100  " >
                      <FaFlagCheckered />
                    </button>

                    <button
                      onClick={() => handleViewerRaceEvent(String(race.id))}
                      className="text-[18px] text-white hover:scale-105 ease-in-out duration-100  "
                    >
                      <FaEye />
                    </button>

                    <button className="text-[18px] text-white hover:scale-105 ease-in-out duration-100  " >
                      <GiTrophy />
                    </button>


                    {playerIsPuppet && (
                      <button className="text-[18px] text-white hover:scale-105 ease-in-out duration-100  " >
                        <FaRegTrashAlt />
                      </button>
                    )}
                  </div>
                </div>
              )
            })}
          </div>
        )
      default:
        return (
          <div className="w-[100% -h-[95%] grid grid-cols-2  overflow-auto p-2 gap-2 " >
            {racesEvents.map((race, index) => {
              return (
                <div
                  key={index}
                  className="w-[100%] h-[60px] flex items-center bg-[#202938] hover:cursor-pointer hover:bg-[#293241] relative  "
                >
                  <div className="p-2 " >
                    <div
                      onClick={() => handleShowPlayerJoined(race.uniqueID)}
                      className="h-[90%] " >
                      <h1 className="text-[15px] text-white font-semibold " >
                        {race.name}
                      </h1>

                      <h1 className="text-[13px] text-white font-semibold " >
                        {race.laps == 1
                          ? (
                            <>
                              Sprint
                            </>
                          )
                          : (
                            <>
                              Laps: {race.laps}
                            </>
                          )
                        } - Countdown: {race.countdown}s
                      </h1>
                    </div>
                  </div>

                  <div className="flex items-center gap-2 absolute right-3   " >
                    {race.creatorId === playerSource && !race.finished && (
                      <>
                        <button
                          onClick={() => handleStartRaceEvent(race.uniqueID)}
                          className="text-[18px] text-white hover:scale-105 ease-in-out duration-100  " >
                          <FaFlagCheckered />
                        </button>

                        <button
                          onClick={() => {
                            setSelectedRace(race)
                            handleCancelRaceEnvent(race.uniqueID)
                          }}
                          className="text-[18px] text-white hover:scale-105 ease-in-out duration-100  " >
                          <GiCancel />
                        </button>

                        {
                          race.started && (
                            <button
                              onClick={() => handleFinishRaceEvent(race.uniqueID)}
                              className="text-[18px] text-white hover:scale-105 ease-in-out duration-100  " >
                              <IoCheckmarkDoneSharp />
                            </button>
                          )
                        }
                      </>
                    )}

                    {
                      !race.finished && !race.started && (
                        <>
                          {race.creatorId !== playerSource && race.players.some((item) => item.src === playerSource) && (
                            <button
                              onClick={() => handleExitRaceEvent(race.uniqueID)}
                              className="text-[18px] text-white hover:scale-105 ease-in-out duration-100  " >
                              <IoIosExit />
                            </button>
                          )}

                          <button
                            onClick={() => {
                              setSelectedRace(race)
                              handleJoinRace(race.uniqueID)
                            }}
                            className="text-[18px] text-white hover:scale-105 ease-in-out duration-100  " >
                            <IoArrowRedoSharp />
                          </button>

                          <button
                            onClick={() => handleMarkerStartRace(race.uniqueID)}
                            className="text-[18px] text-white hover:scale-105 ease-in-out duration-100  " >
                            <LuMapPin />
                          </button>
                        </>
                      )
                    }
                  </div>
                </div>
              )
            })}
          </div>
        )
    }
  }

  return visible && (
    <div className="w-[70%] h-[80%] bg-[#121828] rounded-md z-50  relative " >
      <div className="w-[100%] h-[30px] bg-[#347eff] flex items-center justify-between pl-2 rounded-t-md mb-7 p-2 " >
        <h1 className="text-white font-semibold  " >
          Racing
        </h1>

        <button onClick={onClose} className="text-white font-semibold  " >
          X
        </button>
      </div>

      <div className="w-[100%] flex items-center justify-between p-3  " >
        <div className="flex items-center gap-3 " >
          <button
            onClick={() => setTab("RACINGS")}
            className="w-[200px] h-[40px] flex items-center justify-center text-white text-[16px] bg-[#252525] rounded-md gap-4 relative "
          >
            Events
          </button>



          <button
            onClick={handleOpenRacesListEvents}
            className="w-[200px] h-[40px] flex items-center justify-center text-white text-[16px] bg-[#252525] rounded-md gap-4 relative "
          >
            Racing List
          </button>
        </div>

        {tab === "RACING_LIST" && playerIsPuppet && (
          <>
            {!inRaceCreate
              ? (
                <button
                  onClick={handleRaceCreation}
                  className="w-[200px] h-[40px] flex items-center justify-center text-white text-[16px] bg-[#252525] rounded-md gap-4 relative "
                >
                  Create Races
                </button>
              )
              : (
                <div className="flex items-center gap-3  " >
                  <button
                    onClick={handleModalSaveRaceVisibility}
                    className="w-[200px] h-[40px] flex items-center justify-center text-white text-[16px] bg-[#252525] rounded-md gap-4 relative "
                  >
                    Save Race
                  </button>

                  <button
                    onClick={handleCancelCreateRace}
                    className="w-[200px] h-[40px] flex items-center justify-center text-white text-[16px] bg-[#252525] rounded-md gap-4 relative "
                  >
                    Cancel
                  </button>
                </div>
              )
            }
          </>
        )}
      </div>

      {render()}

      {ModalStartRace({
        races: selectedRace,
        playerSource: playerSource as number,
        visible: modalStartRaceVisible,
        onClose: handleModalStartRaceVisibility
      })}
      {ModalSaveRace({
        visible: modalSaveRaceVisible,
        onClose: () => {
          handleCancelCreateRace()
          handleModalSaveRaceVisibility()
        }
      })}
      {ModalPlayersRace({
        players: playersFromRaceSelected,
        creatorSourceId: playerSource as number,
        visible: modalPlayerRaceVisible,
        onClose: handleModalPlayerRaceVisibility
      })}

    </div>
  )
}