import { useState } from "react"
import { useNuiEvent } from "../../hooks/useNuiEvent"
import inDevelopment from "../../utils/useDevelopment"
import { fetchNui } from "../../utils/fetchNui"

type PlayerDataProps = {
  playerInWeedRun: boolean
}

type Props = {
  visible: boolean
  onClose: () => void
}

export default function WeedSystem({ visible, onClose }: Props) {
  const [playerInWeedRunJob, setPlayerInWeedRunJob] = useState(false)

  useNuiEvent<PlayerDataProps>("WeedSystem:setPlayerData", (data) => {
    setPlayerInWeedRunJob(data.playerInWeedRun)
  })

  const handleExistWeedRunJob = async () => {
    const isDevAmbient = inDevelopment()

    if (!isDevAmbient) {
      await fetchNui("vnx-laptop:NUIEvent:Weed:ExitJobQueue")
    }

    setPlayerInWeedRunJob(false)
  }


  return visible && (
    <div className="w-[70%] h-[80%] bg-[#121828] rounded-md z-50   " >
      <div className="w-[100%] h-[30px] bg-[#347eff] flex items-center justify-between pl-2 rounded-t-md mb-7 p-2 " >
        <h1 className="text-white font-semibold  " >
          Weed Run - Jobs and Management
        </h1>


        <button onClick={onClose} className="text-white font-semibold  " >
          X
        </button>
      </div>

      <div className="w-[100%] flex items-center justify-between p-3  " >
        <div className="flex items-center gap-3 " >
          <button
            className="w-[200px] h-[40px] flex items-center justify-center text-white text-[16px] bg-[#252525] rounded-md gap-4 relative "
          >
            My Data
          </button>
        </div>

        <button
          onClick={playerInWeedRunJob ? handleExistWeedRunJob : undefined}
          className="w-[200px] h-[40px] flex items-center justify-center text-white text-[16px] bg-[#252525] rounded-md gap-4 relative "
        >
          {playerInWeedRunJob ? "Quit Job" : "Await Job"}
        </button>
      </div>

      <div className="w-[100%] flex items-center justify-between p-3  " >
        <div className="w-[100px] flex items-center justify-center  " >
          <h1 className="text-white font-semibold  " >
            Little known
          </h1>
        </div>

        <div className="w-[90%] grid grid-cols-6 justify-items-center p-3 gap-2  " >
          <div className="w-[100%] h-[10px] bg-gradient-to-r from-red-500 via-red-300 to-red-100 rounded-md " />
          <div className="w-[100%] h-[10px] bg-slate-100 rounded-md " />
          <div className="w-[100%] h-[10px] bg-slate-100 rounded-md " />
          <div className="w-[100%] h-[10px] bg-slate-100 rounded-md " />
          <div className="w-[100%] h-[10px] bg-slate-100 rounded-md " />
          <div className="w-[100%] h-[10px] bg-slate-100 rounded-md " />
        </div>

        <div className="flex items-center justify-center  " >
          <h1 className="text-white font-semibold  " >
            Respected
          </h1>
        </div>
      </div>
    </div>
  )
}