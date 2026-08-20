hl.curve("ease_out", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 3, style = "popin", bezier = "ease_out" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 3, style = "fade", bezier = "ease_out" })
