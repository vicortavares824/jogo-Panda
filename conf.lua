function love.conf(t)
    t.title = "Panda Jackin" -- Título da janela do jogo
    t.window.icon = 'sprits/icone.png' -- Caminho para o ícone da janela
    t.window.resizable = false -- Define se a janela pode ser redimensionada
    t.window.vsync = 1 -- Ativa o V-Sync (1 para ativar, 0 para desativar)
    t.window.msaa = 4 -- Anti-aliasing (4x multisample)
end