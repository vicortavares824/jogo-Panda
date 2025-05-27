local buttons = {}
function buttons.draw(show_buttons, x, y, largura_botao, largura_botao_base, altura_botao_base, tela_cheia, tamanhoTela, show_message1, show_message2,estado)
  if show_buttons then -- Desenha os botões apenas se show_buttons for verdadeiro
    suit.theme.color = {
      normal = {bg = {0.2, 0.2, 0.2}, fg = {1, 1, 1}}, -- Fundo cinza escuro, texto branco
      hovered = {bg = {0.5, 0.5, 0.5}, fg = {0, 0, 1}}, -- Fundo cinza médio, texto azul
      active = {bg = {0.1, 0.1, 0.1}, fg = {0, 1, 0}} -- Fundo quase preto, texto verde
  }
        opacao1 = suit.Button("Play Game", x,y, largura_botao,altura_tela)
        opacao2 = suit.Button("Opções", x,y+50, largura_botao,altura_tela)
        opacao3 = suit.Button("Sair", x,y+100, largura_botao,altura_tela)

        if opacao1.hit then
            show_message1 = true
            show_message2 = false
            show_buttons = false 
            estado = "cutscene" -- Muda o estado do jogo para "game"
        end
        if opacao2.hit then
            show_message2 = not show_message2
          if show_message1 then
            show_message1 = true
          else 
            show_message1 = false
          end
        end
        if opacao3.hit then
            love.event.quit(0)
        end
        if tela_cheia then
            largura_botao = largura_botao_base * 1.6 -- Aumenta 10%
            altura_botao = altura_botao_base * 1.6 -- Aumenta 10%
            love.window.setFullscreen(true)
            tamanhoTela()
        else
            largura_botao = largura_botao_base
            altura_botao = altura_botao_base
            love.window.setFullscreen(false)
            tamanhoTela()
        end
    end

    return show_message1,show_message2,show_buttons,estado
end
return buttons