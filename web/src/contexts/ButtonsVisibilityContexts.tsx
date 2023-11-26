import { ReactNode, createContext, useContext, useState } from "react"
import { useNuiEvent } from "../hooks/useNuiEvent"

type ButtonsVisibilityContextsProps = {
  hnoImpostsVisible: boolean
  bennysVisible: boolean
  boostingVisible: boolean
}

type Props = {
  children: ReactNode
}

const ButtonsVisibilityContext = createContext<ButtonsVisibilityContextsProps>({} as ButtonsVisibilityContextsProps)

export default function ButtonsVisibilityProvider({ children }: Props) {
  const [bennysVisible, setBennysVisible] = useState(false)
  const [boostingVisible, setBoostingVisible] = useState(false)
  const [hnoImpostsVisible, setHnoImpostsVisible] = useState(false)

  useNuiEvent<boolean>("ButtonsVisibilityContext:setBennysVisible", setBennysVisible)
  useNuiEvent<boolean>("ButtonsVisibilityContext:setBoostingVisible", setBoostingVisible)
  useNuiEvent<boolean>("ButtonsVisibilityContext:setHnoImpostsVisible", setHnoImpostsVisible);

  return (
    <ButtonsVisibilityContext.Provider value={{ bennysVisible, boostingVisible, hnoImpostsVisible, }} >
      {children}
    </ButtonsVisibilityContext.Provider>
  )
}

export const useButtonsVisibility = () => {
  const context = useContext(ButtonsVisibilityContext)

  if (!context) {
    throw new Error("ButtonsVisibilityContext not defined")
  }

  return context
}