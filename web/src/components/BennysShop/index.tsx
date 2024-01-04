import { useState } from 'react'

import { IoCart } from 'react-icons/io5'
import { BENNYS_SHOP_ITEMS, ItemShopDTO } from '../../configs/bennysShop'
import { fetchNui } from '../../utils/fetchNui'

type Props = {
  visible: boolean
  onClose?: () => void
}

export default function BennysShop({ visible, onClose }: Props) {
  const [tab, setTab] = useState<"COSMETIC" | "PERFORMACE" | "CONSUMABLE" | "CART">("CONSUMABLE")

  const [cart, setCart] = useState<ItemShopDTO[]>([])


  const handleAddItemToCart = (item: ItemShopDTO) => {
    const tempItems: ItemShopDTO[] = []

    for (const _cartItem of cart) {
      tempItems.push(_cartItem)
    }

    tempItems.push(item)
    setCart(tempItems)

  }

  const handleRemoveToCart = (itemIndex: number) => {
    const tempItems: ItemShopDTO[] = []

    for (let index = 0; index < cart.length; index++) {
      if (index !== itemIndex) {
        tempItems.push(cart[index]);
      }
    }

    setCart(tempItems)
  }

  const handleCheckoutCartItems = () => {
    fetchNui("vnx-laptop:BennysShopPurchaseItems", { cart })
    setCart([])
  }

  const renderTab = () => {
    switch (tab) {
      case 'COSMETIC': return (
        <div className='w-[100%] h-[100%] overflow-auto p-2  ' >
        </div>
      )
      // case 'PERFORMACE':
      case 'CONSUMABLE':
        return (
          <div className='w-[100%] h-[100%] grid grid-cols-5 overflow-auto p-4 gap-3  ' >
            {BENNYS_SHOP_ITEMS.consumableParts.map((item, index) => {
              return (
                <div key={index} className='w-[100%] h-[300px]  flex flex-col items-center bg-[#202938] rounded-md gap-3 relative ' >
                  <img
                    src={item.photo}
                    className='w-[90px] h-[90px] mt-3 '
                  />

                  <h1 className='text-[18px] text-white font-semibold  ' >
                    {item.name}
                  </h1>

                  <h1 className='text-[18px] text-white font-semibold  ' >
                    Stock: {item.stock}
                  </h1>

                  <h1 className='text-[18px] text-white font-semibold  ' >
                    Price {item.price} Nort Coin
                  </h1>

                  <button
                    onClick={() => handleAddItemToCart(item)}
                    className='w-[140px] h-[40px] bg-[#5840B2] text-white text-[18px] font-semibold absolute bottom-4 rounded-md hover:scale-105 ease-in-out duration-100  ' >
                    Add to Cart
                  </button>
                </div>
              )
            })}
          </div>
        )
      default:
        return (
          <div className='w-[100%] h-[100%] flex flex-col items-center overflow-auto p-4 gap-2 ' >
            {cart.map((item, index) => {
              return (
                <div key={index} className='w-[100%] h-[110px] flex items-center bg-[#202938] rounded-sm gap-3 relative ' >
                  <div className='w-[20%] h-[100%] flex items-center pl-3   ' >
                    <img
                      src={item.photo}
                      className='w-[90px] h-[90px] mt-3 '
                    />
                  </div>


                  <div className='w-[60%] h-[100%]  flex flex-col gap-3 p-2  ' >
                    <h1 className='text-[18px] text-white font-semibold  ' >
                      {item.name}
                    </h1>

                    <h1 className='text-[18px] text-white font-semibold  ' >
                      Price {item.price} Nort Coin
                    </h1>
                  </div>

                  <div className='w-[20%] h-[100%] flex items-center justify-center ' >
                    <button
                      onClick={() => handleRemoveToCart(index)}
                      className='w-[150px] h-[40px] bg-[#5840B2] text-white text-[18px] font-semibold rounded-md hover:scale-105 ease-in-out duration-100  ' >
                      Remove to Cart
                    </button>
                  </div>
                </div>
              )
            })}
          </div>
        )
    }
  }

  return visible && (
    <div className="w-[80%] h-[85%] bg-[#121828] rounded-md z-50   " >
      <div className="w-[100%] h-[30px] bg-[#347eff] flex items-center justify-between pl-2 rounded-t-md mb-7 p-2 " >
        <h1 className="text-white font-semibold  " >
          Bennys Shop
        </h1>

        <button onClick={onClose} className="text-white font-semibold  " >
          X
        </button>
      </div>


      <div className="w-[100%] h-[90%] flex flex-col " >
        <div className="w-[100%] flex items-center justify-between p-2 " >
          <div className='flex items-center gap-2'>
            <button
              onClick={() => setTab("COSMETIC")}
              className={`
              w-[200px] h-[40px] text-white text-[18px] 
              ${tab === "COSMETIC" ? "bg-[#252525] rounded-md text-[#5E5780] " : null}
            `}
            >
              Cosmetic Parts
            </button>

            <button
              onClick={() => setTab("PERFORMACE")}
              className={`
              w-[200px] h-[40px] text-white text-[18px] 
              ${tab === "PERFORMACE" ? "bg-[#252525] rounded-md text-[#5E5780] " : null}
            `}
            >
              Performace Parts
            </button>

            <button
              onClick={() => setTab("CONSUMABLE")}
              className={`
              w-[200px] h-[40px] text-white text-[18px] 
              ${tab === "CONSUMABLE" ? "bg-[#252525] rounded-md text-[#5E5780] " : null}
            `}
            >
              Consumable Parts
            </button>
          </div>

          <div className='flex items-center gap-2'>
            <button
              onClick={() => setTab("CART")}
              className="w-[100px] h-[40px] flex items-center justify-center text-white text-[18px] bg-[#252525] rounded-md gap-4 relative "
            >
              Cart
              <IoCart />

              {cart.length > 0 && (
                <div className='w-[20px] h-[20px] bg-red-700 absolute top-[-5px] right-[-5px] text-[14px] font-semibold rounded-full ' >
                  {cart.length}
                </div>
              )}
            </button>

            {cart.length > 0 && tab === "CART" && (
              <button
                onClick={handleCheckoutCartItems}
                className="w-[100px] h-[40px] flex items-center justify-center text-white text-[18px] bg-[#252525] rounded-md gap-4 relative "
              >
                Checkout
              </button>
            )}
          </div>
        </div>

        {renderTab()}
      </div>
    </div>
  )
}