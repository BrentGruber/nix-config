local Config = require("config")

require("utils.backdrops"):set_images():random()

return Config:init():append(require("config.appearance"))
