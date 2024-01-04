import { fetchNui } from "../../utils/fetchNui"

type Props = {
  visible: boolean
  onClose: () => void
}

export default function ModalBlockPlayer({ visible, onClose }: Props) {

  const handleSubmit = (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault()

    const playerStateID = document.getElementById("playerStateId") as HTMLInputElement

    if (!playerStateID) {
      return
    }

    const StateId = playerStateID.value

    fetchNui("vnx-laptop:Boosting:BlockOrUnBlockPlayerFromBoosting", { StateId })

    if (onClose) {
      onClose()
    }
  }

  return visible && (
    <div className="w-[100%] h-[100%] bg-black/25 flex items-center justify-center absolute top-0  ">
      <div className="w-[400px] h-[200px] bg-[#302F3C] rounded-md relative shadow-xl " >
        <div className="w-[100%] flex flex-row-reverse pr-2 pt-1 " >

          <button onClick={onClose} className="text-[18px] font-bold text-white  " >
            X
          </button>
        </div>

        <form onSubmit={handleSubmit}>
          <div className="w-[100%] flex flex-col p-3 gap-2  " >
            <label className="text-[20px] text-white font-semibold  ">
              State ID
            </label>

            <div className="w-[100%] flex items-center justify-center  ">
              <input
                id='playerStateId'
                name='playerStateId'
                type='number'
                className='w-[100%] h-[40px] bg-[#6c788b] rounded-md focus:outline-none p-2 text-white font-semibold '
              />
            </div>
          </div>

          <button
            type="submit"
            className="w-[130px] h-[40px] bg-[#474C5B] text-[#BEE8EE] rounded-md absolute bottom-4 right-3 "
          >
            Confirm
          </button>
        </form>

      </div>
    </div>
  )
}