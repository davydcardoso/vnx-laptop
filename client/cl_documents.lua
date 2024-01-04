RegisterNuiCallback("vnx-laptop:NUIEvent:Documents:GetMyDocuments", function(data, cb)
  local result = RPC.execute("vnx-laptop:ServerEvent:Documents:GetMyDocuments")

  SendReactMessage("DesktopDocumentsSystem:setDocuments", result)

  cb({})
end)
