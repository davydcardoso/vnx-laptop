import { useState } from "react"

import { fetchNui } from "../../utils/fetchNui"
import { useNuiEvent } from "../../hooks/useNuiEvent"

import ModalBlockPlayer from "./ModalBlockPlayer"
import ModalStartContract from "./ModalStartContract"

export type BoostingItemProps = {
  id: number
  type: string
  vehicle: string
  owner: string
  units: number
  expires: number
}

export type ResultCheckBoostingData = {
  MyContracts: []
  AlredyContract: boolean
  BoostingStatus: "ENABLED" | "DISABLED"
  PlayersInQueue: number
  ActiveContracts: number
  PendingContracts: number
}

type ResultBoostingQueueStatus = {
  QueueStatus: "ENABLED" | "DISABLED"
}

type Props = {
  visible: boolean
  onClose?: () => void
}

export default function BoostingSystem({ visible, onClose }: Props) {
  const [tab, setTab] = useState<"MY_CONTRACTS" | "PUPPET_MANAGEMENT">("MY_CONTRACTS")
  const [inQueue, setInQueue] = useState(false)
  const [contracts, setContracts] = useState<[]>([])
  const [playerIsPuppet, setPlayerIsPuppet] = useState(false)
  // const [alreadyContract, setAlreadyContract] = useState(false)
  const [contractSelected, setContractSelected] = useState<BoostingItemProps>()
  const [blockModalVisible, setBlockModalVisible] = useState(false)
  const [boostinQueueStatus, setBoostingQueueStatus] = useState<"ENABLED" | "DISABLED">("DISABLED")
  const [numberPlayersInQueue, setNumberPlayersInQueue] = useState<number>(0)
  const [numberActiveContracts, setNumberActiveContracts] = useState<number>(0)
  const [numberPendingContracts, setNumberPendingContracts] = useState<number>(0)
  const [startContractModalVisible, setStartContractModalVisible] = useState<boolean>(false)


  useNuiEvent<boolean>("BooostingSystem:PlayerInQueue", setInQueue)
  useNuiEvent<[]>("BoostingSystem:ResultMyBoostingContracts", setContracts)
  useNuiEvent<boolean>("BoostingContext:setPlayerIsPuppet", setPlayerIsPuppet)
  useNuiEvent<ResultCheckBoostingData>("BoostingSystem:ResultBoostingData", (data) => {
    // setAlreadyContract(data.AlredyContract)
    setBoostingQueueStatus(data.BoostingStatus)
    setNumberPlayersInQueue(data.PlayersInQueue)
    setNumberActiveContracts(data.ActiveContracts)
    setNumberPendingContracts(data.PendingContracts)
    setContracts(data.MyContracts)
  })
  useNuiEvent<ResultBoostingQueueStatus>("BoostingSystem:ResultBoostingQueueStatus", ({ QueueStatus }) => {
    setBoostingQueueStatus(QueueStatus)
  })

  const handleBlockModalVisibility = () => setBlockModalVisible(!blockModalVisible)

  const handleStartContractModalVisiblity = (contract: BoostingItemProps) => {
    setContractSelected(contract)
    setStartContractModalVisible(true)
  }

  const handleBoostingQueueStatus = async () => {
    await fetchNui("vnx-laptop:NUIEvent:Boosting:UpdateBoostingQueueStatus")
  }

  const handleBoostingJoinQueue = async () => {
    setInQueue(true)

    const resultJoinQueue = await fetchNui<boolean>("vnx-laptop:ClientSide:Boosting:JoinQueue", {
      inQueue: !inQueue,
      BoostingStatus: boostinQueueStatus
    })

    setInQueue(resultJoinQueue)
  }

  const handleStartBoostingContract = async (vehicleScraping: boolean) => {
    if (!contractSelected) {
      return
    }

    await fetchNui("vnx-laptop:NUIEvent:Boosting:StartContract", {
      IsVin: vehicleScraping,
      contract: contractSelected
    })

    setStartContractModalVisible(false)
  }

  const renderPage = () => {
    switch (tab) {
      case "MY_CONTRACTS":
        return (
          <div
            className="w-[100%] h-[80%] grid grid-cols-5 justify-items-center overflow-auto p-3 gap-3 "
          >
            {contracts.map((item: BoostingItemProps, index) => {
              return (
                <div
                  key={index}
                  className="w-[100%] max-h-[420px] flex flex-col items-center bg-[#202938]  rounded-md p-2 gap-2  "
                >
                  <div className="min-w-[80px] min-h-[80px] max-w-[80px] max-h-[80px] bg-[#121828] flex items-center justify-center rounded-full border-solid border-[1px] border-gray-500 " >
                    <h1 className="text-[20px] text-white font-semibold  " >
                      {item.type}
                    </h1>
                  </div>
                  <h1 className="text-[15px] text-[#949494] font-semibold " >
                    {item.owner}
                  </h1>

                  <h1 className="text-white text-[20px] font-bold    " >
                    {item.vehicle}
                  </h1>

                  <h1 className="text-[16px] text-white font-semibold " >
                    Buy In: {item.units} GNE
                  </h1>

                  <h1 className="text-[16px] text-[#05976A] font-semibold flex items-center gap-2" >
                    <p className="text-[16px] text-white font-semibold " >Expire In:</p>
                    {Math.floor(Math.round(item.expires) / (60 * 60))}h {Math.floor(Math.round(item.expires) % (60 * 60) / 60)}m {Math.ceil(Math.round(item.expires) % (60 * 60) % 60)}s
                  </h1>

                  <div className="h-[20px]  " />


                  <button
                    onClick={() => handleStartContractModalVisiblity(item)}
                    className="w-[90%] min-h-[40px] bg-[#302F3C] text-white font-semibold rounded-md hover:cursor-pointer hover:scale-105 ease-in-out duration-100  "
                  >
                    Start Contract
                  </button>

                  <button
                    onClick={() => { }}
                    className="w-[90%] min-h-[40px] bg-[#302F3C] text-white font-semibold rounded-md hover:cursor-pointer hover:scale-105 ease-in-out duration-100  "
                  >
                    Transfer Contract
                  </button>

                  <button
                    onClick={() => { }}
                    className="w-[90%] min-h-[40px] bg-[#302F3C] text-white font-semibold rounded-md hover:cursor-pointer hover:scale-105 ease-in-out duration-100  "
                  >
                    Decline Contract
                  </button>

                </div>
              )
            })}

          </div>
        )
      case "PUPPET_MANAGEMENT":
        return (
          <div className="w-[100%] h-[80%] overflow-auto p-3 gap-3 " >
            <div className="w-[100%] flex items-center p-4 gap-4  " >
              <div className="flex flex-col  " >
                <h1 className="text-white text-[17px] font-semibold  ">
                  Players In Queue
                </h1>

                <h1 className="text-[#7B7B83] text-[14px] font-semibold  ">
                  {numberPlayersInQueue} Players
                </h1>
              </div>

              <div className="flex flex-col  " >
                <h1 className="text-white text-[17px] font-semibold  ">
                  Active Contracts
                </h1>

                <h1 className="text-[#7B7B83] text-[14px] font-semibold  ">
                  {numberActiveContracts} Contracts
                </h1>
              </div>

              <div className="flex flex-col  " >
                <h1 className="text-white text-[17px] font-semibold  ">
                  Pending Contracts
                </h1>

                <h1 className="text-[#7B7B83] text-[14px] font-semibold  " >
                  {numberPendingContracts} Contracts
                </h1>
              </div>
            </div>

            <div className="w-[100%] flex items-center p-4 gap-10  " >
              <div className="flex flex-col gap-3 " >
                <h1 className="text-white text-[17px] font-semibold  ">
                  Queue Status ({boostinQueueStatus === "ENABLED" ? "Online" : "Offline"})
                </h1>

                <button
                  onClick={handleBoostingQueueStatus}
                  className="w-[130px] h-[40px] bg-[#474C5B] text-[#BEE8EE] rounded-md "
                >
                  {boostinQueueStatus === "ENABLED" ? "Disabled Queue" : "Enabled Queue"}
                </button>
              </div>

              <div className="flex flex-col  " >
                <div className="flex flex-col gap-3 " >
                  <h1 className="text-white text-[17px] font-semibold  ">
                    Block From Queue (StateID)
                  </h1>

                  <button
                    onClick={handleBlockModalVisibility}
                    className="w-[130px] h-[40px] bg-[#474C5B] text-[#BEE8EE] rounded-md "
                  >
                    Block
                  </button>
                </div>
              </div>
            </div>
          </div >
        )
      default:
        break;
    }
  }

  return visible && (
    <div className="w-[80%] h-[85%] bg-[#1B1745] rounded-md z-50 relative  " >
      <div className="w-[100%] h-[30px] bg-[#347eff] flex items-center justify-between pl-2 rounded-t-md mb-2 p-2 " >
        <h1 className="text-white font-semibold  " >
          Boosting
        </h1>

        <button onClick={onClose} className="text-white font-semibold  " >
          X
        </button>
      </div>

      <div className="w-[100%] flex items-center justify-between p-3  " >
        <div className="flex items-center gap-3 " >
          <button
            onClick={() => setTab("MY_CONTRACTS")}
            className="w-[200px] h-[40px] flex items-center justify-center text-white text-[16px] bg-[#252525] rounded-md gap-4 relative "
          >
            Contracts
          </button>


          {playerIsPuppet && (
            <button
              onClick={() => setTab("PUPPET_MANAGEMENT")}
              className="w-[200px] h-[40px] flex items-center justify-center text-white text-[16px] bg-[#252525] rounded-md gap-4 relative "
            >
              Puppet Management
            </button>
          )}
        </div>

        <button
          onClick={handleBoostingJoinQueue}
          className="w-[200px] h-[40px] flex items-center justify-center text-white text-[16px] bg-[#252525] rounded-md gap-4 relative "
        >
          {inQueue ? "Leave Queue" : "Join Queue"}
        </button>
      </div>

      {renderPage()}
      {ModalBlockPlayer({ visible: blockModalVisible, onClose: handleBlockModalVisibility })}
      {ModalStartContract({
        visible: startContractModalVisible,
        onClose() {
          setStartContractModalVisible(false)
        },
        function: {
          scrap() {
            handleStartBoostingContract(true)
          },
          dropoff() {
            handleStartBoostingContract(false)
          },
        }
      })}
    </div>
  )
}