-- Housing Items Database
Craftpad.Data.HousingItems = {
    { id = 1, name = "Rustic Wooden Chair", category = "Furniture" },
    { id = 2, name = "Grand Fireplace", category = "Furniture" },
    { id = 3, name = "Crystal Chandelier", category = "Lighting" },
    { id = 4, name = "Ornate Carpet", category = "Flooring" },
    { id = 5, name = "Wall Tapestry", category = "Wall Decor" },
    { id = 6, name = "Potted Plant", category = "Nature" },
    { id = 7, name = "Bookshelf", category = "Furniture" },
    { id = 8, name = "Decorative Vase", category = "Accessories" },
    { id = 9, name = "Lantern", category = "Lighting" },
    { id = 10, name = "Dining Table", category = "Furniture" },
}

function Craftpad.Data.GetHousingItems()
    return Craftpad.Data.HousingItems
end

function Craftpad.Data.GetItemCount()
    return #Craftpad.Data.HousingItems
end
