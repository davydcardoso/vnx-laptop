import { ReactNode, createContext, useContext, useState } from "react"

type NotificationsContextProps = {
  notify: object[]
}

type Props = {
  children: ReactNode
}

const NotificationsContext = createContext<NotificationsContextProps>({} as NotificationsContextProps)

export default function NotificationsProvider({ children }: Props) {
  const [notify, setNotify] = useState<object[]>([])





  return (
    <NotificationsContext.Provider value={{ notify }} >
      {children}
    </NotificationsContext.Provider>
  )
}


export function useNotification() {
  const context = useContext(NotificationsContext)

  if (!context) {
    throw new Error("Notification Context/Provider not defined")
  }

  return context
}