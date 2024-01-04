import { RiUserShared2Fill } from "react-icons/ri"
import { JOBS } from "../../configs/jobs.tsx"

import { TbBrandCashapp } from 'react-icons/tb'
import { FaUsersBetweenLines } from "react-icons/fa6"

type Props = {
  visible: boolean
  onClose: () => void
}

export default function JobsSystem({ visible, onClose }: Props) {
  return visible && (
    <div className="w-[70%] h-[80%] bg-[#121828] rounded-md z-50   " >
      <div className="w-[100%] h-[30px] bg-[#347eff] flex items-center justify-between pl-2 rounded-t-md mb-7 p-2 " >
        <h1 className="text-white font-semibold  " >
          Jobs and Business
        </h1>


        <button onClick={onClose} className="text-white font-semibold  " >
          X
        </button>
      </div>

      <div className="w-[100%] h-[90%] grid grid-cols-5 -justify-items-center gap-3 p-2 overflow-auto  " >
        {JOBS.map((job) => {
          return (
            <div
              className="w-[100%] h-[240px] flex flex-col items-center hover:cursor-pointer hover:bg-[#40495a] bg-[#202938] rounded-md p-2 gap-2  "
            >
              <div className="w-[100%] h-[80px] flex items-center justify-center  " >
                {job.icon}
              </div>

              <h1 className="text-[15px] text-white font-semibold   " >{job.name}</h1>

              <div className="flex flex-row items-center gap-3 text-[18px] text-white font-semibold  " >
                2 <FaUsersBetweenLines />
              </div>

              <div className="flex flex-row items-center gap-3 text-[18px] text-white font-semibold  " >
                0 <RiUserShared2Fill />
              </div>

              <div className="flex flex-row items-center gap-2 text-[20px] text-green-800 font-semibold  " >
                <TbBrandCashapp />
                <TbBrandCashapp />
                <TbBrandCashapp />
                <TbBrandCashapp color="#303847" />
                <TbBrandCashapp color="#303847" />
              </div>
            </div>
          )
        })}
      </div>
    </div>
  )
}