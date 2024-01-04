import { HiOutlineLockClosed } from 'react-icons/hi'
import { IoMdCloseCircleOutline } from "react-icons/io"
import { fetchNui } from '../../utils/fetchNui'

type Props = {
  visible: boolean
  creatorSourceId: number
  players?: {
    src: number
    name: string
    stateId: string
    vehicleModel?: string
  }[]
  onClose?: () => void
}

export default function ModalPlayersRace({ visible, players = [], creatorSourceId, onClose }: Props) {

  const handleKickPlayerFromRace = async (sourceId: number) => {
    await fetchNui("vnx-laptop:NUIEvent:Racing:KickPlayerRace", { sourceId, creatorSourceId })
  }

  const handleBanPlayerRaces = async (sourceId: number) => {
    await fetchNui("vnx-laptop:NUIEvent:Racing:BanPlayerRaces", { sourceId, creatorSourceId })
  }

  return visible && (
    <div className="w-[100%] h-[100%] bg-black/25 flex items-center justify-center absolute top-0 ">
      <div className="w-[350px] h-[470px] bg-[#302F3C] rounded-md relative shadow-xl " >
        <div className="w-[100%] flex flex-row-reverse pr-2 pt-1 " >
          <button onClick={onClose} className="text-[18px] font-bold text-white  " >
            X
          </button>
        </div>

        <div className="w-[100%] h-[90%] flex flex-col items-center  overflow-auto p-3 " >
          {players.map(item => {
            return (
              <div
                key={item.src}
                className="w-[100%] h-[60px] flex items-center justify-between hover:cursor-pointer hover:font-extrabold border-solid border-b-[0.5px] border-[#FFF] p-2 " >
                <div className="flex flex-col gap-[0.5px] " >
                  <h1 className="text-[15px] text-white font-semibold " >
                    {item.name}
                  </h1>
                  <h1 className="text-[13px] text-white font-semibold " >
                    {item.vehicleModel}
                  </h1>
                </div>

                <div className="flex flex-row items-center justify-center gap-2 " >
                  <button
                    onClick={() => handleKickPlayerFromRace(item.src)}
                    className="w-[20px] h-[20px] text-[17px] text-white hover:scale-110 ease-in-out duration-100  " >
                    <IoMdCloseCircleOutline />
                  </button>

                  <button
                    onClick={() => handleBanPlayerRaces(item.src)}
                    className="w-[20px] h-[20px] text-[17px] text-white hover:scale-110 ease-in-out duration-100  " >
                    <HiOutlineLockClosed />
                  </button>
                </div>
              </div>
            )
          })}
        </div>
      </div>
    </div>
  )
}