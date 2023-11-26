type Props = {
  visible: boolean
  onClose?: () => void
}

export default function DesktopDocuments({ visible, onClose }: Props) {
  return visible && (
    <div className="w-[70%] h-[80%] bg-[#bdbdbd] rounded-md z-50   " >
      <div className="w-[100%] h-[30px] bg-[#000] flex items-center justify-between pl-2 rounded-t-md mb-7 p-2 " >
        <h1 className="text-white font-semibold  " >
          Meus Documentos
        </h1>


        <button onClick={onClose} className="text-white font-semibold  " >
          X
        </button>
      </div>



    </div>
  )
}