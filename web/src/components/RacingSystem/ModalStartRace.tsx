import { fetchNui } from "../../utils/fetchNui"

type Props = {
  races?: object
  playerSource: number
  visible: boolean
  onClose: () => void
}

export default function ModalStartRace({ races, visible, playerSource, onClose }: Props) {
  const handleSubmit = async (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault()

    const raceName = document.getElementById("raceName") as HTMLInputElement
    const laps = document.getElementById("laps") as HTMLInputElement
    const countdown = document.getElementById("countdown") as HTMLInputElement

    if (!races) {
      return;
    }

    if (!raceName || !raceName.value) {
      return
    }

    if (!laps || !laps.value) {
      return
    }

    if (!countdown || !countdown.value) {
      return
    }

    const min = 10000;
    const max = 99999;
    const numeroAleatorio = Math.floor(Math.random() * (max - min + 1)) + min;

    await fetchNui("vnx-laptop:NUIEvent:Racing:CreateEvent", {
      raceUniqueID: numeroAleatorio,
      name: raceName.value,
      laps: laps.value,
      countdown: countdown.value,
      raceEvent: races,
      playerSource: playerSource
    })

    if (onClose) {
      onClose()
    }
  }

  return visible && (
    <div className="w-[100%] h-[100%] bg-black/25 flex items-center justify-center absolute top-0  ">
      <div className="w-[350px] h-[470px] bg-[#302F3C] rounded-md relative shadow-xl " >
        <div className="w-[100%] flex flex-row-reverse pr-2 pt-1 " >

          <button onClick={onClose} className="text-[18px] font-bold text-white  " >
            X
          </button>
        </div>

        <form onSubmit={handleSubmit}>
          <div className="w-[100%] flex flex-col p-3 gap-2  " >
            <label className="text-[20px] text-white font-semibold  ">
              Name
            </label>

            <div className="w-[100%] flex items-center justify-center  ">
              <input
                id='raceName'
                name='raceName'
                type='text'
                className='w-[100%] h-[40px] bg-[#6c788b] rounded-md focus:outline-none p-2 text-white font-semibold '
              />
            </div>

            <label className="text-[20px] text-white font-semibold  ">
              Laps
            </label>

            <div className="w-[100%] flex items-center justify-center  ">
              <input
                id='laps'
                name='laps'
                type='number'
                className='w-[100%] h-[40px] bg-[#6c788b] rounded-md focus:outline-none p-2 text-white font-semibold '
              />
            </div>

            <label className="text-[20px] text-white font-semibold  ">
              Countdown
            </label>

            <div className="w-[100%] flex items-center justify-center  ">
              <input
                id='countdown'
                name='countdown'
                // value={10}
                type='number'
                className='w-[100%] h-[40px] bg-[#6c788b] rounded-md focus:outline-none p-2 text-white font-semibold '
              />
            </div>

            <label className="text-[20px] text-white font-semibold  ">
              DNF
            </label>

            <div className="w-[100%] flex items-center justify-center  ">
              <input
                id='raceDescription'
                name='raceDescription'
                type='number'
                readOnly
                className='w-[100%] h-[40px] bg-[#6c788b] rounded-md focus:outline-none p-2 text-white font-semibold '
              />
            </div>
          </div>


          <button
            type="submit"
            className="w-[130px] h-[40px] bg-[#474C5B] text-[#BEE8EE] rounded-md absolute bottom-4 right-3 "
          >
            Save
          </button>
        </form>

      </div>
    </div>
  )
}