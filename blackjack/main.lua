function love.load()
   deck = {}
   for _, suit in ipairs({"club", "diamond", "heart", "spade"}) do
      for rank = 1, 13 do
         print("suit: " .. suit .. ", rank: " .. rank)
         table.insert(deck, {suit = suit, rank = rank})
      end
   end
   print("Total number of cards in deck: " .. #deck)

   function takeCard(hand)
      table.insert(hand, table.remove(deck, love.math.random(#deck)))
   end

   playerHand = {}
   takeCard(playerHand)
   takeCard(playerHand)

   dealerHand = {}
   takeCard(dealerHand)
   takeCard(dealerHand)

   roundOver = false

   function getTotal(hand)
      local total = 0
      local hasAce = false

      for _, card in ipairs(hand) do
         if card.rank > 10 then
            total = total + 10
         else
            total = total + card.rank
         end

         if card.rank == 1 then
            hasAce = true
         end

         if hasAce and total <= 11 then
            total = total + 10
         end
      end
      return total
   end

   images = {}
   for nameIndex, name in ipairs(
      {
         1,
         2,
         3,
         4,
         5,
         6,
         7,
         8,
         9,
         10,
         11,
         12,
         13,
         "pip_heart",
         "pip_diamond",
         "pip_club",
         "pip_spade",
         "mini_heart",
         "mini_diamond",
         "mini_club",
         "mini_spade",
         "card",
         "card_face_down",
         "face_jack",
         "face_queen",
         "face_king"
      }
   ) do
      images[name] = love.graphics.newImage("images/" .. name .. ".png")
   end

   love.graphics.setBackgroundColor(1, 1, 1)
end

function love.keypressed(key)
   if not roundOver then
      if key == "h" and not roundOver then
         takeCard(playerHand)

         if getTotal(playerHand) >= 21 then
            roundOver = true
         end
      elseif key == "s" then
         roundOver = true
      end

      if roundOver then
         while getTotal(dealerHand) < 17 do
            takeCard(dealerHand)
         end
      end
   else
      love.load()
   end
end

function love.draw()
   local output = {}

   table.insert(output, "Player hand:")

   for _, card in ipairs(playerHand) do
      table.insert(output, "suit: " .. card.suit .. ", rank: " .. card.rank)
   end

   table.insert(output, "Total: " .. getTotal(playerHand))
   table.insert(output, "")
   table.insert(output, "Dealer Hand:")

   for cardIndex, card in ipairs(dealerHand) do
      if not roundOver and cardIndex == 1 then
         table.insert(output, "(Card Hidden)")
      else
         table.insert(output, "suit: " .. card.suit .. ", rank: " .. card.rank)
      end
   end

   if roundOver then
      table.insert(output, "Total: " .. getTotal(dealerHand))
   else
      table.insert(output, "Total: ?")
   end

   if roundOver then
      table.insert(output, "")

      local function hasHandWon(thisHand, otherHand)
         return getTotal(thisHand) <= 21 and (getTotal(otherHand) > 21 or getTotal(thisHand) > getTotal(otherHand))
      end

      if hasHandWon(playerHand, dealerHand) then
         table.insert(output, "Player wins")
      elseif hasHandWon(dealerHand, playerHand) then
         table.insert(output, "Dealer wins")
      else
         table.insert(output, "Draw")
      end
   end

   -- love.graphics.print(table.concat(output, "\n"), 15, 15)
   local function drawCard(card, x, y)
      love.graphics.setColor(1, 1, 1)
      love.graphics.draw(images.card, x, y)

      -- set card color
      if card.suit == "heart" or card.suit == "diamond" then
         love.graphics.setColor(.89, .06, .39)
      else
         love.graphics.setColor(.2, .2, .2)
      end

      -- draw faces
      if card.rank > 10 then
         local faceImage
         if card.rank == 11 then
            faceImage = images.face_jack
         elseif car.rank == 12 then
            faceImage = images.face_queen
         elseif card.rank == 13 then
            faceImage = images.face_king
         end
         love.graphics.setColor(1, 1, 1)
         love.graphics.draw(faceImage, x + 12, y + 11)
      else
         local pipImage = images['pip_'..card.suit]
         if card.rank == 1 then
            love.graphics.draw(pipImage, x + 21, y + 31)
         end
      end

      local cardWidth = 53
      local cardHeight = 73

      local function drawCorner(image, offsetX, offsetY)
         love.graphics.draw(image, x + offsetX, y + offsetY)
         love.graphics.draw(image, x + cardWidth - offsetX, y + cardHeight - offsetY, 0, -1)
      end

      drawCorner(images[card.rank], 3, 4)
      drawCorner(images["mini_" .. card.suit], 3, 14)
   end

   local testHand = {
      {suit = 'club', rank = 1},
      {suit = 'diamond', rank = 1},
      {suit = 'heart', rank = 1},
      {suit = 'spade', rank = 1},
   }

   for cardIndex, card in ipairs(testHand) do
      drawCard(card, (cardIndex - 1) * 60, 0)
   end
end
