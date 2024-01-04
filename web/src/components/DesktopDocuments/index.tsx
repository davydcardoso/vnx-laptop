import { useState } from "react"

import { IoMdDownload } from 'react-icons/io'
import { FaShareAltSquare } from "react-icons/fa"
import { IoDocumentsSharp, IoTrashSharp } from "react-icons/io5"

import { useNuiEvent } from "../../hooks/useNuiEvent"

export type DocumentsResultData = {
  id: number
  cid: number
  title: string
  notes: string
  temp_doc: number
  editable: number;
  type_document: string
}


type Props = {
  visible: boolean
  onClose?: () => void
}

export default function DesktopDocuments({ visible, onClose }: Props) {

  const [tabs, setTabs] = useState<"NOTES" | "VEHICLES" | "LICENSES" | "DOCUMENTS">("NOTES")
  const [documents, setDocuments] = useState<DocumentsResultData[]>([])

  useNuiEvent<DocumentsResultData[]>("DesktopDocumentsSystem:setDocuments", setDocuments)

  return visible && (
    <div className="w-[70%] h-[80%] bg-[#121828] rounded-md z-50   " >
      <div className="w-[100%] h-[30px] bg-[#347eff] flex items-center justify-between pl-2 rounded-t-md mb-1 p-2 " >
        <h1 className="text-white font-semibold  " >
          Documents
        </h1>

        <button onClick={onClose} className="text-white font-semibold  " >
          X
        </button>
      </div>

      <div className="w-[100%] h-[93%] flex items-center pt-3  " >
        <div className="w-[200px] h-[100%] flex flex-col items-center border-solid border-r-[1px] border-[#202938] text-white gap-2 " >
          <div
            onClick={() => setTabs("NOTES")}
            className="w-[100%] flex items-center justify-center p-1 hover:cursor-pointer hover:bg-[#202938] ease-in-out duration-100  "
          >
            <div className="w-[30%] flex items-center justify-center  " >
              <IoMdDownload size={15} />
            </div>

            <div className="w-[100%] bg-red  " >
              <h1 className="text-[15px] font-semibold  " >Notes</h1>
            </div>
          </div>

          <div
            onClick={() => setTabs("VEHICLES")}
            className="w-[100%] flex items-center justify-center p-1 hover:cursor-pointer hover:bg-[#202938] ease-in-out duration-100  "
          >
            <div className="w-[30%] flex items-center justify-center  " >
              <IoDocumentsSharp size={15} />
            </div>

            <div className="w-[100%] bg-red  " >
              <h1 className="text-[15px] font-semibold  " >Vehicle</h1>
            </div>
          </div>

          <div
            onClick={() => setTabs("LICENSES")}
            className="w-[100%] flex items-center justify-center p-1 hover:cursor-pointer hover:bg-[#202938] ease-in-out duration-100  "
          >
            <div className="w-[30%] flex items-center justify-center  " >
              <IoDocumentsSharp size={15} />
            </div>

            <div className="w-[100%] bg-red  " >
              <h1 className="text-[15px] font-semibold  " >Licenses</h1>
            </div>
          </div>

          <div
            onClick={() => setTabs("DOCUMENTS")}
            className="w-[100%] flex items-center justify-center p-1 hover:cursor-pointer hover:bg-[#202938] ease-in-out duration-100  "
          >
            <div className="w-[30%] flex items-center justify-center  " >
              <IoDocumentsSharp size={15} />
            </div>

            <div className="w-[100%] bg-red  " >
              <h1 className="text-[15px] font-semibold  " >Documents</h1>
            </div>
          </div>
        </div>

        <div className="w-[100%] h-[100%] p-2 gap-2  " >
          <div className="w-[100%] flex flex-row-reverse items-center  " >
            <button
              // onClick={handleBlockModalVisibility}
              className="w-[100px] h-[40px] bg-[#474C5B] hover:bg-[#5d6479v] text-[#BEE8EE] rounded-md  "
            >
              Add New
            </button>
          </div>

          <div className="w-[100% h-[95%] grid grid-cols-2 justify-items-center overflow-auto p-2 gap-2 " >
            {/* {documents.length > 0 && documents?.map((document, index) => {
              if (document.type_document === tabs) {
                return (
                  <div
                    key={index}
                    className="w-[100%] h-[40px] flex items-center bg-[#202938] hover:cursor-pointer hover:bg-[#293241] relative  "
                  >
                    <div className="p-2 " >
                      <div>
                        <h1 className="text-[18px] text-white font-semibold " >
                          {document.title}
                        </h1>
                      </div>
                    </div>

                    <div className="flex items-center gap-2 absolute right-3   " >
                      <button className="text-[18px] text-white hover:scale-105 ease-in-out duration-100  " >
                        <FaShareAltSquare />
                      </button>

                      <button className="text-[18px] text-white hover:scale-105 ease-in-out duration-100  " >
                        <IoTrashSharp />
                      </button>
                    </div>
                  </div>
                )
              }
            })} */}
          </div>
        </div>
      </div>
    </div>
  )
}