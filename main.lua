-- Módulos e dependências
suit = require 'biblioteca/suit'
opcao = require 'fuction/opcao'
button = require 'fuction/button'
sons = require 'fuction/sons'
anim8 = require "biblioteca/anim8"
sti = require "biblioteca/sti"
camera = require "biblioteca/camera"
wf = require 'biblioteca/windfield'
local LG = love.graphics
local LK = love.keyboard
local gameMap = sti('mapa/fase 1/fase1.lua')
-- Configurações e variáveis do jogo
polyline = {
  { x = 0,    y = 0 },
  { x = 704,  y = 0 },
  { x = 704,  y = -16 },
  { x = 720,  y = -16 },
  { x = 720,  y = -32 },
  { x = 816,  y = -32 },
  { x = 816,  y = -16 },
  { x = 832,  y = -16 },
  { x = 832,  y = 0 },
  { x = 1536, y = 0 },
  { x = 1536, y = 16 },
  { x = 1552, y = 16 },
  { x = 1552, y = 32 },
  { x = 2016, y = 32 },
  { x = 2016, y = 16 },
  { x = 2032, y = 16 },
  { x = 2032, y = 0 },
  { x = 4576, y = 0 },
  { x = 4576, y = 16 },
  { x = 4608, y = 16 },
  { x = 4608, y = 32 },
  { x = 4640, y = 32 },
  { x = 4640, y = 48 },
  { x = 4672, y = 48 },
  { x = 4672, y = 64 },
  { x = 4704, y = 64 },
  { x = 4704, y = 80 },
  { x = 4736, y = 80 },
  { x = 4736, y = 96 },
  { x = 4800, y = 96 }
}
local jogo = {
  sons = { value = 10, max = 100 },
  brilho = { value = 80, max = 100 },
  telaCheia = false,
  larguraBotaoBase = 300,
  alturaBotaoBase = 30,
  larguraBotao = 300,
  alturaBotao = 30,
  indice = 1,
  tempoAnimacao = 0.2,
  larguraTela = LG.getWidth(),
  alturaTela = LG.getHeight(),
  posicaoBotaoX = 0,
  posicaoBotaoY = 0,
  escalaX = 1,
  escalaY = 1,
  imagemFundo = LG.newImage('sprits/fundo.png'),
  animacaoFundo = nil,
  larguraFrame = 170,
  alturaFrame = 128,
  fonte = nil,
  exibirMensagem1 = false,
  exibirMensagem2 = false,
  exibirBotoes = true,
  mapaLargura = 9000,
  mapaAltura = gameMap.height * gameMap.tileheight,
  mapLargura = 1,
  mapAltura = 1,
  escala = 1,
  escalaBloco = 1.875,
  estado = "jogando",
}
local player = {
  x = 345,
  y = 134,
  speed = 200,
  spLeft = LG.newImage('Sprit shet/panda andando.png'),
  spRiht = LG.newImage('Sprit shet/panda andando right.png'),
  spAtira = LG.newImage('Sprit shet/panda atirando.png'),
  spAtira1 = LG.newImage('Sprit shet/panda atirando right.png'),
  grid = nil,
  grid1 = nil,
  anim = nil,
  lado = LG.newImage('Sprit shet/panda andando.png'),
  collider = nil,
  jumpCooldown = 0, -- Tempo de recarga para o próximo pulo
  vida = 100,
  largura = 45,
  altura = 70,
  danoTimer = 0, -- Tempo em que o jogador ficará vermelho
  coracao = LG.newImage('Sprit shet/heart.png'),
  coracaoVazio = LG.newImage('Sprit shet/heart-empty.png')
}

local inimigos = {}
local tiros = {}

-- Função para criar inimigos
local function criarInimigo(x, y, tipo)
  local inimigo = {
    x = x,
    y = y,
    speed = 200,
    tipo = tipo,
    vida = 100,
    lado = "left",
    collider = world:newRectangleCollider(x, y, 60, 60),
    spIS = LG.newImage('Sprit shet/inimigo Sushi.png'),
    grid = nil,
    anim = nil,
    limiteEsquerdo = x - 80,
    limiteDireito = x + 400,
    danoTimer = 0 -- Tempo em que o inimigo ficará vermelho
  }
  inimigo.collider:setType("dynamic")
  inimigo.collider:setFixedRotation(true)
  inimigo.collider:setMass(1)
  inimigo.grid = anim8.newGrid(64, 64, inimigo.spIS:getWidth(), inimigo.spIS:getHeight())
  inimigo.anim = anim8.newAnimation(inimigo.grid('1-6', 1), 0.2)
  table.insert(inimigos, inimigo)
  inimigo.spIni = inimigo.spIS
end

local function criarTiro(x, y, direcao)
  local tiro = {
    x = x,
    y = y,
    speed = 500,       -- Velocidade do tiro
    direcao = direcao, -- Direção do tiro (1 para direita, -1 para esquerda)
    largura = 10,
    altura = 5
  }
  table.insert(tiros, tiro)
end
local function reiniciarJogo()
  -- Redefine as variáveis do jogador
  player.x = 345
  player.y = 134
  player.vida = 100
  player.danoTimer = 0
  player.collider:setPosition(400, 250)

  -- Remove todos os inimigos e recria os iniciais
  for _, inimigo in ipairs(inimigos) do
    if inimigo.collider then
      inimigo.collider:destroy()
    end
  end
  carregarInimigos()
  -- Remove todos os tiros
  tiros = {}
  jogo.estado = "jogando"
  -- Reseta outras variáveis do jogo, se necessário
  jogo.exibirMensagem1 = true
end
function carregarInimigos()
  inimigos = {}
  local inimigosIniciais = 8
  for i = 1, inimigosIniciais do
    local posX = math.random(100, jogo.mapaLargura)
    local posY = 237
    criarInimigo(posX, posY, "normal")
  end
end

local function atualizarTiros(dt)
  for i = #tiros, 1, -1 do
    local tiro = tiros[i]
    tiro.x = tiro.x + (tiro.speed * tiro.direcao * dt)

    -- Verifica colisão com inimigos
    for j = #inimigos, 1, -1 do
      local inimigo = inimigos[j]

      -- Ajuste do ponto de colisão (offsetY)


      -- Verifica se o tiro colide com o inimigo (detecção de colisão de retângulos)
      if tiro.x < inimigo.x and tiro.x + tiro.largura > inimigo.x and
          tiro.y < inimigo.y and tiro.y + tiro.altura + 25 > inimigo.y then
        -- Reduz a vida do inimigo

        inimigo.vida = inimigo.vida - 10
        inimigo.danoTimer = 0.2
        if inimigo.vida <= 0 then
          inimigo.collider:destroy()
          table.remove(inimigos, j)
        end

        -- Remove o tiro
        table.remove(tiros, i)
        break
      end
    end

    -- Remove o tiro se ele sair da tela
    if tiro.x < 0 or tiro.x > jogo.mapaLargura then
      table.remove(tiros, i)
    end
  end
end

local function desenharTiros()
  for _, tiro in ipairs(tiros) do
    LG.setColor(1, 0.8, 0.2) -- Cor vermelha para os tiros
    LG.rectangle("fill", tiro.x, tiro.y, tiro.largura, tiro.altura)
  end
  LG.setColor(1, 1, 1) -- Reseta a cor para o padrão
end

local function atualizarInimigos(dt)
  for _, inimigo in ipairs(inimigos) do
    -- Obtém a posição do collider
    inimigo.x, inimigo.y = inimigo.collider:getPosition()
    if inimigo.danoTimer > 0 then
      inimigo.danoTimer = inimigo.danoTimer - dt
    end

    local velX, velY = inimigo.collider:getLinearVelocity()
    if inimigo.lado == "left" then
      inimigo.collider:setLinearVelocity(-inimigo.speed, velY)
      if inimigo.x < inimigo.limiteEsquerdo then
        inimigo.lado = "right"
      end
    elseif inimigo.lado == "right" then
      inimigo.collider:setLinearVelocity(inimigo.speed, velY)
      if inimigo.x > inimigo.limiteDireito then
        inimigo.lado = "left"
      end
    end

    if player.collider:getX() - player.largura / 2 < inimigo.x + 60 / 2 and
        player.collider:getX() + player.largura / 2 > inimigo.x - 60 / 2 and
        player.collider:getY() - player.altura / 2 < inimigo.y + 60 / 2 and
        player.collider:getY() + player.altura / 2 > inimigo.y - 60 / 2 then
      if player.danoTimer <= 0 then
        player.vida = player.vida - 10
        player.danoTimer = 0.1
      end
    end

    inimigo.anim:update(dt)
  end
end
local function desenharVida()
  local coracaoLargura = player.coracao:getWidth() * 1.5
  for i = 1, 3 do
    local coracaoX = 10 + (i - 1) * (coracaoLargura + 5) -- Espaçamento entre os corações
    love.graphics.draw(player.coracao, 10 + coracaoX, 10, 0, 1.5, 1.5)
    if player.vida <= 75 then
      if i == 3 then
        love.graphics.draw(player.coracaoVazio, 10 + coracaoX, 10, 0, 1.5, 1.5)
      end
    end
    if player.vida <= 50 then
      if i == 2 then
        love.graphics.draw(player.coracaoVazio, 10 + coracaoX, 10, 0, 1.5, 1.5)
      end
    end
    if player.vida <= 25 then
      if i == 1 then
        love.graphics.draw(player.coracaoVazio, 10 + coracaoX, 10, 0, 1.5, 1.5)
      end
    end
  end
end

-- Função para desenhar os inimigos
local function desenharInimigos()
  for _, inimigo in ipairs(inimigos) do
    if inimigo.danoTimer > 0 then
      LG.setColor(1, 0, 0, 0.8) -- Vermelho
    else
      LG.setColor(1, 1, 1)     -- Branco (cor normal)
    end
    local escalaX = inimigo.lado == "left" and -1.8 or
        1.8                                                                          -- Inverte a escala para o lado esquerdo
    inimigo.anim:draw(inimigo.spIS, inimigo.x, inimigo.y, nil, escalaX, 1.8, 32, 32) -- Ajusta a posição de origem para o centro do inimigo
  end
  LG.setColor(1, 1, 1)
end
local function desenharPlayer()
  if player.danoTimer > 0 then
    LG.setColor(1, 0, 0) -- Vermelho
  else
    LG.setColor(1, 1, 1) -- Branco (cor normal)
  end

  player.anim:draw(player.lado, player.x - 57, player.y - 80, nil, 1.8)
  LG.setColor(1, 1, 1) -- Reseta a cor para o padrão
end
local direcaoAtual = 1 -- 1 para direita, -1 para esquerda
local cooldownTiro = 0 -- Tempo restante para o próximo tiro
local tempoCooldownTiro = 0.5

local function atualizarTamanhoTela()
  jogo.larguraTela = LG.getWidth()
  jogo.alturaTela = LG.getHeight()
  jogo.posicaoBotaoX = (jogo.larguraTela - jogo.larguraBotao) / 2
  jogo.posicaoBotaoY = (jogo.alturaTela - jogo.alturaBotao) / 2
  jogo.escalaX = jogo.larguraTela / jogo.larguraFrame
  jogo.escalaY = jogo.alturaTela / jogo.alturaFrame
  jogo.mapLargura = jogo.larguraTela / jogo.mapaLargura
  jogo.mapAltura = jogo.alturaTela / jogo.mapaAltura
end


-- Função de carregamento do jogo
function love.load()
  for key, source in pairs(sounds) do
    local volume = math.min(jogo.sons.value / 100, 1.0) -- Converte o valor do slider para o intervalo de 0 a 1
    source:setVolume(volume)
  end
  world = wf.newWorld(0, 500, true)
  cam = camera()
  sons(jogo.sons, true, true)
  player.animation = {}
  player.grid = anim8.newGrid(64, 64, player.spLeft:getWidth(), player.spLeft:getHeight())
  player.animation.left = anim8.newAnimation(player.grid('2-7', 1), 0.2)
  player.grid1 = anim8.newGrid(64, 64, player.spRiht:getWidth(), player.spRiht:getHeight())
  player.animation.right = anim8.newAnimation(player.grid1('2-7', 1), 0.2)
  player.grid2 = anim8.newGrid(64, 64, player.spAtira:getWidth(), player.spAtira:getHeight())
  player.animation.atira = anim8.newAnimation(player.grid2('1-6', 1), 0.1)
  player.grid3 = anim8.newGrid(64, 64, player.spAtira1:getWidth(), player.spAtira1:getHeight())
  player.animation.atira1 = anim8.newAnimation(player.grid3('1-6', 1), 0.2)
  player.anim = player.animation.left
  player.lado = player.spLeft

  jogo.fonte = LG.newFont('font.ttf', 32)
  LG.setFont(jogo.fonte)
  player.collider = world:newBSGRectangleCollider(400, 250, 45, 70, 10)
  player.collider:setFixedRotation(true)
  player.collider:setMass(1)
  LG.setDefaultFilter("nearest", "nearest")

  atualizarTamanhoTela()

  local grid = anim8.newGrid(jogo.larguraFrame, jogo.alturaFrame, jogo.imagemFundo:getWidth(),
    jogo.imagemFundo:getHeight())
  jogo.animacaoFundo = anim8.newAnimation(grid('1-119', 1), jogo.tempoAnimacao)

  carregarInimigos()

  local Walls = {}
  for i = 1, #polyline - 1 do
    local p1 = polyline[i]
    local p2 = polyline[i + 1]
    local scaled_x1 = p1.x * jogo.escalaBloco
    local scaled_y1 = p1.y * jogo.escalaBloco
    local scaled_x2 = p2.x * jogo.escalaBloco
    local scaled_y2 = p2.y * jogo.escalaBloco
    local wall = world:newLineCollider(scaled_x1, scaled_y1 + 330, scaled_x2, scaled_y2 + 330)
    wall:setType('static')
    table.insert(Walls, wall)
  end
end

-- Função de atualização do jogo
function love.update(dt)
  local isMove = false
  if jogo.estado == "pausado" then
    return
  end
  -- Atualiza o cooldown do pulo
  if player.jumpCooldown > 0 then
    player.jumpCooldown = player.jumpCooldown - dt
  end
  if player.danoTimer > 0 then
    player.danoTimer = player.danoTimer - dt
  end

  if LK.isDown("escape") then
    jogo.exibirBotoes = true
  end




  if not exibirBotoes then
    jogo.exibirMensagem1, jogo.exibirMensagem2, jogo.exibirBotoes = button.draw(
      jogo.exibirBotoes,
      jogo.posicaoBotaoX,
      jogo.posicaoBotaoY,
      jogo.larguraBotao,
      jogo.larguraBotaoBase,
      jogo.alturaBotaoBase,
      jogo.telaCheia,
      atualizarTamanhoTela,
      jogo.exibirMensagem1,
      jogo.exibirMensagem2
    )
  end

  if jogo.exibirMensagem1 then
    local velx = 0
    local currentVelY = 0
    local _, vy = player.collider:getLinearVelocity()
    currentVelY = vy

    -- Movimento para a direita
    if LK.isDown("right", "d") then
      if player.x < (9500 - player.spRiht:getWidth()) then
        player.x = player.x + player.speed * dt
        velx = player.speed
        player.anim = player.animation.right
        player.lado = player.spRiht
        direcaoAtual = 1 -- Atualiza a direção para direita
        sons(jogo.sons, false, "andar")
      end
      isMove = true
    elseif LK.isDown("left", "a") then
      if player.x > 0 then
        player.x = player.x - player.speed * dt
        velx = -player.speed
        player.anim = player.animation.left
        player.lado = player.spLeft
        direcaoAtual = -1 -- Atualiza a direção para esquerda
        sons(jogo.sons, false, "andar")
      end
      isMove = true
    elseif cooldownTiro <= 0 and LK.isDown('f') then
      criarTiro(player.x, player.y - 20, direcaoAtual) -- Cria o tiro na direção atual
      if direcaoAtual == 1 then
        player.anim = player.animation.atira
        player.lado = player.spAtira -- Atirando para a direita
      elseif direcaoAtual == -1 then
        player.anim = player.animation.atira1
        player.lado = player.spAtira1 -- Atirando para a esquerda
      end
      sons(jogo.sons, false, "atirar")
      cooldownTiro = tempoCooldownTiro -- Reseta o cooldown
    elseif not LK.isDown('f') then
      -- Reverte a animação para a de movimento ou parada
      if direcaoAtual == 1 then
        player.anim = player.animation.right
        player.lado = player.spRiht
      elseif direcaoAtual == -1 then
        player.anim = player.animation.left
        player.lado = player.spLeft
      end
    end
    if cooldownTiro > 0 then
      cooldownTiro = cooldownTiro - dt
    end



    player.collider:setLinearVelocity(velx, currentVelY)
  end

  if not isMove then
    if player.lado == player.spRiht then
      player.anim = player.animation.right
      player.lado = player.spRiht -- Atirando para a direita
      player.anim:gotoFrame(2)
    elseif player.lado == player.spLeft then
      player.anim = player.animation.left
      player.lado = player.spLeft -- Atirando para a esquerda
      player.anim:gotoFrame(2)
    end
    if jogo.exibirMensagem1 then
      sons(jogo.sons, false, "para")
    end
  end
  world:update(dt)
  player.x = player.collider:getX()
  player.y = player.collider:getY()

  player.anim:update(dt)
  jogo.animacaoFundo:update(dt)
  local targetY = jogo.alturaTela / 2
  cam:lookAt(player.x, targetY)

  if cam.x < jogo.larguraTela / 2 then
    cam.x = jogo.larguraTela / 2
  elseif cam.x > jogo.mapaLargura - jogo.larguraTela / 2 then
    cam.x = jogo.mapaLargura - jogo.larguraTela / 2
  end



  atualizarInimigos(dt)
  atualizarTiros(dt)
end

-- Função de desenho do jogo
function love.draw()
  local escala = math.max(jogo.escalaX, jogo.escalaY)
  if not jogo.exibirMensagem1 then
    jogo.animacaoFundo:draw(jogo.imagemFundo, 0, 0, 0, escala, escala)
  end

  if LK.isDown("up", "space", "w") then
    if player.jumpCooldown <= 0 then
      sons(jogo.sons, false, "pular")
      player.collider:applyLinearImpulse(0, -200) -- Aplica o impulso para o pulo
      player.jumpCooldown = 1                     -- Define o cooldown para o pulo
    end
  end

  if jogo.exibirMensagem2 then
    jogo.exibirMensagem2, jogo.exibirBotoes, jogo.telaCheia = opcao(
      jogo.posicaoBotaoX + 30,
      jogo.posicaoBotaoY - 40,
      atualizarTamanhoTela,
      jogo.exibirMensagem1,
      jogo.exibirMensagem2,
      jogo.sons,
      jogo.brilho,
      jogo.exibirBotoes,
      sounds
    )
    jogo.exibirBotoes = not jogo.exibirMensagem2
  end

  if jogo.exibirMensagem1 then
    sons(jogo.sons, false, nil)
    jogo.escala = math.max(jogo.mapLargura, jogo.mapAltura)

    cam:attach()
    LG.push() -- Salva o estado atual da matriz de transformação
    LG.scale(jogo.escala, jogo.escala)

    gameMap:drawLayer(gameMap.layers["Fundo"])
    gameMap:drawLayer(gameMap.layers["Nuvem"])
    gameMap:drawLayer(gameMap.layers["Chao"])

    LG.pop() -- Restaura o estado da matriz de transformação
    LG.setDefaultFilter("nearest", "nearest")
    desenharPlayer()
    --world:draw()
    desenharInimigos()
    desenharTiros()
    cam:detach()
    desenharVida()
  end
  if player.vida <= 0 then
    -- Define as cores do botão
    suit.theme.color = {
      normal = { bg = { 0.2, 0.2, 0.2 }, fg = { 1, 1, 1 } },
      hovered = { bg = { 0.5, 0.5, 0.5 }, fg = { 0, 0, 1 } },
      active = { bg = { 0.1, 0.1, 0.1 }, fg = { 0, 1, 0 } }
    }
    if player.vida <= 0 then
      jogo.estado = "pausado"   -- Altera o estado do jogo para "pausado"
    end

    if suit.Button("Reiniciar", jogo.posicaoBotaoX, jogo.posicaoBotaoY + 50, jogo.larguraBotao, jogo.alturaBotao).hit then
      reiniciarJogo()
    end

    -- Exibe o texto "Game Over"
    LG.setColor(0.5, 0.5, 0.5) -- Cor cinza médio para o texto
    suit.Label("Game Over", jogo.posicaoBotaoX, jogo.posicaoBotaoY, jogo.larguraBotao, jogo.alturaBotao)
  end
  -- Mova o suit.draw() para o final para que ele seja desenhado por último
  suit.draw()
end
