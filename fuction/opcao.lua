
function opcao(x, y, tamanhoTela, show_message1, show_message2, slider, brilho)
    opacao4 = suit.Button("Voltar", x, y + 140, 300, 30)
    if opacao4.hit then
        show_buttons = true
        show_message2 = false
    end
    suit.Label("Volume:", x - 85, y, 145, 30)
    suit.Slider(slider, x + 80, y, 200, 30)
    suit.Label(tostring(slider.value), { align = "right" }, x + 280, y, 90, 30)
   
    for key, source in pairs(sounds) do
        source:setVolume( math.min(slider.value / 100, 1.0))
      end
    suit.Label("Brilho:", x - 80, y + 40, 145, 30)
    suit.Slider(brilho, x + 80, y + 40, 200, 30)
    suit.Label(tostring(math.floor(brilho.value)), { align = "right" }, x + 280, y + 40, 90, 30)
    love.graphics.setColor(brilho.value / 100, brilho.value / 100, brilho.value / 100)
    suit.Label("Tela Cheia:", x - 200, y + 90, 300, 30)
    if suit.Button(tela_cheia and "Sim" or "Não", x + 80, y + 90, 200, 30).hit then
        tela_cheia = not tela_cheia
    end
    return show_message2, show_buttons, tela_cheia
end
return opcao