local G = {}

G.IronOreHue = { [1] = 0}
G.ShadowIronOreHue = { [1] = 2406}
G.AllOreHue = {
    [1] = 0,
    [2] = 2406
}

-- Iron Ore 2 stones: 6583  # Small scattered
-- Iron Ore 7a stones: 6586 # Large scattered
-- Iron Ore 7b stones: 6584 # Small round
-- Iron Ore 12 stones: 6585 # Large round
G.OreGraphics = { 6583, 6586, 6584, 6585} -- sorted heaviest [1] to lightest [4]

G.OreFilter = {
    [1] = 6583,
    [2] = 6586,
    [3] = 6584,
    [4] = 6585
}

return G