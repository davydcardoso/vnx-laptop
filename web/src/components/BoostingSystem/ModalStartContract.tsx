type Props = {
  visible: boolean
  onClose: () => void
  function?: {
    scrap?: () => void
    dropoff?: () => void
  }
}

export default function ModalStartContract({ visible, onClose, function: functionsOptions }: Props) {
  return visible && (
    <div className="w-[100%] h-[100%] bg-black/25 flex items-center justify-center absolute top-0  ">
      <div className="w-[280px] h-[220px] bg-[#302F3C] rounded-md relative shadow-xl " >
        <div className="w-[100%] flex flex-row-reverse pr-2 pt-1 " >

          <button onClick={onClose} className="text-[18px] font-bold text-white  " >
            X
          </button>
        </div>

        <div className="w-[100%] h-[90%] flex flex-col items-center mt-4 gap-4 p-3  " >
          <button
            onClick={() => functionsOptions && functionsOptions.scrap && functionsOptions.scrap()}
            className="w-[100%] h-[50px] flex items-center justify-center text-white text-[16px] bg-[#252525] hover:bg-[#464646] rounded-md gap-4 relative "
          >
            Chassis Scraping
          </button>

          <button
            onClick={() => functionsOptions && functionsOptions.dropoff && functionsOptions.dropoff()}
            className="w-[100%] h-[50px] flex items-center justify-center text-white text-[16px] bg-[#252525] hover:bg-[#464646] rounded-md gap-4 relative "
          >
            Drop Off
          </button>
        </div>

      </div>
    </div>
  )
}