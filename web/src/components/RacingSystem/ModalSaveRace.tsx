import { fetchNui } from "../../utils/fetchNui"

type Props = {
  visible: boolean
  onClose: () => void
}

export default function ModalSaveRace({ visible, onClose }: Props) {

  const handleSubmit = async (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault()

    const raceName = document.getElementById("raceName") as HTMLInputElement
    const raceDescription = document.getElementById("raceDescription") as HTMLInputElement


    if (!raceName || !raceName.value) {
      return
    }

    if (!raceDescription || !raceDescription.value) {
      return
    }

    await fetchNui("vnx-laptop:NUIEvent:Racing:Save", {
      name: raceName.value,
      desc: raceDescription.value
    })

    if (onClose) {
      onClose()
    }
  }

  return visible && (
    <div className="w-[100%] h-[100%] bg-black/25 flex items-center justify-center absolute top-0  ">
      <div className="w-[400px] h-[300px] bg-[#302F3C] rounded-md relative shadow-xl " >
        <div className="w-[100%] flex flex-row-reverse pr-2 pt-1 " >

          <button onClick={onClose} className="text-[18px] font-bold text-white  " >
            X
          </button>
        </div>

        <form onSubmit={handleSubmit}>
          <div className="w-[100%] flex flex-col p-3 gap-2  " >
            <label className="text-[20px] text-white font-semibold  ">
              Race Name
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
              Description
            </label>

            <div className="w-[100%] flex items-center justify-center  ">
              <input
                id='raceDescription'
                name='raceDescription'
                type='text'
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