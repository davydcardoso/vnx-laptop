import { useState } from 'react'

import { CARS_LIST, CarItem } from "../../configs/cars"
import { fetchNui } from '../../utils/fetchNui'

type Props = {
  visible: boolean
  onClose?: () => void
}


export default function HnoImpotsPage({ visible, onClose }: Props) {
  const [selectedCar, setSelectedCar] = useState<CarItem>()
  const [visibleSaleCar, setVisibleSaleCar] = useState(false)

  const handelSetVisibleSaleCar = () => setVisibleSaleCar(!visibleSaleCar)

  const handleSubmit = (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault()

    const playerStateID = document.getElementById("playerStateId") as HTMLInputElement

    if (!playerStateID) {
      return
    }

    const StateId = playerStateID.value

    fetchNui("vnx-laptop:SaleVehicleForPlayer", { StateId, selectedCar })

    handelSetVisibleSaleCar()
  }

  const handleSpawnVehicle = (car: CarItem) => {
    fetchNui("vnx-laptop:SpawnVehicleHNO", { selectedCar: car })
  }

  return visible && (
    <>
      <div className="w-[70%] h-[80%] bg-[#121828] rounded-md z-50   " >
        <div className="w-[100%] h-[30px] bg-[#000] flex items-center justify-between pl-2 rounded-t-md mb-7 p-2  " >
          <h1 className="text-white font-semibold  " >
            HnO Imports
          </h1>

          <button onClick={onClose} className="text-white font-semibold  " >
            X
          </button>
        </div>

        <div className="w-[100%] h-[90%] -bg-red-400 p-4 grid grid-cols-5 justify-items-center gap-2 overflow-auto  " >
          {CARS_LIST.map((car) => {
            return (
              <div
                key={car.id}
                className="w-[100%] h-[350px] flex flex-col items-center bg-[#202938]  rounded-md p-4 gap-3  "
              >
                <div className="w-[80px] h-[80px] bg-[#121828] flex items-center justify-center rounded-full border-solid border-[1px] border-gray-500 " >
                  <h1 className="text-[20px] text-white font-semibold  " >
                    {car.class}
                  </h1>
                </div>

                <h1 className="text-white text-[20px] font-bold    " >
                  {car.name}
                </h1>

                <h1 className="text-[18px] text-[#05976A] font-semibold " >
                  R$ {car.price.toLocaleString("en", { minimumFractionDigits: 2 })}
                </h1>

                <h1 className="text-[18px] text-[#FFF] font-semibold " >
                  Unidades {car.stock}
                </h1>


                <button
                  onClick={() => {
                    setSelectedCar(car)
                    handleSpawnVehicle(car)
                  }}
                  className="w-[90%] h-[40px] bg-[#05976A] text-white font-semibold rounded-md hover:cursor-pointer hover:scale-105 ease-in-out duration-100  "
                >
                  Spawn
                </button>

                <button
                  onClick={() => {
                    setSelectedCar(car)
                    handelSetVisibleSaleCar()
                  }}
                  className="w-[90%] h-[40px] bg-[#2364EB] text-white font-semibold rounded-md hover:cursor-pointer hover:scale-105 ease-in-out duration-100  "
                >
                  Vender Carro
                </button>

              </div>
            )
          })}

        </div>
      </div>

      {visibleSaleCar && (
        <div className='w-[400px] h-[180px] bg-[#202938] flex flex-col z-50 absolute shadow-md rounded-md p-4  ' >
          <button onClick={handelSetVisibleSaleCar} className='text-white text-[20px] absolute right-5 font-bold  ' >
            X
          </button>

          <form onSubmit={handleSubmit} >


            <label className="text-[20px] text-white font-semibold  ">State ID</label>
            <div className='w-[100%] h-[80%] flex items-center justify-center p-4 ' >
              <input
                id='playerStateId'
                name='playerStateId'
                type='number'
                className='w-[100%] h-[40px] bg-[#6c788b] rounded-md focus:outline-none p-2 text-white font-semibold '
              />
            </div>


            <button
              type='submit'
              className='w-[200px] h-[40px] bg-[#05976A] rounded-md text-white absolute right-5  '
            >
              Vender
            </button>
          </form>
        </div >
      )
      }
    </>
  )
}