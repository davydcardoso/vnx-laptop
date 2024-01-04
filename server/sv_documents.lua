RPC.register("vnx-laptop:ServerEvent:Documents:GetMyDocuments", function(pSource)
  local user = exports["str-base"]:getModule("Player"):GetUser(pSource)
  local char = user:getCurrentCharacter()
  local stateId = char.id

  print("vnx-laptop:ServerEvent:Documents:GetMyDocuments:PlayerStateId: " .. stateId)

  local result = Await(SQL.execute("SELECT * FROM `character_documents` WHERE cid = @stateId ", {
    ["@stateId"] = stateId
  }))

  if #result > 0 then
    return result
  end

  return nil
end)
